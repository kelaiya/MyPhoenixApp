defmodule Myapp.Router do
  use Myapp.Web, :router

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

  scope "/api", Myapp do
    pipe_through :api
    get "/students", StudentController, :index
    get "/users", UserController, :index
    post "/users", LeadController, :create 
  end

  # Other scopes may use custom stacks.
  # scope "/api", Myapp do
  #   pipe_through :api
  # end
end
