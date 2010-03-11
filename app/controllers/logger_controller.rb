class LoggerController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def log
    payload = JSON.parse(request.body.read)
    @listen_logger = ListenLogger.new(payload)
    if @listen_logger
    end

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
