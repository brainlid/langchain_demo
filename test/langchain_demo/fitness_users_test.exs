defmodule LangChainDemo.FitnessUsersTest do
  use LangChainDemo.DataCase

  alias LangChainDemo.FitnessUsers

  describe "fitness_users" do
    alias LangChainDemo.FitnessUsers.FitnessUser

    import LangChainDemo.FitnessUsersFixtures

    @invalid_attrs %{age: nil, current_fitness_plan: nil, fitness_experience: nil, gender: nil, goals: nil, name: nil, resources: nil, why: nil}

    test "list_fitness_users/0 returns all fitness_users" do
      fitness_user = fitness_user_fixture()
      assert FitnessUsers.list_fitness_users() == [fitness_user]
    end

    test "get_fitness_user!/1 returns the fitness_user with given id" do
      fitness_user = fitness_user_fixture()
      assert FitnessUsers.get_fitness_user!(fitness_user.id) == fitness_user
    end

    test "create_fitness_user/1 with valid data creates a fitness_user" do
      valid_attrs = %{age: 42, current_fitness_plan: "some current_fitness_plan", fitness_experience: "some fitness_experience", gender: "some gender", goals: "some goals", name: "some name", resources: "some resources", why: "some why"}

      assert {:ok, %FitnessUser{} = fitness_user} = FitnessUsers.create_fitness_user(valid_attrs)
      assert fitness_user.age == 42
      assert fitness_user.current_fitness_plan == "some current_fitness_plan"
      assert fitness_user.fitness_experience == "some fitness_experience"
      assert fitness_user.gender == "some gender"
      assert fitness_user.goals == "some goals"
      assert fitness_user.name == "some name"
      assert fitness_user.resources == "some resources"
      assert fitness_user.why == "some why"
    end

    test "create_fitness_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FitnessUsers.create_fitness_user(@invalid_attrs)
    end

    test "update_fitness_user/2 with valid data updates the fitness_user" do
      fitness_user = fitness_user_fixture()
      update_attrs = %{age: 43, current_fitness_plan: "some updated current_fitness_plan", fitness_experience: "some updated fitness_experience", gender: "some updated gender", goals: "some updated goals", name: "some updated name", resources: "some updated resources", why: "some updated why"}

      assert {:ok, %FitnessUser{} = fitness_user} = FitnessUsers.update_fitness_user(fitness_user, update_attrs)
      assert fitness_user.age == 43
      assert fitness_user.current_fitness_plan == "some updated current_fitness_plan"
      assert fitness_user.fitness_experience == "some updated fitness_experience"
      assert fitness_user.gender == "some updated gender"
      assert fitness_user.goals == "some updated goals"
      assert fitness_user.name == "some updated name"
      assert fitness_user.resources == "some updated resources"
      assert fitness_user.why == "some updated why"
    end

    test "update_fitness_user/2 with invalid data returns error changeset" do
      fitness_user = fitness_user_fixture()
      assert {:error, %Ecto.Changeset{}} = FitnessUsers.update_fitness_user(fitness_user, @invalid_attrs)
      assert fitness_user == FitnessUsers.get_fitness_user!(fitness_user.id)
    end

    test "delete_fitness_user/1 deletes the fitness_user" do
      fitness_user = fitness_user_fixture()
      assert {:ok, %FitnessUser{}} = FitnessUsers.delete_fitness_user(fitness_user)
      assert_raise Ecto.NoResultsError, fn -> FitnessUsers.get_fitness_user!(fitness_user.id) end
    end

    test "change_fitness_user/1 returns a fitness_user changeset" do
      fitness_user = fitness_user_fixture()
      assert %Ecto.Changeset{} = FitnessUsers.change_fitness_user(fitness_user)
    end
  end
end
