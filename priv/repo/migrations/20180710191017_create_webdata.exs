defmodule Myapp.Repo.Migrations.CreateWebdata do
  use Ecto.Migration

  def change do
  	create table(:webdata) do
      add :name, :string
    end
  end
end
