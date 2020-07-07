defmodule LiveViewStudioWeb.CovidLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Covid

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        country: "",
        countries: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Search By Country</h1>
    <div id="search">
      <form phx-submit="search-country">
        <input type="text" name="country" value="<%= @country %>"
        autofocus autocomplete="off"
        />

        <button name="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <%= if @loading do %>
      <div class="loader">
        Loading...
      </div>
      <% end %>

      <div class="stores">
        <ul>
          <%= for country <- @countries do %>
            <li>
            <div class="first-line">
              <div class="name">
                <%= country["Country"] %>
              </div>
              <div class="status">
                <span class="open">New Confirmed: <%= country["NewConfirmed"] %></span>
                <span class="open">TotalConfirmed: <%= country["TotalConfirmed"] %></span>
                <span class="open">TotalDeaths: <%= country["TotalDeaths"] %></span>
                <span class="open">NewRecovered: <%= country["NewRecovered"] %></span>
              </div>
            </div>
            <div class="second-line">
              <div class="street">
                Last updated: <%= country["Date"] %>
              </div>
            </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search-country", %{"country" => country}, socket) do
    send(self(), {:run_search, country})

    socket =
      assign(
        socket,
        country: country,
        countries: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, country}, socket) do
    case Covid.search_by_country(country) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "Country #{country} not found")
          |> assign(
            countries: [],
            loading: false
          )

        {:noreply, socket}

      countries ->
        socket =
          socket
          |> clear_flash()
          |> assign(
            countries: countries,
            loading: false
          )

        {:noreply, socket}
    end
  end
end
