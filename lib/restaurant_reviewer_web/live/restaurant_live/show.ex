defmodule RestaurantReviewerWeb.RestaurantLive.Show do
  use RestaurantReviewerWeb, :live_view

  alias RestaurantReviewer.Restaurants
  alias RestaurantReviewer.Repo
  alias RestaurantReviewer.Countries.Country
  alias RestaurantReviewer.CountryRepo

  @impl true
  def mount(_params, session, socket) do
    if session["country_id"] do
      country = CountryRepo.get_by(Country, id: session["country_id"])

      new_repo = case country.name do
        "United States of America" -> RestaurantReviewer.Repo.USA
        "Mexico" -> RestaurantReviewer.Repo.Mexico
        "Canada" -> RestaurantReviewer.Repo.Canada
      end

      Repo.put_dynamic_repo(new_repo)
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:restaurant, Restaurants.get_restaurant!(id))}
  end

  defp page_title(:show), do: "Show Restaurant"
  defp page_title(:edit), do: "Edit Restaurant"
end
