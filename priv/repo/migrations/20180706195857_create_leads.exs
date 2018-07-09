defmodule Myapp.Repo.Migrations.CreateLeads do
  use Ecto.Migration

  def change do
    create table(:leads) do
      add :name, :string

      timestamps()
    end

  end
end
