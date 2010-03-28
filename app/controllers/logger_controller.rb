class LoggerController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def log
    payload = request.body.read

    parsed_payload = JSON.parse(payload) 
    logger.debug("\nPARSED PAYLOAD: #{parsed_payload.inspect}")

    # authorization only required for new logStream or logPodcast with user UDIDs
    if (userinfo = parsed_payload['user']) && !User.authenticate(userinfo["UDID"], userinfo['userPIN']) 
      logger.debug("UNAUTHORIZED ACTION")
      render :text => {}.to_json
    else
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


end
