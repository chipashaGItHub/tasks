defmodule Tasks.Repo do
  use Ecto.Repo,
    otp_app: :tasks,
    adapter: Ecto.Adapters.Tds
  use Scrivener, page_size: 10
end
