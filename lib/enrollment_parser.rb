module EnrollmentParser

  def csv_parser(filepath, key)
   enrollment_array = []
   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
     enrollment_array << ({:name => row[:location].upcase, row[:timeframe].to_i => truncate(row[:data].to_f)})
   end
   parse_data(enrollment_array, key)
  end

  def parse_data(enrollment_array, key)
   new_array = enrollment_array.group_by { |a| a.values.first }.map{|_, second_pair| second_pair.reduce(:merge)}

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
