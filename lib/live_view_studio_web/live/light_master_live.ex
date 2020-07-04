defmodule LiveViewStudioWeb.LightMasterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Lights

  def mount(_params, _session, socket) do
    socket = assign(socket, status: "on", brightness: 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Master Bedroom Light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
          <%= @brightness %>
        </span>
      </div>
      <button phx-click="off">
        <img src="images/light-off.svg">
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg">
      </button>
    </div>
    """
  end

  def handle_event("on", _params, socket) do
    %HTTPoison.Response{status_code: status_code} = Lights.turn_on(3)

    case status_code do
      200 ->
        {:noreply, socket}

      _ ->
        socket = assign(socket, :status, "on")
        {:noreply, socket}
    end
  end

  def handle_event("off", _params, socket) do
    %HTTPoison.Response{status_code: status_code} = Lights.turn_off(3)

    case status_code do
      200 ->
        {:noreply, socket}

      _ ->
        socket = assign(socket, :status, "off")
        {:noreply, socket}
    end
  end

  @max_brightness 150

  def handle_event("up", _params, socket) do
    brightness = min(socket.assigns.brightness + 10, @max_brightness)
    %HTTPoison.Response{status_code: status_code} = Lights.adjust_brightness(3, brightness)

    case status_code do
      200 ->
        socket = assign(socket, :brightness, brightness)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @min_brightness 0
  def handle_event("down", _params, socket) do
    brightness = max(socket.assigns.brightness - 10, @min_brightness)
    %HTTPoison.Response{status_code: status_code} = Lights.adjust_brightness(3, brightness)

    case status_code do
      200 ->
        socket = assign(socket, :brightness, brightness)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end
end
