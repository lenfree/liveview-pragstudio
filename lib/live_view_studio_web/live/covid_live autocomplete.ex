defmodule LiveViewStudioWeb.CovidLiveAutocomplete do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Covid

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        country: "",
        countries: Covid.list_summary(),
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Search By Country</h1>
    <div id="search">
      <form phx-submit="search-country" phx-change="autocomplete-search-country">
        <input type="text" name="country" value="<%= @country %>"
        autofocus autocomplete="off" phx-debounce="1000"
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
            <%= create_list(%{country: country}) %>
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

  def handle_event("autocomplete-search-country", %{"country" => country}, socket) do
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

  defp create_list(assigns) do
    ~L"""
      <li>
        <div class="first-line">
          <div class="name">
            <%= @country["Country_Region"] %>
          </div>
        </div>
        <div class="status">
          <span class="open">New Confirmed: <%= @country["NewConfirmed"] %></span>
          <span class="open">Total Confirmed: <%= @country["Confirmed"] %></span>
          <span class="open">New Deaths: <%= @country["NewDeaths"] %></span>
          <span class="open">Deaths: <%= @country["Deaths"] %></span>
          <span class="open">Active: <%= @country["Active"] %></span>
        </div>
        <div class="second-line">
          <div class="street">
            Last updated: <%= @country["Last_Update"] %>
          </div>
        </div>
      </li>
    """
  end
end
