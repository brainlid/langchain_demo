defmodule LangChainDemo.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :name, :string
      add :model, :string
      add :temperature, :float, default: 1.0
      add :frequency_penalty, :float, default: 0.0

      timestamps()
    end

    create index(:conversations, [:name])

    create table(:messages) do
      add :conversation_id, references(:conversations, on_delete: :delete_all), null: false
      add :role, :string
      add :content, :string
      add :edited, :boolean, default: false, null: false
      add :status, :string

      timestamps()
    end

    create index(:messages, [:conversation_id])
    create index(:messages, [:status])
  end
end
