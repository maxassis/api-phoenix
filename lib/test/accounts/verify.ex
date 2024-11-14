defmodule Test.Accounts.Verify do
  # alias Test.Accounts.User
  alias Test.Accounts

  def call(%{id: id, password: password}) do
    case Accounts.get_user(id) do
      nil ->
        {:error, "Usuário não encontrado"}
      user ->
        case Bcrypt.verify_pass(password, user.password_hash) do
          true -> {:ok, user}
          false -> {:error, "Senha incorreta"}
        end
    end
  end

end
