require "http"
require "json"

#Initial start:
border = "="
puts border*35
puts "Will you need an umbrella today?"
puts border*35
puts "Where are you?"
input_location = gets.chomp()
#input_location = "Chicago"
puts "Checking the weather at #{input_location}..."

#Using Google Maps API to find out the longitude and latitude:

#1 - Fetch the GMAPS API Key and dynamically determine the URL for HTTP:
gmaps_api_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{input_location}&key=#{gmaps_api_key}"

#2 - Use HTTP to send a request to Google Maps API with the dynamic URL:
respGEO = HTTP.get(gmaps_url)
raw_response_GEO = respGEO.to_s #Raw body response via .to_s
parsed_response_GEO = JSON.parse(raw_response_GEO) #Readable hash response via JSON gem's .parse() method

=begin
Use the .keys() method to check what is actually inside the Hash. This makes it easier to dig into the data. Can also use hoppscotch to visualize the parsed response data.

Example:
parsed_response_GEO.keys()

Use hoppscotch to follow the chaining of DS digging below.

=end

#Here's the start of DS Digging:

#1: a hash "results"
resultsGEO = parsed_response_GEO.fetch("results")

#2: inner array:
innerArrayGEO = resultsGEO.at(0)

#3: inner hash:
innerHashGEO = innerArrayGEO.fetch("geometry")

#4: inner-inner hash "geometry":
geometry_hash = innerHashGEO.fetch("location")

#5: inner-inner-inner hash "location": this is where the longitude and latitude keys are
latitude = geometry_hash.fetch("lat")
longitude = geometry_hash.fetch("lng")

#Print to the console: "Your coordinates are: "
puts "Your coordinates are #{latitude}, #{longitude}"

#Using Pirate Weather to determine the temperature:

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

pirate_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

#Using HTTP to send a request to Pirate Weather:
respPIR = HTTP.get(pirate_url)

raw_responsePIR = respPIR.to_s
parsed_responsePIR = JSON.parse(raw_responsePIR)

#Accessing the "currently" hash to get the current temperature:
resultsPIR = parsed_responsePIR.fetch("currently")
temperature = resultsPIR.fetch("temperature")
hourly_summary = parsed_responsePIR.fetch("hourly").fetch("summary")

#Print to the console: "It is currently [temperature]":
puts "It is currently #{temperature}°F."
puts "In the next hour, it will be: #{hourly_summary.downcase}"

#Accessing the "hourly" hash in order to get the hourly information for temperature:
hourly = parsed_responsePIR.fetch("hourly")
dataARRAY = hourly.fetch("data")

#Looping through the dataARRAY to print hourly temperature report:
twelve_hourDATA = dataARRAY[1..12]
hour = 1
hour_one = "hour"
hour_multiple = "hours"

twelve_hourDATA.each do |hour_hash|
  hourly_temp = hour_hash.fetch("temperature")
  if hour == 1
    puts "In #{hour} #{hour_one}, the temperature will be: #{hourly_temp}"
    hour = hour + 1
  else
    puts "In #{hour} #{hour_multiple}, the temperature will be: #{hourly_temp}"
    hour = hour + 1
  end
end
