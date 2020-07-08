defmodule LiveViewStudioWeb.LightLivingLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Lights

  @bulb_id 2
  @max_brightness 150
  def mount(_params, _session, socket) do
    %{"state" => state} = Lights.status(@bulb_id)

    socket =
      assign(
        socket,
        status: state["on"],
        brightness: state["bri"],
        max_brightness: @max_brightness,
        bulb_id: @bulb_id
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Living Room Light Control</h1>
    <div id="light">
      <div class="card">
        <div class="contents">
          <div class="content">
            <span>
              Your brightness is currently at
              <strong><%= @brightness %></strong> with a max of <%= @max_brightness %>.
            </span>

            <form phx-change="update">
              <input type="range" min="0" max="<%= @max_brightness %>" step="10"
                    name="brightness" value="<%= @brightness %>" />
            </form>

           <button phx-click="off">
             <img src="images/light-off.svg"">
           </button>

           <button phx-click="on">
             <img src="images/light-on.svg">
           </button>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("on", _params, socket) do
    bulb_id = socket.assigns.bulb_id
    %HTTPoison.Response{status_code: status_code} = Lights.turn_on(bulb_id, 150)

    case status_code do
      200 ->
        {:noreply, socket}

      _ ->
        socket = assign(socket, :status, "on")
        {:noreply, socket}
    end
  end

  def handle_event("off", _params, socket) do
    bulb_id = socket.assigns.bulb_id
    %HTTPoison.Response{status_code: status_code} = Lights.turn_off(bulb_id)

    case status_code do
      200 ->
        {:noreply, socket}

      _ ->
        socket = assign(socket, :status, "off")
        {:noreply, socket}
    end
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    brightness = String.to_integer(brightness)
    bulb_id = socket.assigns.bulb_id
    %HTTPoison.Response{status_code: status_code} = Lights.adjust_brightness(bulb_id, brightness)

    case status_code do
      200 ->
        socket = assign(socket, brightness: brightness)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end
end
