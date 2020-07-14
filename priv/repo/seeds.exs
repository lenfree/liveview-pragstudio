# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveViewStudio.Repo.insert!(%LiveViewStudio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LiveViewStudio.Repo
alias LiveViewStudio.Servers.Server

%Server{
  docker_containers: %{},
  environment: "dev",
  ip_address: "192.168.0.1",
  name: "localhost2"
}
|> Repo.insert!()

%Server{
  docker_containers: %{},
  environment: "dev",
  ip_address: "192.168.0.2",
  name: "localhost3"
}
|> Repo.insert!()
