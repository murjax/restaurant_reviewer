defmodule RestaurantReviewer.RepoSwitcher do
  alias RestaurantReviewer.Countries.Country
  alias RestaurantReviewer.CountryRepo
  alias RestaurantReviewer.Repo

  def connect_to_repo(nil), do: nil
  def connect_to_repo(country_id) do
    country = CountryRepo.get_by(Country, id: country_id)

    new_repo = case country.name do
      "United States of America" -> RestaurantReviewer.Repo.USA
      "Mexico" -> RestaurantReviewer.Repo.Mexico
      "Canada" -> RestaurantReviewer.Repo.Canada
    end

    Repo.put_dynamic_repo(new_repo)
  end
end
