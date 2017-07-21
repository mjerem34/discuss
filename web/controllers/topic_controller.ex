defmodule Discuss.TopicController do
  use(Discuss.Web, :controller)

  alias(Discuss.Topic)

  plug(Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete])
  plug(:check_topic_owner when action in [:edit, :update, :delete])

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
    topic = Repo.get!(Topic, params["id"])

    render conn, "show.html", topic: topic
  end

  # POST /topics
  def create(conn, params) do
    changeset = conn.assigns.user
    |> build_assoc(:topics)
    |> Topic.changeset(params["topic"])
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
    topic = Repo.get(Topic, params["id"])
    changeset = Topic.changeset(topic)
    case Repo.delete(changeset) do
      {:ok, _struct} ->
        conn
        |> put_flash(:info, "Topic deleted")
        |> redirect(to: topic_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to delete topic")
        |> render("show.html")

    end
  end

  def check_topic_owner(conn, _params) do
    if Repo.get(Topic, conn.params["id"]).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot do that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
