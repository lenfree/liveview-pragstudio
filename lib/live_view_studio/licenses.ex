defmodule LiveViewStudio.Licenses do
  def calculate(seats) do
    if seats <= 5 do
      seats * 20.0
    else
      100 + (seats - 5) * 15.0
    end
  end

  def time_remaining(expiration_time) do
    Timex.Interval.new(from: Timex.now(), until: expiration_time)
    |> Timex.Interval.duration(:seconds)
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end
end
