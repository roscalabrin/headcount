require 'pry'
require_relative 'district_repository'
require_relative 'enrollment'
require_relative 'format'
require_relative 'custom_errors'

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
    participation_rates = district_repository.district_collection.fetch(dist_or_state).enrollment.enrollment_data[key].values
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
   district_repository.district_collection.keys.delete("COLORADO")
   correlation_array = district_repository.district_collection.keys.map do |district|
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
   hash = district_repository.district_collection.fetch(dist_or_state).enrollment.enrollment_data[:kindergarten_participation]
   Hash[hash]
  end


end
