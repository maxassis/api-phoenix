defmodule Test.Repo do
  use Ecto.Repo,
    otp_app: :test,
    adapter: Ecto.Adapters.SQLite3
end
