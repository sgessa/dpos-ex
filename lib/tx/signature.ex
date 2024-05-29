defmodule Dpos.Tx.Signature do
  alias Dpos.Tx

  use Tx, type: 1

  @doc """
  Sets the public key to register for second signature.
  """
  @spec set_public_key(%Tx{}, binary()) :: %Tx{}
  def set_public_key(%Tx{} = tx, pub_key)
      when is_binary(pub_key) and byte_size(pub_key) == 32 do
    Map.put(tx, :asset, %{signature: %{publicKey: pub_key}})
  end

  defp get_child_bytes(%{asset: %{signature: %{publicKey: pk}}}), do: <<pk::bytes>>

  defp get_child_bytes(_) do
    "Please set the publick key you would like to register.\nSee Tx.Signature.set_public_key/2."
    |> raise()
  end
end
