# handles logging ListenLog log JSON messages to CouchDB
class ListenLogger

  @@cr = CouchRest.new COUCHHOST
  @@db = @@cr.database(COUCHDB)


  attr_reader :raw, :parsed
  def initialize(json)
    @raw = json
    @parsed = JSON.parse(json)
  end

  def save_doc
    @@db.save_doc(@parsed)
  end


end
