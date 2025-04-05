defmodule RestaurantReviewerWeb.RestaurantLive.Index do
  use RestaurantReviewerWeb, :live_view

  alias RestaurantReviewer.Restaurants
  alias RestaurantReviewer.Restaurants.Restaurant
  alias RestaurantReviewer.Countries.Country
  alias RestaurantReviewer.Repo

  @impl true
  def mount(_params, _session, socket) do
    countries = Repo.all(Country) |> Enum.map(&{&1.name, &1.id})
    socket = assign(socket, countries: countries)
    {:ok, stream(socket, :restaurants, Restaurants.list_restaurants() |> Repo.preload([:country]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Restaurant")
    |> assign(:restaurant, Restaurants.get_restaurant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Restaurant")
    |> assign(:restaurant, %Restaurant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Restaurants")
    |> assign(:restaurant, nil)
  end

  @impl true
  def handle_info({RestaurantReviewerWeb.RestaurantLive.FormComponent, {:saved, restaurant}}, socket) do
    {:noreply, stream_insert(socket, :restaurants, restaurant)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    restaurant = Restaurants.get_restaurant!(id)
    {:ok, _} = Restaurants.delete_restaurant(restaurant)

    {:noreply, stream_delete(socket, :restaurants, restaurant)}
  end
end
