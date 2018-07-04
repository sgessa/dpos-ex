defmodule Dpos.Net do
  use HTTPoison.Base

  def broadcast(tx, net \\ :lwf) do
    config = Application.get_env(:dpos, net)
    broadcast(tx, "127.0.0.1", config[:port], net)
  end

  def broadcast(tx, hostname, port, net) do
    payload = %{transactions: [Dpos.Tx.normalize(tx)]}

    post(
      "http://#{hostname}:#{port}/peer/transactions",
      Jason.encode!(payload),
      headers(net),
      hackney: [pool: :default]
    )
  end

  defp headers(net) do
    config = Application.get_env(:dpos, net)

    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"nethash", config[:nethash]},
      {"version", config[:version]},
      {"port", "1"}
    ]
  end
end
