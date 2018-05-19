# DPoS

A pure Elixir port of vekexasia's [dpos-offline](https://www.npmjs.com/package/dpos-offline) typescript library.

## Installation

Add DPoS to your `mix.exs`

```elixir
def deps do
  [
    {:dpos, "~> 0.1.2"}
  ]
end
```

## Usage

**Wallet utilities**

```elixir
secret = "my secret"

# For LWF
lwf_wallet = Dpos.Wallet.generate_lwf(secret)

# For Lisk
lisk_wallet = Dpos.Wallet.generate_lisk(secret)

# For Shift
shift_wallet = Dpos.Wallet.generate_shift(secret)

# For any lisk-like wallet
wallet = Dpos.Wallet.generate(secret, "XYZ")

# Output
%Dpos.Wallet{
  address: "2340651171948227443XYZ",
  priv_key: <<185, 209, 208, 19, 246, 0, 236, 27, 241, 107, 174, 106, 54, 52,
    202, 209, 93, 204, 73, 12, 159, 40, 53, 118, 66, 1, 164, 26, 29, 112, 222,
    68, 249, 101, 174, 176, 6, 137, 118, 4, 103, 241, 92, 60, 161, 68, 190, 100,
    ...>>,
  pub_key: <<249, 101, 174, 176, 6, 137, 118, 4, 103, 241, 92, 60, 161, 68, 190,
    100, 196, 154, 35, 122, 177, 234, 113, 116, 109, 35, 81, 173, 215, 138, 11,
    101>>
}
```

**Transaction utilities**

```elixir
tx_data =
  %{
    fee: 1_000_000, # Satoshis
    amount: 20_000_000, # Satoshis
    timestamp: 1_523_783_691,
    sender_pkey: wallet.pub_key,
    rcpt_address: wallet.address,
    address_suffix_length: 3
  }

tx =
  tx_data
  |> Dpos.Tx.Send.build()
  |> Dpos.Tx.sign(wallet.priv_key)

# Output
%Dpos.Tx{
  address_suffix_length: 3,
  amount: 20000000,
  fee: 1000000,
  id: "8253638074099328158",
  rcpt_address: "2340651171948227443XYZ",
  second_signature: nil,
  sender_pkey: <<249, 101, 174, 176, 6, 137, 118, 4, 103, 241, 92, 60, 161, 68,
    190, 100, 196, 154, 35, 122, 177, 234, 113, 116, 109, 35, 81, 173, 215, 138,
    11, 101>>,
  signature: <<174, 102, 52, 129, 23, 208, 150, 174, 43, 119, 129, 90, 34, 224,
    143, 107, 59, 247, 255, 73, 169, 207, 67, 2, 148, 104, 44, 234, 138, 9, 138,
    51, 126, 6, 227, 72, 224, 79, 221, 11, 217, 18, ...>>,
  timestamp: 1523783691,
  type: 0
}

# Sign can also accept a wallet.
# Note that this will set the correct address suffix length automatically on the transaction.
Dpos.Tx.sign(tx, wallet)

# And a second signing private key
Dpos.Tx.sign(tx, priv_key, second_priv_key)
# Or
Dpos.Tx.sign(tx, wallet, second_priv_key)
```

## Contributing

Clone the repository and run `$ mix test` to make sure everything is working.

## Authors

* **Stefano Gessa** - [sgessa](https://github.com/sgessa)

## License

DPoS is released under the MIT license. See the [license file](LICENSE.txt).
