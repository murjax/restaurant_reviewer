defmodule RestaurantReviewer.ReviewsTest do
  use RestaurantReviewer.DataCase

  alias RestaurantReviewer.Reviews

  describe "reviews" do
    alias RestaurantReviewer.Reviews.Review

    import RestaurantReviewer.ReviewsFixtures

    @invalid_attrs %{content: nil, reviewer_name: nil}

    test "list_reviews/0 returns all reviews" do
      review = review_fixture()
      assert Reviews.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture()
      assert Reviews.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      valid_attrs = %{content: "some content", reviewer_name: "some reviewer_name"}

      assert {:ok, %Review{} = review} = Reviews.create_review(valid_attrs)
      assert review.content == "some content"
      assert review.reviewer_name == "some reviewer_name"
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture()
      update_attrs = %{content: "some updated content", reviewer_name: "some updated reviewer_name"}

      assert {:ok, %Review{} = review} = Reviews.update_review(review, update_attrs)
      assert review.content == "some updated content"
      assert review.reviewer_name == "some updated reviewer_name"
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture()
      assert {:error, %Ecto.Changeset{}} = Reviews.update_review(review, @invalid_attrs)
      assert review == Reviews.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture()
      assert {:ok, %Review{}} = Reviews.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture()
      assert %Ecto.Changeset{} = Reviews.change_review(review)
    end
  end
end
