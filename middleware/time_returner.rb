require 'byebug'
require_relative '../constants'

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
        HTTP_STATUS_CODES[:NOT_FOUND],
        HEADERS
      )
    else
      parsed_time_formats = parse_time_formats(request_format_params)

      requested_time_element_formats = []
      wrong_formats = []

      parsed_time_formats.each do |element|
        if TIME_FORMATS.key?(element)
          requested_time_element_formats << TIME_FORMATS[element]
        else
          wrong_formats << element
        end
      end

      unless wrong_formats.empty?
        rack_response(
          [unknown_time_formats(wrong_formats)],
          HTTP_STATUS_CODES[:BAD_REQUEST], 
          HEADERS
        )
      else
        rack_response(
          requested_time(requested_time_element_formats),
          HTTP_STATUS_CODES[:OK], 
          HEADERS
        )
      end      
    end
  end

  private

  def parse_time_formats(formats)
    formats.split(',')
  end

  def unknown_time_formats(wrong_formats)
    "Unknown time formats: #{wrong_formats.to_s.gsub!(/"/, '')}\n"
  end

  def requested_time(element_formats)
    Time.now.strftime(element_formats.join('-'))
  end

  def rack_response(body, status_code, headers)
    response = Rack::Response.new(body, status_code, headers)
    response.finish
  end

  def wrong_url?(path, params)
    path != TIME_URL || params.nil?
  end
end
