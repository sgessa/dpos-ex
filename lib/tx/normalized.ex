defmodule Dpos.Tx.Normalized do
  alias Dpos.{Tx, Utils}

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
  Normalizes the transaction in a format that it could be broadcasted through a relay node.
  """
  @spec normalize(%Tx{}) :: %Tx{}
  def normalize(%Tx{} = tx) do
    tx
    |> Map.put(:senderPublicKey, Utils.hexdigest(tx.senderPublicKey))
    |> Map.put(:signature, Utils.hexdigest(tx.signature))
    |> Map.put(:signSignature, Utils.hexdigest(tx.signSignature))
    |> normalize_asset()
  end

  # Called for Tx.Signature
  defp normalize_asset(%{type: 1, asset: %{signature: %{publicKey: pk}}} = tx) do
    Map.put(tx, :asset, %{signature: %{publicKey: Utils.hexdigest(pk)}})
  end

  defp normalize_asset(tx), do: tx
end
