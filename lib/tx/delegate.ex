defmodule Dpos.Tx.Delegate do
  @type_id 2
  @amount 0

  def build(attrs) do
    asset = normalize_asset(attrs)
    struct!(Dpos.Tx, Map.merge(attrs, %{type: @type_id, amount: @amount, asset: asset}))
  end

  def get_child_bytes(%Dpos.Tx{asset: %{delegate: %{username: username}}}), do: username

  defp normalize_asset(%{asset: %{delegate: %{username: username}}}) do
    username =
      username
      |> String.downcase()
      |> String.trim()

    %{delegate: %{username: username}}
  end

  defp normalize_asset(attrs), do: attrs
end
