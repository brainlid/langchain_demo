defmodule LangChainDemoWeb.AgentChatLive.Agent.UpdateCurrentUserFunction do
  @moduledoc """
  Defines an UpdateCurrentUserFunction tool for modifying a fitness user's account.

  Defines a function to expose to an LLM and provide the `execute/2` function
  for evaluating it when an LLM executes the function.
  """
  require Logger
  alias LangChain.Function
  alias LangChain.FunctionParam
  alias LangChainDemo.FitnessUsers

  @doc """
  Defines the "update_current_user" function.
  """
  @spec new() :: {:ok, Function.t()} | {:error, Ecto.Changeset.t()}
  def new() do
    Function.new(%{
      name: "update_current_user",
      display_text: "Update user",
      description:
        "Update one or more fields at a time on the user's account and workout information.",
      parameters: [
        FunctionParam.new!(%{name: "age", type: :integer, description: "The user's age"}),
        FunctionParam.new!(%{
          name: "overall_fitness_plan",
          type: :string,
          description: "Description of the user's current overall fitness plan"
        }),
        FunctionParam.new!(%{
          name: "fitness_experience",
          type: :string,
          enum: ["beginner", "intermediate", "advance"],
          description:
            "The user's experience with physical fitness. Used to customize instructions."
        }),
        FunctionParam.new!(%{
          name: "gender",
          type: :string,
          description: "The user's gender. Used to help customize workouts"
        }),
        FunctionParam.new!(%{
          name: "goals",
          type: :string,
          description:
            "The user's current set of goals. CSV list of goals. (Ex: 12 bicep curls at 35 lbs, run a mile without walking)"
        }),
        FunctionParam.new!(%{
          name: "name",
          type: :string,
          description: "The user's name. Used to customize the interaction and training"
        }),
        FunctionParam.new!(%{
          name: "resources",
          type: :string,
          description:
            "CSV list of fitness resources available to the user. (Ex: gym membership, rack of free weight dumbbells, stationary bike)"
        }),
        FunctionParam.new!(%{
          name: "why",
          type: :string,
          description:
            "The user's reasons for wanting to improve fitness. Used for motivation and to customize the fitness plan to satisfy the user"
        }),
        FunctionParam.new!(%{
          name: "limitations",
          type: :string,
          description:
            "CSV list of any physical limitations the user has that may impact which exercises they can do"
        }),
        FunctionParam.new!(%{
          name: "notes",
          type: :string,
          description:
            "Place to store relevant and temporary notes about the user for future reference"
        }),
        FunctionParam.new!(%{
          name: "fitness_plan_for_week",
          type: :string,
          description: "The user's specific workout plan for the week"
        })
      ],
      function: &execute/2
    })
  end

  @spec new!() :: Function.t() | no_return()
  def new!() do
    case new() do
      {:ok, function} ->
        function

      {:error, changeset} ->
        raise LangChain.LangChainError, changeset
    end
  end

  @doc """
  Performs the function and let's the LiveView know of the change. Returns the
  result to the LLM.
  """
  @spec execute(args :: %{String.t() => any()}, context :: map()) :: String.t()
  def execute(%{} = args, %{live_view_pid: pid, current_user: user} = _context) do
    # Use the context for the current_user
    case FitnessUsers.update_fitness_user(user, args) do
      {:ok, updated_user} ->
        send(pid, {:updated_current_user, updated_user})
        # return text to the LLM letting it know the result of the action
        {:ok, "success"}

      {:error, changeset} ->
        reason = LangChain.Utils.changeset_error_to_string(changeset)
        {:error, "ERROR: #{reason}"}
    end
  end
end
