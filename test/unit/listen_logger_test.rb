require 'test_helper'

class ListenLoggerTest < ActiveSupport::TestCase

  def setup
    @cr = CouchRest.new COUCHHOST
    @db = @cr.database!(COUCHDB)
  end

  def teardown
    @db.delete! rescue nil
  end

  test "create couchrest db" do
    assert @cr.databases.include?(COUCHDB)
  end

  test "hold raw json and parse json" do
    x = ListenLogger.new(create_stream_json)
    assert_equal x.raw, create_stream_json
    assert_equal "WHYY-FM 90.9", x.parsed['stream']['frequency']
    assert_equal "45A4C147-9ECE-592E-925B-FC39657842F6", x.parsed['user']['UDID']
  end

  test 'persist json in couchDB' do
    x = ListenLogger.new(create_stream_json)
    resp = x.create_doc
    assert resp['ok']
    assert resp['id']
    assert resp['rev']
    doc = @db.get(resp['id'])
    assert_equal "Pennsylvania", doc['stream']['location']
  end

  test "should set initial listen duration and array to hold all log time markers" do
    doc_id = ListenLogger.new(create_stream_json).create_doc['id']
    doc = @db.get(doc_id)
    assert doc['listenLog']
    assert doc['listenLog']['listenDuration']
    assert_equal 0, doc['listenLog']['listenDuration']
    assert_match %r{\d\d\d\d/\d\d/\d\d \d\d:\d\d:\d\d \+\d\d\d\d}, doc['listenLog']['createdAt']
    DateTime.parse(doc['listenLog']['createdAt']) # should not raise error
  end

  test "extend duration of stream listen record" do
    time_start = 1.minute.ago
    time_2 = time_start + 5.seconds
    doc_id = ListenLogger.new(create_stream_json).create_doc(time_start)['id']
    # Note that this is the kind of JSON that the client should send:
    json = {:doc_id => doc_id, :mesasgeType => "extendDuration"}.to_json
    ListenLogger.new(json).extend_duration(:until => time_2)
    assert_equal 5, @db.get(doc_id)['listenLog']['listenDuration']
  end

  test "create a podcast listen" do

  end

  def create_stream_json
    <<-JSON
{"stream":{"frequency":"WHYY-FM 90.9","website":"http://whyy.org","url":"http://207.245.67.204:80","location":"Pennsylvania","streamID":63,"logoURL":"http://stream.publicbroadcasting.net/publicradioplayer/iphone/logos/whyy.jpg","displayName":"WHYY Philadelphia"},"currentProgram":{"title":"Fresh Air","endTime":"2010-03-10 16:00:00 -0500","startTime":"2010-03-10 15:00:00 -0500","programID":27},"messageType":"logStream","user":{"UDID":"45A4C147-9ECE-592E-925B-FC39657842F6"}}
    JSON
  end

  def create_podcast_json

  end
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



