require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollment_collection


  def initialize
    @enrollment_collection = {}
  end

  def load_data(file_tree)
   filepath = file_tree[:enrollment][:kindergarten]
   array = []

   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     array << ({:name => row[:location], row[:timeframe].to_i => row[:data].to_f})
   end

   parse_data(array)
  end

  def parse_data(array)
   new_array = array.group_by { |a| a.values.first }.map{|_, second_pair| second_pair.reduce(:merge)}

    array_2 = new_array.reduce({}) do |result, item|
      new_array.map do |item|
      {:name => item.values_at(:name).join, :kindergarten_participation => item}
      end
    end
    finalize_load_data(array_2)
  end

  def finalize_load_data(array_2)
    final = array_2.map do |item|
      item[:kindergarten_participation].delete(:name)
      item
    end
    final.map do |item|
      enrollment_object = Enrollment.new(item)
      enrollment_collection[item[:name]] = enrollment_object

    end
  end

  def find_by_name(district_name)
    enrollment_collection[district_name]
  end

end
