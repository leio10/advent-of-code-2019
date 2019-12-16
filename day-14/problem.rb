INPUT = ['1 HKCVW, 2 DFCT => 5 ZJZRN', '8 TCPN, 7 XHTJF, 3 DFCT => 8 ZKCXK', '1 ZJZRN, 4 NZVL, 1 NJFXK, 7 RHJCQ, 32 MCQS, 1 XFNPT => 5 ZWQX', '10 DRWB, 16 JBHKV => 6 TCPN', '3 MBFK => 7 DRWB', '9 RHJCQ => 6 MBMKZ', '1 BVFPF => 2 KRTGD', '1 QNXC, 7 BKNQT, 1 XFNPT => 4 VNFJQ', '2 TCPN, 1 WFSV => 2 TGJP', '35 DFCT => 2 RHJCQ', '1 SKBV, 7 CTRH => 8 QGDSV', '8 VSRMJ, 1 BVFPF => 4 CTRH', '1 WMCD => 3 FPZLF', '13 CVJQG, 8 DXBZJ => 9 QBDQ', '1 XSRWM => 5 GDJGV', '132 ORE => 3 MBFK', '2 BQGP => 9 LZKJZ', '5 GZLHP => 7 WFSV', '2 RXSZS, 10 MBFK, 1 BPNVK => 2 GZLHP', '13 BZFH => 8 XSRWM', '3 QLSVN => 3 SKBV', '8 QBDQ => 4 VSRMJ', '1 RXSZS => 9 CVJQG', '3 MBFK => 3 BVFPF', '7 GZLHP, 4 MBFK, 5 CVJQG => 8 XHTJF', '1 GZLHP => 2 DFCT', '4 SZDWB, 4 RHJCQ, 1 WMCD => 3 RGZDK', '2 BRXLV => 8 DXBZJ', '192 ORE => 7 RXSZS', '1 PRMR, 6 DFCT => 5 SZDWB', '104 ORE => 9 BPNVK', '6 VLJWQ, 8 ZKCXK, 6 BKNQT, 26 JRXQ, 7 FPZLF, 6 HKCVW, 18 KRTGD => 4 RBFX', '7 XFNPT, 1 GDJGV => 2 HJDB', '15 SKBV, 8 DRWB, 12 RXSZS => 3 GHQPH', '1 BZFH => 5 GCBR', '1 TGJP, 6 SKBV => 1 BZFH', '4 KRTGD, 1 ZJHKP, 1 LZKJZ, 1 VNFJQ, 6 QBDQ, 1 PRMR, 1 NJFXK, 1 HJDB => 8 TFQH', '10 BVFPF, 1 RGZDK => 8 QNXC', '1 XHTJF => 5 JRXQ', '3 XKTMK, 4 QGDSV => 3 ZJHKP', '2 BZFH => 7 PRMR', '1 BPNVK, 1 RXSZS => 5 JBHKV', '10 XHTJF => 9 BKNQT', '1 JBHKV, 2 XHTJF => 8 QLSVN', '24 VNFJQ, 42 TFQH, 39 RBFX, 1 ZWQX, 7 VBHVQ, 26 DRWB, 21 NJFXK => 1 FUEL', '26 WBKQ, 14 XHTJF => 5 BQGP', '5 WBKQ, 7 MBMKZ => 3 LQGC', '6 LQGC => 5 NZVL', '13 KRTGD, 5 GHQPH => 9 VLJWQ', '117 ORE => 4 BRXLV', '3 XKTMK, 1 PRMR => 2 MCQS', '3 DRWB, 7 BVFPF, 4 TCPN => 7 NJFXK', '10 VHFCR, 13 JZQJ => 5 XKTMK', '17 CVJQG, 4 GCBR => 9 HKCVW', '22 DFCT, 17 TGJP => 2 WBKQ', '2 JZQJ, 12 XFNPT, 1 BQGP => 2 VBHVQ', '12 HKCVW => 1 JZQJ', '1 XSRWM => 3 WMCD', '12 BZFH, 14 SKBV, 1 CTRH => 4 XFNPT', '7 ZKCXK => 6 VHFCR']

def pair(data)
  cant, elem = data.split(" ").map(&:strip)
  [elem, cant.to_i]
end

reactions = INPUT.map do |definition|
  input, output = definition.split("=>", 2)

  inputs = input.split(",").map {|i| pair(i)}

  output_elem, output_cant = pair(output)
  [output_elem, [output_cant, inputs]]
end.to_h

needed = Hash.new { |hash, key| hash[key] = 0 }
needed["FUEL"] = 1

Kernel.loop do
  needed.dup.each do |elem, cant|
    next if elem == "ORE" || cant < 0

    output_cant, inputs = reactions[elem]
    mult = (1.0 * cant / output_cant).ceil

    needed[elem] -= output_cant * mult

    inputs.each do |input_elem, input_cant|
      needed[input_elem] += input_cant * mult
    end
  end

  break if needed.none? {|key, val| key != "ORE" && val > 0 }
end

print "First problem: #{needed["ORE"]}\n"


min_fuel = 1
max_fuel = 1_000_000_000_000

Kernel.loop do
  fuel = (min_fuel + max_fuel)/2
  needed = Hash.new { |hash, key| hash[key] = 0 }
  needed["FUEL"] = fuel

  Kernel.loop do
    needed.dup.each do |elem, cant|
      next if elem == "ORE" || cant < 0

      output_cant, inputs = reactions[elem]
      mult = (1.0 * cant / output_cant).ceil

      needed[elem] -= output_cant * mult

      inputs.each do |input_elem, input_cant|
        needed[input_elem] += input_cant * mult
      end
    end

    break if needed.none? {|key, val| key != "ORE" && val > 0 }
  end

  if needed["ORE"] > 1_000_000_000_000
    max_fuel = fuel
  else
    break if min_fuel == fuel
    min_fuel = fuel
  end
end

print "First problem: #{min_fuel}\n"
