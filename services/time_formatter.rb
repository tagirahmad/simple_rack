class TimeFormatter
  attr_reader :wrong_formats

  TIME_FORMATS = {
    'year' => '%Y', 'month' => '%m', 'day' => '%d',
    'hour' => '%H', 'minute' => '%M', 'second' => '%S'
  }.freeze

  def initialize(time_string_params)
    @time_string_params = time_string_params
    @correct_formats = []
    @wrong_formats = []
  end

  def perform
    requested_time_formats = parse_time_formats(@time_string_params)

    requested_time_formats.each do |format|
      if TIME_FORMATS.key?(format)
        @correct_formats << TIME_FORMATS[format]
      else
        @wrong_formats << format
      end
    end

    return
  end

  def requested_time
    Time.now.strftime(correct_formats.join('-'))
  end

  def unknown_time_formats
    "Unknown time formats: #{@wrong_formats.to_s.gsub!(/"/, '')}\n"
  end

  private

  def parse_time_formats(formats)
    formats.split(',')
  end
end
