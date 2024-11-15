defmodule MyApp.Repo.Migrations.CreateNotas do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :content, :text
      add :user_id, references(:users)

      timestamps()
    end

    create index(:notes, [:user_id])
  end
end
