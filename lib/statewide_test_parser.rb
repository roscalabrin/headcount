require_relative 'format'

module StatewideTestParser
  include Format

  def csv_parser(filepath, argument, key)
   statewide_test_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     statewide_test_array <<
     ({:name => row[:location].upcase, :year => row[:timeframe].to_i, row[argument].to_s.downcase => truncate(row[:data])})
   end
   group_data(statewide_test_array, key)
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
  end

end
