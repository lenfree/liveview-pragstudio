defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers),
        add_new_entry: false,
        load: true
      )

    {:ok, socket, temporary_assigns: [servers: []]}
  end

  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= for server <- @servers do %>
            <div>
              <%= live_patch server.name,
                to: Routes.live_path(
                    @socket,
                    __MODULE__,
                    id: server.id
                  ),
                  class: if server == @selected_server, do: "active" %>
            </div>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <%= if @load do  %>
          <div class="card" style="margin: 0 auto; width:1000px;">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class="<%= @selected_server.name %>">
                <%= @selected_server.name %>
              </span>
            </div>
            <div class="body">
              <h3>FQDN</h3>
              <div class="fqdn">
                <%= @selected_server.name %>
              </div>
              <h3>IP Address</h3>
              <div class="ip address">
                <%= @selected_server.ip_address %>
              </div>
              <h3>IP Address</h3>
              <div class="ip address">
                <%= @selected_server.ip_address %>
              </div>
              <h3>Environment</h3>
              <div class="environment">
                <%= @selected_server.environment %>
              </div>
              <h3>Containers</h3>
              <div class="containers">
                <%= if Map.has_key?(@selected_server.docker_containers, :result)  do %>
                <%= for result <- parse_containers(@selected_server.docker_containers) do %>
                <span style="white-space:pre">
                  <%= result  %>
                <span>
                <%= end %>
                <%= end %>
              </div>
              <!-- add tags -->
              <h3>Tags</h3>
              <blockquote>
                <%= @selected_server.environment %>
              </blockquote>
              <div class="add">
                <button phx-click="add">
                  <img src="images/add.svg">
                </button>
              </div>
            </div>
          </div>
      <% end %>
      <%= if @add_new_entry do %>
      <div class="main">
        <div class="wrapper">
          <div class="card">
            <div class="header">
            <h3>Add new entry form</h3>
            </div>
            <form phx-submit="add-server">
                Name:<input type="text" id="name" name="name" style="border:1px solid #AEB6BF" placeholder="name" ><br><br>
                IP Address:<input type="text" id="ip_address" name="ip_address" style="border:1px solid #AEB6BF" placeholder="1.2.3.4"><br><br>
                Environment: <input type="text" id="environment" name="environment" style="border:1px solid #AEB6BF" placeholder="test"><br><br>
        <button name="submit">
          <img src="images/enter.svg">
        </button>
              </form>
          </div>
        </div>
      </div>
      <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp parse_containers(%{result: result}) do
    {_header, rows} = List.pop_at(result, 0)

    # headers = String.split(header, "   ") |> Enum.reject(fn x -> x == "" end)

    data = Enum.map(rows, fn row -> String.split(row, "  ") end)

    data
    |> Enum.map(fn row -> Enum.reject(row, fn x -> x == "" end) end)
    |> Enum.reduce(
      [],
      fn [id | [image | [cmd | [created | [status | [ports | name]]]]]], acc ->
        ["#{name} with image #{image} is #{status} and listening on port #{ports}"] ++ acc
      end
    )
  end

  def handle_params(%{"id" => id}, _url, socket) do
    id = String.to_integer(id)

    server = Servers.get_server!(id)

    socket =
      assign(socket,
        selected_server: server,
        servers: Servers.list_servers()
      )

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("add", _params, socket) do
    socket =
      assign(
        socket,
        add_new_entry: true,
        load: false
      )

    {:noreply, socket}
  end

  def handle_event(
        "add-server",
        params,
        socket
      ) do
    params =
      Enum.map(params, fn {key, value} -> {String.to_existing_atom(key), value} end)
      |> Enum.into(%{})

    # TODO: handle case
    {:ok, server} = Servers.create_server(params)
    servers = Servers.list_servers()

    socket =
      assign(
        socket,
        servers: servers,
        selected_server: server,
        add_new_entry: true,
        load: false
      )

    {:noreply, socket}
  end
end
