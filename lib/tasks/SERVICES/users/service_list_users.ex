defmodule Tasks.Service.ListUsers do
  use TasksWeb, :universal

  def index(search_params, page, size) do
    User
    |> compose_query(search_params)
    |> Repo.paginate(page: page, page_size: size)
  end

  def compose_query(query, params) do
    query
    |> where([a], is_nil(a.deleted_at))
    |> handle_filter(params)
    |> compose_query()
    |> order_by([desc: :id])
  end

  defp compose_query(query) do
    query
    |> select([a], %{
      username: a.username,
      email: a.email,
      mobile: a.mobile,
      status: a.status,
      failed_attempts: a.failed_attempts,
      date: fragment("FORMAT (CAST(? AS datetime), 'yyyy-MM-dd HH:mm:ss')", a.updated_at),
      last_login_date: fragment("FORMAT (CAST(? AS datetime), 'yyyy-MM-dd HH:mm:ss')", a.last_login_date),
      last_name: a.last_name,
      first_name: a.first_name,
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