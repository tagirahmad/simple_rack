require 'byebug'
require_relative '../constants'
require_relative '../services/time_formatter'

class TimeReturner
  include Constants

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    request_format_params = request.params['format']
    
    if wrong_url?(request.path, request_format_params)
      rack_response(
        "#{HTTP_STATUS_CODES.key(404).to_s}\n",
        HTTP_STATUS_CODES[:NOT_FOUND]
      )
    else
      tf = TimeFormatter.new(request_format_params)
      tf.perform

      unless tf.wrong_formats.empty?
        rack_response(tf.unknown_time_formats, HTTP_STATUS_CODES[:BAD_REQUEST])
      else
        rack_response(tf.requested_time, HTTP_STATUS_CODES[:OK])
      end      
    end
  end

  private
  
  def rack_response(body, status_code)
    response = Rack::Response.new(body, status_code, HEADERS)
    response.finish
  end

  def wrong_url?(path, params)
    path != TIME_URL || params.nil?
  end
end
