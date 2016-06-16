require 'pry'
require_relative 'district_repository'
require_relative 'enrollment'
require_relative 'format'
require_relative 'custom_errors'
require_relative 'statewide_test_repository'

class HeadcountAnalyst
  include Format

  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(district_1, state_or_district_2)
    district_1 = format_district_input(district_1)
    state_or_district_2 = format_district_input(state_or_district_2)

    if validate_district_input(district_1) && validate_district_input(state_or_district_2)
      key = :kindergarten_participation
      district_1_average = average(district_1, key)
      state_or_district_2_average = average(state_or_district_2, key)
      truncate(district_1_average/state_or_district_2_average)
    end
  end

  def high_school_graduation_rate_variation(district_1, state)
    district_1 = format_district_input(district_1)
    state =  format_district_input(state)

    if validate_district_input(district_1) && validate_district_input(state)
    key = :high_school_graduation_rates
    district_1_average = average(district_1, key)
    state_average = average(state, key)
    truncate(district_1_average/state_average)
    end
  end

  def average(dist_or_state, key)
    participation_rates = district_repository.d_group.fetch(dist_or_state).enrollment.enrollment_data[key].values
    participation_rates.reduce(:+) / participation_rates.length
  end

  def kindergarten_participation_rate_variation_trend(district_1, state)
    district = get_hash(district_1.upcase)
    state    = get_hash(state.fetch(:against).upcase)

    if district.keys == state.keys
      district.merge(state) { |key, district_value, state_value| truncate(district_value/state_value) }
    end
  end

  def kindergarten_participation_against_high_school_graduation(district_1, state = {:against => 'COLORADO'})
    district_1 = format_district_input(district_1)
    state = format_district_input(state)

    if validate_district_input(district_1) && validate_district_input(state)

      result =
      truncate(kindergarten_participation_rate_variation(district_1, state)) / truncate(high_school_graduation_rate_variation(district_1, state))
      if result.nan?
        0
      else
        truncate(result)
      end
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    district = check_argument_format(district)
    if district.is_a?Array
      districts_correlate_among_themselves?(district)
    elsif district == "STATEWIDE"
      districts_correlate_across_state?
    elsif validate_district_input(district)
      against = kindergarten_participation_against_high_school_graduation(district)
      if against >= 0.6 && against <= 1.5
        true
      else
        false
      end
    end
end

  def correlation_of_all_districts
   district_repository.d_group.keys.delete("COLORADO")
   correlation_array = district_repository.d_group.keys.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(district)
    end
    correlation_number = correlation_array.select do |item|
      item == true
    end.length
    truncate(correlation_number/correlation_array.length.to_f)
  end

  def correlation_across_subset_of_districts(district_array)
    result = district_array.map do |district|
       kindergarten_participation_correlates_with_high_school_graduation(district)
     end
     correlation_number = result.select do |item|
       item == true
     end.length

     truncate(correlation_number/district_array.length.to_f)
  end

  def districts_correlate_across_state?
    if correlation_of_all_districts >= 0.7
        true
      else
        false
      end
  end

  def districts_correlate_among_themselves?(district_array)
    if correlation_across_subset_of_districts(district_array) >= 0.7
        true
      else
        false
      end
  end

  def get_hash(dist_or_state)
   hash = district_repository.d_group.fetch(dist_or_state).enrollment.enrollment_data[:kindergarten_participation]
   Hash[hash]
  end
  ##################################################SONIAS WORK BEGINS NOW

  def top_statewide_test_year_over_year_growth(grade: nil, subject: nil, top: nil, weighting: nil)
    # binding.pry
    data = district_repository.d_group["COLORADO"].statewide_test.statewide_test_data
    if grade.nil?
      raise InsufficientInformationError
    elsif grade.nil? == false
      if data.has_key?(grade) == false
        raise UnknownDataError, "#{grade} is not a known grade"
      elsif
        data.has_key?(grade) == true
          if subject.nil? == false && top.nil? && weighting.nil?
            find_single_leader(grade, subject)
          elsif subject.nil? == false && top.nil? == false && weighting.nil?
            find_multiple_leader(grade, subject, top)
          elsif subject.nil? && top.nil? && weighting.nil?
            find_growth_across_all_subjects(grade)
          elsif subject.nil? && top.nil? && weighting.nil? == false
            find_growth_across_all_subjects_with_weighting(grade, weighting)
          end
      end
    end
  end

  def sort_grade_by_district(grade)
    data = district_repository.d_group.values
    statewide_test_objects = data.map do |element|
      element.statewide_test
    end
    statewide_test_data_objects = statewide_test_objects.map do |element|
      element.statewide_test_data
    end
    grade_by_district = []
    statewide_test_data_objects.map do |element|
      grade_by_district << element.fetch(grade)
    end
    grade_by_district = grade_by_district.map do |element|
      element.sort_by do |hash|
        hash[:year]
      end
    end
    #data
    sorted = grade_by_district.map do |array|
      array.flat_map(&:entries).group_by(&:first).map{|k,v| Hash[k, v.map(&:last)]}
    end
  end

  def find_single_leader(grade, subject)
    sorted = sort_grade_by_district(grade)
    subject_values = sorted.map do |element|
      element.find do |x|
        x[subject.to_s]
      end
    end
    subject_values_difference = subject_values.map do |hash|
      (hash.values.flatten.last - hash.values.flatten.first)
    end
    year_over_year = subject_values_difference.map do |difference|
      truncate(difference / ((subject_values[0][subject.to_s].length) - 1))
    end
    combined = district_repository.d_group.keys.zip(year_over_year)
    single_leader = combined.max_by do |element|
      element[1]
    end
    single_leader
  end

  def find_multiple_leader(grade, subject, top)
    sorted = sort_grade_by_district(grade)
    subject_values = sorted.map do |element|
      element.find do |x|
        x[subject.to_s]
      end
    end
    subject_values_difference = subject_values.map do |hash|
      (hash.values.flatten.last - hash.values.flatten.first)
    end
    year_over_year = subject_values_difference.map do |difference|
      truncate(difference / ((subject_values[0][subject.to_s].length) - 1))
    end
    combined = district_repository.d_group.keys.zip(year_over_year)
    multiple_leader = combined.sort_by do |element|
      element[1]*-1 #takes care of negatives
    end
    multiple_leader[0..(top - 1)]
  end

  def math_values_difference(sorted)
    math_values = sorted.map do |element|
      element.find do |x|
          x["math"]
      end
    end
    math_values_difference = math_values.map do |hash|
      (hash.values.flatten.last - hash.values.flatten.first)
    end
  end

  def reading_values_difference(sorted)
    reading_values = sorted.map do |element|
      element.find do |x|
              x["reading"]
      end
    end
    reading_values_difference = reading_values.map do |hash|
      (hash.values.flatten.last - hash.values.flatten.first)
    end
  end

  def writing_values_difference(sorted)
    writing_values = sorted.map do |element|
      element.find do |x|
              x["writing"]
      end
    end
    writing_values_difference = writing_values.map do |hash|
      (hash.values.flatten.last - hash.values.flatten.first)
    end
  end

  def find_growth_across_all_subjects(grade)
    sorted = sort_grade_by_district(grade)
    math = math_values_difference(sorted)
    reading = reading_values_difference(sorted)
    writing = writing_values_difference(sorted)
    writing_and_math = writing.zip(math).map{|x, y| x + y}
    all = writing_and_math.zip(reading).map{|x, y| x + y}
    averages = all.map do |number|
      number/3
    end
    combined = district_repository.d_group.keys.zip(averages)
    across_all= combined.max_by do |element|
      element[1]
    end
    across_all
  end

  def find_growth_across_all_subjects_with_weighting(grade, weighting)
    sorted = sort_grade_by_district(grade)
    if weighting.values.reduce(:+) > 1
      raise InsufficientInformationError
    else
      math = math_values_difference(sorted).map do |number|
        number * weighting[:math]
      end
      reading = reading_values_difference(sorted).map do |number|
        number * weighting[:reading]
      end
      writing = writing_values_difference(sorted).map do |number|
        number * weighting[:writing]
      end
    end
    writing_and_math = writing.zip(math).map{|x, y| x + y}
    all = writing_and_math.zip(reading).map{|x, y| x + y}
    averages = all.map do |number|
      number/3
    end
    combined = district_repository.d_group.keys.zip(averages)
    across_all= combined.max_by do |element|
      element[1]
    end
    across_all
  end

end
