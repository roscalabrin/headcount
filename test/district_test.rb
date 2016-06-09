require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_that_district_exists
    d = District.new({:name => "ACADEMY 20"})

    assert_instance_of District, d
  end

  def test_name_returns_upcase_district_name
    d = District.new({:name => "ACADEMY 20"})

    assert_equal "ACADEMY 20", d.name
  end

  def test_name_returns_upcase_district_name_even_with_lowercase_input
    d = District.new({:name => "Colorado"})

    assert_equal "COLORADO", d.name
  end

end
