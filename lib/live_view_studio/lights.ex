defmodule LiveViewStudio.Lights do
  def turn_on(bulb_id, brightness) do
    body = Poison.encode!(%{on: true, bri: brightness})
    HTTPoison.put!("#{build_url()}/#{bulb_id}/state", body)
  end

  def turn_off(bulb_id) do
    body = Poison.encode!(%{on: false})
    HTTPoison.put!("#{build_url()}/#{bulb_id}/state", body)
  end

  def adjust_brightness(bulb_id, brightness) do
    body = Poison.encode!(%{bri: brightness})
    HTTPoison.put!("#{build_url()}/#{bulb_id}/state", body)
  end

  @api_key System.get_env("HUE_API_KEY")
  @url "192.168.0.2/api"
  def build_url() do
    "#{@url}/#{@api_key}/lights"
  end
end
