#!usr/bin/ruby
####################################################################################
#
# This code was made for an Amazon AWS services interviews.
#
# It just checks which "combination" out of a given set of integers
# sums up to a target numbers.
#
# I though a bit about it then decided to pre-optmized w/o tail recursion
# ... and reuse, like engineers usually do, a binary sequence.
#
####################################################################################

require 'test/unit'

class TestCombinationSum < Test::Unit::TestCase
  def setup
    @combination_sum = CombinationSum.new()
  end

  def test_compute_5
    assert_equal(3,  @combination_sum.compute([5, 5, 15, 10], 15) )
  end
  
  def test_compute_1_to_4
    assert_equal(2, @combination_sum.compute([1, 2, 3, 4], 6))
  end
end

class CombinationSum
  
  def compute(sequence, target_sum)
    count = 0
    (0 .. sequence.length ** 2 - 1).each do |i|
      binary = i.to_s(2).split("").reverse
      sum = 0
      (0 .. binary.length - 1).each do |j|
        if binary[j].to_i != 0
          sum = sum + sequence[j]
        end
      end
      if sum == target_sum
        count = count + 1
      end
    end
    return count
  end

end
