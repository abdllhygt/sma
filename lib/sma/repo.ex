defmodule Sma.Repo do
  use Ecto.Repo,
    otp_app: :sma,
    adapter: Ecto.Adapters.Postgres
end
