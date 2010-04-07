# a class that interfaces with couch ; not activerecord
class User

  @@cr = CouchRest.new COUCHHOST
  @@db = @@cr.database(COUCHDB)

  attr_reader :raw, :parsed, :message_type
  def initialize(user_id)
    @user_id = user_id
  end

  def self.create_doc(created_at = Time.now) # parameterized to make testing easier
    user_pin = "%.6d" % rand(1000000)
    new_user = {:createdAt => created_at, :pin => user_pin, :messageType => "createUser"}
    doc_id = @@db.save_doc(new_user)['id'] 
    doc = @@db.get(doc_id)
  end

  def self.authenticate(doc_id, pin)
    doc = @@db.get(doc_id)
    doc['pin'] == pin ? true : false
  rescue RestClient::ResourceNotFound
    return false
  end

  def all_docs
    @res = Views.fetch("deletion/all_for_user", 
                    :startkey => [@user_id],
                    :endkey => [@user_id, {}])

    @res['rows'].map do |item|
      { '_id' => item["id"], '_rev' => item["key"][1] }
    end
  end

  def delete_activity
    all_docs.map do |doc|
       @@db.delete_doc(doc)
    end
  end

end
