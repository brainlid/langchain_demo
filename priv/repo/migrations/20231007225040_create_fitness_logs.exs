defmodule LangChainDemo.Repo.Migrations.CreateFitnessLogs do
  use Ecto.Migration

  def change do
    create table(:fitness_logs) do
      add :fitness_user_id, references(:fitness_users, on_delete: :delete_all), null: false
      add :date, :date
      add :activity, :string
      add :amount, :integer
      add :units, :string
      add :notes, :string

      timestamps()
    end

    create index(:fitness_logs, [:fitness_user_id])
    create index(:fitness_logs, [:date])
    create index(:fitness_logs, [:activity])
  end
end
