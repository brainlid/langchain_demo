defmodule LangChainDemo.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :name, :string
    field :model, :string

    field :temperature, :float, default: 1.0
    field :frequency_penalty, :float, default: 0.0

    has_many :messages, LangChainDemo.Messages.Message
    timestamps()
  end

  def model_options() do
    [
      {"gpt-4", "gpt-4"},
      {"gpt-3.5-turbo-16k", "gpt-3.5-turbo-16k"},
      {"gpt-3.5-turbo (stable)", "gpt-3.5-turbo"}
    ]
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:name, :model, :temperature, :frequency_penalty])
    |> validate_required([:name, :model])
  end
end
