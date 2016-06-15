require 'pry'
require_relative 'format'
require_relative 'statewide_test_repository'
require_relative 'custom_errors'

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
      raise UnknownDataError
    else
      result = statewide_test_data[grade].map do |array|
        {array[:year]=>{:math => array["math"], :reading => array["reading"], :writing => array["writing"]}}
      end
      result.reduce({}, :merge)
    end
  end

  def proficient_by_race_or_ethnicity(race)

    if valid_race_or_ethnicity?(race) == true
      query_proficient_by_race_or_ethnicity(race.to_s.downcase)
    else
      raise UnknownRaceError
    end
      # binding.pry
  end

  def query_proficient_by_race_or_ethnicity(race)
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

  def valid_subject?(subject)
    statewide_test_data.keys[3..5].include?(subject)
  end

  def valid_grade?(grade)
    statewide_test_data.keys[1..2].include?(grade)
  end

  def valid_race_or_ethnicity?(race)
    races = statewide_test_data[:math][0].keys
    races.shift
    races.include?(race.to_s.downcase)
  end

  def valid_year?(year)
    [2008, 2009, 2010, 2011, 2012, 2013, 2014].include?(year)
  end

  def error
    raise UnknownDataError
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if valid_subject?(subject) == true && valid_grade?(grade) == true && valid_year?(year) == true
      query_proficient_for_subject_by_grade_in_year(subject, grade, year)
    else
      error
    end
  end

  def query_proficient_for_subject_by_grade_in_year(subject, grade, year)
    result = statewide_test_data[grade].map do |hash|
      if hash[:year] == year
        hash[subject.to_s]
      end
    end
    result.select {|item| item != nil}.join.to_f
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if valid_subject?(subject) == true && valid_race_or_ethnicity?(race) == true && valid_year?(year) == true
      query_proficient_for_subject_by_race_in_year(subject, race, year)
    else
      error
    end
  end

  def query_proficient_for_subject_by_race_in_year(subject, race, year)
    result = statewide_test_data[subject].map do |hash|
      if hash[:year] == year
        hash[race.to_s]
      end
    end
    result.select {|item| item != nil}.join.to_f
  end
end
