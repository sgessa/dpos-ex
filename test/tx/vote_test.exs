defmodule Dpos.Tx.VoteTest do
  use ExUnit.Case

  @secret "wagon stock borrow episode laundry kitten salute link globe zero feed marble"

  @tx %Dpos.Tx{
    type: 3,
    amount: 0,
    senderPublicKey: "c094ebee7ec0c50ebee32918655e089f6e1a604b83bcaa760293c61e0f18ab6f",
    timestamp: 3000,
    recipientId: "16313739661670634666L",
    id: "232176044966210996",
    fee: 100_000_000,
    signature:
      "c1fa4aef9b0743bd99daf4964ff93626e2dc9c6166b9ba73311cf4f6714a3ccc40815339f13b3c93a2140855c7958bb8373ee7e7a64ac45602b75aa2819fe00b",
    asset: %{
      votes: [
        "+01389197bbaf1afb0acd47bbfeabb34aca80fb372a8f694a1c0716b3398db746"
      ]
    }
  }

  def build_and_sign_tx() do
    wallet = Dpos.Wallet.generate(@secret)

    tx =
      Dpos.Tx.Vote.build(%{
        fee: @tx.fee,
        timestamp: @tx.timestamp,
        recipientId: @tx.recipientId
      })

    tx
    |> Dpos.Tx.Vote.vote("01389197bbaf1afb0acd47bbfeabb34aca80fb372a8f694a1c0716b3398db746")
    |> Dpos.Tx.Vote.sign(wallet)
    |> Dpos.Tx.Vote.normalize()
  end

  describe "vote transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
