defmodule TestWeb.Router do
  use TestWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TestWeb do
    pipe_through :api
  end

  # rotas de usuario
  scope "/users", TestWeb do
    pipe_through :api

     # retorna todos os usuarios
    get "/", UserController, :index

    # cria um usuário
    post "/simple", UserController, :create_simple

    # retorna um usuário
    get "/:id", UserController, :get_user

    delete "/:id", UserController, :delete
  end


  # rotas de notas
  scope "/", TestWeb do
    pipe_through :api

    resources "/notes", NoteController
  end


  # Enable LiveDashboard in development
  if Application.compile_env(:test, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TestWeb.Telemetry
    end
  end
end
