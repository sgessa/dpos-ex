defmodule Dpos.Tx.MultiSig do
  alias Dpos.Tx

  @type_id 4
  @amount 0

  def build(attrs) do
    attrs =
      attrs
      |> Tx.validate_timestamp()
      |> Map.put(:type, @type_id)
      |> Map.put(:amount, @amount)

    struct!(Tx, attrs)
  end

  def get_child_bytes(%Tx{
        asset: %{multisignature: %{min: min, keysgroup: keys, lifetime: ttl}}
      }) do
    keys = Enum.join(keys)
    <<min::size(8), ttl::size(8), keys::bytes>>
  end
end
