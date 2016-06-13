require_relative 'format'

module Parser2
  include Format

  def csv_parser(filepath, key)
   statewide_test_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     statewide_test_array <<
     ({:name => row[:location].upcase, :year => row[:timeframe].to_i, row[:score].to_s.downcase => truncate(row[:data].to_f)})
   end
   parse_data(statewide_test_array, key)
  end

  def parse_data(statewide_test_array, key)
    new_array = statewide_test_array.group_by { |a| a.values.first }
    grouped_data = new_array.map do |_, second_pair|
      second_pair.group_by { |a| a[:year] }
    end

    xx = grouped_data.map do |item|
     item.map{|_, second_pair| second_pair.reduce(:merge)}
    end

    xxx = xx.map do |hash|
     hash.group_by do |key, value|
       key[:name]
     end
    end

    xxx.flatten.map do |hash|
      hash.values.flatten.map do |hash|
        hash.delete(:name)
        hash.flatten
      end

    end

    array_2 = xxx.reduce({}) do |result, item|
      xxx.map do |item|

        {:name => item.keys.join, key => item.flatten}
        # b= item
      end
    end
binding.pry
  end

  # def finalize_load_data(array_2, key)
  #   final = array_2.map do |item|
  #     item[key].delete(:name)
  #     item
  #     binding.pry
  #   end




  # def finalize_load_data(array_2, key)
  #   final = array_2.map do |item|
  #     item[key].delete(:name)
  #     item
  #   end
  #
  # end
end
