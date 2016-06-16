require_relative 'custom_errors'

module Format

  def truncate(number)
    input = is_number?(number)
    if input == 'N/A'
      'N/A'
    else
      if input.to_s.length >= 5
        (input * 1000).floor / 1000.to_f
      elsif input.to_s.length < 5
        input.to_s.ljust(5, "0").to_f
      end
    end
  end

  def is_number?(number)
    if number == 'LNE' || number == 'N/A' || number == '#VALUE!' || number == ' '
      'N/A'
    else
    number = number.to_f
    end
  end

  def sort_data(input)
    input.sort_by {|item| item[:name]}
  end

  def sanitize_district_name(name)
      if name[/[a-zA-Z0-9]+/]  == name
          name
          else
          name.gsub!(/\W+/, '')
      end
  end

  def format_district_input(district_input)
    if district_input.class == Hash
      district_input.fetch(:against).upcase
    else
      district_input.to_s.upcase
    end
  end

  def validate_district_input(district_input)
    district_repository.d_group.include?(district_input)
  end

  def check_argument_format(district_input)
    if district_input.class == Hash
      if district_input.has_key?(:for)
        district_input.fetch(:for).upcase
      elsif
        district_input.has_key?(:across)
        district_input[:across]
      end
    else
      district_input.to_s.upcase
    end
  end

  def valid_year?(year)
    if year.is_a?(Fixnum) && year.inspect.size == 4
      true
    else
      raise UnknownDataError
    end
  end

end
