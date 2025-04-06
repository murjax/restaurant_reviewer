defmodule RestaurantReviewer.RepoSwitcher do
  alias RestaurantReviewer.Countries.Country
  alias RestaurantReviewer.CountryRepo
  alias RestaurantReviewer.Repo

  def connect_to_repo(nil), do: nil
  def connect_to_repo(country_id) do
    country = CountryRepo.get_by(Country, id: country_id)
    prefix = "reviews_#{country.name}"
    query_args = ["SET search_path TO #{prefix}", []]
    after_connect = {Postgrex, :query!, query_args}
    config = Application.get_env(:restaurant_reviewer, Repo) |> Keyword.put(:after_connect, after_connect)

    case Repo.start_link(config) do
      {:ok, pid} ->
        Repo.put_dynamic_repo(pid)
      {:error, {:already_started, pid}} ->
        Repo.stop(1000)
        {:ok, pid} = Repo.start_link(config)
        Repo.put_dynamic_repo(pid)
    end
  end
end
