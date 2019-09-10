class TimeHandler
  attr_reader :unknown_formats
  TIME_FORMATS = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }

  def initialize(time_formats)
    @time_formats = time_formats.split(',')
  end

  def check_formats
    @unknown_formats = []
    @requested_formats = []
    @time_formats.each do |format|
      if TIME_FORMATS.key?(format.to_sym)
        @requested_formats << format
      else
        @unknown_formats << format
      end
    end
  end

  def format_time
    formats = @requested_formats.map { |format| TIME_FORMATS[format.to_sym] }
    Time.now.strftime(formats.join('-'))
  end
end
