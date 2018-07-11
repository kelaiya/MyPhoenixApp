defmodule Myapp.WebdataController do
  use Myapp.Web, :controller


  def create(conn, %{"name" => name}) do
		Myapp.Repo.insert %Myapp.Webdata{name: name}
		json conn, %{"name": name}
	end
end