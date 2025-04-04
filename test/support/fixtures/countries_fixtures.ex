defmodule RestaurantReviewer.CountriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RestaurantReviewer.Countries` context.
  """

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> RestaurantReviewer.Countries.create_country()

    country
  end
end
