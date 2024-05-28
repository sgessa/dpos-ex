defmodule Dpos.Crypto.Ed25519 do
  @moduledoc """
  Wrap crypto erlang functions to work with ED25519
  """

  @dialyzer {:nowarn_function, sign: 2}
  @spec sign(binary(), binary()) :: {:ok, binary()}
  def sign(message, private_key) when byte_size(private_key) == 32 do
    {:ok, public_key, ^private_key} = seed_keypair(private_key)
    signature = :public_key.sign(message, :none, {:ed_pri, :ed25519, public_key, private_key})
    {:ok, signature}
  end

  @dialyzer {:nowarn_function, verify_detached: 3}
  @spec verify_detached(binary(), binary(), binary()) :: :ok | {:error, :invalid_signature}
  def verify_detached(message, signature, public_key)
      when byte_size(signature) == 64 and byte_size(public_key) == 32 do
    if :public_key.verify(message, :none, signature, {:ed_pub, :ed25519, public_key}) do
      :ok
    else
      {:error, :invalid_signature}
    end
  end

  @spec seed_keypair(binary()) :: {:ok, binary(), binary()}
  def seed_keypair(private_key) when byte_size(private_key) == 32 do
    {pk, sk} = :crypto.generate_key(:eddsa, :ed25519, private_key)
    {:ok, pk, sk}
  end

  @spec generate_keypair() :: {:ok, binary(), binary()}
  def generate_keypair do
    {pk, sk} = :crypto.generate_key(:eddsa, :ed25519)
    {:ok, pk, sk}
  end
end
