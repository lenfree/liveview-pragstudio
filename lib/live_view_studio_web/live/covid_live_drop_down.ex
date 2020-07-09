defmodule LiveViewStudioWeb.CovidLiveDropDown do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Covid

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        country: "",
        result: nil,
        loading: false,
        matches: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Search By Country</h1>
    <div id="search">
      <form phx-submit="search-country" phx-change="search-country-suggest">
        <input type="text" name="country" value="<%= @country %>"
        autocomplete="off" list="match" placeholder="Country"
        phx-debounce="1000"
        <%= if @loading, do: "readonly" %>
        />

        <button name="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <datalist id="match">
        <%= for match <- @matches do %>
          <option value="<%= match["Country_Region"] %>"><%= match[:Country_Region] %>
        <% end%>
      </datalist>

      <%= if @loading do %>
      <div class="loader">
        Loading...
      </div>
      <% end %>


      <div class="stores">
        <ul>
          <%= if @result do %>
            <li>
            <div class="first-line">
              <div class="name">
                <%= @result[:Country_Region] %>
              </div>
              <div class="status">
                <span class="open">New Confirmed: <%= @result[:NewConfirmed] %></span>
                <span class="open">Total Confirmed: <%= @result[:Confirmed] %></span>
                <span class="open">New Deaths: <%= @result[:NewDeaths] %></span>
                <span class="open">Deaths: <%= @result[:Deaths] %></span>
                <span class="open">Active: <%= @result[:Active] %></span>
              </div>
            </div>
            <div class="second-line">
              <div class="street">
                Last updated: <%= @result[:Last_Update] %>
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
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("search-country-suggest", %{"country" => country}, socket) do
    result = Covid.search_by_country(country)

    socket =
      assign(
        socket,
        matches: result
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, country}, socket) do
    result = Covid.list_by_country(country)

    socket =
      socket
      |> clear_flash()
      |> assign(
        loading: false,
        result:
          result["Summary"]
          |> Enum.reduce(%{}, fn {key, val}, acc -> Map.put(acc, String.to_atom(key), val) end)
      )

    {:noreply, socket}
  end
end
