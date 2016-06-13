require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'district'

class DistrictRepository

  attr_reader :district_collection,
              :enrollment_repo,
              :statewide_repo

  def initialize
    @district_collection = {}
    @enrollment_repo = EnrollmentRepository.new
    @statewide_repo = StatewideTestRepository.new
  end

  def load_data(file_tree)
    statewide_repo.load_data(file_tree)
	  enrollment_repo.load_data(file_tree).each do |hash|
	    names_array = enrollment_repo.enrollment_collection.keys
	      names_array.each do |name|
	        district = District.new({:name => name})
	        district_collection[name.upcase] = district
          district.enrollment = enrollment_repo.enrollment_collection.fetch(name)
          district.statewide_test = statewide_repo.statewide_test_collection.fetch(name)
	      end
      end
	  end

  def find_by_name(district_name)
    if district_collection[district_name.upcase].nil?
      nil
    else
      district_collection[district_name.upcase]
    end
  end

  def find_all_matching(district_name_fragment)
    district_collection.keys.select do |item|
      item.include?(district_name_fragment.upcase)
    end
  end


end
