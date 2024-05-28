defmodule Dpos.Time do
  @lisk_epoch "2016-05-24T17:00:00.000Z"

  @doc """
  Converts a Lisk timestamp to `DateTime`.
  """
  @spec at(integer()) :: DateTime.t()
  def at(int) do
    {:ok, start, 0} = DateTime.from_iso8601(@lisk_epoch)
    start = DateTime.to_unix(start)
    DateTime.from_unix!(start + int)
  end

  @doc """
  Returns the current Lisk timestamp.
  """
  @spec now() :: integer()
  def now() do
    now = DateTime.to_unix(DateTime.utc_now())
    {:ok, start, 0} = DateTime.from_iso8601(@lisk_epoch)
    start = DateTime.to_unix(start)
    now - start
  end
end
