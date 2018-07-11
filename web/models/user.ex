defmodule Myapp.User do
  use Myapp.Web, :model
  schema "users" do
    field :name, :string
    field :pic, :string
  end
end
