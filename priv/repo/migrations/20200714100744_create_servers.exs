defmodule LiveViewStudio.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :ip_address, :string
      add :docker_containers, :map
      add :environment, :string

      timestamps()
    end

  end
end
