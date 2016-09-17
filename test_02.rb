def solution(s)
  # write your code in Ruby 2.2
  digits = s.split("").select { |c| c =~ /[[:digit:]]/}
  number = []

  while digits and digits.size > 0
    case digits.size
    when 2, 4
      number.push digits[0 .. 1].join("")
      digits.shift
      digits.shift
    when 1
      number.push digits[0 .. 1].join("")
      digits.shift
    else
      number.push digits[0 .. 2].join("")
      digits.shift
      digits.shift
      digits.shift
    end
  end
  number = number.join("-")
end

puts solution("00-44  48 5555 8361")
puts solution("0 - 22 1985--324")
puts solution("555372654")
