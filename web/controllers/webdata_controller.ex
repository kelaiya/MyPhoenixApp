defmodule Myapp.WebdataController do
  use Myapp.Web, :controller


  def create(conn, %{"name" => name, "webid" => webid, "webimage" => webimage}) do
		Myapp.Repo.insert %Myapp.Webdata{name: name, webid: webid, webimage: webimage}
		json conn, %{"name": name, "webid": webid, "webimage": webimage}
	end
end