defmodule Dpos.Tx.RegisterDelegateTest do
  use ExUnit.Case

  @delegate_secret "robust swift grocery peasant forget share enable convince deputy road keep cheap"

  @delegate_pk <<157, 48, 88, 23, 90, 202, 185, 105, 244, 26, 217, 184, 111, 122, 41, 38, 199, 66,
                 88, 103, 15, 229, 107, 55, 196, 41, 192, 31, 202, 159, 47, 15>>

  @tx %Dpos.Tx{
    type: 2,
    amount: 0,
    sender_pkey: @delegate_pk,
    requester_pkey: nil,
    timestamp: 0,
    asset: %{
      delegate: %{
        username: "genesis_1",
        pub_key: @delegate_pk
      }
    },
    rcpt_address: nil,
    signature:
      <<4, 50, 187, 74, 172, 90, 179, 7, 171, 86, 231, 94, 70, 194, 215, 155, 52, 254, 122, 210,
        68, 210, 141, 83, 21, 31, 158, 88, 123, 199, 223, 107, 224, 18, 231, 210, 37, 73, 124,
        158, 185, 11, 0, 158, 58, 169, 10, 54, 80, 73, 57, 43, 236, 154, 202, 147, 86, 240, 20,
        42, 213, 49, 38, 9>>,
    id: "11209400488510627518",
    fee: 2_500_000_000
  }

  def build_tx(asset \\ %{}) do
    Dpos.Tx.RegisterDelegate.build(%{
      fee: @tx.fee,
      timestamp: @tx.timestamp,
      sender_pkey: @tx.sender_pkey,
      asset: asset
    })
  end

  def sign_tx(tx) do
    wallet = Dpos.Wallet.generate(@delegate_secret)
    Dpos.Tx.sign(tx, wallet.priv_key)
  end

  test "delegate transaction" do
    tx =
      @tx.asset
      |> build_tx()
      |> sign_tx()

    assert tx == @tx
  end

  test "should return zero byte binary on get_child_bytes if delegate asset is not set" do
    tx = build_tx()
    assert Dpos.Tx.RegisterDelegate.get_child_bytes(tx) == <<>>
  end
end
