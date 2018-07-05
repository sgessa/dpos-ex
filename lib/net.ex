defmodule Dpos.Net do
  use HTTPoison.Base

  @networks [
    lwf: [
      nethash: "704f232786a9bff25d0630c06abbc34957448ba6309d6dcef949cf9a6f43954a",
      version: "0.1.4",
      port: 18124
    ],
    "lwf-t": [
      nethash: "c16656e85880df9a41abed0aa13b2987b0d853adadc91cbc7e5c8332ea37ccc9",
      version: "0.1.4",
      port: 18101
    ]
  ]

  def broadcast(%Dpos.Tx{} = tx, net) when is_binary(net) do
    broadcast(tx, String.to_atom(net))
  end

  def broadcast(%Dpos.Tx{} = tx, net) when is_atom(net) do
    config = [host: "127.0.0.1"] ++ @networks[net]
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
