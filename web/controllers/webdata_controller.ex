defmodule Myapp.WebdataController do
  use Myapp.Web, :controller


  def create(conn, %{"name" => name, "webid" => webid}) do
		Myapp.Repo.insert %Myapp.Webdata{name: name, webid: webid}
		json conn, %{"name": name, "webid": webid}
	end
end