require_relative 'test_helper'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_exists
    statewide_test = StatewideTest.new({:name=>"ACADEMY 20",
   3=>
    [{:year=>2008, "math"=>0.857, "reading"=>0.866, "writing"=>0.671},
     {:year=>2009, "math"=>0.824, "reading"=>0.862, "writing"=>0.706},
     {:year=>2010, "math"=>0.849, "reading"=>0.864, "writing"=>0.662},
     {:year=>2011, "math"=>0.819, "reading"=>0.867, "writing"=>0.678},
     {:year=>2012, "reading"=>0.87, "math"=>0.83, "writing"=>0.655},
     {:year=>2013, "math"=>0.855, "reading"=>0.859, "writing"=>0.668},
     {:year=>2014, "math"=>0.834, "reading"=>0.831, "writing"=>0.639}],
   8=>
    [{:year=>2008, "math"=>0.64, "reading"=>0.843, "writing"=>0.734},
     {:year=>2009, "math"=>0.656, "reading"=>0.825, "writing"=>0.701},
     {:year=>2010, "math"=>0.672, "reading"=>0.863, "writing"=>0.754},
     {:year=>2011, "reading"=>0.832, "math"=>0.653, "writing"=>0.745},
     {:year=>2012, "math"=>0.681, "writing"=>0.738, "reading"=>0.833},
     {:year=>2013, "math"=>0.661, "reading"=>0.852, "writing"=>0.75},
     {:year=>2014, "math"=>0.684, "reading"=>0.827, "writing"=>0.747}],
   :math=>
    [{:year=>2011, "all students"=>0.68, "asian"=>0.816, "black"=>0.424, "hawaiian/pacific islander"=>0.568, "hispanic"=>0.568, "native american"=>0.614, "two or more"=>0.677, "white"=>0.706},
     {:year=>2012, "all students"=>0.689, "asian"=>0.818, "black"=>0.424, "hawaiian/pacific islander"=>0.571, "hispanic"=>0.572, "native american"=>0.571, "two or more"=>0.689, "white"=>0.713},
     {:year=>2013, "all students"=>0.696, "asian"=>0.805, "black"=>0.44, "hawaiian/pacific islander"=>0.683, "hispanic"=>0.588, "native american"=>0.593, "two or more"=>0.696, "white"=>0.72},
     {:year=>2014, "all students"=>0.699, "asian"=>0.8, "black"=>0.42, "hawaiian/pacific islander"=>0.681, "hispanic"=>0.604, "native american"=>0.543, "two or more"=>0.693, "white"=>0.723}],
   :reading=>
    [{:year=>2011, "all students"=>0.83, "asian"=>0.897, "black"=>0.662, "hawaiian/pacific islander"=>0.745, "hispanic"=>0.748, "native american"=>0.816, "two or more"=>0.841, "white"=>0.851},
     {:year=>2012, "all students"=>0.845, "asian"=>0.893, "black"=>0.694, "hawaiian/pacific islander"=>0.833, "hispanic"=>0.771, "native american"=>0.785, "two or more"=>0.845, "white"=>0.861},
     {:year=>2013, "all students"=>0.845, "asian"=>0.901, "black"=>0.669, "hawaiian/pacific islander"=>0.866, "hispanic"=>0.772, "native american"=>0.813, "two or more"=>0.855, "white"=>0.86},
     {:year=>2014, "all students"=>0.841, "asian"=>0.855, "black"=>0.703, "hawaiian/pacific islander"=>0.931, "hispanic"=>0.007, "native american"=>0.007, "two or more"=>0.008, "white"=>0.008}],
   :writing=>
    [{:year=>2011, "all students"=>0.719, "asian"=>0.826, "black"=>0.515, "hawaiian/pacific islander"=>0.725, "hispanic"=>0.606, "native american"=>0.6, "two or more"=>0.727, "white"=>0.74},
     {:year=>2012, "all students"=>0.705, "asian"=>0.808, "black"=>0.504, "hawaiian/pacific islander"=>0.683, "hispanic"=>0.597, "native american"=>0.589, "two or more"=>0.718, "white"=>0.726},
     {:year=>2013, "all students"=>0.72, "asian"=>0.81, "black"=>0.481, "hawaiian/pacific islander"=>0.716, "hispanic"=>0.623, "native american"=>0.61, "two or more"=>0.747, "white"=>0.74},
     {:year=>2014, "all students"=>0.715, "asian"=>0.789, "black"=>0.519, "hawaiian/pacific islander"=>0.727, "hispanic"=>0.624, "native american"=>0.62, "two or more"=>0.731, "white"=>0.734}]})

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

    assert_raises(UnknownDataError) do
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

    assert_raises(UnknownRaceError) do
      statewide_test.proficient_by_race_or_ethnicity(:aldebarans)
    end
  end

  def test_proficient_for_subject_by_grade_in_year
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

    assert_equal 0.857, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_grade_in_year(:science, 2, 2008)
    end

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_grade_in_year(:math, 1, 2008)
    end

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_grade_in_year(:math, 1, 2005)
    end

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2005)
    end
  end

  def test_proficient_for_subject_by_race_in_year
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

    statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_race_in_year(:math, :cylon, 2008)
    end
  end
#
end
