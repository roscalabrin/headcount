require 'pry'
require 'csv'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  include Format
  include Parser

  attr_reader :enrollment_collection

  def initialize
    @enrollment_collection = {}
  end

  def load_data(file_tree)
   filepath = file_tree[:enrollment][:kindergarten]
     if file_tree[:enrollment][:high_school_graduation].nil?
       kindergarten_array = csv_parser(filepath, :kindergarten_participation)
       create_enrollment_object(kindergarten_array)
     else
       filepath_2 = file_tree[:enrollment][:high_school_graduation]
       kindergarten_array = csv_parser(filepath, :kindergarten_participation)
       high_school_array = csv_parser(filepath_2, :high_school_graduation_rates)
       merge_data(kindergarten_array, high_school_array)
     end
#find a way to dynamically pass in the key (i.e. :kindergarten, or high_school_graduation, or whatever)
#maybe make a method that just extracts the filepath dynamically (def extract filepath, takes in the actual key as an arg)
  end

  def merge_data(kindergarten_array, high_school_array)
    enrollment_info = kindergarten_array.zip(high_school_array).map do |kindergarten_array|
      kindergarten_array.reduce(&:merge)
    end
    create_enrollment_object(enrollment_info)
  end

  def create_enrollment_object(enrollment_info)
    enrollment_info.map do |item|
      enrollment_object = Enrollment.new(item)
      enrollment_collection[item[:name]] = enrollment_object

    end
  end

  def find_by_name(district_name)# fix this method
    enrollment_collection[district_name]
  end

end
