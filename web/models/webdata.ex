defmodule Myapp.Webdata do
  use Myapp.Web, :model
  schema "webdata" do
    field :name, :string
    field :webid, :integer
  end
  @derive {Poison.Encoder, only: [:name, :uwebid]}
end
