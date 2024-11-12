defmodule TestWeb.UserController do
  use TestWeb, :controller
  alias Test.Accounts

  def create_simple(conn, user_params) do
    case Accounts.create_simple_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "Usuário criado com sucesso",
          data: %{
            id: user.id,
            name: user.name,
            email: user.email,
            inserted_at: user.inserted_at
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          success: false,
          errors: format_errors(changeset)
        })
    end
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    IO.inspect(users)

    conn
    |> put_status(:ok)
    |> json(%{
      data: Enum.map(users, fn user ->
        %{
          id: user.id,
          name: user.name,
          email: user.email
        }
      end)
    })
  end

  def get_user(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Usuário não encontrado"})

      user ->
        conn
        |> put_status(:ok)
        |> json(%{
          data: %{
            id: user.id,
            name: user.name,
            email: user.email
          }
        })
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.delete_user(id) do
      {:ok, _user} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Usuário deletado com sucesso"})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Usuário não encontrado"})

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Erro ao deletar usuário"})
    end
  end
end
