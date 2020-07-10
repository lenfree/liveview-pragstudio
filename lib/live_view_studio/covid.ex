defmodule LiveViewStudio.Covid do
  def search_by_country(country) do
    list_summary()
    |> Enum.filter(&country_match?(&1, country))
  end

  def country_match?(result, country) do
    String.downcase(result["Country_Region"]) =~ country
  end

  def list_summary() do
    Neuron.Config.set(url: "https://api-corona.azurewebsites.net/graphql")

    case Neuron.query("""
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
         """) do
      {:ok, %{body: body}} ->
        body["data"]["summary"]["countries"]

      _ ->
        []
    end
  end

  def list_by_country(country) do
    Neuron.Config.set(url: "https://api-corona.azurewebsites.net/graphql")

    case Neuron.query(
           """
            query($country: ID!) {
              country(country: $country) {
              Summary {
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
           """,
           %{country: country}
         ) do
      {:ok, %{body: %{"data" => %{"country" => result}}}} ->
        result

      _ ->
        %{}
    end
  end

  def list_countries() do
    list_summary()
  end
end
