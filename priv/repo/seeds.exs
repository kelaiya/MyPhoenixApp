# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Myapp.Repo.insert!(%Myapp.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.
alias Myapp.Repo
alias Myapp.User

Repo.insert! %User{name: "Hanna", pic: "hello"}
Repo.insert! %User{name: "Ann", pic: "Hello"}
Repo.insert! %User{name: "Emma", pic: "Hello"}
Repo.insert! %User{name: "Mary", pic: "Hello"}
Repo.insert! %User{name: "Julia", pic: "Hello"}
