defmodule RestaurantReviewerWeb.RestaurantLive.FormComponent do
  use RestaurantReviewerWeb, :live_component

  alias RestaurantReviewer.Repo
  alias RestaurantReviewer.Restaurants

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage restaurant records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="restaurant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:country_id]} type="select" options={@countries} label="Country" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Restaurant</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{restaurant: restaurant} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Restaurants.change_restaurant(restaurant))
     end)}
  end

  @impl true
  def handle_event("validate", %{"restaurant" => restaurant_params}, socket) do
    changeset = Restaurants.change_restaurant(socket.assigns.restaurant, restaurant_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"restaurant" => restaurant_params}, socket) do
    save_restaurant(socket, socket.assigns.action, restaurant_params)
  end

  defp save_restaurant(socket, :edit, restaurant_params) do
    case Restaurants.update_restaurant(socket.assigns.restaurant, restaurant_params) do
      {:ok, restaurant} ->
        restaurant = Repo.preload(restaurant, [:country])
        notify_parent({:saved, restaurant})

        {:noreply,
         socket
         |> put_flash(:info, "Restaurant updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_restaurant(socket, :new, restaurant_params) do
    case Restaurants.create_restaurant(restaurant_params) do
      {:ok, restaurant} ->
        notify_parent({:saved, restaurant})

        {:noreply,
         socket
         |> put_flash(:info, "Restaurant created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
