defmodule Tx.SendTest do
  use ExUnit.Case

  alias Dpos.{Tx, Wallet}

  @secret "wagon stock borrow episode laundry kitten salute link globe zero feed marble"

  @tx %Tx.Normalized{
    type: 0,
    amount: 8840,
    senderPublicKey: "c094ebee7ec0c50ebee32918655e089f6e1a604b83bcaa760293c61e0f18ab6f",
    timestamp: 6030,
    recipientId: "2581762640681118072L",
    signature:
      "23189880562d8fa55f723f673c7b6afacb9712da8647bd140d589a9ecac6aa10215cd00e922bb0ec548bccbde7b40ffb3a30ae97e4e7b5e86d93129f7f36b80e",
    id: "10564000757818327695",
    fee: 10_000_000
  }

  def build_and_sign_tx() do
    wallet = Wallet.generate(@secret)

    tx =
      Tx.build(Tx.Send, %{
        amount: @tx.amount,
        fee: @tx.fee,
        timestamp: @tx.timestamp,
        public_key: wallet.pub_key,
        recipient: @tx.recipientId
      })

    tx
    |> Tx.sign(wallet)
    |> Tx.normalize()
  end

  describe "send transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
