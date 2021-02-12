# frozen_string_literal: true
class App
  attr_accessor :status, :body, :header

  def call(env)
    request_parser(env)
    [@status, @header, @body]
  end

  private

  def request_parser(env)
    req = Rack::Request.new(env)
    path = req.path

    case path
    when '/'
      root
    when '/time'
      server_time(req)
    else
      redirect_to_root
    end
  end

  def server_time(req)
    @body = [Time.now.to_s]
    @status = 200
    @header = headers
    return if req.params.empty?

    formatter(req.params['format'])
  end

  def redirect_to_root
    @status = 302
    @header = { 'Location' => 'http://localhost:9292' }
    @body = []
  end

  def formatter(format)
    formatter = ''
    unknown_formats = ''
    return if format.nil? || format.empty?

    query_params = format.split(',')
    query_params.each do |qp|
      formatter += case qp
                   when 'year'
                     ' %Y '
                   when 'month'
                     ' %m '
                   when 'day'
                     ' %d '
                   when 'hour'
                     ' %H '
                   when 'minute'
                     ' %m '
                   when 'seconds'
                     ' %S '
                   else
                     unknown_formats += unknown_formats.empty? ? qp : ", #{qp}"
                     ''
                  end
    end
    unknown_formats = "Unknown format: #{unknown_formats}" unless unknown_formats.empty?
    return unknown_format(unknown_formats) unless unknown_formats.empty?

    @body = [Time.now.strftime(formatter)]
  end

  def unknown_format(unknown)
    @status = 400
    @body = [unknown]
  end

  def perform_request
    sleep rand(2..3)
  end

  def root
    @status = 200
    @header = { 'Content-Type' => 'text/html' }
    @body = ['Time server', '<br>', '<a href="/time?format=year,month,day">Time?</a>']
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
end
