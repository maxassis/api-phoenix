defmodule TestWeb.UserController do
  use TestWeb, :controller
  alias Test.Accounts
  alias TestWeb.Token
  alias Test.Accounts.Verify

  def create_simple(conn, user_params) do
    IO.inspect(user_params)

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

  def get_by_email(conn, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Usuário nao encontrado"})

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

  def login(conn, params) do
    with {:ok, user} <- Verify.call(params) do
      token = Token.sign(user)

      conn
      |> put_status(:ok)
      |> json(%{message: "Usuário logado com sucesso", token: token})
    else
      {:error, "Usuário não encontrado"} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Usuário não encontrado"})

      {:error, "Senha incorreta"} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Senha incorreta"})
    end
  end

end
