class Views
  @@cr = CouchRest.new COUCHHOST
  @@db = @@cr.database(COUCHDB)

  def self.fetch(view, params={})
    @@db.view(view, params)
  end

  def self.list
    @@db.get("_design/my_views").inspect
  end


end

__END__

e.g.


Views.fetch("my_views/all_by_created_at", :include_docs => true, :descending => true)
