defmodule Myapp.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
  	create table(:users) do
      add :name, :string
      add :pic, :string
    end
  end
end

