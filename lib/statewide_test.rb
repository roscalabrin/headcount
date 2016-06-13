require 'pry'
require_relative 'format'
require_relative 'statewide_test_repository'

class StatewideTest
  include Format

  attr_reader :statewide_test_data,
              :name

  def initialize(statewide_test_data)
    @name = statewide_test_data[:name].upcase
    @statewide_test_data = statewide_test_data
  end

  def proficient_by_grade(grade)
    if statewide_test_data.key?(grade) == false
      raise ArgumentError, "UnknownDataError"
    else
      result = statewide_test_data[grade].map do |array|
        {array[:year]=>{:math => array["math"], :reading => array["reading"], :writing => array["writing"]}}
      end
      result.reduce({}, :merge)
    end
  end

  def valid_race_or_ethnicity?(race)
    races = statewide_test_data[:math][0].keys
    races.shift
      if races.include?(race.to_s.downcase)
        proficient_by_race_or_ethnicity(race)
        # something(race.to_s.downcase)
      else
        raise ArgumentError, "UnknownRaceError"
      end
  end

  #   if statewide_test_data.key?(race) == false
  #     binding.pry
  #
  #   else
  # end

  def proficient_by_race_or_ethnicity(race)
    valid_race_or_ethnicity?(race)
  # end
  #
  # def something(race)
      math_array = statewide_test_data[:math].map do |hash|
        {hash[:year]=>hash[race.to_s.downcase]}
      end

      reading_array = statewide_test_data[:reading].map do |hash|
        {hash[:year]=>hash[race.to_s.downcase]}
      end

      writing_array = statewide_test_data[:writing].map do |hash|
        {hash[:year]=>hash[race.to_s.downcase]}
      end

      combined = [math_array, reading_array, writing_array].transpose.each do |math, reading, writing| p [math, reading, writing]
      end

      result = combined.map do |array|
        {array[0].keys.join.to_i => {math: array[0].values.join.to_f, reading: array[1].values.join.to_f, writing: array[2].values.join.to_f}}
      end
      result.reduce({}, :merge)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if statewide_test_data[grade] == nil ||
      statewide_test_data[grade][year] == nil || statewide_test_data[grade][year][subject] == nil
      raise ArgumentError, "UnknownDataError"
    else
      statewide_test_data[grade][year][subject]
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if statewide_test_data[race] == nil ||
      statewide_test_data[race][year] == nil || statewide_test_data[race][year][subject] == nil
      raise ArgumentError, "UnknownDataError"
    else
      statewide_test_data[race][year][subject]
    end
  end

end
