defmodule RestaurantReviewer.Restaurants.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restaurants" do
    field :name, :string
    belongs_to :country, RestaurantReviewer.Countries.Country

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [:name, :country_id])
    |> validate_required([:name])
  end
end
