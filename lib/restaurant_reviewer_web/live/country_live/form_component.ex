defmodule RestaurantReviewerWeb.CountryLive.FormComponent do
  use RestaurantReviewerWeb, :live_component

  alias RestaurantReviewer.Countries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage country records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="country-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Country</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{country: country} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Countries.change_country(country))
     end)}
  end

  @impl true
  def handle_event("validate", %{"country" => country_params}, socket) do
    changeset = Countries.change_country(socket.assigns.country, country_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"country" => country_params}, socket) do
    save_country(socket, socket.assigns.action, country_params)
  end

  defp save_country(socket, :edit, country_params) do
    case Countries.update_country(socket.assigns.country, country_params) do
      {:ok, country} ->
        notify_parent({:saved, country})

        {:noreply,
         socket
         |> put_flash(:info, "Country updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_country(socket, :new, country_params) do
    case Countries.create_country(country_params) do
      {:ok, country} ->
        notify_parent({:saved, country})

        {:noreply,
         socket
         |> put_flash(:info, "Country created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
