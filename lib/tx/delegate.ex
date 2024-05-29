defmodule Dpos.Tx.Delegate do
  alias Dpos.Tx

  @behaviour Tx

  @impl Tx
  def type_id, do: 2

  @impl Tx
  def get_child_bytes(%{asset: %{delegate: %{username: username}}}) when is_binary(username),
    do: username

  def get_child_bytes(_tx),
    do: raise("Please set a delegate name\nSee Tx.Delegate.set_delegate/2")

  @doc """
  Sets the delegate username to be registered.
  """
  @spec set_delegate(%Tx{}, String.t()) :: %Tx{}
  def set_delegate(%Tx{} = tx, username) when is_binary(username) do
    username = username |> String.downcase() |> String.trim()
    Map.put(tx, :asset, %{delegate: %{username: username}})
  end
end
