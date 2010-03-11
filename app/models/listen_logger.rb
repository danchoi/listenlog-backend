# handles logging ListenLog log JSON messages to CouchDB
class ListenLogger

  @@cr = CouchRest.new COUCHHOST
  @@db = @@cr.database(COUCHDB)


  attr_reader :raw, :parsed
  def initialize(json)
    @raw = json
    @parsed = JSON.parse(json)
  end

  def create_doc(created_at = Time.now) # parameterized to make testing easier
    @parsed[:listenLog] = {:listenDuration => 0, :createdAt => created_at}

    if @parsed[:messageType] == 'logPodcast'
      @parsed.merge!({:totalDuration => nil, :lastListenedSecond => 0})
    elsif @parsed[:messageType] == 'logStream'

    end
    @@db.save_doc(@parsed)
  end

  def extend_duration(params)
    get_doc
    if params[:until].is_a?(Time)
      created_at = DateTime.parse(@doc['listenLog']['createdAt'])
      new_duration = (params[:until] - created_at).to_i
      @doc['listenLog']['listenDuration'] = new_duration
      @doc['listenLog']['updatedAt'] = params[:until]
      @@db.save_doc(@doc)
    end
  end

  def get_doc
    @doc_id = @parsed.delete("doc_id")
    @doc = @@db.get(@doc_id)
  end


end
