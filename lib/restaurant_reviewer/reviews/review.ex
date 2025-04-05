defmodule RestaurantReviewer.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :content, :string
    field :reviewer_name, :string
    belongs_to :restaurant, RestaurantReviewer.Restaurants.Restaurant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:reviewer_name, :content, :restaurant_id])
    |> validate_required([:reviewer_name, :content])
  end
end
