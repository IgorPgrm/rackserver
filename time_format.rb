class TimeFormat
  attr_reader :date_string, :invalid_string

  TIME_FORMAT = { year: '%Y', month: '%m',
                  day: '%d', hour: '%H',
                  minute: '%M', second: '%S' }.freeze

  def initialize(req)
    @invalid_string = ''
    @success = false
    @req = req
    @params = req.params['format'].split(',')
  end

  def call
    time_format = ''
    return if @params.nil? || @params.empty?
    return if unknown_format_present?

    @params.each do |p|
      TIME_FORMAT.map { |k, v| time_format += v if p.to_sym == k }
      time_format += '-' unless @params.last == p
    end
    @date_string = Time.now.strftime(time_format)
    @success = true
  end

  def unknown_format_present?
    @params&.each do |p|
      unless TIME_FORMAT.keys.include?(p.to_sym)
        @invalid_string += @invalid_string.empty? ? p : ", #{p}"
      end
    end
    !@invalid_string.empty?
  end

  def success?
    @success
  end

end
