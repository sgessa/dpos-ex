defmodule Dpos.Tx.MultiSig do
  @type_id 4
  @amount 0

  def build(attrs) do
    struct!(Dpos.Tx, Map.merge(attrs, %{type: @type_id, amount: @amount}))
  end

  def get_child_bytes(%Dpos.Tx{
        asset: %{multisignature: %{min: min, keysgroup: keys, lifetime: ttl}}
      }) do
    keys = Enum.join(keys)
    <<min::size(8), ttl::size(8), keys::bytes>>
  end
end
