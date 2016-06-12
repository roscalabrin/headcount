module Format

  def truncate(number)
    if is_number?(number)
      (number * 1000).floor / 1000.to_f
    else
      truncate(number.to_f)
    end
  end

  def is_number?(string)
    true if Float(string) rescue false
  end

  def format_district_input(district_input)
    if district_input.class == Hash
      district_input.fetch(:against).upcase
    else
      district_input.to_s.upcase
    end
  end

  def validate_district_input(district_input)
    district_repository.district_collection.include?(district_input)
  end

  def check_argument_format(district_input)
    if district_input.class == Hash
      if district_input.has_key?(:for)
        district_input.fetch(:for).upcase
      elsif
        district_input.has_key?(:across)
        districts_correlate_among_themselves?(district_input)
      end
    else
      district_input.to_s.upcase
    end
  end

end
