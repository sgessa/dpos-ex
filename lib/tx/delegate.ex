defmodule Dpos.Tx.Delegate do
  use Dpos.Tx, type: 2

  @doc """
  Sets the delegate username to be registered.
  """
  @spec set_delegate(Dpos.Tx.t(), String.t()) :: Dpos.Tx.t()
  def set_delegate(%Dpos.Tx{} = tx, username) when is_binary(username) do
    username = username |> String.downcase() |> String.trim()
    Map.put(tx, :asset, %{delegate: %{username: username}})
  end

  defp get_child_bytes(%{asset: %{delegate: %{username: username}}}) when is_binary(username),
    do: username

  defp get_child_bytes(_),
    do: raise("Please set a delegate name\nSee Tx.Delegate.set_delegate/2")
end
