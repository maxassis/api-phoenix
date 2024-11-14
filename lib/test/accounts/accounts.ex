defmodule Test.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Test.Repo
  alias Test.Accounts.User

  @doc """
  Creates a user with basic information.
  """
  def create_simple_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single user by id.
  Returns nil if the User does not exist.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Deletes a user by id.
  Returns {:ok, user} if successful.
  Returns {:error, :not_found} if user doesn't exist.
  """
  def delete_user(id) when is_binary(id) do
    case Integer.parse(id) do
      {id_integer, _} -> do_delete_user(id_integer)
      :error -> {:error, :not_found}
    end
  end

  def delete_user(id) when is_integer(id) do
    do_delete_user(id)
  end

  defp do_delete_user(id) do
    case get_user(id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
