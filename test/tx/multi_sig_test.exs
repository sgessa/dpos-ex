defmodule Dpos.Tx.MultiSigTest do
  use ExUnit.Case

  @secret "wagon stock borrow episode laundry kitten salute link globe zero feed marble"

  @tx %Dpos.Tx{
    type: 4,
    amount: 0,
    senderPublicKey: "c094ebee7ec0c50ebee32918655e089f6e1a604b83bcaa760293c61e0f18ab6f",
    timestamp: 73_056_420,
    recipientId: nil,
    id: "5822475998283797000",
    fee: 2_000_000_000,
    signature:
      "28a129d8ddf5a6de0d663e9fef75eab456f335ebe83d3763053fe2123b33198bb6803d9cebef4215fd9c78e9180ed80698333b2f78ffbd7d42e0765f85679f07",
    asset: %{
      multisignature: %{
        min: 2,
        lifetime: 14,
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

    tx =
      Dpos.Tx.MultiSig.build(%{
        fee: @tx.fee,
        timestamp: @tx.timestamp
      })

    tx
    |> Dpos.Tx.MultiSig.set_lifetime(14)
    |> Dpos.Tx.MultiSig.set_min(2)
    |> Dpos.Tx.MultiSig.add_public_key(
      "6267e1754d4b29cae9007fc0b3f0d435f981c90f70281ce053cb1c2243b848a2"
    )
    |> Dpos.Tx.MultiSig.add_public_key(
      "0bc54404ef644519592568687d2bc62593b912a57df319062bb7611b11009ebf"
    )
    |> Dpos.Tx.MultiSig.add_public_key(
      "b65aa5950acf1ade522bcf520f2b2491dcde2f312b4933f56443faff80ad8ebc"
    )
    |> Dpos.Tx.MultiSig.sign(wallet)
    |> Dpos.Tx.MultiSig.normalize()
  end

  describe "multi sig transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
