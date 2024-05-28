defmodule Dpos.Utils do
  alias Dpos.Crypto.Ed25519

  @doc """
  Seed a keypair from a secret key.
  """
  @spec seed_keypair(String.t()) :: {:ok, binary(), binary()}
  def seed_keypair(secret) when is_binary(secret) do
    {:ok, pk, sk} =
      :sha256
      |> :crypto.hash(secret)
      |> Ed25519.seed_keypair()

    {:ok, sk, pk}
  end

  @doc """
  Signs a message and returns the signature.
  """
  @spec sign_message(String.t(), binary()) :: {:ok, binary()}
  def sign_message(msg, priv_key)
      when is_binary(msg) and is_binary(priv_key) and byte_size(priv_key) == 64 do
    Ed25519.sign(msg, priv_key)
  end

  @doc """
  Verifies a message.
  """
  @spec verify_message(String.t(), binary(), binary()) :: :ok
  def verify_message(msg, sig, pub_key)
      when is_binary(msg) and is_binary(sig) and is_binary(pub_key) and byte_size(pub_key) == 32 do
    Ed25519.verify_detached(msg, sig, pub_key)
  end

  @doc """
  Derives a wallet address from the public key.
  """
  @spec derive_address(binary(), String.t()) :: String.t()
  def derive_address(pub_key, suffix)
      when is_binary(pub_key) and byte_size(pub_key) == 32 and is_binary(suffix) do
    hash = :crypto.hash(:sha256, pub_key)
    <<head::bytes-size(8), _tail::bytes>> = hash

    head
    |> reverse_binary()
    |> to_string()
    |> Kernel.<>(suffix)
  end

  @doc """
  Reverses the given binary (from little-endian to big-endian).
  """
  @spec reverse_binary(binary()) :: integer()
  def reverse_binary(bin) when is_binary(bin) do
    {int, ""} =
      bin
      |> :binary.decode_unsigned(:little)
      |> :binary.encode_unsigned(:big)
      |> Base.encode16()
      |> Integer.parse(16)

    int
  end

  @doc """
  Encodes the binary in base 16.

  Returns nil if binary is nil.
  """
  @spec hexdigest(binary()) :: String.t()
  def hexdigest(bin)
  def hexdigest(nil), do: nil
  def hexdigest(bin) when is_binary(bin), do: Base.encode16(bin, case: :lower)

  @doc """
  Converts the wallet address to binary.
  """
  @spec address_to_binary(String.t(), pos_integer()) :: binary()
  def address_to_binary(address, suffix_length)
  def address_to_binary(nil, _suffix_length), do: :binary.copy(<<0>>, 8)

  def address_to_binary(address, suffix_length)
      when is_binary(address) and is_integer(suffix_length) do
    len = String.length(address) - suffix_length

    {int, ""} =
      address
      |> String.slice(0..(len - 1))
      |> Integer.parse()

    <<int::size(64)>>
  end

  @doc """
  Ensures signature is a binary 64 bytes long.

  Returns an empty binary if signature is nil.
  """
  @spec signature_to_binary(binary()) :: binary()
  def signature_to_binary(sig)
  def signature_to_binary(nil), do: <<>>
  def signature_to_binary(sig) when is_binary(sig), do: <<sig::bytes-size(64)>>
end
