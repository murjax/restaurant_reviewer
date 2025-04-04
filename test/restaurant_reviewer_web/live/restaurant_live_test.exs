defmodule RestaurantReviewerWeb.RestaurantLiveTest do
  use RestaurantReviewerWeb.ConnCase

  import Phoenix.LiveViewTest
  import RestaurantReviewer.RestaurantsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_restaurant(_) do
    restaurant = restaurant_fixture()
    %{restaurant: restaurant}
  end

  describe "Index" do
    setup [:create_restaurant]

    test "lists all restaurants", %{conn: conn, restaurant: restaurant} do
      {:ok, _index_live, html} = live(conn, ~p"/restaurants")

      assert html =~ "Listing Restaurants"
      assert html =~ restaurant.name
    end

    test "saves new restaurant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/restaurants")

      assert index_live |> element("a", "New Restaurant") |> render_click() =~
               "New Restaurant"

      assert_patch(index_live, ~p"/restaurants/new")

      assert index_live
             |> form("#restaurant-form", restaurant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#restaurant-form", restaurant: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/restaurants")

      html = render(index_live)
      assert html =~ "Restaurant created successfully"
      assert html =~ "some name"
    end

    test "updates restaurant in listing", %{conn: conn, restaurant: restaurant} do
      {:ok, index_live, _html} = live(conn, ~p"/restaurants")

      assert index_live |> element("#restaurants-#{restaurant.id} a", "Edit") |> render_click() =~
               "Edit Restaurant"

      assert_patch(index_live, ~p"/restaurants/#{restaurant}/edit")

      assert index_live
             |> form("#restaurant-form", restaurant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#restaurant-form", restaurant: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/restaurants")

      html = render(index_live)
      assert html =~ "Restaurant updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes restaurant in listing", %{conn: conn, restaurant: restaurant} do
      {:ok, index_live, _html} = live(conn, ~p"/restaurants")

      assert index_live |> element("#restaurants-#{restaurant.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#restaurants-#{restaurant.id}")
    end
  end

  describe "Show" do
    setup [:create_restaurant]

    test "displays restaurant", %{conn: conn, restaurant: restaurant} do
      {:ok, _show_live, html} = live(conn, ~p"/restaurants/#{restaurant}")

      assert html =~ "Show Restaurant"
      assert html =~ restaurant.name
    end

    test "updates restaurant within modal", %{conn: conn, restaurant: restaurant} do
      {:ok, show_live, _html} = live(conn, ~p"/restaurants/#{restaurant}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Restaurant"

      assert_patch(show_live, ~p"/restaurants/#{restaurant}/show/edit")

      assert show_live
             |> form("#restaurant-form", restaurant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#restaurant-form", restaurant: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/restaurants/#{restaurant}")

      html = render(show_live)
      assert html =~ "Restaurant updated successfully"
      assert html =~ "some updated name"
    end
  end
end
