defmodule Dpos.Tx do
  import Dpos.Utils, only: [hexdigest: 1]

  alias Dpos.Crypto.Ed25519

  @keys [
    :id,
    :recipientId,
    :senderPublicKey,
    :signature,
    :signSignature,
    :timestamp,
    :type,
    address_suffix_length: 1,
    amount: 0,
    asset: %{},
    fee: 0
  ]

  @json_keys [
    :id,
    :type,
    :fee,
    :amount,
    :recipientId,
    :senderPublicKey,
    :signature,
    :signSignature,
    :timestamp,
    :asset
  ]

  @derive {Jason.Encoder, only: @json_keys}
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

  defmacro __using__(keys) do
    unless keys[:type], do: raise("option 'type' is required")

    quote do
      @type wallet_or_secret() :: %Dpos.Wallet{} | {String.t(), String.t()}

      @doc """
      Builds a new transaction.
      """
      @spec build(map()) :: %Dpos.Tx{}
      def build(attrs) do
        keys = Enum.into(unquote(keys), %{})

        attrs =
          attrs
          |> Map.merge(keys)
          |> Dpos.Tx.validate_timestamp()

        struct!(Dpos.Tx, attrs)
      end

      @doc """
      Signs the transaction with the sender private key.

      It accepts either a `Dpos.Wallet` or a `{"secret", "L"}` tuple as second argument
      where the first element is the secret and the second element is the address suffix
      (i.e. `"L"` for Lisk).

      A secondary private_key can also be provided as third argument.
      """
      @spec sign(%Dpos.Tx{}, wallet_or_secret, binary()) :: %Dpos.Tx{}
      def sign(tx, wallet_or_secret, second_priv_key \\ nil)

      def sign(%Dpos.Tx{} = tx, %Dpos.Wallet{} = wallet, second_priv_key) do
        tx
        |> Map.put(:senderPublicKey, wallet.pub_key)
        |> Map.put(:address_suffix_length, wallet.suffix_length)
        |> create_signature(wallet.priv_key)
        |> create_signature(second_priv_key, :signSignature)
        |> determine_id()
      end

      def sign(%Dpos.Tx{} = tx, {secret, suffix}, second_priv_key)
          when is_binary(secret) and is_binary(suffix) do
        wallet = Dpos.Wallet.generate(secret, suffix)
        sign(tx, wallet, second_priv_key)
      end

      @doc """
      Normalizes the transaction in a format that it could be broadcasted through a relay node.
      """
      @spec normalize(%Dpos.Tx{}) :: %Dpos.Tx{}
      def normalize(%Dpos.Tx{} = tx) do
        tx
        |> Map.put(:senderPublicKey, hexdigest(tx.senderPublicKey))
        |> Map.put(:signature, hexdigest(tx.signature))
        |> Map.put(:signSignature, hexdigest(tx.signSignature))
        |> normalize_asset()
      end

      defp create_signature(tx, priv_key, field \\ :signature)

      defp create_signature(%Dpos.Tx{} = tx, nil, _field), do: tx

      defp create_signature(%Dpos.Tx{} = tx, priv_key, field) do
        {:ok, signature} =
          tx
          |> compute_hash()
          |> Ed25519.sign(priv_key)

        Map.put(tx, field, signature)
      end

      defp determine_id(%Dpos.Tx{} = tx) do
        <<head::bytes-size(8), _rest::bytes>> = compute_hash(tx)
        id = head |> Dpos.Utils.reverse_binary() |> to_string()
        Map.put(tx, :id, id)
      end

      defp compute_hash(%Dpos.Tx{} = tx) do
        bytes =
          :erlang.list_to_binary([
            <<tx.type>>,
            <<tx.timestamp::little-integer-size(32)>>,
            <<tx.senderPublicKey::bytes-size(32)>>,
            Dpos.Utils.address_to_binary(tx.recipientId, tx.address_suffix_length),
            <<tx.amount::little-integer-size(64)>>,
            get_child_bytes(tx),
            Dpos.Utils.signature_to_binary(tx.signature),
            Dpos.Utils.signature_to_binary(tx.signSignature)
          ])

        :crypto.hash(:sha256, bytes)
      end

      defp get_child_bytes(%Dpos.Tx{}), do: ""

      defp normalize_asset(%Dpos.Tx{} = tx), do: tx

      defoverridable get_child_bytes: 1, normalize_asset: 1
    end
  end
end
