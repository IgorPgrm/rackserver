# frozen_string_literal: true

require_relative 'time_format'
class App

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    if path == '/time'
      time_formatter(req)
    else
      response(400, { 'Content-Type' => 'text/plain' }, 'wrong path')
    end
  end

  private

  def time_formatter(req)
    date_time = TimeFormat.new(req)
    date_time.call
    if date_time.success?
      response(200, { 'Content-Type' => 'text/plain' }, date_time.date_string)
    else
      response(400, { 'Content-Type' => 'text/plain' },
               "Parameter missing or set incorrectly \n #{date_time.invalid_string}")
    end
  end

  def response(status, header, body)
    Rack::Response.new(body, status, header).finish
  end

end
