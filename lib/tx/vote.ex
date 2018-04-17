defmodule Dpos.Tx.Vote do
  @type_id 3
  @amount 0

  def build(attrs) do
    struct!(Dpos.Tx, Map.merge(attrs, %{type: @type_id, amount: @amount}))
  end

  def get_child_bytes(%Dpos.Tx{asset: %{votes: votes}}), do: <<Enum.join(votes)::bytes>>
end
