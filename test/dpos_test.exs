defmodule DposTest do
  use ExUnit.Case

  doctest Dpos

  alias Dpos.Wallet

  test "dpos wallets" do
    secret = "space slice acid gadget improve middle grit that deny useless stumble win"

    wallet = %Wallet{} = Dpos.Wallet.generate_lwf(secret)

    assert byte_size(wallet.priv_key) == 64
    assert byte_size(wallet.pub_key) == 32

    assert Base.encode16(wallet.priv_key, case: :lower) ==
             "136b2b21792126ec68d61d28c28d47863e9dcf6784dba01ff3787133010a80e14a8cea620ac403a10deb5af2d9304745e45607b6e773efc65ef72f83da7c85ff"

    assert Base.encode16(wallet.pub_key, case: :lower) ==
             "4a8cea620ac403a10deb5af2d9304745e45607b6e773efc65ef72f83da7c85ff"

    assert wallet.address == "8745944213379218362LWF"

    tx =
      %{
        fee: 1,
        amount: 5,
        timestamp: 1_523_783_691,
        sender_pkey: wallet.pub_key,
        rcpt_address: wallet.address,
        address_suffix_length: 3
      }
      |> Dpos.Tx.build_send_tx()
      |> Dpos.Tx.sign(wallet.priv_key)

    assert tx.id == "12177981357595809166"
  end
end
