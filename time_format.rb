class TimeFormat

  TIME_FORMAT = { year: '%Y', month: '%m',
                  day: '%d', hour: '%H',
                  minute: '%M', second: '%S' }.freeze

  def initialize(req)
    @invalid_params = []
    @valid_params = []
    @params = req.params['format'].split(',')
    @time_format = ''
  end

  def call
    return if @params.nil? || @params.empty?

    @params.each do |param|
      TIME_FORMAT.map { |key, value| @time_format += value if param.to_sym == key }
      @invalid_params << param unless TIME_FORMAT.include?(param.to_sym)
      @time_format += '-' unless @params.last == param
    end
  end

  def success?
    @invalid_params.empty?
  end

  def invalid_string
    @invalid_params.join(', ')
  end

  def date_string
    Time.now.strftime(@time_format)
  end

end
