defmodule Dpos.Tx.Vote do
  @moduledoc """
  A transaction to vote or unvote delegates.

  Example:

  Tx.Vote
  |> Tx.build(%{fee: 100000000, recipient: "16313739661670634666L"})
  |> Tx.Vote.vote("01389197bbaf1afb0acd47bbfeabb34aca80fb372a8f694a1c0716b3398db746")
  |> Tx.sign(wallet)
  |> Tx.normalize()
  """

  alias Dpos.Tx

  @behaviour Tx

  @impl Tx
  def type_id, do: 3

  @impl Tx
  def get_child_bytes(%Tx{asset: %{votes: votes}}) when is_list(votes),
    do: <<Enum.join(votes)::bytes>>

  def get_child_bytes(_tx) do
    [
      "Please vote or unvote at least a public key",
      "See Tx.Vote.vote/2",
      "See Tx.Vote.unvote/2"
    ]
    |> Enum.join("\n")
    |> raise()
  end

  @doc """
  Adds the delegate's public key to vote.
  """
  @spec vote(Tx.t(), String.t()) :: Tx.t()
  def vote(%Tx{} = tx, pub_key) when is_binary(pub_key) and byte_size(pub_key) == 64 do
    vote(tx, "+", pub_key)
  end

  @doc """
  Adds the delegate's public key to unvote.
  """
  @spec unvote(Tx.t(), String.t()) :: Tx.t()
  def unvote(%Tx{} = tx, pub_key) when is_binary(pub_key) and byte_size(pub_key) == 64 do
    vote(tx, "-", pub_key)
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
