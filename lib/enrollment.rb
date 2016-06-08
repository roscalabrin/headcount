class Enrollment
  attr_reader :enrollment_data,
              :name

  def initialize(enrollment_data = {})
    @enrollment_data = enrollment_data
  end

  def name
    enrollment_data[:name].upcase
  end

  def kindergarten_participation_by_year
   participation_by_year = enrollment_data[:kindergarten_participation]
   participation_by_year.map do |key, value|
     participation_by_year[key] = truncate(value)
   end
   participation_by_year
  end

  def truncate(number)
    (number * 1000).floor / 1000.to_f
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year.fetch(year)
  end

end
