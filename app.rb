# frozen_string_literal: true

require_relative 'time_format'
class App

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    case path
    when '/'
      root
    when '/time'
      time_formatter(req)
    else
      redirect_to_root
    end
  end

  private

  def time_formatter(req)
    tf = TimeFormat.new(req)
    result = tf.call
    if result
      success_response(result)
    else
      error_response("Parameter missing or set incorrectly \n #{tf.unknown_format}")
    end
  end

  def success_response(body)
    response(200, headers, [body])
  end

  def error_response(body)
    response(400, headers, [body])
  end

  def response(status, header, body)
    Rack::Response.new(body, status, header).finish
  end

  def status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    ["Welcome aboard!\n"]
  end

  def redirect_to_root
    response(302, { 'Location' => 'http://localhost:9292' }, [])
  end

  def root
    response(200, { 'Content-Type' => 'text/html' }, ['Time server', '<br>',
                                                      '<a href="/time?format=year,month,day">Time?</a>'])
  end

end
