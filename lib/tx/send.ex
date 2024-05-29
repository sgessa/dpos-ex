defmodule Dpos.Tx.Send do
  alias Dpos.Tx

  @behaviour Tx

  @impl Tx
  def type_id, do: 0

  @impl Tx
  def get_child_bytes(%Tx{}), do: ""
end
