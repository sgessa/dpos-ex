defmodule Dpos.Tx.Vote do
  use Dpos.Tx, type: 3

  @doc """
  Adds the delegate's public key to vote.
  """
  @spec vote(%Dpos.Tx{}, String.t()) :: %Dpos.Tx{}
  def vote(%Dpos.Tx{} = tx, pub_key) when is_binary(pub_key) and byte_size(pub_key) == 64 do
    vote(tx, "+", pub_key)
  end

  @doc """
  Adds the delegate's public key to unvote.
  """
  @spec unvote(%Dpos.Tx{}, String.t()) :: %Dpos.Tx{}
  def unvote(%Dpos.Tx{} = tx, pub_key) when is_binary(pub_key) and byte_size(pub_key) == 64 do
    vote(tx, "-", pub_key)
  end

  defp get_child_bytes(%{asset: %{votes: votes}}) when is_list(votes),
    do: <<Enum.join(votes)::bytes>>

  defp get_child_bytes(_) do
    [
      "Please vote or unvote at least a public key\n",
      "See Tx.Vote.vote/2\n",
      "See Tx.Vote.unvote/2"
    ]
    |> Enum.join()
    |> raise()
  end

  defp get_votes(%{asset: %{votes: votes}}) when is_list(votes), do: votes
  defp get_votes(_), do: []

  defp vote(tx, sign, pub_key) do
    votes =
      tx
      |> get_votes()
      |> Kernel.++([sign <> pub_key])

    Map.put(tx, :asset, %{votes: votes})
  end
end
