defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= for server <- @servers do %>
            <a href="#"
              phx-click="show"
              phx-value-id="<%= server.id %>"
               class="<%= if server == @selected_server, do: 'active' %>">
              <img src="/images/server.svg">
              <%= server.name %>
            </a>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <div class="card" style="margin: 0 auto; width:855px;">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class="<%= @selected_server.name %>">
                <%= @selected_server.name %>
              </span>
            </div>
            <div class="body" style="margin: 0 auto; width:855px;">
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
    <%= result |> Enum.join("\t\t\t\t\t\t") %>
                <%= end %>
                <%= end %>
              </div>
              <!-- add tags -->
              <blockquote>
                <%= @selected_server.environment %>
              </blockquote>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp parse_containers(%{result: result}) do
    {header, rows} = List.pop_at(result, 0)

    headers = String.split(header, "   ") |> Enum.reject(fn x -> x == "" end)

    r = Enum.map(rows, fn row -> String.split(row, "  ") end)
    row = r |> Enum.map(fn row -> Enum.reject(row, fn x -> x == "" end) end)
    row
    #      Enum.each(row, fn [h| t] ->  :ets.insert_new(:container_id, h) end)
    #      :ets.tab2list(:container_id)
    #     require IEx
    #     IEx.pry()
    #     Enum.map(row, fn x -> Enum.join(x, "\n") end)
  end

  def handle_event("show", %{"id" => id}, socket) do
    id = String.to_integer(id)

    server = Servers.get_server!(id)

    socket =
      assign(socket,
        selected_server: server
      )

    {:noreply, socket}
  end
end
