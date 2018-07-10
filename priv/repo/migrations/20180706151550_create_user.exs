defmodule Myapp.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
  	create table(:users) do
      add :name, :string
      add :pic, :string, size: 7000 
    end
  end
end

