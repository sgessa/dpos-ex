defmodule Tx.SecondSignatureTest do
  use ExUnit.Case

  alias Dpos.{Tx, Utils, Wallet}

  @delegate_secret "robust swift grocery peasant forget share enable convince deputy road keep cheap"

  @tx %Tx{
    type: 1,
    amount: 0,
    fee: 2_500_000_000,
    id: "5346148086335491279",
    recipientId: nil,
    senderPublicKey: "9d3058175acab969f41ad9b86f7a2926c74258670fe56b37c429c01fca9f2f0f",
    timestamp: 0,
    asset: %{
      signature: %{publicKey: "f965aeb00689760467f15c3ca144be64c49a237ab1ea71746d2351add78a0b65"}
    },
    signature:
      "21251e1652df90191d3fbf74ee2426b0bf6e6302e666ad1d301410f4ec7a47755dc9e57003eef26cf18e0f3c60a31e80a8c9a38becc89b5bae47f50692fff100"
  }

  def build_and_sign_tx() do
    wallet = Wallet.generate(@delegate_secret)
    {:ok, _, second_pub_key} = Utils.seed_keypair("my secret")

    %{fee: @tx.fee, timestamp: @tx.timestamp}
    |> Tx.Signature.build()
    |> Tx.Signature.set_public_key(second_pub_key)
    |> Tx.Signature.sign(wallet)
    |> Tx.normalize()
  end

  describe "register signature transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
