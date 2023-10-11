defmodule LangChainDemo.FitnessUsers do
  @moduledoc """
  The FitnessUsers context.
  """

  import Ecto.Query, warn: false
  alias LangChainDemo.Repo

  alias LangChainDemo.FitnessUsers.FitnessUser

  @doc """
  Returns the list of fitness_users.

  ## Examples

      iex> list_fitness_users()
      [%FitnessUser{}, ...]

  """
  def list_fitness_users do
    Repo.all(FitnessUser)
  end

  @doc """
  Gets a single fitness_user.

  Raises `Ecto.NoResultsError` if the Fitness user does not exist.

  ## Examples

      iex> get_fitness_user!(123)
      %FitnessUser{}

      iex> get_fitness_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fitness_user!(id), do: Repo.get!(FitnessUser, id)

  def get_fitness_user(id), do: Repo.get(FitnessUser, id)

  @doc """
  Creates a fitness_user.

  ## Examples

      iex> create_fitness_user(%{field: value})
      {:ok, %FitnessUser{}}

      iex> create_fitness_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fitness_user(attrs \\ %{}) do
    %FitnessUser{}
    |> FitnessUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fitness_user.

  ## Examples

      iex> update_fitness_user(fitness_user, %{field: new_value})
      {:ok, %FitnessUser{}}

      iex> update_fitness_user(fitness_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fitness_user(%FitnessUser{} = fitness_user, attrs) do
    fitness_user
    |> FitnessUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fitness_user.

  ## Examples

      iex> delete_fitness_user(fitness_user)
      {:ok, %FitnessUser{}}

      iex> delete_fitness_user(fitness_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fitness_user(%FitnessUser{} = fitness_user) do
    Repo.delete(fitness_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fitness_user changes.

  ## Examples

      iex> change_fitness_user(fitness_user)
      %Ecto.Changeset{data: %FitnessUser{}}

  """
  def change_fitness_user(%FitnessUser{} = fitness_user, attrs \\ %{}) do
    FitnessUser.changeset(fitness_user, attrs)
  end
end
