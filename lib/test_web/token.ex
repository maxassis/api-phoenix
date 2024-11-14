defmodule TestWeb.Token do
  alias Phoenix.Token
  alias TestWeb.Endpoint

  @salt "secret"

  def sign(user) do
    Token.sign(Endpoint, @salt, %{user_id: user.id})
  end

  def verify(token) do
   case Token.verify(Endpoint, @salt, token) do
     {:ok, %{user_id: user_id}} -> {:ok, %{user_id: user_id}}
     _ -> :error
   end
  end

end
