defmodule RestaurantReviewerWeb.RestaurantLive.Show do
  use RestaurantReviewerWeb, :live_view

  alias RestaurantReviewer.Restaurants
  alias RestaurantReviewer.Countries.Country
  alias RestaurantReviewer.Repo

  @impl true
  def mount(_params, _session, socket) do
    countries = Repo.all(Country) |> Enum.map(&{&1.name, &1.id})
    socket = assign(socket, countries: countries)
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
