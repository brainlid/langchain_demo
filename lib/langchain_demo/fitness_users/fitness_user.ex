defmodule LangChainDemo.FitnessUsers.FitnessUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias LangChainDemo.FitnessLogs.FitnessLog

  @derive {Jason.Encoder,
           only: [
             :age,
             :overall_fitness_plan,
             :fitness_experience,
             :gender,
             :goals,
             :name,
             :resources,
             :why,
             :limitations,
             :notes,
             :fitness_plan_for_week,
             :timezone
           ]}
  schema "fitness_users" do
    field :age, :integer
    field :overall_fitness_plan, :string
    field :fitness_experience, Ecto.Enum, values: [:beginner, :intermediate, :advanced]
    field :gender, :string
    field :goals, :string
    field :name, :string
    field :resources, :string
    field :why, :string
    field :limitations, :string
    field :notes, :string
    field :fitness_plan_for_week, :string
    field :timezone, :string

    timestamps()

    has_many :fitness_logs, FitnessLog
  end

  @doc false
  def changeset(fitness_user, attrs) do
    fitness_user
    |> cast(attrs, [
      :name,
      :gender,
      :age,
      :why,
      :fitness_experience,
      :goals,
      :resources,
      :overall_fitness_plan,
      :limitations,
      :notes,
      :fitness_plan_for_week,
      :timezone
    ])
    |> validate_required([])
  end
end
