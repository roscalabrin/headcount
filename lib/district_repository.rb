
require 'csv'
require_relative 'enrollment_repository'

class DistrictRepository
  attr_reader :district_collection,
              :enrollment_repo

  def initialize
    @district_collection = {}
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      district_name = row[:location].upcase#row[:location] is a string
      district_object = District.new({:name => district_name})
      district_collection[district_name] = district_object
      #refactor for above code:
      # name = row[:location]
      # district_collection[name] = District.new({:name => name}
    end
  end

  def find_by_name(district_name)
    district_collection[district_name.upcase]
  end

  def find_all_matching(district_name_fragment)
    district_collection.keys.select do |item|
      item.include?(district_name_fragment.upcase)
    end
  end


end
