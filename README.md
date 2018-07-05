# DPoS

A pure Elixir port of vekexasia's [dpos-offline](https://www.npmjs.com/package/dpos-offline) typescript library.

## Installation

Install libsodium development headers:

`apt install -y libsodium-dev`

Add DPoS to your `mix.exs`

```elixir
def deps do
  [
    {:dpos, "~> 0.1.9"}
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

# Sign a message
{:ok, signature} = Dpos.Wallet.sign_message(wallet, "I Love LWF")

# Verify a message
:ok = Dpos.Wallet.verify_message(wallet, "I Love LWF", signature)
```

**Transaction utilities**

```elixir
tx =
  Dpos.Tx.Send.build(%{
    amount: 10_000_000_000,
    fee: 10_000_000,
    timestamp: 600,
    senderPublicKey: wallet.pub_key,
    recipientId: rcpt,
    asset: %{note: "Test message 2"}
  })

tx
|> Dpos.Tx.sign(wallet)
|> Dpos.Tx.normalize()


# Output
{
  "id":"12019159304724346467",
  "type":0,
  "fee":10000000,
  "amount":10000000000,
  "recipientId":"9961568538380190560LWF",
  "senderPublicKey":"e2857234d0dbf8d609ab8a20207d1ba9c84d21dc9a7b95e4ecd717e0369a744b",
  "signature":"5917d20da52e851f50968fe08bddd37a4ddff5d80e622c1f9623c2210c8eb24876dc5fae80aa39bb84872670da175aa9b0a20b0f2c865752912e4204caccdc0e",
  "timestamp":600,
  "asset":{"note": "Test message 2"}
}

# Optional: signing the tx using a second private key
Dpos.Tx.sign(tx, wallet, second_priv_key)
```

## Contributing

Clone the repository and run `$ mix test` to make sure everything is working.

## Authors

* **Stefano Gessa** - [sgessa](https://github.com/sgessa)

## License

DPoS is released under the MIT license. See the [license file](LICENSE.txt).
