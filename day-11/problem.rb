class Brain
  MEM = [3,8,1005,8,299,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,28,1006,0,85,1,106,14,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,58,1,1109,15,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,84,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,105,1006,0,48,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,130,1006,0,46,1,1001,17,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,160,2,109,20,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,185,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,207,1006,0,89,2,1002,6,10,1,1007,0,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,241,2,4,14,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,267,1,1107,8,10,1,109,16,10,2,1107,4,10,101,1,9,9,1007,9,1003,10,1005,10,15,99,109,621,104,0,104,1,21101,0,387239486208,1,21102,316,1,0,1106,0,420,21101,0,936994976664,1,21102,327,1,0,1105,1,420,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,29192457307,1,21102,1,374,0,1106,0,420,21101,0,3450965211,1,21101,0,385,0,1106,0,420,3,10,104,0,104,0,3,10,104,0,104,0,21102,1,837901103972,1,21101,408,0,0,1106,0,420,21102,867965752164,1,1,21101,0,419,0,1105,1,420,99,109,2,22102,1,-1,1,21102,40,1,2,21102,451,1,3,21102,1,441,0,1106,0,484,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,446,447,462,4,0,1001,446,1,446,108,4,446,10,1006,10,478,1102,0,1,446,109,-2,2105,1,0,0,109,4,1201,-1,0,483,1207,-3,0,10,1006,10,501,21101,0,0,-3,22101,0,-3,1,22102,1,-2,2,21101,1,0,3,21101,520,0,0,1106,0,525,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,548,2207,-4,-2,10,1006,10,548,21201,-4,0,-4,1105,1,616,22101,0,-4,1,21201,-3,-1,2,21202,-2,2,3,21101,0,567,0,1106,0,525,22101,0,1,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,586,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,608,21202,-1,1,1,21102,608,1,0,106,0,483,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0]

  def initialize
    reset
  end

  attr_accessor :mem, :pointer, :relative, :inputs, :op, :modifiers, :params_count, :output

  def reset
    self.mem = MEM.dup
    self.pointer = 0
    self.relative = 0
  end

  def run(inputs = [])
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
    5 => proc { jump(params(2), !params(1).zero?) },
    6 => proc { jump(params(2), params(1).zero?) },
    7 => proc { write(3, params(1) < params(2) ? 1 : 0) },
    8 => proc { write(3, params(1) == params(2) ? 1 : 0) },
    9 => proc { update_relative(params(1)) },
    99 => proc { self.output = :halt }
  }.freeze

  def prepare_command
    self.op = mem[pointer] % 100
    self.modifiers = (mem[pointer] / 100).to_s.rjust(3, '0')
    self.params_count = 1
  end

  def run_command
    raise 'Error!' unless OPS[op]

    instance_eval(&OPS[op])
  end

  def update_params_count(param)
    self.params_count = 1 + param if params_count <= param
  end

  def params(param)
    update_params_count(param)
    mems(param_address(param))
  end

  def param_address(param)
    case modifiers[-param].to_i
    when 0 then mems(pointer + param)
    when 1 then pointer + param
    when 2 then relative + mems(pointer + param)
    end
  end

  def mems(position)
    raise 'Negative memory' if position.negative?

    mem[position] || 0
  end

  def write(param, value)
    update_params_count(param)
    mem[param_address(param)] = value
  end

  def jump(new_pointer, condition)
    return unless condition

    self.pointer = new_pointer
    self.params_count = 0
  end

  def update_relative(delta)
    self.relative += delta
  end

  def increment_pointer
    self.pointer += params_count
  end
end

class Robot
  def initialize
    @brain = Brain.new

    @x = @y = 0
    @panels = Hash.new {|h,k| h[k] = 0}
    @direction = [0, -1, 0, 1]
  end

  attr_accessor :panels, :x, :y, :direction, :brain

  def run(first)
    painted = []
    panels[[x,y]] = first
    Kernel.loop do
      output = brain.run([panels[[x,y]]])
      break if output == :halt

      painted << [x,y]
      panels[[x,y]] = output
      output = brain.run
      break if output == :halt
      change_direction(output)
      forward
    end
    painted.uniq.count
  end

  def change_direction(right)
    direction.rotate!(right == 1 ? -1 : 1)
  end

  def forward
    @x += direction[0]
    @y += direction[1]
  end

  def draw
    painted_panels = panels.keys
    x1 = painted_panels.map(&:first).min
    x2 = painted_panels.map(&:first).max
    y1 = painted_panels.map(&:last).min
    y2 = painted_panels.map(&:last).max

    (y1..y2).each do |j|
      (x1..x2).each do |i|
        print panels[[i+x1, j+y1]] == 1 ? '#' : ' '
      end
      print "\n"
    end
  end
end

print "First problem: #{Robot.new.run(0)}\n"

robot = Robot.new
robot.run(1)
print "Second problem: \n"
robot.draw
