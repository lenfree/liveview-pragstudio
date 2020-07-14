defmodule LiveViewStudio.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :docker_containers, :map
    field :environment, :string
    field :ip_address, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :ip_address, :docker_containers, :environment])
    |> validate_required([:name, :ip_address, :docker_containers, :environment])
  end
end
