defmodule LiveViewStudio.Covid do
  def search_by_country(country) do
    list_summary()
    |> Enum.filter(&(&1["Country_Region"] == String.capitalize(country)))
  end

  def list_summary() do
    Neuron.Config.set(url: "https://api-corona.azurewebsites.net/graphql")

    {:ok, %{body: body}} =
      Neuron.query("""
        {
          summary {
            countries {
              Country_Region
              Last_Update
              Deaths
              NewDeaths
              NewConfirmed
              Confirmed
              Active
            }
          }
        }
      """)

    body["data"]["summary"]["countries"]
  end

  def list_countries() do
    list_summary()
  end
end
