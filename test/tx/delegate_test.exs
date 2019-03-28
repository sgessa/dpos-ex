defmodule Dpos.Tx.DelegateTest do
  use ExUnit.Case

  @delegate_secret "robust swift grocery peasant forget share enable convince deputy road keep cheap"

  @tx %Dpos.Tx{
    type: 2,
    amount: 0,
    senderPublicKey: "9d3058175acab969f41ad9b86f7a2926c74258670fe56b37c429c01fca9f2f0f",
    timestamp: 0,
    asset: %{delegate: %{username: "genesis_1"}},
    recipientId: nil,
    signature:
      "0432bb4aac5ab307ab56e75e46c2d79b34fe7ad244d28d53151f9e587bc7df6be012e7d225497c9eb90b009e3aa90a365049392bec9aca9356f0142ad5312609",
    id: "11209400488510627518",
    fee: 2_500_000_000
  }

  def build_and_sign_tx() do
    wallet = Dpos.Wallet.generate(@delegate_secret)

    %{fee: @tx.fee, timestamp: @tx.timestamp}
    |> Dpos.Tx.Delegate.build()
    |> Dpos.Tx.Delegate.set_delegate("genesis_1")
    |> Dpos.Tx.Delegate.sign(wallet)
    |> Dpos.Tx.Delegate.normalize()
  end

  describe "delegate transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
