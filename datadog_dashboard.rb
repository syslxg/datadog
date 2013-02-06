require 'dogapi'
dog = Dogapi::Client.new('api_key', 'app_key')
#search for metrics
search = "services"
result=dog.search ("metrics:#{search}")
metrics = result[1]["results"]["metrics"]

# Create a dashboard.
title = "#{search} from API"
description = "an equivalent of #{search} tab on dashboard.cf.com"
graphs = []
metrics.each { |m| g = {
  "definition" => {
    "events" => [],
    "requests"=> [
      {"q" => "avg:#{m}{*}"}
    ],
  "viz" => "timeseries"
  },
  "title" => "#{m}" 
 }
graphs<<g
}

dog.create_dashboard(title, description, graphs)
