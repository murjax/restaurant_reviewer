defmodule RestaurantReviewer.ReviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RestaurantReviewer.Reviews` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(attrs \\ %{}) do
    {:ok, review} =
      attrs
      |> Enum.into(%{
        content: "some content",
        reviewer_name: "some reviewer_name"
      })
      |> RestaurantReviewer.Reviews.create_review()

    review
  end
end
