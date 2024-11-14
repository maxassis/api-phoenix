defmodule TestWeb.Router do
  use TestWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TestWeb.Plugs.Auth
  end

  # rotas de usuario
  scope "/users", TestWeb do
    pipe_through :api

     # retorna todos os usuarios
    get "/", UserController, :index

    # cria um usuário
    post "/simple", UserController, :create_simple

    # retorna um usuário pelo id
    get "/:id", UserController, :get_user

    post "/user_email", UserController, :get_by_email

    delete "/:id", UserController, :delete
  end


  # rotas de notas
  scope "/", TestWeb do
    pipe_through [:api, :auth]

    resources "/notes", NoteController
    get "/notes/user/:user_id", NoteController, :getUserNotes

    get "/notes", NoteController, :index
  end

  # rotas de login
  scope "/", TestWeb do
    pipe_through :api

    post "/login", UserController, :login
  end


  # Enable LiveDashboard in development
  if Application.compile_env(:test, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TestWeb.Telemetry
    end
  end
end
