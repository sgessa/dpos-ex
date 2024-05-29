defmodule Dpos.Net do
  import HTTPoison, only: [post: 4]

  @required_opts [
    :uri,
    :nethash,
    :version
  ]

  @doc """
  Broadcasts the transaction through a relay node.

  The transaction must be already normalized.
  """
  @type network() :: [uri: String.t(), nethash: String.t(), version: String.t()]
  @spec broadcast(%Dpos.Tx.Normalized{}, network()) :: {:ok, String.t()} | {:error, term}
  def broadcast(tx, net) when is_list(net) do
    with :ok <- validate_network(net),
         {:ok, resp} <- request(net, %{transaction: tx}),
         {:ok, body} <- Jason.decode(resp.body) do
      if body["success"] do
        {:ok, body}
      else
        {:error, body}
      end
    end
  end

  defp request(net, payload) do
    post(
      net[:uri] <> "/peer/transactions",
      Jason.encode!(payload),
      headers(net),
      hackney: [pool: :dpos]
    )
  end

  defp validate_network(net) do
    Enum.reduce_while(@required_opts, :ok, fn opt, _acc ->
      if net[opt] do
        {:cont, :ok}
      else
        {:halt, {:error, "Network option :#{opt} not configured."}}
      end
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
