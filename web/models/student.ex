defmodule Myapp.Student do
  use Myapp.Web, :model
  schema "students" do
    field :name, :string
    field :pic, :string
  end
  # @derive {Poison.Encoder, only: [:name]}
end
