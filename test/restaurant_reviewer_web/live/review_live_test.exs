defmodule RestaurantReviewerWeb.ReviewLiveTest do
  use RestaurantReviewerWeb.ConnCase

  import Phoenix.LiveViewTest
  import RestaurantReviewer.ReviewsFixtures

  @create_attrs %{content: "some content", reviewer_name: "some reviewer_name"}
  @update_attrs %{content: "some updated content", reviewer_name: "some updated reviewer_name"}
  @invalid_attrs %{content: nil, reviewer_name: nil}

  defp create_review(_) do
    review = review_fixture()
    %{review: review}
  end

  describe "Index" do
    setup [:create_review]

    test "lists all reviews", %{conn: conn, review: review} do
      {:ok, _index_live, html} = live(conn, ~p"/reviews")

      assert html =~ "Listing Reviews"
      assert html =~ review.content
    end

    test "saves new review", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("a", "New Review") |> render_click() =~
               "New Review"

      assert_patch(index_live, ~p"/reviews/new")

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#review-form", review: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reviews")

      html = render(index_live)
      assert html =~ "Review created successfully"
      assert html =~ "some content"
    end

    test "updates review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{review.id} a", "Edit") |> render_click() =~
               "Edit Review"

      assert_patch(index_live, ~p"/reviews/#{review}/edit")

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#review-form", review: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reviews")

      html = render(index_live)
      assert html =~ "Review updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{review.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reviews-#{review.id}")
    end
  end

  describe "Show" do
    setup [:create_review]

    test "displays review", %{conn: conn, review: review} do
      {:ok, _show_live, html} = live(conn, ~p"/reviews/#{review}")

      assert html =~ "Show Review"
      assert html =~ review.content
    end

    test "updates review within modal", %{conn: conn, review: review} do
      {:ok, show_live, _html} = live(conn, ~p"/reviews/#{review}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Review"

      assert_patch(show_live, ~p"/reviews/#{review}/show/edit")

      assert show_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#review-form", review: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/reviews/#{review}")

      html = render(show_live)
      assert html =~ "Review updated successfully"
      assert html =~ "some updated content"
    end
  end
end
