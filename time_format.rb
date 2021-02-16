class TimeFormat

  TIME_FORMAT = { year: '%Y', month: '%m',
                  day: '%d', hour: '%H',
                  minute: '%M', second: '%S' }.freeze

  def initialize(req)
    @invalid_params = []
    @valid_params = []
    @params = req.params['format'].split(',')
  end

  def call
    return if @params.nil? || @params.empty?

    @params.each do |param|
      TIME_FORMAT[param.to_sym].nil? ? @invalid_params << param : @valid_params << TIME_FORMAT[param.to_sym]
    end
  end

  def success?
    @invalid_params.empty?
  end

  def invalid_string
    @invalid_params.join(', ')
  end

  def date_string
    Time.now.strftime(@valid_params.join('-'))
  end

end
