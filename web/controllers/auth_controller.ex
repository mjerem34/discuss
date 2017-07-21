defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  # GET /auth/:provider/callback
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{email: auth.info.email, provider: params["provider"],
    token: auth.credentials.token}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  # DELETE /auth/signout
  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "See you soon !")
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user changeset do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back !")
        |> redirect(to:  topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Unexpected error when attempt to log you in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
