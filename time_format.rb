class TimeFormat
  attr_reader :unknown_format

  def initialize(req)
    @unknown_format = ''
    @req = req
  end

  def call
    return if @req.params.empty?

    formatter(@req.params['format'])
  end

  def formatter(format)
    formatter = ''
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
                     @unknown_format += @unknown_format.empty? ? qp : ", #{qp}"
                     ''
                   end
    end
    @unknown_format = "Unknown format: #{@unknown_format}" unless @unknown_format.empty?
    return false unless @unknown_format.empty?

    Time.now.strftime(formatter)
  end

end
