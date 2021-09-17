defmodule Tasks.Util.Pages do


  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)

  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def display(draw, results) do
    total_entries = total_entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries(results) |> Enum.map(&sanitize_params/1)
    }
  end

  defp sanitize_params(params) do
    Enum.reduce(params, %{}, fn {k, value}, acc ->
      val =
        cond do
          String.valid?(value) ->
            term = value
                   |> String.to_charlist()
                   |> Enum.filter(&(&1 in 0..127))
                   |> List.to_string()
            for <<c <- term>>, c in 0..127, into: "", do: <<c>>
          true ->
            value
        end
      Map.put(acc, k, val)
    end)
  end

end