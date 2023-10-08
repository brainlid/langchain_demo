defmodule LangChainDemo.Conversations do
  @moduledoc """
  The Conversations context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias LangChainDemo.Repo

  alias LangChainDemo.Conversations.Conversation
  alias LangChainDemo.Messages.Message

  @doc """
  Returns the list of conversations.
  """
  def load_conversations() do
    from(c in Conversation, order_by: [desc: c.id])
    |> Repo.all()
  end

  def where_a_message_contains(query, value) do
    # NOTE: The right way to do this isn't working. I return a single field
    # value but it's returning a map SQLite can't understand in the subquery.
    # Doing it the ugly, terrible, two-stage way that works
    ids =
      from(m in Message,
        where: like(m.content, ^value),
        select: m.conversation_id
        # distinct: m.conversation_id
      )
      |> Repo.all()
      |> Enum.uniq()

    from(q in query,
      where: q.id in ^ids
    )
  end

  @doc """
  Returns the list of conversations.

  ## Examples

      iex> list_conversations()
      [%Conversation{}, ...]

  """
  def list_conversations do
    from(c in Conversation,
      order_by: [desc: c.id]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single conversation.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation!(123)
      %Conversation{}

      iex> get_conversation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation!(id), do: Repo.get!(Conversation, id)

  @doc """
  Creates a conversation.

  ## Examples

      iex> create_conversation(%{field: value})
      {:ok, %Conversation{}}

      iex> create_conversation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a conversation.

  ## Examples

      iex> update_conversation(conversation, %{field: new_value})
      {:ok, %Conversation{}}

      iex> update_conversation(conversation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a conversation.

  ## Examples

      iex> delete_conversation(conversation)
      {:ok, %Conversation{}}

      iex> delete_conversation(conversation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation changes.

  ## Examples

      iex> change_conversation(conversation)
      %Ecto.Changeset{data: %Conversation{}}

  """
  def change_conversation(%Conversation{} = conversation, attrs \\ %{}) do
    Conversation.changeset(conversation, attrs)
  end
end
