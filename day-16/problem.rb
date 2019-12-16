INPUT = "59717238168580010599012527510943149347930742822899638247083005855483867484356055489419913512721095561655265107745972739464268846374728393507509840854109803718802780543298141398644955506149914796775885246602123746866223528356493012136152974218720542297275145465188153752865061822191530129420866198952553101979463026278788735726652297857883278524565751999458902550203666358043355816162788135488915722989560163456057551268306318085020948544474108340969874943659788076333934419729831896081431886621996610143785624166789772013707177940150230042563041915624525900826097730790562543352690091653041839771125119162154625459654861922989186784414455453132011498"

def pattern(i)
  ([0]*i + [1]*i + [0]*i + [-1]*i).cycle
end

def phase(input)
  chars = "0#{input}".chars.map(&:to_i)
  (0...input.size).map do |i|
    chars.zip(pattern(i+1)).sum { |c, p| c * p }.to_s[-1]
  end.join
end

input = INPUT;
100.times do
  input = phase(input)
end

print "First problem: #{input[0..7]}\n"

# For the second problem, the offset is very big, so the pattern for each digit is [0]*(offset-1) + [1]*(offset+y)
# This means for the first digit you only need to sum numbers after the offset and keep the last number,
# and for the following digits you need to substract the previous number and keep the last number again.

input = INPUT.chars.map(&:to_i)
offset = INPUT[0..6].to_i
ending = (input*10_000)[offset..-1]

100.times do
  total = ending.sum
  ending = ending.map do |n|
    ret = total
    total -= n
    ret % 10
  end
end

print "First problem: #{ending[0..7].map(&:to_s).join}\n"
