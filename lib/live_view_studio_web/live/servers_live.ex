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
               class="<%= if server == @selected_server, do: 'active' %>">
              <img src="/images/server.svg">
              <%= server.name %>
            </a>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <div class="card">
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
end
