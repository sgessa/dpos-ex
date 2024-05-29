defmodule Dpos.Tx.MultiSig do
  @moduledoc """
  A Multi Sig transaction.

  Example:

  Tx.MultiSig
  |> Tx.build(%{fee: 2000000000, timestamp: 73056420})
  |> Tx.MultiSig.set_lifetime(3600)
  |> Tx.MultiSig.set_min(2)
  |> Tx.MultiSig.add_public_key("6267e1754d4b29cae9007fc0b3f0d435f981c90f70281ce053cb1c2243b848a2")
  |> Tx.MultiSig.add_public_key("0bc54404ef644519592568687d2bc62593b912a57df319062bb7611b11009ebf")
  |> Tx.MultiSig.add_public_key("b65aa5950acf1ade522bcf520f2b2491dcde2f312b4933f56443faff80ad8ebc")
  |> Tx.sign(wallet)
  """

  alias Dpos.Tx

  @behaviour Tx

  @impl Tx
  def type_id, do: 4

  @impl Tx
  def get_child_bytes(%{asset: %{multisignature: %{min: m, keysgroup: k, lifetime: t}}})
      when is_integer(m) and is_integer(t) and is_list(k) do
    keys = Enum.join(k)
    <<m::size(8), t::size(8), keys::bytes>>
  end

  def get_child_bytes(_tx) do
    [
      "Invalid multi signature\n" <>
        "See Tx.MultiSig.set_lifetime/2\n" <>
        "See Tx.MultiSig.set_min/2\n" <>
        "See Tx.MultiSig.add_public_key/2"
    ]
    |> Enum.join()
    |> raise()
  end

  @doc """
  Sets the lifetime in seconds of the multisignature.

  The lifetime must be >= 3600 and <= 259200.
  """
  @spec set_lifetime(Tx.t(), pos_integer) :: Tx.t()
  def set_lifetime(%Tx{} = tx, ttl)
      when is_integer(ttl) and ttl >= 3600 and ttl <= 259_200 do
    ms =
      tx
      |> get_multi_signature()
      |> Map.put(:lifetime, ttl)

    Map.put(tx, :asset, %{multisignature: ms})
  end

  @doc """
  Sets the minimum number of signatures required to validate a transaction.

  The minimum possible value is 2.
  """
  @spec set_min(Tx.t(), pos_integer()) :: Tx.t()
  def set_min(%Tx{} = tx, min) when is_integer(min) and min >= 2 do
    ms =
      tx
      |> get_multi_signature()
      |> Map.put(:min, min)

    Map.put(tx, :asset, %{multisignature: ms})
  end

  @doc """
  Adds a public key to the keysgroup field of the multisignature.
  """
  @spec add_public_key(Tx.t(), String.t()) :: Tx.t()
  def add_public_key(%Tx{} = tx, pub_key)
      when is_binary(pub_key) and byte_size(pub_key) == 64 do
    ms =
      tx
      |> get_multi_signature()
      |> add_to_keysgroup(pub_key)

    Map.put(tx, :asset, %{multisignature: ms})
  end

  defp get_multi_signature(%{asset: %{multisignature: ms}}) when is_map(ms), do: ms
  defp get_multi_signature(_), do: %{}

  defp add_to_keysgroup(multi_signature, pub_key) do
    keysgroup = multi_signature[:keysgroup] || []
    keysgroup = ["+" <> pub_key | keysgroup]
    Map.put(multi_signature, :keysgroup, keysgroup)
  end
end
