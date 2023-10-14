defmodule LangChainDemoWeb.AgentChatLive.Agent.FitnessLogsTool do
  @moduledoc """
  Defines a set of LLM tools for working with the FitnessLogs linked to the user's account..
  """
  require Logger
  alias LangChain.Function
  alias LangChainDemo.FitnessLogs

  @doc """
  Return the functions used for operating on a user's FitnessLogs.
  """
  @spec new_functions!() :: [Function.t()]
  def new_functions!() do
    [
      new_get_fitness_logs!(),
      new_create_fitness_log!()
    ]
  end

  @doc """
  Defines the "get_fitness_logs" function.
  """
  @spec new_get_fitness_logs!() :: Function.t() | no_return()
  def new_get_fitness_logs!() do
    Function.new!(%{
      name: "get_fitness_logs",
      description: "Search for and return the user's past fitness workout logs as a JSON array.",
      parameters_schema: %{
        type: "object",
        properties: %{
          days: %{
            type: "integer",
            description:
              "The number of days of history to return from the search. Defaults to 12."
          },
          activity: %{
            type: "string",
            description:
              "The name of the activity being search for. Searches for one activity at a time, but supports partial matches. An activity of \"bench\" will return both Incline Bench and Bench Press."
          }
        },
        required: []
      },
      function: &execute_get_fitness_logs/2
    })
  end

  @spec execute_get_fitness_logs(args :: %{String.t() => any()}, context :: map()) :: String.t()
  def execute_get_fitness_logs(%{} = args, %{live_view_pid: pid, current_user: user} = _context) do
    # Use the context for the current_user
    days = Map.get(args, "days", nil)
    activity = Map.get(args, "activity", nil)

    filters =
      [
        if days do
          {:days, days}
        else
          nil
        end,
        if activity do
          {:activity, "%#{activity}%"}
        else
          nil
        end
      ]
      |> Enum.reject(&is_nil(&1))

    send(pid, {:function_run, "Retrieving fitness history."})

    user.id
    |> FitnessLogs.list_fitness_logs(filters)
    |> Jason.encode!()
  end

  @doc """
  Defines the "create_fitness_log" function.
  """
  @spec new_create_fitness_log!() :: Function.t() | no_return()
  def new_create_fitness_log!() do
    Function.new!(%{
      name: "create_fitness_log",
      description: "Create a new fitness log entry for the user.",
      parameters_schema: %{
        type: "object",
        properties: %{
          date: %{
            type: "string",
            description:
              "The date the activity was performed as a string in the format YYYY-MM-DD."
          },
          activity: %{
            type: "string",
            description:
              "The name of the activity. Ex: Running, Elliptical, Bench Press, Push Ups, Bent-Over Rows, etc."
          },
          amount: %{
            type: "integer",
            description:
              "Either the duration in time, a distance traveled, the number of times an activity was performed (like push-ups), or the weight used (like \"25\" for 25 lbs)."
          },
          units: %{
            type: "string",
            description: "One word unit for the amount. Ex: lbs, minutes, miles, count."
          },
          notes: %{
            type: "string",
            description: "Notes about the activity. How it went, heart rate, etc."
          }
        },
        required: []
      },
      function: &execute_create_fitness_log/2
    })
  end

  @spec execute_create_fitness_log(args :: %{String.t() => any()}, context :: map()) :: String.t()
  def execute_create_fitness_log(
        %{} = args,
        %{live_view_pid: pid, current_user: user} = _context
      ) do
    # Use the context for the current_user
    case FitnessLogs.create_fitness_log(user.id, args) do
      {:ok, log} ->
        send(pid, {:function_run, "Recorded fitness activity entry."})
        "created log ##{log.id}"

      {:error, changeset} ->
        errors = LangChain.Utils.changeset_error_to_string(changeset)
        "ERROR: #{errors}"
    end
  end
end
