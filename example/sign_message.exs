secret = "my secret"
message = "I Love LWF"

wallet = Dpos.Wallet.generate_lwf(secret)

{:ok, signature} = Dpos.Wallet.sign_message(wallet, message)
:ok = Dpos.Wallet.verify_message(wallet, message, signature)

signature
|> Base.encode16()
|> IO.puts()
