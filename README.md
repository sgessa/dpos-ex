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
iex> secret = "my secret"

# For Lisk
iex> lisk_wallet = Wallet.generate_lisk(secret)

# For Shift
iex> shift_wallet = Wallet.generate_shift(secret)

# For any lisk-like wallet
iex> wallet = Wallet.generate(secret, "XYZ")
%Wallet{
  address: "2340651171948227443XYZ",
  priv_key: <<185, 209, 208, 19, 246, 0, 236, 27, 241, 107, 174, 106, 54, 52,
    202, 209, 93, 204, 73, 12, 159, 40, 53, 118, 66, 1, 164, 26, 29, 112, 222,
    68>>,
  pub_key: <<249, 101, 174, 176, 6, 137, 118, 4, 103, 241, 92, 60, 161, 68, 190,
    100, 196, 154, 35, 122, 177, 234, 113, 116, 109, 35, 81, 173, 215, 138, 11,
    101>>
}

# Sign a message
iex> {:ok, signature} = Wallet.sign_message(wallet, "My Signed Message")

# Verify a message
iex> :ok = Wallet.verify_message(wallet, "My Signed Message", signature)
```

**Transaction utilities**

```elixir
iex> tx =
iex>  Tx.Send \
iex>  |> Tx.build(%{amount: 10_000_000_000, fee: 10_000_000, recipient: "2340651171948227443XYZ"}) \
iex>  |> Tx.sign(wallet)

# Optional: signing the tx using a second private key
iex> Tx.sign(tx, wallet, second_priv_key)

# It is possible to pass a secret/suffix tuple as second argument to Tx.sign/3:
iex> Tx.sign(tx, {"my secret", "L"})

# Finally we can broadcast our transaction to a remote node (or a local node)
iex> network = [
iex>   nethash: "ed14889723f24ecc54871d058d98ce91ff2f973192075c0155ba2b7b70ad2511",
iex>   version: "1.5.0",
iex>   uri: "http://127.0.0.1:8000"
iex> ]

iex> tx \
iex> |> Tx.normalize() \
iex> |> Net.broadcast(network)

# The transaction can be normalized to be easier to read and to be broadcasted to a remote node
iex> Tx.normalize(tx)
%Tx{
  id: "14577272354830356516",
  recipientId: "2340651171948227443XYZ",
  senderPublicKey: "f965aeb00689760467f15c3ca144be64c49a237ab1ea71746d2351add78a0b65",
  signature: "271d56c46e49d9b01707ba7ec90ea69a59a9e6f606abf532315e5e2fa327b465e9d9f4ef6c37d11ca84aec61f8b138881b9afa92ba39123dc6622057ea53f50f",
  signSignature: nil,
  timestamp: 252848803,
  type: 0,
  address_suffix_length: 3,
  amount: 10000000000,
  asset: %{},
  fee: 10000000
}
```

## Contributing

Clone the repository and run `$ mix test` to make sure everything is working.

## Authors

* **Stefano Gessa** - [sgessa](https://github.com/sgessa)

## License

DPoS is released under the MIT license. See the [license file](LICENSE.txt).
