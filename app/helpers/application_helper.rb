# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def format_duration(seconds)
    minutes = seconds.to_i / 60 
    if minutes < 1
      "< 1 minute"
    elsif minutes < 60
      pluralize(minutes, "minute")
    else
      hours = minutes / 60
      minutes = minutes % 60
      [pluralize(hours, "hours"), pluralize(minutes, "minutes")].join(' and ')
    end
  end

  def format_date(datetime)
    time_ago_in_words(datetime) + " ago"
  end

  def raw_item(item)
    item = item.dup
    item.delete('_id')
    item.delete('_rev')
    item.to_json
  end

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

  def image(item)
    case item['messageType']
    when 'logStream'
      image_tag(item['stream']['logoURL'], :class => 'stationLogo') 
    when 'logPodcast'
      program = item['program']
      program_image_url = !program['imageURL'].blank? ? program['imageURL'] : nil
      if program_image_url
        image_tag(program_image_url, :class => 'podcastImage')
      end
    end
  end

  # for stream
  def current_streaming_program_description(item)
    "started listening " + 
    (item["currentProgram"]["title"] ? "to <strong>#{item['currentProgram']['title']}</strong> on " : "to ") +
      link_to(item['stream']['displayName'], item['stream']['website'])
  end

  def podcast_description(item)
    
    episode_url = item["episode"]["url"]
    program = item['program']
    program_link = !program['website'].blank? ? link_to(program['title'], program['website']) : program['title']

      "started listening to the <strong>#{program_link}</strong> podcast" +
        (item['episode']['title'] ?  ", #{link_to(item['episode']['title'], episode_url)}" : "") 

   
  end


end
