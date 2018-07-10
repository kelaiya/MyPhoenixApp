defmodule Myapp.Webdata do
  use Myapp.Web, :model
  schema "webdata" do
    field :name, :string
  end
  @derive {Poison.Encoder, only: [:name]}
end
