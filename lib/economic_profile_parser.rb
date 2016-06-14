require_relative 'format'

module EconomicProfileParser
  include Format

  def csv_parser_household(filepath, key)
   household_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     household_array <<
     ({:name => row[:location].upcase, row[:timeframe].split("-") => row[:data].to_i})
   end
   parse_data(household_array, key)
  end

  def csv_parser_children(filepath, key)
   children_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     if row[:dataformat] == "Percent"
       children_array <<
       ({:name => row[:location].upcase, row[:timeframe].to_s => truncate(row[:data].to_f)})
     end
   end
   parse_data(children_array, key)
  end

  def csv_parser_lunch(filepath, key)
   lunch_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     if row[:poverty_level] == "Eligible for Free or Reduced Lunch"
       if row[:dataformat] == "Percent"
          x = {:percentage => truncate(row[:data].to_f)}
        else
          x = {:number => truncate(row[:data].to_f)}
        end
       lunch_array <<
       ({:name => row[:location].upcase, :year => row[:timeframe].to_i, :poverty_level => x})
     end
    end
    lunch_array
    # binding.pry
  end

   def csv_parser_title_i(filepath, key)
    title_i_array = []
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      title_i_array <<
       ({:name => row[:location].upcase, row[:timeframe].to_i => truncate(row[:data].to_f)})
    end
   parse_data(title_i_array, key)
  end

  def combine_imported_data_from_files
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

#########################
  def parse_data(array, key)
   new_array = array.group_by { |a| a.values.first }.map{|_, second_pair| second_pair.reduce(:merge)}

    array_2 = new_array.reduce({}) do |result, item|
      new_array.map do |item|
      {:name => item.values_at(:name).join, key => item}
      end
    end
    finalize_load_data(array_2, key)
  end

  def finalize_load_data(array_2, key)
    final = array_2.map do |item|
      item[key].delete(:name)
      item
    end
  end


end
