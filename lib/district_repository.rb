require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'district'

class DistrictRepository

  attr_reader :district_collection,
              :enrollment_repo

  def initialize
    @district_collection = {}
    # @enrollment_repo = {}
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(file_tree)
	  enrollment_repo.load_data(file_tree).each do |hash|
	    names_array = enrollment_repo.enrollment_collection.keys
	      names_array.each do |name|
	        district = District.new({:name => name})
	        district_collection[name.upcase] = district
          district.enrollment = enrollment_repo.enrollment_collection.fetch(name)
	      end
      end
	  end


  # def load_data(file_tree)
  #   enrollment_repo.load_data(file_tree)
  #
  #   filepath = file_tree[:enrollment][:kindergarten]
  #   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
  #     district_name = row[:location].upcase
  #     district_object = District.new({:name => district_name})
  #     district_collection[district_name] = district_object
  #
  #   end
  #   binding.pry
  # end

  def find_by_name(district_name)
    if district_collection[district_name.upcase].nil?
      nil
    else
      district_collection[district_name.upcase].enrollment =  enrollment_repo.enrollment_collection[district_name]

      district_collection[district_name.upcase]
    end
    # binding.pry
  end

  def find_all_matching(district_name_fragment)
    district_collection.keys.select do |item|
      item.include?(district_name_fragment.upcase)
    end
  end


end
