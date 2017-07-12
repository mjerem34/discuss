defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  # GET /topics OR /
  def index(conn, _params) do
    topics = Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  # GET /topics/new
  def new(conn, _params) do
    changeset = Topic.changeset %Topic{}, %{}
    render conn, "new.html", changeset: changeset
  end

  # GET /topics/:id
  def show(conn, params) do
    topic = Repo.get(Topic, params["id"])

    render conn, "show.html", topic: topic
  end

  # POST /topics
  def create(conn, params) do
    changeset = Topic.changeset(%Topic{}, params["topic"])
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  # GET /topics/:id/edit
  def edit(conn, params) do
    topic = Repo.get Topic, params["id"]
    changeset = Topic.changeset topic
    render conn, "edit.html", topic: topic, changeset: changeset
  end

  # PUT /topics/:id
  def update(conn, params) do
    topic = Repo.get(Topic, params["id"])
    changeset = Topic.changeset(topic, params["topic"])
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Unable to update topic")
        |> render("edit.html", changeset: changeset, topic: topic)
    end
  end

  # DELETE /topic/:id
  def delete(conn, params) do
    changeset = Repo.get(Topic, params["id"]) |> Topic.changeset()
    case Repo.delete(changeset) do
      {:ok, _struct} ->
        conn
        |> put_flash(:info, "Topic deleted")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Unable to delete topic")
        |> render("show.html")

    end
  end
end
