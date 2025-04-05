defmodule RestaurantReviewerWeb.ReviewLive.Index do
  use RestaurantReviewerWeb, :live_view

  alias RestaurantReviewer.Repo
  alias RestaurantReviewer.Restaurants.Restaurant
  alias RestaurantReviewer.Reviews
  alias RestaurantReviewer.Reviews.Review
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
    {:ok, stream(socket, :reviews, Reviews.list_reviews() |> Repo.preload([:restaurant]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Review")
    |> assign(:review, Reviews.get_review!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Review")
    |> assign(:review, %Review{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reviews")
    |> assign(:review, nil)
  end

  @impl true
  def handle_info({RestaurantReviewerWeb.ReviewLive.FormComponent, {:saved, review}}, socket) do
    {:noreply, stream_insert(socket, :reviews, review)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Reviews.get_review!(id)
    {:ok, _} = Reviews.delete_review(review)

    {:noreply, stream_delete(socket, :reviews, review)}
  end
end
