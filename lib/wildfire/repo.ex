defmodule Wildfire.Repo do
  use Ecto.Repo,
    otp_app: :wildfire,
    adapter: Ecto.Adapters.SQLite3
end
