defmodule LangChainDemo.FitnessLogsTest do
  use LangChainDemo.DataCase

  alias LangChainDemo.FitnessLogs

  describe "fitness_logs" do
    alias LangChainDemo.FitnessLogs.FitnessLog

    import LangChainDemo.FitnessUsersFixtures
    import LangChainDemo.FitnessLogsFixtures

    @invalid_attrs %{activity: nil, amount: nil, date: nil, units: nil}

    setup do
      user = fitness_user_fixture()
      %{user: user}
    end

    test "list_fitness_logs/0 returns all fitness_logs", %{user: user} do
      fitness_log = fitness_log_fixture(user.id)
      assert FitnessLogs.list_fitness_logs(user.id) == [fitness_log]
    end

    test "get_fitness_log!/1 returns the fitness_log with given id", %{user: user} do
      fitness_log = fitness_log_fixture(user.id)
      assert FitnessLogs.get_fitness_log!(user.id, fitness_log.id) == fitness_log
    end

    test "create_fitness_log/1 with valid data creates a fitness_log", %{user: user} do
      valid_attrs = %{activity: "some activity", amount: 42, date: ~D[2023-10-06], units: "some units"}

      assert {:ok, %FitnessLog{} = fitness_log} = FitnessLogs.create_fitness_log(user.id, valid_attrs)
      assert fitness_log.activity == "some activity"
      assert fitness_log.amount == 42
      assert fitness_log.date == ~D[2023-10-06]
      assert fitness_log.units == "some units"
    end

    test "create_fitness_log/1 with invalid data returns error changeset", %{user: _user} do
      assert {:error, %Ecto.Changeset{}} = FitnessLogs.create_fitness_log(@invalid_attrs)
    end

    test "update_fitness_log/2 with valid data updates the fitness_log", %{user: user} do
      fitness_log = fitness_log_fixture(user.id)
      update_attrs = %{activity: "some updated activity", amount: 43, date: ~D[2023-10-07], units: "some updated units"}

      assert {:ok, %FitnessLog{} = fitness_log} = FitnessLogs.update_fitness_log(fitness_log, update_attrs)
      assert fitness_log.activity == "some updated activity"
      assert fitness_log.amount == 43
      assert fitness_log.date == ~D[2023-10-07]
      assert fitness_log.units == "some updated units"
    end

    test "update_fitness_log/2 with invalid data returns error changeset", %{user: user} do
      fitness_log = fitness_log_fixture(user.id)
      assert {:error, %Ecto.Changeset{}} = FitnessLogs.update_fitness_log(fitness_log, @invalid_attrs)
      assert fitness_log == FitnessLogs.get_fitness_log!(user.id, fitness_log.id)
    end

    test "delete_fitness_log/1 deletes the fitness_log", %{user: user} do
      fitness_log = fitness_log_fixture(user.id)
      assert {:ok, %FitnessLog{}} = FitnessLogs.delete_fitness_log(fitness_log)
      assert_raise Ecto.NoResultsError, fn -> FitnessLogs.get_fitness_log!(user.id, fitness_log.id) end
    end

    test "change_fitness_log/1 returns a fitness_log changeset", %{user: user} do
      fitness_log = fitness_log_fixture(user.id)
      assert %Ecto.Changeset{} = FitnessLogs.change_fitness_log(fitness_log)
    end
  end
end
