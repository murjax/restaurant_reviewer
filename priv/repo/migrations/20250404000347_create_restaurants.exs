defmodule RestaurantReviewer.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
