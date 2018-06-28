defmodule Dpos.Wallet do
  defstruct [:priv_key, :pub_key, :address, :suffix_length]

  def generate_lisk(secret), do: generate(secret, "L")
  def generate_shift(secret), do: generate(secret, "S")
  def generate_lwf(secret), do: generate(secret, "LWF")

  def generate(secret, suffix \\ "L") do
    {priv_key, pub_key} = Dpos.Utils.generate_keypair(secret)
    address = Dpos.Utils.derive_address(pub_key, suffix)

    %Dpos.Wallet{
      priv_key: priv_key,
      pub_key: pub_key,
      address: address,
      suffix_length: String.length(suffix)
    }
  end

  def sign_message(%Dpos.Wallet{priv_key: sk}, message) do
    Dpos.Utils.sign_message(message, sk)
  end

  def verify_message(%Dpos.Wallet{pub_key: pk}, message, signature) do
    Dpos.Utils.verify_message(message, signature, pk)
  end
end
