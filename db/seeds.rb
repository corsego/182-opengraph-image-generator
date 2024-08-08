require 'open-uri'
path = "https://raw.githubusercontent.com/ruby-conferences/ruby-conferences.github.io/main/_data/conferences.yml"
uri = URI.open(path)
yaml = YAML.load_file uri, permitted_classes: [Date]

yaml.each do |event|
  next if event["start_date"].to_datetime < Date.today

  Event.create!(
    name: event["name"],
    location: event["location"],
    start_date: event["start_date"],
    url: event["url"],
  )
end
