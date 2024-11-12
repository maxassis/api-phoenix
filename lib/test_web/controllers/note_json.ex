defmodule TestWeb.NoteJSON do
  alias Test.Notes.Note

  @doc """
  Renders a list of notes.
  """
  def index(%{notes: notes}) do
    %{data: for(note <- notes, do: data(note))}
  end

  @doc """
  Renders a single note.
  """
  def show(%{note: note}) do
    %{data: data(note)}
  end

  defp data(%Note{} = note) do
    %{
      id: note.id,
      title: note.title,
      content: note.content
    }
  end
end
