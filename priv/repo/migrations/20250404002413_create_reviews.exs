defmodule RestaurantReviewer.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :reviewer_name, :string
      add :content, :text
      add :restaurant_id, references(:restaurants, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:reviews, [:restaurant_id])
  end
end
