defmodule Dpos.Tx do
  alias Dpos.Tx
  alias Salty.Sign.Ed25519

  @types %{
    0 => Tx.Send,
    1 => Tx.CreateSignature,
    2 => Tx.RegisterDelegate,
    3 => Tx.Vote
  }

  @enforce_keys [
    :type,
    :fee,
    :amount,
    :timestamp,
    :sender_pkey
  ]

  @optional_keys [
    :id,
    :rcpt_address,
    :requester_pkey,
    :asset,
    :signature,
    :second_signature,
    address_suffix_length: 1
  ]

  defstruct @enforce_keys ++ @optional_keys

  def sign(tx, priv_key_or_wallet, second_priv_key \\ nil)

  def sign(%Tx{} = tx, %Dpos.Wallet{} = wallet, second_priv_key) do
    tx
    |> Map.put(:address_suffix_length, wallet.suffix_length)
    |> sign(wallet.priv_key, second_priv_key)
  end

  def sign(%Tx{} = tx, priv_key, second_priv_key) do
    if tx.timestamp < 0, do: raise("Invalid Timestamp")

    tx
    |> create_signature(priv_key)
    |> create_signature(second_priv_key, :second_signature)
    |> determine_id()
  end

  defp create_signature(tx, priv_key, key \\ :signature)

  defp create_signature(%Tx{} = tx, nil, _key), do: tx

  defp create_signature(%Tx{} = tx, priv_key, key) do
    {:ok, signature} =
      tx
      |> compute_hash()
      |> Ed25519.sign_detached(priv_key)

    Map.put(tx, key, signature)
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
    rcpt_address = address_to_binary(tx.rcpt_address, tx.address_suffix_length)
    child_bytes = get_child_bytes(tx)
    signature = signature_to_binary(tx.signature)
    second_signature = signature_to_binary(tx.second_signature)

    bytes =
      <<tx.type, tx.timestamp::little-integer-size(32), tx.sender_pkey::bytes-size(32)>> <>
        rcpt_address <>
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
