class TravelController < ApplicationController
  def index
  end

  def search
  countries = find_country(params[:country_ip])

  unless countries
    flash[:alert] = 'Country ip not found'
    return render action: index
  end

  @country = countries
  # @weather = find_weather(@country['capital'], @country['alpha2Code'])
  end

  private

  def request_api(url)
    response = Excon.get(
      url,
      headers:  {
        'X-RapidApi-Host' => URI.parse(url).host,
        'X-RapidApi-key'=> ENV.fetch('RAPIDAPI_API_KEY')
      }
    )

    return nil if response.status != 200

    JSON.parse(response.body)
  end

  def find_country(ip_address)
    request_api(
      "https://ip-geolocation-ipwhois-io.p.rapidapi.com/json/#{URI.encode_www_form_component(ip_address)}"
    )
  end

  # def find_weather(city, country_code)
  #   query = URI.encode("#{city}, #{country_code}")
  #
  #   request_api(
  #     "https://community-open-weather-map.p.rapidapi.com/forecast?q=#{query}"
  #   )
  # end
end
