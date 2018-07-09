defmodule Myapp.Market.Lead do
  use Ecto.Schema
  import Ecto.Changeset
  alias Myapp.Market.Lead

  @derive {Poison.Encoder, only: [:name]}
  schema "leads" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Lead{} = lead, attrs) do
    lead
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
