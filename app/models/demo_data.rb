class DemoData < ActiveRecord::Base
  serialize :payload

  def to_s
    y = payload
    if schedule = y.delete("schedule")
      y['program'] = schedule.first
    end

    location = if y['user']['lat']
      lat, lng = y['user']['lat'], y['user']['lng']
      res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"
      "in <strong>#{res.city}, #{res.location}</strong>"
               else
                 "" 
               end

    programDesc = if y['program']
                    "<strong>#{y['program']['programTitle']}</strong> on"
                  else
                    ""
                  end
    %Q[
<a class="stationLogo" href="#{y['website']}"><img src='#{y['logoURL']}'/></a>
      Someone #{location} just started listening to #{programDesc} <a href="#{y['website']}">#{y['displayName']}</a>
    ]
  end


end
