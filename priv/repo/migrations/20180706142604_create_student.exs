defmodule Myapp.Repo.Migrations.CreateStudent do
  use Ecto.Migration

  def change do
  	create table(:students) do
      add :name, :string
      add :pic, :string
    end
  end
end
