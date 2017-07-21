defmodule Discuss.Topic do
  @moduledoc """
    Topic model
  """
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string

    belongs_to(:user, Discuss.User)
    has_many(:comments, Discuss.Comment)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
