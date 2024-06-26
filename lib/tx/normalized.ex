defmodule Dpos.Tx.Normalized do
  @moduledoc """
  Normalized transaction data structure to be broadcasted via a relay node.
  """

  alias Dpos.{Tx, Utils}

  @type t :: %__MODULE__{}

  @derive Jason.Encoder
  defstruct [
    :id,
    :recipientId,
    :senderPublicKey,
    :signature,
    :signSignature,
    :timestamp,
    :type,
    amount: 0,
    asset: %{},
    fee: 0
  ]

  @doc """
  Normalizes the transaction in a format that it could be broadcasted through a relay node.
  """
  @spec normalize(Tx.t()) :: t()
  def normalize(%Tx{} = tx) do
    attrs = Map.take(tx, [:id, :timestamp, :amount, :fee, :asset])

    %__MODULE__{}
    |> Map.merge(attrs)
    |> Map.put(:type, tx.type.type_id())
    |> Map.put(:recipientId, tx.recipient)
    |> Map.put(:senderPublicKey, Utils.hexdigest(tx.public_key))
    |> Map.put(:signature, Utils.hexdigest(tx.signature))
    |> Map.put(:signSignature, Utils.hexdigest(tx.second_signature))
    |> normalize_asset()
  end

  # Called for Tx.Signature
  defp normalize_asset(%{type: 1, asset: %{signature: %{publicKey: pk}}} = tx) do
    Map.put(tx, :asset, %{signature: %{publicKey: Utils.hexdigest(pk)}})
  end

  defp normalize_asset(tx), do: tx
end
