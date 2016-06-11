module Format

  def truncate(number)
    (number * 1000).floor / 1000.to_f
  end

  def format_district_input(district_input)
    if district_input.class == Hash
      district_input.fetch(:against).upcase
    else district_input.to_s
      district_input.upcase
    end
  end

  def validate_district_input(district_input)
    district_repository.district_collection.include?(district_input)
  end

  

end
