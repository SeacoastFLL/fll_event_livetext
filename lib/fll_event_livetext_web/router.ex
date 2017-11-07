defmodule FllEventLivetextWeb.Router do
  use FllEventLivetextWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FllEventLivetextWeb do
    pipe_through :browser # Use the default browser stack

    get "/", DashboardController, :index
    scope "/osc", as: :osc do
      put "/match/:match", OscController, :update, as: :match
      put "/team/:team/:side", OscController, :update, as: :team
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FllEventLivetextWeb do
  #   pipe_through :api
  # end
end
