require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @cr = CouchRest.new COUCHHOST
    @db = @cr.database!(COUCHDB)
  end

  def teardown
    @db.delete! rescue nil
  end

  test "create a user with hash id and pin" do
    x = User.create_doc
    # returns a doc like this
    # {"_id"=>"b7f96eb914dbc91acaa588f123fd6b52", "_rev"=>"1-3425854716", "createdAt"=>"2010/03/28 21:54:42 +0000", "pin"=>"625321"}
    assert x['_id']
    assert x['pin'] =~ /\d{6}/
    assert_equal "createUser",  x['messageType']
  end


end
