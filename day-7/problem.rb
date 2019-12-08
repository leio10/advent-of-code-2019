class Amplifier
  MEM = [3,8,1001,8,10,8,105,1,0,0,21,46,59,72,93,110,191,272,353,434,99999,3,9,101,4,9,9,1002,9,3,9,1001,9,5,9,102,2,9,9,1001,9,5,9,4,9,99,3,9,1002,9,5,9,1001,9,5,9,4,9,99,3,9,101,4,9,9,1002,9,4,9,4,9,99,3,9,102,3,9,9,101,3,9,9,1002,9,2,9,1001,9,5,9,4,9,99,3,9,1001,9,2,9,102,4,9,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,99]

  def initialize
    reset
  end

  attr_accessor :mem, :pointer, :inputs, :op, :modifiers, :params_count, :output

  def reset
    self.mem = MEM.dup
    self.pointer = 0
  end

  def run(inputs)
    self.inputs = inputs
    self.output = nil
    until output
      prepare_command
      run_command
      increment_pointer
    end

    output
  end

  private

  OPS = {
    1 => proc { write(3, params(1) + params(2)) },
    2 => proc { write(3, params(1) * params(2)) },
    3 => proc { write(1, inputs.shift) },
    4 => proc { self.output = params(1) },
    5 => proc { jump(params(2)) unless params(1).zero? },
    6 => proc { jump(params(2)) if params(1).zero? },
    7 => proc { write(3, params(1) < params(2) ? 1 : 0) },
    8 => proc { write(3, params(1) == params(2) ? 1 : 0) },
    99 => proc { self.output = :halt }
  }.freeze

  def prepare_command
    self.op = mem[pointer] % 100
    self.modifiers = (mem[pointer] / 100).to_s.rjust(3, '0')
    self.params_count = 0
  end

  def run_command
    raise 'Error!' unless OPS[op]

    instance_eval(&OPS[op])
  end

  def update_params_count(param)
    self.params_count = 1 + param if params_count < param
  end

  def params(param)
    update_params_count(param)
    modifiers[-param].to_i.zero? ? mem[mem[pointer + param]] : mem[pointer + param]
  end

  def write(param, value)
    update_params_count(param)
    mem[mem[pointer + param]] = value
  end

  def jump(new_pointer)
    self.pointer = new_pointer
    self.params_count = 0
  end

  def increment_pointer
    self.pointer += params_count
  end
end

AMPLIFIERS = 5

first = (0...AMPLIFIERS).to_a.permutation(AMPLIFIERS).map do |order|
  input = 0
  order.each do |phase|
    input = Amplifier.new.run([phase, input])
  end
  input
end.max

second = (AMPLIFIERS...AMPLIFIERS * 2).to_a.permutation(AMPLIFIERS).map do |order|
  inputs = order.map { |phase| [phase] }
  amplifiers = AMPLIFIERS.times.map { Amplifier.new }

  last_output = 0
  inputs.each_with_index.cycle do |input, amplifier|
    last_output = amplifiers[amplifier].run(input.push(last_output))
    break if last_output == :halt
  end

  amplifiers[-1].output
end.max

print "First problem: #{first}\n"
print "Second problem: #{second}\n"
