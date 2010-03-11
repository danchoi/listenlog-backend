class LoggerController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def log
    payload = JSON.parse(request.body.read.to_s)
    logger.debug("\nPAYLOAD: #{payload.inspect}")
    # TODO proxy this back to the CouchDB server

    docid = if payload['stream']
              payload['stream']['displayName']
            elsif payload['episode']
              payload['episode']['title'] || payload['program']['title'] 
            end
    #DemoData.create :payload => payload
    render :text => {"docID" => docid}.to_json
  end
end
