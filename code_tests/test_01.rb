def solution(n)
  # write your code in Ruby 2.2
  n = n.to_s.split("")
  family = n.permutation.to_a
  family = family.map { |x| x.join("").to_i }
  family.max
end

puts solution(213)
puts solution(554)
