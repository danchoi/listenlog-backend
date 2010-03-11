require 'test_helper'

class ListenLoggerTest < ActiveSupport::TestCase

end

__END__

from DemoData

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



