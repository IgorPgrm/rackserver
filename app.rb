# frozen_string_literal: true

require_relative 'time_format'
class App

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    pp "path = #{path}"
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
    tf.call
    response(tf.status, tf.header, tf.body)
  end

  def response(status, header, body)
    Rack::Response.new(body, status, header).finish
  end

  def perform_request
    sleep rand(2..3)
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
    @status = 302
    @header = { 'Location' => 'http://localhost:9292' }
    @body = []
    response(@status, @header, @body)
  end

  def root
    @body = ['Time server', '<br>', '<a href="/time?format=year,month,day">Time?</a>']
    response(200, { 'Content-Type' => 'text/html' }, @body)
  end

end
