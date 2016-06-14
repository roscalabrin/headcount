require_relative 'format'

module EconomicProfileParser
  include Format

  def csv_parser_household(filepath)
   household_economic_profile_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     household_economic_profile_array <<
     ({:name => row[:location].upcase, row[:timeframe].split("-") => truncate(row[:data].to_f)})
   end
  #  group_data(statewide_test_array, key)
  end

  def csv_parser_children(filepath)
   children_economic_profile_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     children_economic_profile_array <<
     ({:name => row[:location].upcase, row[:timeframe].to_s => truncate(row[:data].to_f)})
   end
  #  group_data(statewide_test_array, key)
  end

  def csv_parser_lunch(filepath, argument)
   lunch_economic_profile_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     lunch_economic_profile_array <<
     ({:name => row[:location].upcase, :year => row[:timeframe].to_i,  row[argument].to_s.downcase => truncate(row[:data].to_f)})
   end
  #  group_data(statewide_test_array, key)
  end

  def group_data(statewide_test_array, key)
    grouped_data = statewide_test_array.group_by { |a| a.values.first }
    grouped_data_years = grouped_data.map do |_, second_pair|
      second_pair.group_by { |a| a[:year] }
    end

    grouped_array = grouped_data_years.map do |item|
     item.map{|_, second_pair| second_pair.reduce(:merge)}.flatten
   end
    array_by_district = grouped_array.map do |hash|
     hash.group_by do |key, value|
       key[:name]
     end
    end
    clean_data(array_by_district, key)
  end

  def clean_data(array_by_district, key)
    array_by_district.flatten.map do |hash|
      hash.values.flatten.map do |hash|
        hash.delete(:name)
        hash.flatten
      end
    end
    create_hash_with_data(array_by_district, key)
  end

  def create_hash_with_data(array_by_district, key)
    statewide_parsed_array = array_by_district.reduce({}) do |result, item|
      array_by_district.map do |item|
        item.values.flatten
        {:name => item.keys.join, key => item.values.flatten}
      end
    end
# binding.pry
  end

end
