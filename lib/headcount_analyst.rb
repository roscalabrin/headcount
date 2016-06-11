require 'pry'
require_relative 'district_repository'
require_relative 'enrollment'
require_relative 'format'

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

    truncate(kindergarten_participation_rate_variation(district_1, state) / high_school_graduation_rate_variation(district_1, state))
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    district = check_for_statewide_as_argument(district)
    if district == "STATEWIDE"
      list_of_all_districts
    elsif validate_district_input(district)
    against = kindergarten_participation_against_high_school_graduation(district)
      if against >= 0.6 && against <= 1.5
        true
      else
        false
      end
    end
  end

  def list_of_all_districts
    "test"
    # statewide = district_repository.district_collection.keys #except for the word "Colorado"

  end



  # def check_if_statewide
  #
  # end
    #if district(the argument passed in above) is "STATEWIDE" then kick to another method. If more than 70% of districts across the state show a correlation, then this method will answer true. If it's less than 70% we'll answer false.

    #even before this special "STATEWIDE" method, we need a method that calculates the kindergarten_participation_against_high_school_graduation for every district, put these results into an array.

    #then we say if 70% or more of these numbers in the above array are between 0.6 and 1.5 return true, else false.


  def get_hash(dist_or_state)
   hash = district_repository.district_collection.fetch(dist_or_state).enrollment.enrollment_data[:kindergarten_participation]
   Hash[hash.sort]
#    #Hash[hash.sort]
# => {2004=>0.30201, 2005=>0.26709, 2006=>0.35364, 2007=>0.39159, 2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022}
  end


end
