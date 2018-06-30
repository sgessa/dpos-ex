defmodule Dpos.Tx.MultiSigTest do
  use ExUnit.Case

  @secret "my secret"
  @senderPublicKey <<94, 169, 241, 207, 48, 182, 157, 239, 77, 88, 214, 50, 206, 24, 190, 230,
                     190, 218, 54, 168, 1, 95, 226, 74, 49, 200, 120, 138, 47, 252, 38, 178>>

  @tx %Dpos.Tx{
    type: 4,
    amount: 0,
    senderPublicKey: @senderPublicKey,
    timestamp: 3000,
    asset: %{
      multisignature: %{
        min: 2,
        keysgroup: [
          @senderPublicKey,
          <<138, 199, 109, 65, 163, 134, 218, 235, 205, 249, 171, 150, 94, 130, 245, 203, 104, 25,
            191, 153, 59, 166, 100, 66, 2, 86, 152, 15, 212, 106, 209, 180>>,
          <<191, 216, 193, 125, 233, 49, 196, 165, 40, 184, 150, 229, 222, 111, 210, 114, 25, 209,
            194, 99, 26, 59, 214, 7, 74, 174, 38, 95, 202, 143, 136, 16>>
        ],
        lifetime: 48
      }
    },
    recipientId: "4710442220763968163L",
    signature:
      <<193, 250, 74, 239, 155, 7, 67, 189, 153, 218, 244, 150, 79, 249, 54, 38, 226, 220, 156,
        97, 102, 185, 186, 115, 49, 28, 244, 246, 113, 74, 60, 204, 64, 129, 83, 57, 241, 59, 60,
        147, 162, 20, 8, 85, 199, 149, 139, 184, 55, 62, 231, 231, 166, 74, 196, 86, 2, 183, 90,
        162, 129, 159, 224, 11>>,
    id: "14379964418280410957",
    fee: 1_000
  }

  def build_tx(asset \\ %{}) do
    Dpos.Tx.MultiSig.build(%{
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

  describe "multi sig transaction" do
    test "should match example tx" do
      tx =
        @tx.asset
        |> build_tx()
        |> sign_tx()

      assert tx == @tx
    end
  end
end
