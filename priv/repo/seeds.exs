# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LangChainDemo.Repo.insert!(%LangChainDemo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LangChainDemo.FitnessUsers
alias LangChainDemo.FitnessUsers.FitnessUser

defmodule Seeds.CreateNew do
  def find_or_create_fitness_user(id, %{} = attrs) do
    case FitnessUsers.get_fitness_user(id) do
      %FitnessUser{} = user ->
        user

      nil ->
        {:ok, user} = FitnessUsers.create_fitness_user(attrs)
        user
    end
  end
end

Seeds.CreateNew.find_or_create_fitness_user(1, %{})
