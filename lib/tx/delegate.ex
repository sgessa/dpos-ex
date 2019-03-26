defmodule Dpos.Tx.Delegate do
  alias Dpos.Tx

  @type_id 2
  @amount 0

  def build(attrs) do
    attrs =
      attrs
      |> normalize_asset()
      |> Tx.validate_timestamp()
      |> Map.put(:type, @type_id)
      |> Map.put(:amount, @amount)

    struct!(Tx, attrs)
  end

  def get_child_bytes(%Tx{asset: %{delegate: %{username: username}}}), do: username

  def normalize(%Tx{} = tx), do: tx

  defp normalize_asset(%{asset: %{delegate: %{username: username}}} = attrs) do
    username = username |> String.downcase() |> String.trim()
    Map.put(attrs, :asset, %{delegate: %{username: username}})
  end

  defp normalize_asset(attrs), do: attrs
end
