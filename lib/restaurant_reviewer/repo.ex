defmodule RestaurantReviewer.Repo do
  use Ecto.Repo,
    otp_app: :restaurant_reviewer,
    adapter: Ecto.Adapters.Postgres
end
