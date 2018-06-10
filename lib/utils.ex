defmodule Dpos.Utils do
  alias Salty.Sign.Ed25519

  def generate_keypair(secret) do
    {:ok, pk, sk} =
      :sha256
      |> :crypto.hash(secret)
      |> Ed25519.seed_keypair()

    {sk, pk}
  end

  def derive_address(pk, suffix) do
    pk_hash = :crypto.hash(:sha256, pk)
    <<head::bytes-size(8), _tail::bytes>> = pk_hash

    head
    |> reverse_binary()
    |> to_string()
    |> Kernel.<>(suffix)
  end

  def reverse_binary(binary) do
    {int, ""} =
      binary
      |> :binary.decode_unsigned(:little)
      |> :binary.encode_unsigned(:big)
      |> Base.encode16()
      |> Integer.parse(16)

    int
  end

  def hexdigest(nil), do: nil
  def hexdigest(b), do: Base.encode16(b, case: :lower)
end
