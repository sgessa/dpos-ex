defmodule Dpos.Tx.SecondSignature do
  @moduledoc """
  A transaction to register a secondary public key to sign transactions.

  Example:

  wallet = Wallet.generate("first secret")
  %{pub_key: second_pub_key} = Wallet.generate("second secret")

  Tx.SecondSignature
  |> Tx.build(%{fee: 2500000000})
  |> Tx.SecondSignature.set_public_key(second_pub_key)
  |> Tx.sign(wallet)
  """

  alias Dpos.Tx

  @behaviour Tx

  @impl Tx
  def type_id, do: 1

  @impl Tx
  def get_child_bytes(%{asset: %{signature: %{publicKey: pk}}}), do: <<pk::bytes>>

  def get_child_bytes(_) do
    "Please set the publick key you would like to register.\nSee Tx.Signature.set_public_key/2."
    |> raise()
  end

  @doc """
  Sets the public key to register for second signature.
  """
  @spec set_public_key(Tx.t(), binary()) :: Tx.t()
  def set_public_key(%Tx{} = tx, pub_key)
      when is_binary(pub_key) and byte_size(pub_key) == 32 do
    Map.put(tx, :asset, %{signature: %{publicKey: pub_key}})
  end
end
