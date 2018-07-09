defmodule Myapp.LeadController do
  use Myapp.Web, :controller
  alias Myapp.Market

  def create(conn, params) do
		with {:ok, lead} <- Market.create_leads(params) do
			json conn, lead
		end
	end
end