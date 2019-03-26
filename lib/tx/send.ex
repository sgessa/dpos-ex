defmodule Dpos.Tx.Send do
  alias Dpos.Tx

  @type_id 0

  def build(attrs) do
    attrs =
      attrs
      |> Map.put(:type, @type_id)
      |> Tx.validate_timestamp()

    struct!(Tx, attrs)
  end

  def get_child_bytes(%Tx{asset: %{note: note}}), do: <<note::bytes>>
  def get_child_bytes(_tx), do: <<>>

  def normalize(%Tx{} = tx), do: tx
end
