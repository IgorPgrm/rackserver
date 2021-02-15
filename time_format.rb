class TimeFormat
  attr_reader :unknown_format

  TIME_FORMAT = { year: '%Y', month: '%m',
                  day: '%d', hour: '%H',
                  minute: '%M', second: '%S' }.freeze

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
      unless TIME_FORMAT.keys.include?(qp.to_sym)
        @unknown_format += @unknown_format.empty? ? qp : ", #{qp}"
      end
      TIME_FORMAT.map { |k, v| formatter += v if qp.to_sym == k }
      formatter += '-' unless query_params.last == qp
    end

    @unknown_format = "Unknown format: #{@unknown_format}" unless @unknown_format.empty?
    pp "UNKN FORMAT found #{@unknown_format}"
    return false unless @unknown_format.empty?

    Time.now.strftime(formatter)
  end

end
