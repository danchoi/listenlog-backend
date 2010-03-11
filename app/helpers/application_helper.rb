# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def reverse_geocode(item)
    return # for testing
    return unless item["user"]
    lat, lng = item['user']["lat"], item["user"]["lng"]
    return if lat.nil?
    res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"
    if res.respond_to?(:location)
      logger.debug("FOUND LOCATION: #{res.inspect}")
      "in <strong>#{res.city}, #{res.location}</strong>"
    end
  end

  # for stream
  def current_streaming_program_description(item)
    image_tag(item['stream']['logoURL'], :class => 'stationLogo') +
    "started listening " + 
    (item["currentProgram"]["title"] ? "to <strong>#{item['currentProgram']['title']}</strong> on " : "to ") +
      link_to(item['stream']['displayName'], item['stream']['website'])
  end

  def podcast_description(item)
    
    episode_url = item["episode"]["url"]
      "started listening to the <strong>#{item['program']['title']}</strong> podcast" +
        (item['episode']['title'] ?  ", #{link_to(item['episode']['title'], episode_url)}" : "") +
      "<div class='episode-summary'>#{item["episode"]["summary"]}</div>" + 
      link_to("listen now", item["episode"]["enclosure"])
   
  end


end
