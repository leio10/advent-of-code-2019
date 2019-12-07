class Amplifier
  MEM = [3,8,1001,8,10,8,105,1,0,0,21,46,59,72,93,110,191,272,353,434,99999,3,9,101,4,9,9,1002,9,3,9,1001,9,5,9,102,2,9,9,1001,9,5,9,4,9,99,3,9,1002,9,5,9,1001,9,5,9,4,9,99,3,9,101,4,9,9,1002,9,4,9,4,9,99,3,9,102,3,9,9,101,3,9,9,1002,9,2,9,1001,9,5,9,4,9,99,3,9,1001,9,2,9,102,4,9,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,99]

  def initialize
    reset
  end

  attr_reader :mem, :pointer

  def reset
    @mem = MEM.dup
    @pointer = 0
  end

  PARAMS = { 1 => 3, 2 => 3, 3 => 1, 4 => 1, 5 => 2, 6 => 2, 7 => 3, 8 => 3, 99 => 0 }.freeze

  def run(inputs)
    ret_code = nil
    until ret_code
      command = next_command
      step = command.size

      case command.first
      when 1 then write 3, command[1] + command[2]
      when 2 then write 3, command[1] * command[2]
      when 3 then write 1, inputs.shift
      when 4
        output = command[1]
        ret_code = :output
      when 5 then step = jump(command[2]) unless command[1].zero?
      when 6 then step = jump(command[2]) if command[1].zero?
      when 7 then write 3, command[1] < command[2] ? 1 : 0
      when 8 then write 3, command[1] == command[2] ? 1 : 0
      when 99 then ret_code = :halt
      else print "¡Error!\n"
      end

      @pointer += step
    end

    [ret_code, output]
  end

  def next_command
    op = mem[pointer] % 100
    modifiers = (mem[pointer] / 100).to_s.rjust(3, '0')

    (1..PARAMS[op]).map do |param|
      modifiers[-param].to_i.zero? ? mem[mem[pointer + param]] : mem[pointer + param]
    end.unshift(op)
  end

  def write(param, value)
    mem[mem[pointer + param]] = value
  end

  def jump(new_pointer)
    @pointer = new_pointer
    0
  end
end

AMPLIFIERS = 5

(0...AMPLIFIERS).to_a.permutation(AMPLIFIERS).map do |order|
  input = 0
  order.each do |phase|
    input = Amplifier.new.run([phase, input]).last
  end
  input
end.max

(AMPLIFIERS...AMPLIFIERS * 2).to_a.permutation(AMPLIFIERS).map do |order|
  inputs = order.map { |phase| [phase] }
  amplifiers = AMPLIFIERS.times.map { Amplifier.new }

  last_output = last_amplifier_last_output = 0
  inputs.each_with_index.cycle do |input, amplifier|
    code, last_output = amplifiers[amplifier].run(input.push(last_output))

    last_amplifier_last_output = last_output if amplifier + 1 == AMPLIFIERS
    break if code == :halt
  end

  last_amplifier_last_output
end.max
