defmodule Dpos.Tx.RegisterDelegate do
  @type_id 2
  @amount 0

  def build(attrs) do
    struct!(Dpos.Tx, Map.merge(attrs, %{type: @type_id, amount: @amount}))
  end

  def get_child_bytes(%Dpos.Tx{asset: %{delegate: %{username: username}}}), do: username

  def get_child_bytes(_tx), do: <<>>
end
