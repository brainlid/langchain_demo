defmodule LangChainDemo.FitnessLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LangChainDemo.FitnessLogs` context.
  """

  @doc """
  Generate a fitness_log.
  """
  def fitness_log_fixture(attrs \\ %{}) do
    {:ok, fitness_log} =
      attrs
      |> Enum.into(%{
        activity: "some activity",
        amount: 42,
        date: ~D[2023-10-06],
        units: "some units"
      })
      |> LangChainDemo.FitnessLogs.create_fitness_log()

    fitness_log
  end
end
