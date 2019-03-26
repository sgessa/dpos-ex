defmodule Dpos.Tx.Signature do
  alias Dpos.Tx

  @type_id 1
  @amount 0

  def build(attrs) do
    attrs =
      attrs
      |> Tx.validate_timestamp()
      |> Map.put(:type, @type_id)
      |> Map.put(:amount, @amount)

    struct!(Tx, attrs)
  end

  def get_child_bytes(%Dpos.Tx{asset: %{signature: %{pub_key: pk}}}), do: <<pk::bytes>>

  def normalize(%Dpos.Tx{} = tx), do: tx
end
