defmodule LangChainDemo.FitnessLogs.FitnessLog do
  use Ecto.Schema
  import Ecto.Changeset
  alias LangChainDemo.FitnessUsers.FitnessUser
  alias __MODULE__

  @derive {Jason.Encoder, only: [:activity, :amount, :date, :units, :notes]}
  schema "fitness_logs" do
    field :activity, :string
    field :amount, :integer
    field :date, :date
    field :units, :string
    field :notes, :string

    timestamps()

    belongs_to :fitness_user, FitnessUser
  end

  @create_fields [:date, :activity, :amount, :units, :notes]
  @update_fields @create_fields
  @required_fields [:date, :activity]

  @doc false
  def create_changeset(fitness_user_id, attrs) do
    %FitnessLog{}
    |> cast(attrs, @create_fields)
    |> put_change(:fitness_user_id, fitness_user_id)
    |> common_validations()
  end

  @doc false
  def changeset(fitness_log, attrs) do
    fitness_log
    |> cast(attrs, @update_fields)
    |> common_validations()
  end

  defp common_validations(changeset) do
    changeset
    |> validate_required(@required_fields)
  end
end
