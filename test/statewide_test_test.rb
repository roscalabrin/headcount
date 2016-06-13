require_relative 'test_helper'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_exists
    statewide_test = StatewideTest.new({:name => "ACADEMY 20",
                                        3 => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}, 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}},
                                        8 => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}, 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}},
                                        :asian => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}, 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}},
                                        :black => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234} , 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}}
                            })
    assert_instance_of StatewideTest, statewide_test
  end

  def test_proficient_by_grade
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })

    statewide_test = str.find_by_name('ACADEMY 20')

    result = {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
              2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
              2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
              2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
              2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
              2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
              2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
              }

    assert_equal result, statewide_test.proficient_by_grade(3)

    assert_raises("UnknownDataError") do
      statewide_test.proficient_by_grade(2)
      end
  end

  def test_proficient_by_race_or_ethnicity
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })

    statewide_test = str.find_by_name('ACADEMY 20')

    result = {2011 => {math: 0.816, reading: 0.897, writing: 0.826},
              2012 => {math: 0.818, reading: 0.893, writing: 0.808},
              2013 => {math: 0.805, reading: 0.901, writing: 0.810},
              2014 => {math: 0.800, reading: 0.855, writing: 0.789}
              }
    assert_equal result, statewide_test.proficient_by_race_or_ethnicity(:asian)

    assert_raises("UnknownRaceError") do
      statewide_test.proficient_by_race_or_ethnicity(:aldebarans)
    end
  end


  def test_proficient_for_subject_by_grade_in_year #change files
    statewide_test = StatewideTest.new({:name => "ACADEMY 20",
                            3 => {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                                  2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                                  2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                                  2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                                  2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                                  2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                                  2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}},
                            8 => {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                                  2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                                  2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                                  2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                                  2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                                  2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                                  2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}}
                                  })

    assert_equal 0.857, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)

    assert_raises("UnknownDataError") do
      statewide_test.proficient_for_subject_by_grade_in_year(:science, 2, 2008)
    end

    assert_raises("UnknownDataError") do
      statewide_test.proficient_for_subject_by_grade_in_year(:math, 1, 2008)
    end

    assert_raises("UnknownDataError") do
      statewide_test.proficient_for_subject_by_grade_in_year(:math, 1, 2005)
    end

    assert_raises("UnknownDataError") do
      statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2005)
    end
  end

  def test_proficient_for_subject_by_race_in_year # change to files
    skip
    statewide_test = StatewideTest.new({:name => "ACADEMY 20",
                                        3 => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}, 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}},
                                        8 => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}, 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}},
                                        :asian => {2011 => {math: 0.816, reading: 0.897, writing: 0.826}, 2012 => {math: 0.818, reading: 0.893, writing: 0.808}, 2013 => {math: 0.805, reading: 0.901, writing: 0.810}, 2014 => {math: 0.800, reading: 0.855, writing: 0.789}},
                                        :black => {2010 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234} , 2011 => {:math => 0.1234 , :writing => 0.1234 , :reading => 0.1234}}})
    assert_equal 0.818, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)

    assert_raises("UnknownDataError") do
      statewide_test.proficient_for_subject_by_race_in_year(:math, :cylon, 2008)
    end

  end

end
