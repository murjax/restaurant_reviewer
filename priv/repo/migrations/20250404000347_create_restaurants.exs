defmodule RestaurantReviewer.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :string
      add :country_id, references(:countries, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:restaurants, [:country_id])
  end
end
