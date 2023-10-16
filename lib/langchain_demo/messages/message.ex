defmodule LangChainDemo.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "messages" do
    field :content, :string
    field :edited, :boolean, default: false

    field :role, Ecto.Enum,
      values: [:system, :user, :assistant, :function, :function_call],
      default: :user

    field :status, Ecto.Enum, values: [:complete, :length, :cancelled], default: nil

    belongs_to(:conversation, LangChainDemo.Conversations.Conversation)

    timestamps()
  end

  @type t :: %Message{}

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:role, :content, :status, :edited])
    |> auto_set_edited()
    |> common_validations()
  end

  @doc false
  def create_changeset(conversation_id, attrs) do
    %Message{}
    |> cast(attrs, [:role, :content, :status])
    |> put_change(:conversation_id, conversation_id)
    |> common_validations()
  end

  defp common_validations(changeset) do
    changeset
    |> validate_required([:role])
    |> validate_user_content()
  end

  defp auto_set_edited(changeset) do
    case fetch_change(changeset, :content) do
      {:ok, _value} ->
        # if not explicitly setting "edited" value, flag it as "edited"
        if !changed?(changeset, :edited) do
          put_change(changeset, :edited, true)
        else
          changeset
        end

      :error ->
        changeset
    end
  end

  # validate that a "user" message has content. Allow an assistant message to be
  # returned where we don't have content yet.
  defp validate_user_content(changeset) do
    case fetch_field!(changeset, :role) do
      :user ->
        validate_required(changeset, [:content])

      _other ->
        changeset
    end
  end
end
