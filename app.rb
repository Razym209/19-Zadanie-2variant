require_relative 'time_handler'

class App

  def call(env)
    @req = Rack::Request.new(env)
    manage_request
    [status, headers, body]
  end

  private

  def manage_request
    return wrong_path_error unless correct_path? && correct_params?
    @time_handler = TimeHandler.new(@req.params['format'])
    @time_handler.check_formats
    return unknown_format_error if @time_handler.unknown_formats.count > 0
    make_formatted_time
  end

  def status
    @http_code
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    ["#{@message}\n"]
  end

  def make_formatted_time
    @message = @time_handler.format_time
    @http_code = 200
  end

  def correct_path?
    @req.path_info.include?("time")
  end

  def correct_params?
    !@req.params['format'].nil?
  end

  def wrong_path_error
    @message = "Wrong path, should be domain/time?format=params"
    @http_code = 404
  end

  def unknown_format_error
    @message = "Unknown time format [#{@time_handler.unknown_formats.join(', ')}]"
    @http_code = 400
  end
end
