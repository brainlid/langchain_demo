defmodule LangChainDemo.FitnessLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LangChainDemo.FitnessLogs` context.
  """

  @doc """
  Generate a fitness_log.
  """
  def fitness_log_fixture(user_id, attrs \\ %{}) do
    values =
      attrs
      |> Enum.into(%{
        activity: "some activity",
        amount: 42,
        date: ~D[2023-10-06],
        units: "some units"
      })

    {:ok, fitness_log} = LangChainDemo.FitnessLogs.create_fitness_log(user_id, values)

    fitness_log
  end
end
