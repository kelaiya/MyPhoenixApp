defmodule Myapp.StudentController do
  use Myapp.Web, :controller
  def index(conn, _params) do
		students = Myapp.Repo.all(Myapp.Student)
		json conn, students
	end
end