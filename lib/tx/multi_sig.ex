defmodule Dpos.Tx.MultiSig do
  use Dpos.Tx, type: 4

  @doc """
  Sets the lifetime in seconds of the multisignature.

  The lifetime must be >= 3600 and <= 259200.
  """
  @spec set_lifetime(Dpos.Tx.t(), pos_integer) :: Dpos.Tx.t()
  def set_lifetime(%Dpos.Tx{} = tx, ttl)
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
  @spec set_min(Dpos.Tx.t(), pos_integer()) :: Dpos.Tx.t()
  def set_min(%Dpos.Tx{} = tx, min) when is_integer(min) and min >= 2 do
    ms =
      tx
      |> get_multi_signature()
      |> Map.put(:min, min)

    Map.put(tx, :asset, %{multisignature: ms})
  end

  @doc """
  Adds a public key to the keysgroup field of the multisignature.
  """
  @spec add_public_key(Dpos.Tx.t(), String.t()) :: Dpos.Tx.t()
  def add_public_key(%Dpos.Tx{} = tx, pub_key)
      when is_binary(pub_key) and byte_size(pub_key) == 64 do
    ms =
      tx
      |> get_multi_signature()
      |> add_to_keysgroup(pub_key)

    Map.put(tx, :asset, %{multisignature: ms})
  end

  defp get_child_bytes(%{asset: %{multisignature: %{min: m, keysgroup: k, lifetime: t}}})
       when is_integer(m) and is_integer(t) and is_list(k) do
    keys = Enum.join(k)
    <<m::size(8), t::size(8), keys::bytes>>
  end

  defp get_child_bytes(_) do
    [
      "Invalid multi signature\n" <>
        "See Tx.MultiSig.set_lifetime/2\n" <>
        "See Tx.MultiSig.set_min/2\n" <>
        "See Tx.MultiSig.add_public_key/2"
    ]
    |> Enum.join()
    |> raise()
  end

  defp get_multi_signature(%{asset: %{multisignature: ms}}) when is_map(ms), do: ms
  defp get_multi_signature(_), do: %{}

  defp add_to_keysgroup(multi_signature, pub_key) do
    keysgroup = multi_signature[:keysgroup] || []
    keysgroup = ["+" <> pub_key | keysgroup]
    Map.put(multi_signature, :keysgroup, keysgroup)
  end
end
