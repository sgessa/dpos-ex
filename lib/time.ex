defmodule Dpos.Time do
  def at(int) do
    {:ok, start, 0} = DateTime.from_iso8601("2016-05-24T17:00:00.000Z")
    start = DateTime.to_unix(start)
    DateTime.from_unix!(start + int)
  end

  def now() do
    now = DateTime.utc_now() |> DateTime.to_unix()
    {:ok, start, 0} = DateTime.from_iso8601("2016-05-24T17:00:00.000Z")
    start = DateTime.to_unix(start)
    now - start
  end
end
