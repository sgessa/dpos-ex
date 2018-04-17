defmodule Dpos.Tx.MultiSig do
  @type_id 4
  @amount 0

  def build(attrs) do
    struct!(Dpos.Tx, %{attrs | type: @type_id, amount: @amount})
  end

  def get_child_bytes(%Dpos.Tx{asset: %{multi_sig: %{min: min, group: group, ttl: ttl}}}) do
    group = Enum.join(group)
    <<min::size(8), ttl::size(8), group::bytes>>
  end
end
