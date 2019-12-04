def valid?(password, &block)
  prev = 0
  doubles = ['0']
  password.chars.each do |digit|
    this = digit.to_i
    return false unless this >= prev
    if this == prev
      doubles[-1] += digit
    else
      doubles.push(digit)
    end
    prev = this
  end

  doubles.any? &block
end

first = (240920..789857).sum do |i|
  valid?(i.to_s) {|double| double.size >= 2} ? 1 : 0
end
second = (240920..789857).sum do |i|
  valid?(i.to_s) {|double| double.size == 2} ? 1 : 0
end

print "First problem: #{first}\n"
print "\nSecond problem: #{second}\n"
