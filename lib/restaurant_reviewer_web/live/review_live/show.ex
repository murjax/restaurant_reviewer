defmodule RestaurantReviewerWeb.ReviewLive.Show do
  use RestaurantReviewerWeb, :live_view

  alias RestaurantReviewer.Repo
  alias RestaurantReviewer.Restaurants.Restaurant
  alias RestaurantReviewer.Reviews
  alias RestaurantReviewer.RepoSwitcher

  @impl true
  def mount(_params, session, socket) do
    RepoSwitcher.connect_to_repo(session["country_id"])
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
