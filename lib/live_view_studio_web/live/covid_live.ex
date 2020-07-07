defmodule LiveViewStudioWeb.CovidLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        country: "",
        countries: []
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sesrch By Country</h1>
    <div id="search">
      <form phx-submit="search-country">
        <input type="text" name="country" value="<%= @country %>"
        autofocus autocomplete="off"
        />

        <button name="Submit">
          <img src="images/search.svg"
        </button>
      </form>

      <div class="stores">
        <ul>
          <%= for country <- @countries do %>
            <li>
            <div class="first-line">
              <div class="name">
                <%= country["Country"] %>
              </div>
            </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
