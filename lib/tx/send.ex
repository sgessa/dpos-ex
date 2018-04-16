defmodule Dpos.Tx.Send do
  @type_id 0

  def build(attrs) do
    struct!(Dpos.Tx, Map.put(attrs, :type, @type_id))
  end

  def get_child_bytes(_tx), do: <<>>
end
