module Constants
  HEADERS = { 'Content-Type' => 'text/plain' }

  HTTP_STATUS_CODES = {
    OK: 200,
    BAD_REQUEST: 400,
    NOT_FOUND: 404
  }

  TIME_URL = '/time'.freeze
  
  TIME_FORMATS = {
    'year' => '%Y', 'month' => '%m', 'day' => '%d',
    'hour' => '%H', 'minute' => '%M', 'second' => '%S'
  }.freeze
end
