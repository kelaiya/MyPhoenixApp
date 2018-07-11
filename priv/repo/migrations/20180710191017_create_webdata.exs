defmodule Myapp.Repo.Migrations.CreateWebdata do
  use Ecto.Migration

  def change do
  	create table(:webdata) do
      add :name, :string
      add :webid, :integer
    end
  end
end
