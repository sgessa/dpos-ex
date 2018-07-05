defmodule Dpos.Tx do
  alias Dpos.Tx
  alias Salty.Sign.Ed25519

  @types %{
    0 => Tx.Send,
    1 => Tx.Signature,
    2 => Tx.Delegate,
    3 => Tx.Vote,
    4 => Tx.MultiSig
  }

  @enforce_keys [
    :type,
    :fee,
    :amount,
    :timestamp,
    :senderPublicKey
  ]

  @optional_keys [
    :id,
    :recipientId,
    :requester_pkey,
    :signature,
    :second_signature,
    :asset,
    address_suffix_length: 1
  ]

  @json_keys [
    :id,
    :type,
    :fee,
    :amount,
    :recipientId,
    :senderPublicKey,
    :signature,
    :timestamp,
    :asset
  ]

  @derive {Jason.Encoder, only: @json_keys}
  defstruct @enforce_keys ++ @optional_keys

  def sign(%Tx{} = tx, %Dpos.Wallet{} = wallet, second_priv_key \\ nil) do
    if tx.timestamp < 0, do: raise("Invalid Timestamp")

    tx
    |> Map.put(:address_suffix_length, wallet.suffix_length)
    |> create_signature(wallet.priv_key)
    |> create_signature(second_priv_key, :second_signature)
    |> determine_id()
  end

  def normalize(%Tx{} = tx) do
    tx
    |> Map.put(:senderPublicKey, Dpos.Utils.hexdigest(tx.senderPublicKey))
    |> Map.put(:signature, Dpos.Utils.hexdigest(tx.signature))
    |> Map.delete(:second_signature)
  end

  defp create_signature(tx, priv_key, field \\ :signature)

  defp create_signature(%Tx{} = tx, nil, _field), do: tx

  defp create_signature(%Tx{} = tx, priv_key, field) do
    {:ok, signature} =
      tx
      |> compute_hash()
      |> Ed25519.sign_detached(priv_key)

    Map.put(tx, field, signature)
  end

  defp determine_id(%Tx{} = tx) do
    <<head::bytes-size(8), _tail::bytes>> = compute_hash(tx)

    id =
      head
      |> Dpos.Utils.reverse_binary()
      |> to_string()

    Map.put(tx, :id, id)
  end

  defp compute_hash(%Tx{} = tx) do
    recipientId = address_to_binary(tx.recipientId, tx.address_suffix_length)
    child_bytes = get_child_bytes(tx)
    signature = signature_to_binary(tx.signature)
    second_signature = signature_to_binary(tx.second_signature)

    bytes =
      <<tx.type, tx.timestamp::little-integer-size(32), tx.senderPublicKey::bytes-size(32)>> <>
        recipientId <>
        <<tx.amount::little-integer-size(64)>> <> child_bytes <> signature <> second_signature

    :crypto.hash(:sha256, bytes)
  end

  defp address_to_binary(nil, _suffix_length), do: :binary.copy(<<0>>, 8)

  defp address_to_binary(address, suffix_length) do
    len = String.length(address) - suffix_length

    {int, ""} =
      address
      |> String.slice(0..(len - 1))
      |> Integer.parse()

    <<int::size(64)>>
  end

  defp signature_to_binary(nil), do: <<>>

  defp signature_to_binary(sig), do: <<sig::bytes-size(64)>>

  defp get_child_bytes(%Tx{type: type} = tx), do: @types[type].get_child_bytes(tx)
end
