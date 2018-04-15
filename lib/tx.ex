defmodule Dpos.Tx do
  alias Salty.Sign.Ed25519

  @enforce_keys [
    :type,
    :fee,
    :amount,
    :timestamp,
    :sender_pkey,
    :rcpt_address
  ]

  defstruct @enforce_keys ++ [:id, :signature, :second_signature, address_suffix_length: 1]

  def build_send_tx(attrs) do
    struct!(Dpos.Tx, Map.put(attrs, :type, 0))
  end

  def sign(tx, priv_key_or_wallet, second_priv_key \\ nil)

  def sign(tx, %Dpos.Wallet{} = wallet, second_priv_key) do
    tx
    |> Map.put(:address_suffix_length, wallet.suffix_length)
    |> sign(wallet.priv_key, second_priv_key)
  end

  def sign(tx, priv_key, second_priv_key) when is_binary(priv_key) do
    if tx.timestamp < 0, do: raise("Invalid Timestamp")

    tx
    |> create_signature(priv_key)
    |> create_signature(second_priv_key, :second_signature)
    |> determine_id()
  end

  defp compute_hash(tx) do
    bytes = <<tx.type, tx.timestamp::little-integer-size(32), tx.sender_pkey::bytes-size(32)>>

    bytes =
      if tx.rcpt_address do
        address_length = String.length(tx.rcpt_address) - tx.address_suffix_length

        {int, ""} =
          String.slice(tx.rcpt_address, 0..(address_length - 1))
          |> Integer.parse()

        bytes <> <<int::size(64)>>
      else
        bytes <> String.duplicate(<<0>>, 8)
      end

    bytes = bytes <> <<tx.amount::little-integer-size(64)>>

    bytes =
      if tx.signature do
        bytes <> <<tx.signature::bytes-size(64)>>
      else
        bytes
      end

    bytes =
      if tx.second_signature do
        bytes <> <<tx.second_signature::bytes-size(64)>>
      else
        bytes
      end

    :crypto.hash(:sha256, bytes)
  end

  defp create_signature(tx, priv_key, key \\ :signature)

  defp create_signature(tx, nil, _key), do: tx

  defp create_signature(tx, priv_key, key) do
    {:ok, signature} =
      tx
      |> compute_hash()
      |> Ed25519.sign_detached(priv_key)

    Map.put(tx, key, signature)
  end

  defp determine_id(tx) do
    <<head::bytes-size(8), _tail::bytes>> = compute_hash(tx)

    id =
      head
      |> Dpos.Utils.reverse_binary()
      |> to_string()

    Map.put(tx, :id, id)
  end
end
