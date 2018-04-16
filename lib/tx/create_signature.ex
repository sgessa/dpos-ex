defmodule Dpos.Tx.CreateSignature do
  @type_id 1
  @amount 0

  def build(attrs) do
    struct!(Dpos.Tx, %{attrs | type: @type, amount: @amount})
  end

  def get_child_bytes(_tx), do: <<>>
end
