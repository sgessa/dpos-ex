defmodule Dpos.Tx.SignatureTest do
  use ExUnit.Case

  @secret "my secret"

  @tx %Dpos.Tx{
    type: 1,
    amount: 0,
    senderPublicKey:
      <<249, 101, 174, 176, 6, 137, 118, 4, 103, 241, 92, 60, 161, 68, 190, 100, 196, 154, 35,
        122, 177, 234, 113, 116, 109, 35, 81, 173, 215, 138, 11, 101>>,
    timestamp: 31337,
    asset: %{
      signature: %{
        pub_key:
          <<87, 153, 36, 247, 110, 2, 35, 53, 18, 33, 166, 85, 105, 36, 195, 168, 45, 16, 90, 53,
            187, 145, 100, 115, 99, 209, 139, 185, 84, 221, 181, 24>>
      }
    },
    recipientId: "2340651171948227443L",
    signature:
      <<30, 176, 173, 203, 104, 176, 234, 72, 192, 18, 162, 206, 91, 94, 244, 24, 254, 196, 224,
        148, 48, 95, 89, 62, 39, 97, 227, 131, 38, 229, 241, 83, 202, 248, 192, 140, 89, 107, 73,
        16, 241, 6, 40, 215, 68, 58, 194, 165, 60, 76, 236, 74, 248, 145, 151, 246, 109, 225, 51,
        218, 201, 35, 142, 11>>,
    id: "2201705324276812645",
    fee: 10
  }

  def build_tx(asset \\ %{}) do
    Dpos.Tx.Signature.build(%{
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

  describe "signature transaction" do
    test "should match example tx" do
      tx =
        @tx.asset
        |> build_tx()
        |> sign_tx()

      assert tx == @tx
    end
  end
end
