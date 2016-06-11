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
    key = :kindergarten_participation
    district_1_average = average(district_1.upcase, key)
    state_or_district_2_average = average(state_or_district_2.fetch(:against).upcase, key)

    truncate(district_1_average/state_or_district_2_average)
  end

  def high_school_graduation_rate_variation(district_1, state)
    key = :high_school_graduation_rates
    district_1_average = average(district_1.upcase, key)
    state_average = average(state.fetch(:against).upcase, key)

    truncate(district_1_average/state_average)
  end

  def average(dist_or_state, key)
    participation_rates = district_repository.district_collection.fetch(dist_or_state).enrollment.enrollment_data[key].values #an array
  # binding.pry
    participation_rates.reduce(:+) / participation_rates.length
  end

  def kindergarten_participation_rate_variation_trend(district_1, state)
    district = get_hash(district_1.upcase)
    state    = get_hash(state.fetch(:against).upcase)

    if district.keys == state.keys
      district.merge(state) { |key, district_value, state_value| truncate(district_value/state_value) }
    else
      nil
    end
    # binding.pry
  end

  def kindergarten_participation_against_high_school_graduation(district_1, state = {:against => 'COLORADO'})

    truncate(kindergarten_participation_rate_variation(district_1, state) / high_school_graduation_rate_variation(district_1, state))
  end

  def get_hash(dist_or_state)
   hash = district_repository.district_collection.fetch(dist_or_state).enrollment.enrollment_data[:kindergarten_participation]
   Hash[hash.sort]
#    #Hash[hash.sort]
# => {2004=>0.30201, 2005=>0.26709, 2006=>0.35364, 2007=>0.39159, 2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022}
  end

end
