defmodule Dpos.Tx.Vote do
  alias Dpos.Tx

  @type_id 3
  @amount 0

  def build(attrs) do
    attrs =
      attrs
      |> Tx.validate_timestamp()
      |> Map.put(:type, @type_id)
      |> Map.put(:amount, @amount)

    struct!(Tx, attrs)
  end

  def get_child_bytes(%Tx{asset: %{votes: votes}}), do: <<Enum.join(votes)::bytes>>

  def normalize(%Tx{} = tx), do: tx
end
