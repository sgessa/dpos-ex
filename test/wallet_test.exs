defmodule Dpos.WalletTest do
  use ExUnit.Case

  alias Dpos.Wallet

  @wallet %{
    secret: "robust swift grocery peasant forget share enable convince deputy road keep cheap",
    address: "8273455169423958419S",
    pub_key: "9d3058175acab969f41ad9b86f7a2926c74258670fe56b37c429c01fca9f2f0f"
  }

  describe "wallet" do
    test "should match example wallet" do
      wallet = Wallet.generate_shift(@wallet.secret)

      assert wallet == Wallet.generate(@wallet.secret, "S")
      assert byte_size(wallet.priv_key) == 64
      assert byte_size(wallet.pub_key) == 32
      assert Base.encode16(wallet.pub_key, case: :lower) == @wallet.pub_key
      assert wallet.address == @wallet.address
    end
  end
end
