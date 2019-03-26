defmodule Dpos.Net do
  use HTTPoison.Base

  @required_opts [
    :uri,
    :nethash,
    :version
  ]

  def broadcast(%Dpos.Tx{} = tx, net) when is_list(net) do
    validate_network!(net)
    payload = %{transaction: Dpos.Tx.normalize(tx)}

    req =
      post(
        net[:uri] <> "/peer/transactions",
        Jason.encode!(payload),
        headers(net),
        hackney: [pool: :dpos]
      )

    with {:ok, resp} <- req,
         {:ok, body} <- Jason.decode(resp.body) do
      if body["success"] do
        {:ok, body}
      else
        {:error, body}
      end
    end
  end

  defp validate_network!(net) do
    Enum.each(@required_opts, fn opt ->
      unless net[opt], do: raise("Option #{opt} not configured.")
    end)
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
