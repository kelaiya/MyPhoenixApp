defmodule Myapp.WebdataController do
  use Myapp.Web, :controller


  def create(conn, %{"name" => name}) do
  	# items = for item <- items, do: Map.put item, :_id, to_string(item._id)
		webdata = Myapp.Repo.insert %Myapp.Webdata{name: name}
		json conn, %{name: name}
	end
end