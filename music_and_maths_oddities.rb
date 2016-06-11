#!/usr/bin/ruby
################################################################################
#
# Override some Fixnum operators with funny music oriented results
#
################################################################################

require 'test/unit'


class Fixnum

  alias_method :old_add, :+

  def +(other)
    if self == 2 and other == 2 then
      # At least RadioHead's from UK said so ...
      5
    else
      self.old_add(other)
    end
  end

  alias_method :old_mul, :*

  def *(other)
    if self == 4 and other == 4 then
      # ... by far less known in European countries, but according to Deadmau5 ... :-D
      12
    else
      self.old_mul(other)
    end
  end

  # what else?
  # ;-)

end

class TestFixnum < Test::Unit::TestCase

  def test_compute_2_plus_2
    assert_equal(5, 2 + 2)
  end

  def test_compute_2_plus_1
    assert_equal(3, 2 + 1)
  end

  def test_compute_4_times_4
    assert_equal(12, 4 * 4)
  end

  def test_compute_4_times_3
    assert_equal(12, 4 * 3)
  end

end
