defmodule RestaurantReviewerWeb.Router do
  use RestaurantReviewerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RestaurantReviewerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RestaurantReviewerWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/set_cookie/:id", CountryController, :set_cookie

    live "/countries", CountryLive.Index, :index
    live "/countries/new", CountryLive.Index, :new
    live "/countries/:id/edit", CountryLive.Index, :edit

    live "/countries/:id", CountryLive.Show, :show
    live "/countries/:id/show/edit", CountryLive.Show, :edit

    live "/restaurants", RestaurantLive.Index, :index
    live "/restaurants/new", RestaurantLive.Index, :new
    live "/restaurants/:id/edit", RestaurantLive.Index, :edit

    live "/restaurants/:id", RestaurantLive.Show, :show
    live "/restaurants/:id/show/edit", RestaurantLive.Show, :edit

    live "/reviews", ReviewLive.Index, :index
    live "/reviews/new", ReviewLive.Index, :new
    live "/reviews/:id/edit", ReviewLive.Index, :edit

    live "/reviews/:id", ReviewLive.Show, :show
    live "/reviews/:id/show/edit", ReviewLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", RestaurantReviewerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:restaurant_reviewer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RestaurantReviewerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
