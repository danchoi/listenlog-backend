class LoggerController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def log
    payload = request.body.read
    logger.debug("\nPAYLOAD: #{payload.inspect}")

    @listen_logger = ListenLogger.new(payload)

    @json_response = case @listen_logger.message_type 
                     when 'extendDuration' 
                       @listen_logger.extend_duration 
                     when 'logStream', 'logPodcast' 
                       @listen_logger.create_doc
                     end

    render :text => @json_response.to_json
  end
end
