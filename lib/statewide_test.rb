require 'pry'
require_relative 'format'

class StatewideTest
  include Format

  attr_reader :statewide_test_data,
              :name

  def initialize(statewide_test_data)
    @name = statewide_test_data[:name].upcase
    @statewide_test_data = statewide_test_data #this is coming in already truncated
  end

  def proficient_by_grade(grade)
    if statewide_test_data.key?(grade) == false
      raise ArgumentError, "UnknownDataError"
    else
      statewide_test_data[grade]
    end
  end

  def proficient_by_race_or_ethnicity(race)
    if statewide_test_data.key?(race) == false
      raise ArgumentError, "UnknownRaceError"
    else
      statewide_test_data[race]
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if statewide_test_data[grade] == nil ||
      statewide_test_data[grade][year] == nil || statewide_test_data[grade][year][subject] == nil
      raise ArgumentError, "UnknownDataError"
    else
      statewide_test_data[grade][year][subject]
    end
  end

  # def kindergarten_participation_by_year
  #  participation_by_year = enrollment_data[:kindergarten_participation]
  #  participation_by_year.map do |key, value|
  #    participation_by_year[key] = truncate(value)
  #  end
  #  participation_by_year
  # end
  #

end
