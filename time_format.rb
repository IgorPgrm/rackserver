class TimeFormat
  attr_accessor :status, :body, :header

  def initialize(req)
    @req = req
  end

  def call
    server_time
  end

  def server_time
    @body = [Time.now.to_s]
    @status = 200
    @header = { 'Content-Type' => 'text/html' }
    return if @req.params.empty?

    formatter(@req.params['format'])
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
    [@status, @header, @body]
  end

  def unknown_format(unknown)
    @status = 400
    @body = [unknown]
  end
end
