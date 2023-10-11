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
        current_fitness_plan: "some current_fitness_plan",
        fitness_experience: "some fitness_experience",
        gender: "some gender",
        goals: "some goals",
        name: "some name",
        resources: "some resources",
        why: "some why"
      })
      |> LangChainDemo.FitnessUsers.create_fitness_user()

    fitness_user
  end
end
