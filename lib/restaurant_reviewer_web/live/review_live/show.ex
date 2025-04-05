defmodule RestaurantReviewerWeb.ReviewLive.Show do
  use RestaurantReviewerWeb, :live_view

  alias RestaurantReviewer.Repo
  alias RestaurantReviewer.Restaurants.Restaurant
  alias RestaurantReviewer.Reviews
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

    restaurants = Repo.all(Restaurant) |> Enum.map(&{&1.name, &1.id})
    socket = assign(socket, restaurants: restaurants)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:review, Reviews.get_review!(id) |> Repo.preload([:restaurant]))}
  end

  defp page_title(:show), do: "Show Review"
  defp page_title(:edit), do: "Edit Review"
end
