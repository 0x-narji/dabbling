def solution(e, l)
  # write your code in Ruby 2.2
  a = e.split(":").map { |x| x.to_i }
  b = l.split(":").map { |x| x.to_i }
  minutes = (b[0] * 60 + b[1]) - (a[0] * 60 + a[1])
  fee = 2             # entrance
  hours = (minutes + 59) / 60
  fee = fee + case hours
  when 0, 1
    3
  else
    3 + (hours-1) * 4
  end
  return fee
end


puts solution("10:00", "13:21")
puts solution("09:42", "11:42")
puts solution("10:00", "10:21")
puts solution("11:00", "11:00")
