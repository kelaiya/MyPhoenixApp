defmodule Myapp.UserController do
  use Myapp.Web, :controller
  
  def index(conn, _params) do
		users = Myapp.Repo.all(Myapp.User)
		json conn, users
	end
end