require_relative 'format'

class Enrollment
  include Format

  attr_reader :enrollment_data,
              :name

  def initialize(enrollment_data)
    @name = enrollment_data[:name].upcase
    @enrollment_data = enrollment_data
  end

  def kindergarten_participation_by_year
   participation_by_year = enrollment_data[:kindergarten_participation]
   participation_by_year.map do |key, value|
     participation_by_year[key] = truncate(value)
   end
   participation_by_year
  end

  def kindergarten_participation_in_year(year)
    if kindergarten_participation_by_year.key?(year) == false
      nil
    else
      kindergarten_participation_by_year.fetch(year)
    end
  end

  def graduation_rate_by_year
    graduation_rate_by_year = enrollment_data[:highschool_grad_rate]
    graduation_rate_by_year.map do |key, value|
      graduation_rate_by_year[key] = truncate(value)
    end
    graduation_rate_by_year
  end

  def graduation_rate_in_year(year)
    if graduation_rate_by_year.key?(year) == false
      nil
    else
      graduation_rate_by_year.fetch(year)
    end
  end

end
