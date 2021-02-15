# frozen_string_literal: true

require_relative 'time_format'
class App

  def call(env)
    request = Rack::Request.new(env)
    path = request.path

    if path == '/time'
      get_time(request)
    else
      response(400, { 'Content-Type' => 'text/plain' }, 'wrong path')
    end
  end

  private

  def get_time(req)
    date_time = TimeFormat.new(req)
    date_time.call
    if date_time.success?
      response(200, header, date_time.date_string)
    else
      response(400, header,
               "Parameter missing or set incorrectly \n #{date_time.invalid_string}")
    end
  end

  def response(status, header, body)
    Rack::Response.new(body, status, header).finish
  end

  def header
    { 'Content-Type' => 'text/plain' }
  end

end
