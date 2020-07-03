defmodule LiveViewStudioWeb.TimerLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Licenses

  def mount(_params, _session, socket) do
    expiration_time = Timex.shift(Timex.now(), hours: 1)

    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    socket =
      assign(socket,
        expiration_time: expiration_time,
        time_remaining: Licenses.time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Countdown Timer</h1>
    <div id="license">
      <p class="m-4 font-semibold text-indigo-800">
        <%= @time_remaining %>
      </p>
    </div>
    """
  end

  def handle_info(:tick, socket) do
    expiration_time = socket.assigns.expiration_time
    socket = assign(socket, :time_remaining, Licenses.time_remaining(expiration_time))
    {:noreply, socket}
  end
end
