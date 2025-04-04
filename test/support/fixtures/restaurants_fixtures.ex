defmodule RestaurantReviewer.RestaurantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RestaurantReviewer.Restaurants` context.
  """

  @doc """
  Generate a restaurant.
  """
  def restaurant_fixture(attrs \\ %{}) do
    {:ok, restaurant} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> RestaurantReviewer.Restaurants.create_restaurant()

    restaurant
  end
end
