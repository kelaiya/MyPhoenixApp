defmodule Myapp.Marketing.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:name]}
  schema "store" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
