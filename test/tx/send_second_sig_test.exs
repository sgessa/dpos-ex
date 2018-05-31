defmodule Dpos.Tx.SendSecondSigTest do
  use ExUnit.Case

  @secret "jump bicycle member exist glare hip hero burger volume cover route rare"
  @second_secret "autumn foil east grape walnut mother hello favorite wink shaft fancy about"

  @tx %Dpos.Tx{
    type: 0,
    amount: 15,
    senderPublicKey:
      <<144, 76, 41, 72, 153, 129, 156, 206, 2, 131, 216, 211, 81, 203, 16, 254, 191, 160, 233,
        240, 172, 217, 10, 130, 14, 200, 235, 144, 167, 8, 76, 55>>,
    timestamp: 40_404_848,
    recipientId: "6726252519465624456L",
    signature:
      <<230, 64, 174, 136, 241, 166, 174, 17, 139, 108, 186, 27, 118, 169, 114, 103, 1, 22, 65,
        134, 129, 61, 171, 235, 244, 116, 115, 28, 37, 177, 27, 52, 20, 195, 120, 156, 175, 11,
        91, 139, 133, 177, 24, 11, 87, 141, 63, 199, 198, 161, 41, 31, 95, 50, 21, 71, 87, 213,
        166, 20, 17, 32, 235, 7>>,
    second_signature:
      <<218, 211, 41, 208, 242, 239, 145, 216, 47, 180, 50, 102, 161, 48, 28, 248, 237, 155, 51,
        97, 129, 177, 199, 6, 90, 5, 151, 121, 212, 22, 72, 86, 107, 13, 105, 122, 155, 150, 13,
        5, 233, 104, 184, 208, 188, 118, 95, 117, 39, 228, 226, 105, 173, 81, 41, 89, 51, 225,
        113, 65, 174, 105, 133, 9>>,
    id: "15158421722232362907",
    fee: 10_000_000
  }

  def build_tx() do
    Dpos.Tx.Send.build(%{
      amount: @tx.amount,
      fee: @tx.fee,
      timestamp: @tx.timestamp,
      senderPublicKey: @tx.senderPublicKey,
      recipientId: @tx.recipientId
    })
  end

  def sign_tx(tx) do
    wallet = Dpos.Wallet.generate(@secret)
    second_wallet = Dpos.Wallet.generate(@second_secret)
    Dpos.Tx.sign(tx, wallet.priv_key, second_wallet.priv_key)
  end

  describe "send transaction" do
    test "should match example tx" do
      assert sign_tx(build_tx()) == @tx
    end
  end
end
