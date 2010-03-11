require 'test_helper'
require 'format_log'

class TestFormatLog < ActiveSupport::TestCase

  def setup
    @data = {"displayName"=>"WABE 90.1 FM , Atlanta, GA", "schedule"=>[{"programID"=>11063, "startTime"=>"2010-03-05 12:00:00 -0500", "endTime"=>"2010-03-05 13:00:00 -0500", "programTitle"=>"City Cafe"}, {"programID"=>1378, "startTime"=>"2010-03-05 13:00:00 -0500", "endTime"=>"2010-03-05 15:00:00 -0500", "programTitle"=>"Afternoon Classics"}, {"programID"=>114, "startTime"=>"2010-03-05 15:00:00 -0500", "endTime"=>"2010-03-05 16:00:00 -0500", "programTitle"=>"The World"}, {"programID"=>37, "startTime"=>"2010-03-05 16:00:00 -0500", "endTime"=>"2010-03-05 18:30:00 -0500", "programTitle"=>"All Things Considered"}, {"programID"=>40, "startTime"=>"2010-03-05 18:30:00 -0500", "endTime"=>"2010-03-05 19:00:00 -0500", "programTitle"=>"Marketplace"}, {"programID"=>378, "startTime"=>"2010-03-05 19:00:00 -0500", "endTime"=>"2010-03-05 19:30:00 -0500", "programTitle"=>"Between the Lines"}, {"programID"=>11065, "startTime"=>"2010-03-05 19:30:00 -0500", "endTime"=>"2010-03-05 20:00:00 -0500", "programTitle"=>"Says You!"}, {"programID"=>124, "startTime"=>"2010-03-05 20:00:00 -0500", "endTime"=>"2010-03-05 21:00:00 -0500", "programTitle"=>"Performance Today"}, {"programID"=>11066, "startTime"=>"2010-03-05 21:00:00 -0500", "endTime"=>"2010-03-05 22:00:00 -0500", "programTitle"=>"Thistle & Shamrock"}, {"programID"=>11067, "startTime"=>"2010-03-05 22:00:00 -0500", "endTime"=>"2010-03-05 23:00:00 -0500", "programTitle"=>"A Night on the Town"}, {"programID"=>11068, "startTime"=>"2010-03-05 23:00:00 -0500", "endTime"=>"2010-03-06 00:00:00 -0500", "programTitle"=>"MUSIC FROM HEARTS OF SPACE"}, {"programID"=>40, "startTime"=>"2010-03-05 18:29:59 -0500", "endTime"=>"2010-03-05 19:00:00 -0500", "programTitle"=>"Marketplace"}], "logoURL"=>"http://stream.publicbroadcasting.net/publicradioplayer/iphone/logos/wabe.jpg", "streamURL"=>"http://pba-ice.streamguys.org/wabe.m3u", "website"=>"http://www.wabe.org", "frequency"=>"WABE-FM 90.1", "streamID"=>51, "user"=>{"UDID"=>"45A4C147-9ECE-592E-925B-FC39657842F6"}, "state"=>"Georgia"}
    @out = FormatLog.format(@data)
  end

  def test_parse
    assert !@out.nil?

  end
end
