class TimeFormat
  attr_reader :date_string, :invalid_string

  TIME_FORMAT = { year: '%Y', month: '%m',
                  day: '%d', hour: '%H',
                  minute: '%M', second: '%S' }.freeze

  def initialize(req)
    @invalid_string = ''
    @req = req
    @params = req.params['format'].split(',')
  end

  def call
    return if @params.nil? || @params.empty?

    time_format = params_parser
    return unless success?

    @date_string = Time.now.strftime(time_format)
  end

  def params_parser
    time_format = ''
    @params.each do |p|
      TIME_FORMAT.map { |k, v| time_format += v if p.to_sym == k }
      @invalid_string += @invalid_string.empty? ? p : ", #{p}" unless TIME_FORMAT.include?(p.to_sym)
      time_format += '-' unless @params.last == p
    end
    time_format
  end

  def success?
    @invalid_string.empty?
  end

end
