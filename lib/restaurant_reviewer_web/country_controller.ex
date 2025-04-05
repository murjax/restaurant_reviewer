defmodule RestaurantReviewerWeb.CountryController do
  use RestaurantReviewerWeb, :controller

  def set_cookie(conn, %{"id" => id}) do
    conn
    |> put_session(:country_id, id)
    |> redirect(to: "/restaurants")
  end
end
