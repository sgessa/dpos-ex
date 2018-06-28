# The output of this script can be used to broadcast a Transaction

secret = "my secret"
rcpt = "9961568538380190560LWF"
note = "lorem ipsum"

sender = Dpos.Wallet.generate_lwf(secret)

tx =
  Dpos.Tx.Send.build(%{
    amount: 10_000_000_000,
    fee: 10_000_000,
    timestamp: 600,
    senderPublicKey: sender.pub_key,
    recipientId: rcpt,
    asset: %{note: note}
  })

tx
|> Dpos.Tx.sign(sender)
|> Dpos.Tx.normalize()
|> IO.puts()
