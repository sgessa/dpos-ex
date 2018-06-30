defmodule Dpos.Tx.SendTest do
  use ExUnit.Case

  @secret "wagon stock borrow episode laundry kitten salute link globe zero feed marble"

  @tx %Dpos.Tx{
    type: 0,
    amount: 8840,
    senderPublicKey:
      <<192, 148, 235, 238, 126, 192, 197, 14, 190, 227, 41, 24, 101, 94, 8, 159, 110, 26, 96, 75,
        131, 188, 170, 118, 2, 147, 198, 30, 15, 24, 171, 111>>,
    timestamp: 6030,
    recipientId: "2581762640681118072L",
    signature:
      <<35, 24, 152, 128, 86, 45, 143, 165, 95, 114, 63, 103, 60, 123, 106, 250, 203, 151, 18,
        218, 134, 71, 189, 20, 13, 88, 154, 158, 202, 198, 170, 16, 33, 92, 208, 14, 146, 43, 176,
        236, 84, 139, 204, 189, 231, 180, 15, 251, 58, 48, 174, 151, 228, 231, 181, 232, 109, 147,
        18, 159, 127, 54, 184, 14>>,
    id: "10564000757818327695",
    fee: 10_000_000,
    asset: %{}
  }

  @tx2 %Dpos.Tx{
    type: 0,
    amount: 8840,
    senderPublicKey:
      <<192, 148, 235, 238, 126, 192, 197, 14, 190, 227, 41, 24, 101, 94, 8, 159, 110, 26, 96, 75,
        131, 188, 170, 118, 2, 147, 198, 30, 15, 24, 171, 111>>,
    timestamp: 6030,
    recipientId: "2581762640681118072L",
    signature:
      <<35, 24, 152, 128, 86, 45, 143, 165, 95, 114, 63, 103, 60, 123, 106, 250, 203, 151, 18,
        218, 134, 71, 189, 20, 13, 88, 154, 158, 202, 198, 170, 16, 33, 92, 208, 14, 146, 43, 176,
        236, 84, 139, 204, 189, 231, 180, 15, 251, 58, 48, 174, 151, 228, 231, 181, 232, 109, 147,
        18, 159, 127, 54, 184, 14>>,
    id: "10564000757818327695",
    fee: 10_000_000,
    asset: %{
      note: "Testing SendTx note"
    }
  }

  def build_tx(asset \\ %{}) do
    Dpos.Tx.Send.build(%{
      amount: @tx.amount,
      fee: @tx.fee,
      timestamp: @tx.timestamp,
      senderPublicKey: @tx.senderPublicKey,
      recipientId: @tx.recipientId,
      asset: asset
    })
  end

  def sign_tx(tx) do
    wallet = Dpos.Wallet.generate(@secret)
    Dpos.Tx.sign(tx, wallet)
  end

  describe "send transaction" do
    test "should match example tx" do
      assert sign_tx(build_tx()) == @tx
    end

    test "should match example tx with note" do
      tx =
        @tx2.asset
        |> build_tx()
        |> sign_tx()

      assert tx == @tx2
    end
  end
end
