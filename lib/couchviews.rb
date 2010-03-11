require 'couchrest'

# can run outside rails

class CouchViews
  def initialize
    @db = CouchRest.database! "http://localhost:5984/listenlog"
  end

  def views
    { 
    'all_by_created_at' => { "map" => "function(doc) {
      if (doc.listenLog && doc.listenLog.createdAt)
        emit(doc.listenLog.createdAt, null); }"},

    'all_by_user_and_created_at' => { "map" => "function(doc) {
    if (doc.user && doc.listenLog.createdAt)
      emit([doc.user, doc.listenLog.createdAt], null); }" },

      'listens_count_per_user' => { 
          "map" => "
            function(doc) {
              if (doc.user && doc.listenLog.createdAt)
                emit(doc.user, 1)
            }",
          "reduce" => "
            function(keys, values, rereduce) {
              return sum(values);
          } 
          "},

      'total_seconds_per_user' => { 
          "map" => "
            function(doc) {
              if (doc.user && doc.listenLog.listenDuration)
                emit(doc.user, doc.listenLog.listenDuration)
            }",
          "reduce" => "
            function(keys, values, rereduce) {
              return sum(values);
          } "},

      'total_seconds_per_user_per_program' => { 
          "map" => "function(doc) {

              if (doc.user && doc.listenLog.listenDuration && doc.program)
                emit([doc.user, doc.program.title], doc.listenLog.listenDuration)

              if (doc.user && doc.listenLog.listenDuration && doc.currentProgram)
                emit([doc.user, doc.currentProgram.title], doc.listenLog.listenDuration)
            }",
          "reduce" => "
            function(keys, values, rereduce) {
              return sum(values);
          } "},

      'total_seconds_per_user_per_stream' => { 
          "map" => "function(doc) {

              if (doc.user && doc.listenLog.listenDuration && doc.stream)
                emit([doc.user, doc.stream.displayName], doc.listenLog.listenDuration)

            }",
          "reduce" => "
            function(keys, values, rereduce) {
              return sum(values);
          } "},

      'total_seconds_per_program' => { 
          "map" => "function(doc) {

              if (doc.listenLog.listenDuration && doc.program)
                emit(doc.program.title, doc.listenLog.listenDuration)

              if (doc.listenLog.listenDuration && doc.currentProgram)
                emit( doc.currentProgram.title, doc.listenLog.listenDuration)
            }",
          "reduce" => "
            function(keys, values, rereduce) {
              return sum(values);
          } "},

      'total_seconds_per_stream' => { 
          "map" => "function(doc) {
              if (doc.listenLog.listenDuration && doc.stream)
                emit(doc.stream.displayName, doc.listenLog.listenDuration)
            }",
          "reduce" => "
            function(keys, values, rereduce) {
              return sum(values);
          } "},



    }
  end

  def create!
    doc = {
      "_id" => "_design/my_views",
      :views => self.views
    }
    begin
      res = @db.get("_design/my_views")
      doc.merge!("_rev" =>  res["_rev"])
      puts "updating #{doc.inspect}"
    rescue RestClient::ResourceNotFound
    end

    res = @db.save_doc(doc)
    puts res.inspect
  end
end


if __FILE__ == $0
  CouchViews.new.create!
end

__END__


  def test
    <<-JS
function(doc) {
  if (doc.program && doc.program.title && doc.episode && doc.episode.title) 
    emit([doc.program.title, doc.episode.title, doc.messageType], null);
  else if (doc.currentProgram && doc.currentProgram.title && doc.stream && doc.stream.displayName)
    emit([doc.stream.displayName, doc.currentProgram.title, doc.messageType], null);
}
    JS
  end

