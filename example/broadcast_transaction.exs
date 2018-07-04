# The output of this script can be used to broadcast a Transaction

secret = "my secret"
rcpt = "9961568538380190560LWF"
note = "lorem ipsum"

sender = Dpos.Wallet.generate_lwf(secret)

tx =
  Dpos.Tx.Send.build(%{
    amount: 50_000_000_000,
    fee: 10_000_000,
    timestamp: Dpos.Time.now(),
    senderPublicKey: sender.pub_key,
    recipientId: rcpt,
    asset: %{note: note}
  })
  |> Dpos.Tx.sign(wallet)

tx
|> Dpos.Tx.normalize()
|> IO.puts()

tx
|> Dpos.Net.broadcast("node1.lwf.io", 18124)
|> IO.inspect()
