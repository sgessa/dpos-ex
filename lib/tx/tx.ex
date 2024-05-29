defmodule Dpos.Tx do
  alias Dpos.Crypto.Ed25519
  alias Dpos.{Tx, Utils, Wallet}

  @callback type_id() :: integer()
  @callback get_child_bytes(%__MODULE__{}) :: binary()

  defstruct [
    :id,
    :recipient,
    :public_key,
    :signature,
    :second_signature,
    :timestamp,
    :type,
    address_suffix_length: 1,
    asset: %{},
    amount: 0,
    fee: 0
  ]

  @doc """
  Builds a new transaction.
  """
  @spec build(module(), map()) :: %Tx{}
  def build(mod, attrs) do
    attrs =
      attrs
      |> Map.put(:type, mod)
      |> Tx.ensure_timestamp()

    struct!(Tx, attrs)
  end

  @doc """
  Signs the transaction with the sender private key.

  It accepts either a `Dpos.Wallet` or a `{"secret", "L"}` tuple as second argument
  where the first element is the secret and the second element is the address suffix
  (i.e. `"L"` for Lisk).

  A secondary private_key can also be provided as third argument.
  """
  @type wallet_or_secret() :: %Wallet{} | {String.t(), String.t()}
  @spec sign(%Tx{}, wallet_or_secret(), binary() | nil) :: %Tx{}
  def sign(tx, wallet_or_secret, second_priv_key \\ nil)

  def sign(%Tx{} = tx, %Wallet{} = wallet, second_priv_key) do
    tx
    |> Map.put(:public_key, wallet.pub_key)
    |> Map.put(:address_suffix_length, wallet.suffix_length)
    |> attach_signature(wallet.priv_key)
    |> attach_second_signature(second_priv_key)
    |> calculate_id()
  end

  def sign(%Tx{} = tx, {secret, suffix}, second_priv_key)
      when is_binary(secret) and is_binary(suffix) do
    wallet = Wallet.generate(secret, suffix)
    sign(tx, wallet, second_priv_key)
  end

  defp attach_second_signature(%Tx{} = tx, nil), do: tx

  defp attach_second_signature(%Tx{} = tx, second_priv_key) do
    Map.put(tx, :second_signature, calculate_signature(tx, second_priv_key))
  end

  defp attach_signature(%Tx{} = tx, priv_key) do
    Map.put(tx, :signature, calculate_signature(tx, priv_key))
  end

  defp calculate_signature(%Tx{} = tx, priv_key) do
    {:ok, signature} =
      tx
      |> compute_hash()
      |> Ed25519.sign(priv_key)

    signature
  end

  defp calculate_id(%Tx{} = tx) do
    <<head::bytes-size(8), _rest::bytes>> = compute_hash(tx)
    id = head |> Utils.reverse_binary() |> to_string()
    Map.put(tx, :id, id)
  end

  defp compute_hash(%Tx{} = tx) do
    bytes =
      :erlang.list_to_binary([
        <<tx.type.type_id()>>,
        <<tx.timestamp::little-integer-size(32)>>,
        <<tx.public_key::bytes-size(32)>>,
        Utils.address_to_binary(tx.recipient, tx.address_suffix_length),
        <<tx.amount::little-integer-size(64)>>,
        tx.type.get_child_bytes(tx),
        Utils.signature_to_binary(tx.signature),
        Utils.signature_to_binary(tx.second_signature)
      ])

    :crypto.hash(:sha256, bytes)
  end

  @doc """
  Ensure transaction has a correct timestamp value.

  Check if timestamp is present and not negative,
  otherwise it will be set to `Dpos.Time.now/0`.
  """
  @spec ensure_timestamp(map()) :: map()
  def ensure_timestamp(attrs) when is_map(attrs) do
    ts = attrs[:timestamp]

    if ts && is_integer(ts) && ts >= 0 do
      attrs
    else
      Map.put(attrs, :timestamp, Dpos.Time.now())
    end
  end

  def normalize(%Tx{} = tx) do
    Tx.Normalized.normalize(tx)
  end
end
