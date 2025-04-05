defmodule RestaurantReviewer.Repo do
  use Ecto.Repo,
    otp_app: :restaurant_reviewer,
    adapter: Ecto.Adapters.Postgres

  @sub_repos [
    RestaurantReviewer.Repo.USA,
    RestaurantReviewer.Repo.Mexico,
    RestaurantReviewer.Repo.Canada
  ]

  for repo <- @sub_repos do
    defmodule repo do
      use Ecto.Repo,
        otp_app: :restaurant_reviewer,
        adapter: Ecto.Adapters.Postgres
    end
  end
end
