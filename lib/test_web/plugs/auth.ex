defmodule TestWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]  # Importa `json/2`

  alias TestWeb.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- Token.verify(token) do
      assign(conn, :user_id, data)
    else
      _ -> conn
      |> put_status(:unauthorized)
      |> json(%{error: "Nao autorizado"})
      |> halt()  # Interrompe a conexão para evitar processamento adicional
    end
  end
end
