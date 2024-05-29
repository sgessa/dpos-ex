defmodule Tx.MultiSigTest do
  use ExUnit.Case

  alias Dpos.Tx

  @secret "wagon stock borrow episode laundry kitten salute link globe zero feed marble"

  @tx %Tx{
    type: 4,
    amount: 0,
    senderPublicKey: "c094ebee7ec0c50ebee32918655e089f6e1a604b83bcaa760293c61e0f18ab6f",
    timestamp: 73_056_420,
    recipientId: nil,
    id: "4885146472837367544",
    fee: 2_000_000_000,
    signature:
      "cc5f80d136178e9db65c9679cd7e5421e68917c36c86a9611f8b45e8618c817b8c4c1e58109930515aeffe187492486af35e93dc2f5d5addb53e06e914335e09",
    asset: %{
      multisignature: %{
        min: 2,
        lifetime: 3600,
        keysgroup: [
          "+b65aa5950acf1ade522bcf520f2b2491dcde2f312b4933f56443faff80ad8ebc",
          "+0bc54404ef644519592568687d2bc62593b912a57df319062bb7611b11009ebf",
          "+6267e1754d4b29cae9007fc0b3f0d435f981c90f70281ce053cb1c2243b848a2"
        ]
      }
    }
  }

  def build_and_sign_tx() do
    wallet = Dpos.Wallet.generate(@secret)

    %{fee: @tx.fee, timestamp: @tx.timestamp}
    |> Tx.MultiSig.build()
    |> Tx.MultiSig.set_lifetime(3600)
    |> Tx.MultiSig.set_min(2)
    |> Tx.MultiSig.add_public_key(
      "6267e1754d4b29cae9007fc0b3f0d435f981c90f70281ce053cb1c2243b848a2"
    )
    |> Tx.MultiSig.add_public_key(
      "0bc54404ef644519592568687d2bc62593b912a57df319062bb7611b11009ebf"
    )
    |> Tx.MultiSig.add_public_key(
      "b65aa5950acf1ade522bcf520f2b2491dcde2f312b4933f56443faff80ad8ebc"
    )
    |> Tx.MultiSig.sign(wallet)
    |> Tx.normalize()
  end

  describe "multi sig transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
