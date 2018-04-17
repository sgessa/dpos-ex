defmodule Dpos.Tx.Signature do
  @type_id 1
  @amount 0

  def build(attrs) do
    struct!(Dpos.Tx, Map.merge(attrs, %{type: @type_id, amount: @amount}))
  end

  def get_child_bytes(%Dpos.Tx{asset: %{signature: %{pub_key: pk}}}), do: <<pk::bytes>>
end
