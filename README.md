# DPoS

An Elixir port of vekexasia's [dpos-offline](https://www.npmjs.com/package/dpos-offline) typescript library.

## Installation

Add DPoS to your `mix.exs`

```elixir
def deps do
  [
    {:dpos, "~> 0.3.1"}
  ]
end
```

## Usage

**Wallet utilities**

```elixir
secret = "my secret"

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
  %{amount: 10_000_000_000, fee: 10_000_000, recipientId: "9961568538380190560LWF"}
  |> Dpos.Tx.Send.build()
  |> Dpos.Tx.Send.sign(wallet)

# The transaction can be normalized to be easier to read
tx |> Dpos.Tx.Send.normalize() |> IO.inspect()

# Output
%Dpos.Tx{
  type: 0,
  id: "4370528448668269583",
  recipientId: "9961568538380190560LWF",
  senderPublicKey: "f965aeb00689760467f15c3ca144be64c49a237ab1ea71746d2351add78a0b65",
  signature: "d35ea618fc55a8d6ad1f63e76bfb241387e11487f7999cfcb263e051b5dd846682ad48e8d1d255c345a88684eeb8c4ac559febc62b93d9d0ff724f3547ba4503",
  signSignature: nil,
  amount: 10000000000,
  fee: 10000000,
  timestamp: 89501419,
  address_suffix_length: 3,
  asset: nil
}

# Optional: signing the tx using a second private key
Dpos.Tx.Send.sign(tx, wallet, second_priv_key)

# It is possible to pass a secret/suffix tuple as second argument to Tx.sign/3:
Dpos.Tx.Send.sign(tx, {"my secret", "L"})

# Finally we can broadcast our transaction to a remote node (or a local node)
network = [
  nethash: "ed14889723f24ecc54871d058d98ce91ff2f973192075c0155ba2b7b70ad2511",
  version: "1.5.0",
  uri: "http://127.0.0.1:8000"
]

tx
|> Dpos.Tx.Send.normalize()
|> Dpos.Net.broadcast(network)
```

## Contributing

Clone the repository and run `$ mix test` to make sure everything is working.

## Authors

* **Stefano Gessa** - [sgessa](https://github.com/sgessa)

## License

DPoS is released under the MIT license. See the [license file](LICENSE.txt).
