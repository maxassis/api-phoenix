defmodule TestWeb.NoteController do
  use TestWeb, :controller

  alias Test.Notes  # controller
  alias Test.Notes.Note # model

  action_fallback TestWeb.FallbackController

  def index(conn, _params) do
    notes = Notes.list_notes()
    render(conn, :index, notes: notes)
  end



  def create(conn, %{"title" => title, "content" => content}) do
    note_params = %{"title" => title, "content" => content}

    with {:ok, %Note{} = note} <- Notes.create_note(note_params) do
      conn
      |> put_status(:created)
      |> render(:show, note: note)
    end
  end

  def show(conn, %{"id" => id}) do
    note = Notes.get_note!(id)
    render(conn, :show, note: note)
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Notes.get_note!(id)

    with {:ok, %Note{} = note} <- Notes.update_note(note, note_params) do
      render(conn, :show, note: note)
    end
  end

  def delete(conn, %{"id" => id}) do
    note = Notes.get_note!(id)

    with {:ok, %Note{}} <- Notes.delete_note(note) do
      send_resp(conn, :no_content, "")
    end
  end
end
