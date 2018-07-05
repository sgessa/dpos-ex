defmodule Dpos.Net do
  use HTTPoison.Base

  def broadcast(%Dpos.Tx{} = tx, net) when is_binary(net) do
    broadcast(tx, String.to_atom(net))
  end

  def broadcast(%Dpos.Tx{} = tx, net) when is_atom(net) do
    config = [host: "127.0.0.1"] ++ Application.get_env(:dpos, net)
    broadcast(tx, config)
  end

  def broadcast(%Dpos.Tx{} = tx, net) when is_list(net) do
    host = net[:host]
    port = net[:port]

    payload = %{transactions: [Dpos.Tx.normalize(tx)]}

    post(
      "http://#{host}:#{port}/peer/transactions",
      Jason.encode!(payload),
      headers(net),
      hackney: [pool: :default]
    )
  end

  defp headers(net) do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"nethash", net[:nethash]},
      {"version", net[:version]},
      {"port", "1"}
    ]
  end
end
