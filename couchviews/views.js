{
   "_id":"design/my_views",

   "views": {
       "all_by_user_and_created_at": { "map": "function(doc) { if (doc.user && doc.listenLog.createdAt) emit([doc.user.UDID, doc.listenLog.createdAt], null); }" },
       "total_seconds_per_user": { "reduce": "function(keys, values, rereduce) { return sum(values); } ", 
         "map": "function(doc) { if (doc.user && doc.listenLog.listenDuration) emit(doc.user.UDID, doc.listenLog.listenDuration) }"
       },
       "all_by_user_and_created_at": {
           "map": "function(doc) { if (doc.user && doc.listenLog.createdAt) emit([doc.user.UDID, doc.listenLog.createdAt], null); }"
       },

       "total_seconds_per_user_per_program": {
           "reduce": "function(keys, values, rereduce) {  sum(values);  ",
           "map": "function(doc) { 
             if (doc.user && doc.listenLog.listenDuration && doc.program)
               emit([doc.user.UDID, doc.program.title], doc.listenLog.listenDuration)
             if (doc.user && doc.listenLog.listenDuration && doc.currentProgram)
               emit([doc.user.UDID, doc.currentProgram.title], doc.listenLog.listenDuration) }" },
       "total_seconds_per_user_per_stream": {
           "reduce": "function(keys, values, rereduce) { return sum(values); } ",
           "map": "function(doc) {
             if (doc.user && doc.listenLog.listenDuration && doc.stream)
               emit([doc.user.UDID, doc.stream.displayName], doc.listenLog.listenDuration)
           }"
       },
       "listens_count_per_user": {
           "map": "function(doc) { if (doc.user && doc.listenLog.createdAt)
             emit(doc.user.UDID, 1) }",
           "reduce": "function(keys, values, rereduce) { return sum(values); }"
       },

       "total_seconds_per_stream": {
           "reduce": "function(keys, values, rereduce) { return sum(values); } ",
           "map": "function(doc) {
             if (doc.listenLog && doc.listenLog.listenDuration && doc.stream)
               emit(doc.stream.displayName, doc.listenLog.listenDuration)
           }"
       },
       "total_seconds_per_program": {
           "reduce": "function(keys, values, rereduce) { return sum(values); } ",
           "map": "function(doc) { 
             if (doc.listenLog && doc.listenLog.listenDuration && doc.program)
               emit(doc.program.title, doc.listenLog.listenDuration)
             if (doc.listenLog && doc.listenLog.listenDuration && doc.currentProgram)
               emit( doc.currentProgram.title, doc.listenLog.listenDuration)
           }"
       },
       "all_by_created_at": {
           "map": "function(doc) {
               if (doc.listenLog && doc.listenLog.createdAt)
                 emit(doc.listenLog.createdAt, null); }"
       }
     }
}


