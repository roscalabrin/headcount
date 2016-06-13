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

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if statewide_test_data[race] == nil ||
      statewide_test_data[race][year] == nil || statewide_test_data[race][year][subject] == nil
      raise ArgumentError, "UnknownDataError"
    else
      statewide_test_data[race][year][subject]
    end
  end

end
