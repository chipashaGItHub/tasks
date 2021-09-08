defmodule Tasks.Utility do

  # time functions
  defmodule Time do
    def local_day(), do: Timex.now()
    def local_time(), do: local_day() |> DateTime.truncate(:second) |> Timex.to_naive_datetime() |> Timex.shift(hours: 2)
  end

  def format_date(date), do: (if date == nil do "N/A"  else date |> Timex.to_datetime() |> Calendar.DateTime.shift_zone!("Africa/Cairo") |> Calendar.Strftime.strftime!("%d-%b-%Y %H:%M:%S") end)

  def autogenerate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
end