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


  # def check_input(grade, subject, top, weighting)
  #   data = district_repository.d_group["COLORADO"].statewide_test.statewide_test_data
  #   if grade.nil?
  #     raise InsufficientInformationError
  #   elsif grade.nil? == false
  #     if data.has_key?(grade) == false
  #       raise UnknownDataError, "#{grade} is not a known grade"
  #     elsif
  #       data.has_key?(grade) == true
  #         if subject.nil? == false && top.nil? && weighting.nil?
  #           find_single_leader(grade, subject)
  #         elsif subject.nil? == false && top.nil? == false && weighting.nil?
  #           find_multiple_leader(grade, subject, top)
  #         elsif subject.nil? && top.nil? && weighting.nil?
  #           find_growth_across_all_subjects(grade)
  #         elsif subject.nil? && top.nil? && weighting.nil? == false
  #           find_growth_across_all_subjects_with_weighting(grade, weighting)
  #         end
  #       end
  #     end
  #   end
  #
  #   def find_single_leader(grade, subject)
  #     sorted = sort_grade_by_district(grade)
  #     subject_values = sorted.map do |element|
  #       element.find do |x|
  #         x[subject.to_s]
  #       end
  #     end
  #   end

end
