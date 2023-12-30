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
puts input_location
puts "Checking the weather at #{input_location}..."

#Using Google Maps API to find out the longitude and latitude:
gmaps_api_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{input_location}&key=#{gmaps_api_key}"

#Use HTTP to send a request for Google Maps API:
respGEO = HTTP.get(gmaps_url)

#See the contents of the body (eye-friendly):
raw_response_GEO = respGEO.to_s

#Use JSON to parse the response: turn the response into an OBJECT we can dig into
parsed_response_GEO = JSON.parse(raw_response_GEO)

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

pp latitude
pp longitude


