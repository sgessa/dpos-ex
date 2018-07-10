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

  def broadcast(tx, net, opts \\ [])

  def broadcast(%Dpos.Tx{} = tx, net, opts) when is_binary(net) and is_list(opts) do
    broadcast(tx, String.to_atom(net), opts)
  end

  def broadcast(%Dpos.Tx{} = tx, net, opts) when is_atom(net) and is_list(opts) do
    net = @networks[net] || []
    opts = Keyword.merge(net, opts)

    host = opts[:host] || "127.0.0.1"
    port = opts[:port]

    payload = %{transaction: Dpos.Tx.normalize(tx)}

    req =
      post(
        "http://#{host}:#{port}/peer/transactions",
        Jason.encode!(payload),
        headers(opts),
        hackney: [pool: :default]
      )

    with {:ok, resp} <- req,
         {:ok, body} <- Jason.decode(resp.body) do
      if body["success"] do
        {:ok, body}
      else
        {:error, body["message"]}
      end
    end
  end

  defp headers(opts) do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"nethash", opts[:nethash]},
      {"version", opts[:version]},
      {"port", "1"}
    ]
  end
end
