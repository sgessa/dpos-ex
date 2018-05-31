defmodule Dpos.Tx.VoteTest do
  use ExUnit.Case

  @secret "wagon stock borrow episode laundry kitten salute link globe zero feed marble"

  @tx %Dpos.Tx{
    type: 3,
    amount: 0,
    senderPublicKey:
      <<192, 148, 235, 238, 126, 192, 197, 14, 190, 227, 41, 24, 101, 94, 8, 159, 110, 26, 96, 75,
        131, 188, 170, 118, 2, 147, 198, 30, 15, 24, 171, 111>>,
    timestamp: 3000,
    asset: %{
      votes: [
        "+01389197bbaf1afb0acd47bbfeabb34aca80fb372a8f694a1c0716b3398db746"
      ]
    },
    recipientId: "16313739661670634666L",
    signature:
      <<193, 250, 74, 239, 155, 7, 67, 189, 153, 218, 244, 150, 79, 249, 54, 38, 226, 220, 156,
        97, 102, 185, 186, 115, 49, 28, 244, 246, 113, 74, 60, 204, 64, 129, 83, 57, 241, 59, 60,
        147, 162, 20, 8, 85, 199, 149, 139, 184, 55, 62, 231, 231, 166, 74, 196, 86, 2, 183, 90,
        162, 129, 159, 224, 11>>,
    id: "232176044966210996",
    fee: 100_000_000
  }

  def build_tx(asset \\ %{}) do
    Dpos.Tx.Vote.build(%{
      fee: @tx.fee,
      timestamp: @tx.timestamp,
      senderPublicKey: @tx.senderPublicKey,
      recipientId: @tx.recipientId,
      asset: asset
    })
  end

  def sign_tx(tx) do
    wallet = Dpos.Wallet.generate(@secret)
    Dpos.Tx.sign(tx, wallet.priv_key)
  end

  describe "vote transaction" do
    test "should match example tx" do
      tx =
        @tx.asset
        |> build_tx()
        |> sign_tx()

      assert tx == @tx
    end
  end
end
