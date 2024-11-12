defmodule Test.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :title, :string
    field :content, :string
    belongs_to :user, Test.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
  end
end
