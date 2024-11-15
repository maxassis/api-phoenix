defmodule TestWeb.NoteController do
  use TestWeb, :controller

  alias Test.Notes  # controller
  alias Test.Notes.Note # model

  action_fallback TestWeb.FallbackController

  #retorna todas as notas
  def index(conn, _params) do
    notes = Notes.list_notes()
    render(conn, :index, notes: notes)
  end

  # cria uma nova nota
  def create(conn, %{"title" => title, "content" => content }) do
    IO.inspect(conn, label: "conn")
    %{user_id: user_id} = conn.assigns[:user_id]
    note_params = %{"title" => title, "content" => content, "user_id" => user_id}

    with {:ok, %Note{} = note} <- Notes.create_note(note_params) do
      conn
      |> put_status(:created)
      |> render(:show, note: note)
    end
  end

  # retorna uma nota especifica pelo id
  def show(conn, %{"id" => id}) do
    note = Notes.get_note!(id)
    render(conn, :show, note: note)
  end


  #retorna todas as notas de um usuario
  def getUserNotes(conn, _params) do
    %{user_id: user_id} = conn.assigns[:user_id]
    IO.inspect(user_id, label: "teste")

    notes = Notes.getUserNotes(user_id)
    render(conn, :index, notes: notes)
  end

  # altera uma nota
  def update(conn, %{"id" => id} = params) do
    note = Notes.get_note!(id)

     # Mantém os valores originais para os campos que não foram enviados
  updated_params =
    note
    |> Map.from_struct()               # Converte a `struct` da `note` para um mapa
    |> Map.merge(params)                # Mescla com os parâmetros recebidos
    |> Map.take(["title", "content"])   # Restringe aos campos que podem ser atualizados

     # Atualiza a nota
  with {:ok, %Note{} = updated_note} <- Notes.update_note(note, updated_params) do
    render(conn, :show, note: updated_note)
  end
  end

  # deleta uma nota
  def delete(conn, %{"id" => id}) do
    note = Notes.get_note!(id)

    with {:ok, %Note{}} <- Notes.delete_note(note) do
      send_resp(conn, :no_content, "")
    end
  end
end
