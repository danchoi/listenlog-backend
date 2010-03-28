# a class that interfaces with couch ; not activerecord
class User

  @@cr = CouchRest.new COUCHHOST
  @@db = @@cr.database(COUCHDB)

  attr_reader :raw, :parsed, :message_type
  def initialize(json)
    @raw = json
    @parsed = JSON.parse(json)
    @message_type = @parsed['messageType']
  end

  def create_doc(created_at = Time.now) # parameterized to make testing easier
    return unless @message_type == 'createUser'

    user_pin = "%.6d" % rand(1000000)
    new_user = {:createdAt => created_at, :pin => user_pin}

    @@db.save_doc(user_doc)
  end



end
