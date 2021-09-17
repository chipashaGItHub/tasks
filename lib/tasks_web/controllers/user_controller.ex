defmodule TasksWeb.UserController do
  use TasksWeb, :controller
  use TasksWeb, :universal

@index "RwjudkggtZhrykQAgqHmpAfbArfjdlllhWD"
@list_users "tQnwtfkqwquvEFjMapqsSwPhpslsMC5vqzSrxmTxeuNDczspnNB2wByZh82QbpdymajAXYa7yVh4jndGRpq8jkPuGr"

  def redirect(conn, params) do
    if Map.has_key?(params, "form") == false do
      index(conn, params)
    else
      %{"view" => render_view, "form" => form_name} = params

      view = (fn _fn_conn, _fn_params, view_name->
        view_name |> case do
                       @form_get_transaction_report -> index(conn, params)
                       _ -> index(conn, params)
                     end
              end)

      form = (fn conn, params, form_name ->
        form_name
        |> case do
             @list_users -> get_users(conn, params)
             _ ->  index(conn, params)
           end
              end)

      case conn.method do
        "GET" -> view.(conn, params, render_view)
        "POST" -> form.(conn, params, form_name)
        _ -> index(conn, params)
      end
    end
  end

  def index(conn, params) do
    conn |> render("index.html")
  end

  defp get_users(conn, params) do
    {draw, start, length, search_params} = Pages.search_options(params)
    json(conn, Pages.display(draw, Tasks.Service.ListUsers.index(
      search_params,
      start,
      length
    )))
  end
end