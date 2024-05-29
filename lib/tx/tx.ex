defmodule Dpos.Tx do
  alias Dpos.Crypto.Ed25519
  alias Dpos.{Tx, Utils, Wallet}

  @keys [
    :id,
    :recipient,
    :public_key,
    :signature,
    :sign_signature,
    :timestamp,
    :type,
    address_suffix_length: 1,
    asset: %{},
    amount: 0,
    fee: 0
  ]

  defstruct @keys

  @doc """
  Validates timestamp value.

  Check if timestamp is present and not negative,
  otherwise it will be set to `Dpos.Time.now/0`.
  """
  @spec validate_timestamp(map()) :: map()
  def validate_timestamp(attrs) when is_map(attrs) do
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

  defmacro __using__(keys) do
    unless keys[:type], do: raise("option 'type' is required")

    quote do
      @type wallet_or_secret() :: %Wallet{} | {String.t(), String.t()}

      @doc """
      Builds a new transaction.
      """
      @spec build(map()) :: %Tx{}
      def build(attrs) do
        keys = Enum.into(unquote(keys), %{})

        attrs =
          attrs
          |> Map.merge(keys)
          |> Tx.validate_timestamp()

        struct!(Tx, attrs)
      end

      @doc """
      Signs the transaction with the sender private key.

      It accepts either a `Dpos.Wallet` or a `{"secret", "L"}` tuple as second argument
      where the first element is the secret and the second element is the address suffix
      (i.e. `"L"` for Lisk).

      A secondary private_key can also be provided as third argument.
      """
      @spec sign(%Tx{}, wallet_or_secret, binary()) :: %Tx{}
      def sign(tx, wallet_or_secret, second_priv_key \\ nil)

      def sign(%Tx{} = tx, %Wallet{} = wallet, second_priv_key) do
        tx
        |> Map.put(:public_key, wallet.pub_key)
        |> Map.put(:address_suffix_length, wallet.suffix_length)
        |> create_signature(wallet.priv_key)
        |> create_signature(second_priv_key, :sign_signature)
        |> determine_id()
      end

      def sign(%Tx{} = tx, {secret, suffix}, second_priv_key)
          when is_binary(secret) and is_binary(suffix) do
        wallet = Wallet.generate(secret, suffix)
        sign(tx, wallet, second_priv_key)
      end

      defp create_signature(tx, priv_key, field \\ :signature)

      defp create_signature(%Tx{} = tx, nil, _field), do: tx

      defp create_signature(%Tx{} = tx, priv_key, field) do
        {:ok, signature} =
          tx
          |> compute_hash()
          |> Ed25519.sign(priv_key)

        Map.put(tx, field, signature)
      end

      defp determine_id(%Tx{} = tx) do
        <<head::bytes-size(8), _rest::bytes>> = compute_hash(tx)
        id = head |> Utils.reverse_binary() |> to_string()
        Map.put(tx, :id, id)
      end

      defp compute_hash(%Tx{} = tx) do
        bytes =
          :erlang.list_to_binary([
            <<tx.type>>,
            <<tx.timestamp::little-integer-size(32)>>,
            <<tx.public_key::bytes-size(32)>>,
            Utils.address_to_binary(tx.recipient, tx.address_suffix_length),
            <<tx.amount::little-integer-size(64)>>,
            get_child_bytes(tx),
            Utils.signature_to_binary(tx.signature),
            Utils.signature_to_binary(tx.sign_signature)
          ])

        :crypto.hash(:sha256, bytes)
      end

      defp get_child_bytes(%Tx{}), do: ""

      defoverridable get_child_bytes: 1
    end
  end
end
