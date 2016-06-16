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

  def top_statewide_test_year_over_year_growth(grade: nil, subject: nil, top: nil, weighting: nil)
    if subject.nil?
      find_growth_across_all_subjects(grade, top, weighting)
    else
      find_growth_by_subject(grade, subject, top, weighting)
    end
  end

  def find_growth_across_all_subjects(grade, top, weighting)
    math = calculate_growth(grade, 'math', top, weighting)
    reading = calculate_growth(grade, 'reading', top, weighting)
    writing = calculate_growth(grade, 'writing', top, weighting)
    weighting(math, reading, writing, grade, weighting)
  end

  def clean_numbers(average)
    average.reject do |item|
        item[1].nil? || item[1].is_a?(Fixnum)
    end
  end

  def weighting(math, reading, writing, grade, weighting)
  check_weighting(weighting)

    names = district_repository.d_group.keys
    math = names.zip(math)
    reading = names.zip(reading)
    writing = names.zip(writing)

    m = clean_numbers(math).map do |number|
      [number[0], number[1] * weighting[:math]]
      end
    r = clean_numbers(reading).map do |number|
      [number[0], number[1] * weighting[:reading]]
      end
    w = clean_numbers(writing).map do |number|
      [number[0], number[1] * weighting[:writing]]
      end
    combine_subjects(m, r, w)
  end

  def check_weighting(weighting)
    if weighting.nil?
      weighting = {:math=>0.33, :reading=>0.33, :writing=>0.33}
    else
      if weighting.values.reduce(:+) > 1
        raise InsufficientInformationError
      else
        weighting
      end
    end
  end

  def combine_subjects(m, r, w)
    add_all = m.reduce ({}) do |result, item|
      if result[item[0]].nil?
        result[item[0]] = item[1]
      else
        result[item] << item
      end
      result
    end

    w.map do |item|
      if add_all[item[0]].nil?
        add_all.store(item[0], item[1])
      else
         add_all[item[0]] = [add_all[item[0]], item[1]]
       end
     end

    r.map do |item|
       if add_all[item[0]].nil?
         add_all.store(item[0], item[1])
       else
          add_all[item[0]] = [add_all[item[0]], item[1]]
        end
      end

    averages = add_all.map do |item|
      x = item.flatten
      [x[0], x[1..-1].reduce(:+)/x.size - 1]
    end
    result_across_subjects(averages)
end

  def result_across_subjects(averages)
    names = averages.map do |item|
      item[0]
    end
    values = averages.map do |item|
      item[1]
    end
    value = values.max
    index = values.find_index(value)
    names[index]
    [names[index], truncate(value)]
  end


  def find_growth_by_subject(grade, subject, top, weighting)
    average = calculate_growth(grade, subject, top, weighting)
    find_single_leader(average, top)
  end

  def calculate_growth(grade, subject, top, weighting)
    data = district_repository.statewide_repo.st_group.values.map do |item|
        item.statewide_test_data[grade]
        end

    result = data.map do |item|
        item.map do |item|
          {item[:year] => item[subject.to_s]}
        end
    end

    cleaned = result.map do |item|
      item.reject do |item|
        item.values.join == 'N/A'
      end
    end

    average = cleaned.map do |array|
      next if array.empty?
      if array.count == 1
        0
      else
      (array[-1].values.join.to_f - array[0].values.join.to_f)/
          (array[-1].keys.join.to_i - array[0].keys.join.to_i)
      end
    end
    average
  end

  def find_single_leader(average, top)

    if top.nil?
      no_nil = eliminate_nil(average)
      value = no_nil.max
      index = average.find_index(value)
      name = district_repository.d_group.keys[index]
      [name, truncate(value)]
    else
      find_multiple_leaders(average, top)
    end
  end

  def find_multiple_leaders(average, top)
    name = district_repository.d_group.keys
    no_nil = eliminate_nil(average)
    values = no_nil.sort_by do |element|
      element * -1
    end
    result = values[0..(top - 1)].map do |item|
      [name[average.find_index(item)], truncate(item)]
    end
  end

  def eliminate_nil(average)
    average.reject do |item|
        item.nil? || item.is_a?(Fixnum)
    end
  end

end
