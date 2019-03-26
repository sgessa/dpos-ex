defmodule Dpos.Tx.SendSecondSigTest do
  use ExUnit.Case

  @secret "jump bicycle member exist glare hip hero burger volume cover route rare"
  @second_secret "autumn foil east grape walnut mother hello favorite wink shaft fancy about"

  @tx %Dpos.Tx{
    type: 0,
    amount: 15,
    senderPublicKey: "904c294899819cce0283d8d351cb10febfa0e9f0acd90a820ec8eb90a7084c37",
    timestamp: 40_404_848,
    recipientId: "6726252519465624456L",
    signature:
      "e640ae88f1a6ae118b6cba1b76a9726701164186813dabebf474731c25b11b3414c3789caf0b5b8b85b1180b578d3fc7c6a1291f5f32154757d5a6141120eb07",
    signSignature:
      "dad329d0f2ef91d82fb43266a1301cf8ed9b336181b1c7065a059779d41648566b0d697a9b960d05e968b8d0bc765f7527e4e269ad51295933e17141ae698509",
    id: "15158421722232362907",
    fee: 10_000_000
  }

  def build_and_sign_tx() do
    wallet = Dpos.Wallet.generate(@secret)
    {second_priv_key, _} = Dpos.Utils.generate_keypair(@second_secret)

    tx =
      Dpos.Tx.Send.build(%{
        amount: @tx.amount,
        fee: @tx.fee,
        timestamp: @tx.timestamp,
        senderPublicKey: wallet.pub_key,
        recipientId: @tx.recipientId
      })

    tx
    |> Dpos.Tx.sign(wallet, second_priv_key)
    |> Dpos.Tx.normalize()
  end

  describe "send transaction" do
    test "should match example tx" do
      assert build_and_sign_tx() == @tx
    end
  end
end
