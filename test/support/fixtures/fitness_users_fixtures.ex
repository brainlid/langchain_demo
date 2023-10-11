defmodule LangChainDemo.FitnessUsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LangChainDemo.FitnessUsers` context.
  """

  @doc """
  Generate a fitness_user.
  """
  def fitness_user_fixture(attrs \\ %{}) do
    {:ok, fitness_user} =
      attrs
      |> Enum.into(%{
        age: 42,
        overall_fitness_plan: nil,
        fitness_experience: :beginner,
        gender: "male",
        goals: nil,
        name: nil,
        resources: nil,
        why: "some why"
      })
      |> LangChainDemo.FitnessUsers.create_fitness_user()

    fitness_user
  end
end
