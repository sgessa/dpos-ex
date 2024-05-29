defmodule Dpos.Tx.Send do
  @moduledoc """
  A transaction to send crypto to an other recipient.

  Example:

  Tx.Send
  |> Tx.build(%{amount: 8840, fee: 100})
  |> Tx.sign(wallet)
  """

  alias Dpos.Tx

  @behaviour Tx

  @impl Tx
  def type_id, do: 0

  @impl Tx
  def get_child_bytes(%Tx{}), do: ""
end
