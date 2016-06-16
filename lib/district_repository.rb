require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'district'

class DistrictRepository

  attr_reader :d_group,
              :enrollment_repo,
              :statewide_repo

  def initialize
    @d_group = {}
    @enrollment_repo = EnrollmentRepository.new
    @statewide_repo = StatewideTestRepository.new
  end

  def load_data(file_tree)
    if file_tree[:statewide_testing].nil?
      load_enrollment_only(file_tree)
    else
      load_combined_data(file_tree)
    end
  end

  def load_combined_data(file_tree)
    statewide_repo.load_data(file_tree)
    enrollment_repo.load_data(file_tree).each do |hash|
      names_array = enrollment_repo.e_group.keys
        names_array.each do |name|
          district = District.new({:name => name})
          d_group[name.upcase] = district
          district.enrollment = enrollment_repo.e_group.fetch(name)
          district.statewide_test = statewide_repo.st_group.fetch(name)
        end
      end
  end

  def load_enrollment_only(file_tree)
    enrollment_repo.load_data(file_tree).each do |hash|
      names_array = enrollment_repo.e_group.keys
      names_array.each do |name|
        district = District.new({:name => name})
        d_group[name.upcase] = district
        district.enrollment = enrollment_repo.e_group.fetch(name)
      end
    end
  end

  def find_by_name(district_name)
    if d_group[district_name.upcase].nil?
      nil
    else
      d_group[district_name.upcase]
    end
  end

  def find_all_matching(district_name_fragment)
    d_group.keys.select do |item|
      item.include?(district_name_fragment.upcase)
    end
  end

end
