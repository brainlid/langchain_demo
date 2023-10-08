defmodule LangChainDemo.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias LangChainDemo.Repo
  alias LangChainDemo.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(conversation_id) do
    from(m in Message,
      where: m.conversation_id == ^conversation_id,
      order_by: [asc: m.id]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(conversation_id, id) do
    from(m in Message, where: m.conversation_id == ^conversation_id, where: m.id == ^id)
    |> Repo.one!()
  end

  def get_last_message!(conversation_id) do
    from(m in Message,
      where: m.conversation_id == ^conversation_id,
      order_by: [desc: m.id],
      limit: 1
    )
    |> Repo.one!()
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(conversation_id, attrs \\ %{}) do
    conversation_id
    |> Message.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  @doc """
  Convert an Ecto DB message to a LangChain Message struct.
  """
  def db_messages_to_langchain_messages(messages) do
    Enum.map(messages, fn db_msg ->
      LangChain.Message.new!(%{
        role: db_msg.role,
        content: db_msg.content,
      })
    end)
  end
end
