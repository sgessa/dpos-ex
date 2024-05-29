defmodule Dpos.Wallet do
  @moduledoc """
  The wallet struct.
  Holds the private key, public key, address and suffix length.
  """

  defstruct [:priv_key, :pub_key, :address, :suffix_length]

  @type t() :: %__MODULE__{}

  @doc """
  Alias for `generate(_secret, "L")`.
  """
  @spec generate_lisk(String.t()) :: t()
  def generate_lisk(secret), do: generate(secret, "L")

  @doc """
  Alias for `generate(_secret, "S")`.
  """
  @spec generate_shift(String.t()) :: t()
  def generate_shift(secret), do: generate(secret, "S")

  @doc """
  Returns a `Dpos.Tx.Wallet` struct.
  """
  @spec generate(String.t(), String.t()) :: t()
  def generate(secret, suffix \\ "L") when is_binary(secret) and is_binary(suffix) do
    {:ok, priv_key, pub_key} = Dpos.Utils.seed_keypair(secret)
    address = Dpos.Utils.derive_address(pub_key, suffix)

    %Dpos.Wallet{
      priv_key: priv_key,
      pub_key: pub_key,
      address: address,
      suffix_length: String.length(suffix)
    }
  end

  @doc """
  Signs a message using the wallet private key.
  Returns the signature.
  """
  @spec sign_message(t(), String.t()) :: {:ok, String.t()}
  def sign_message(%Dpos.Wallet{priv_key: sk}, msg) when is_binary(msg) do
    Dpos.Utils.sign_message(msg, sk)
  end

  @doc """
  Verifies a message using its signature and the wallet public key.
  """
  @spec verify_message(t(), String.t(), binary()) :: :ok
  def verify_message(%Dpos.Wallet{pub_key: pk}, msg, sign)
      when is_binary(msg) and is_binary(sign) do
    Dpos.Utils.verify_message(msg, sign, pk)
  end
end
