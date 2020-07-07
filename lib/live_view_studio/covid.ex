defmodule LiveViewStudio.Covid do
  def search_by_country(country) do
    list_countries()
    |> Enum.filter(&(&1["Country"] == String.capitalize(country)))
  end

  def list_summary() do
    %HTTPoison.Response{body: body} = HTTPoison.get!("https://api.covid19api.com/summary")

    body |> Poison.decode!()
  end

  def list_countries() do
    %{"Countries" => countries} = list_summary()
    countries
  end
end
