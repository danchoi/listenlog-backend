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
    doc = @db.get(resp['id'])
    assert_equal "Pennsylvania", doc['stream']['location']
  end

  test 'should strip any userPIN info' do
    x = ListenLogger.new(create_stream_json)
    resp = x.create_doc
    doc = @db.get(resp['id'])
    assert doc['user']['pin'].nil?, "user pin not stripped"
  end

  test "should add initial listen log attributes" do
    doc_id = ListenLogger.new(create_stream_json).create_doc['id']
    doc = @db.get(doc_id)
    assert doc['listenLog']
    assert_equal 0, doc['listenLog']['listenDuration']
    DateTime.parse(doc['listenLog']['createdAt']) # should not raise error
  end

  test "extend duration of stream listen record" do
    time_start = 1.minute.ago
    time_2 = time_start + 5.seconds
    # time_start need not be passed in. By default, #create_doc uses current time
    doc_id = ListenLogger.new(create_stream_json).create_doc(time_start)['id']
    # Note that this is the kind of JSON that the client should send:
    json = {:doc_id => doc_id, :mesasgeType => "extendDuration"}.to_json
    ListenLogger.new(json).extend_duration(:until => time_2)
    assert_equal 5, @db.get(doc_id)['listenLog']['listenDuration']
  end

  test "create a podcast listen record" do
    x = ListenLogger.new(create_podcast_json)
    resp = x.create_doc
    doc = @db.get(resp['id'])
    assert_equal "Fresh Air", doc['program']['title']
    assert_equal "http://podcastdownload.npr.org/anon.npr-podcasts/podcast/13/124475239/npr_124475239.mp3", doc['episode']["enclosure"]
  end

  test "extend duration of podcast listen record" do
    time_start = 1.minute.ago
    time_2 = time_start + 5.seconds
    doc_id = ListenLogger.new(create_podcast_json).create_doc(time_start)['id']
    json = {:doc_id => doc_id, :mesasgeType => "extendDuration"}.to_json
    ListenLogger.new(json).extend_duration(:until => time_2)
    assert_equal 5, @db.get(doc_id)['listenLog']['listenDuration']
  end

  test "log podcastDuration and podcastCurrentTime with extend duration message" do
    doc_id = ListenLogger.new(create_podcast_json).create_doc['id']
    message = {:doc_id => doc_id, :mesasgeType => "extendDuration", :listenLog => {:podcastDuration => 11, :lastListenedPoint => 7}}
    ListenLogger.new(message.to_json).extend_duration
    assert_equal 11, @db.get(doc_id)['listenLog']['podcastDuration']
    assert_equal 7, @db.get(doc_id)['listenLog']['lastListenedPoint']
  end

  test "should expose flag to indicate message type" do
    listen_logger = ListenLogger.new(create_podcast_json)
    assert_equal "logPodcast", listen_logger.message_type
    listen_logger = ListenLogger.new(create_stream_json)
    assert_equal "logStream", listen_logger.message_type

    message = {:doc_id => '1234', :messageType => "extendDuration"}
    listen_logger = ListenLogger.new(message.to_json)
    assert_equal 'extendDuration', listen_logger.message_type 
  end

  def create_stream_json
    <<-JSON
{"stream":{"frequency":"WHYY-FM 90.9","website":"http://whyy.org","url":"http://207.245.67.204:80","location":"Pennsylvania","streamID":63,"logoURL":"http://stream.publicbroadcasting.net/publicradioplayer/iphone/logos/whyy.jpg","displayName":"WHYY Philadelphia"},"currentProgram":{"title":"Fresh Air","endTime":"2010-03-10 16:00:00 -0500","startTime":"2010-03-10 15:00:00 -0500","programID":27},"messageType":"logStream","user":{"UDID":"45A4C147-9ECE-592E-925B-FC39657842F6", "pin":"625321"}}
    JSON
  end

  def create_podcast_json
    <<-JSON
    {"program":{"programID":27,"podcast":"http://www.npr.org/rss/podcast.php?id=13","title":"Fresh Air","description":"Fresh Air from WHYY, the Peabody Award-winning weekday magazine of contemporary arts and issues, is one of public radio's most popular programs. Hosted by Terry Gross, the show features intimate conversations with today's biggest luminaries.","category":"","imageURL":"http://media.npr.org/images/podcasts/thumbnail/npr_freshair_image_75.jpg","website":""},"messageType":"logPodcast","episode":{"enclosure":"http://podcastdownload.npr.org/anon.npr-podcasts/podcast/13/124475239/npr_124475239.mp3","title":"NPR: 03-08-2010 Fresh Air","url":"http://freshair.npr.org?ft=2&f=13","episodeID":4007779,"summary":"Stories:  1) 'Whip Smart': Memoirs Of A Dominatrix 2) The Gods, At Play In The House Of Mortals 3) A Tribute To Sparklehorse's Mark Linkous","pubDate":"2010-03-08 21:31:14 -0500"},"user":{"UDID":"45A4C147-9ECE-592E-925B-FC39657842F6"}}
    JSON
  end

  def create_search_podcast_json
    <<-JSON
    {"program":{"title":"Morning Edition"},"messageType":"logPodcast","episode":{"enclosure":"http://pd.npr.org/anon.npr-mp3/npr/me/2008/12/20081203_me_10.mp3?orgId=1&topicId=1006&ft=3&f=searchTerm=linux","title":"Chinese City Cracks Down On Pirated Software","url":"http://pd.npr.org/anon.npr-mp3/npr/me/2008/12/20081203_me_10.mp3?orgId=1&topicId=1006&ft=3&f=searchTerm=linux","summary":"Red Flag Linux is the name of a Chinese-made operating system. Officials in Nanchang are forcing local Internet cafe owners to install it in place of Microsoft Windows. An official from the the cit..."},"user":{"UDID":"45A4C147-9ECE-592E-925B-FC39657842F6"}
    JSON
  end
end

__END__

 {"stream":{"frequency":"WBUR 90.9 FM","website":"http://www.wbur.org","url":"http://wbur-sc.streamguys.com:80","location":"Massachusetts","streamID":142,"logoURL":"http://stream.publicbroadcasting.net/publicradioplayer/iphone/logos/wbur.jpg","displayName":"90.9 WBUR, Boston"},"currentProgram":{"title":"Newshour","endTime":"2010-03-11 10:00:00 -0500","startTime":"2010-03-11 09:00:00 -0500","programID":23},"messageType":"logStream","user":{"UDID":"45A4C147-9ECE-592E-925B-FC39657842F6"}}

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



