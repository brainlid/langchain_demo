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
      {"Anthropic claude-3-5-sonnet", "claude-3-5-sonnet-latest"},
      {"Anthropic claude-3-5-haiku", "claude-3-5-haiku-latest"},
      # https://us-west-2.console.aws.amazon.com/bedrock/home?region=us-west-2#/models
      {"Bedrock: Anthropic Claude 3.5 Sonnet v2", "anthropic.claude-3-5-sonnet-20241022-v2:0"},
      {"Bedrock: Anthropic Claude 3.5 Haiku", "anthropic.claude-3-5-haiku-20241022-v1:0"},
      {"OpenAI o1", "o1"},
      {"OpenAI o1-mini", "o1-mini"},
      {"OpenAI gpt-4o", "gpt-4o"},
      {"OpenAI gpt-4o mini", "gpt-4o-mini"},
      {"OpenAI gpt-4-turbo", "gpt-4-turbo"},
      {"gpt-4", "gpt-4"},
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
