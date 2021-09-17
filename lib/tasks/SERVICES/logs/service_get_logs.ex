defmodule Tasks.Service.GetLogs do
  use TasksWeb, :universal


  def index(search_params, page, size) do
    Logs
    |> compose_query(search_params)
    |> Repo.paginate(page: page, page_size: size)
  end

  def compose_query(query, params) do
    query
    |> handle_filter(params)
    |> compose_query()
    |> order_by([desc: :id])
  end

  defp compose_query(query) do
    query
    |> select([a], %{
      narration: a.narration,
      reference: a.reference,
      username: a.username,
      ip_address: a.ip_address,
      actionType: a.actionType,
      date: fragment("FORMAT (CAST(? AS datetime), 'yyyy-MM-dd HH:mm:ss')", a.updated_at),
      description: a.description,
      id: a.id
    })
  end

  defp handle_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        isearch_filter(query, sanitize_term(value))


      {"startDate", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("CAST(? AS DATE) >= ?", a.created_at, ^value))
      #
      {"endDate", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("CAST(? AS DATE) <= ?", a.created_at, ^value))

      {_, _}, query ->

        # Not a where parameter
        query
    end)
  end

  defp isearch_filter(query, search_term) do
    where(
      query,
      [a],
      fragment("lower(?) LIKE lower(?)", a.first_name, ^search_term)
    )
  end

  defp sanitize_term(term), do: "%#{String.replace(term, "%", "\\%")}%"
end