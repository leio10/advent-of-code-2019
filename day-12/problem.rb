require "set"

class Moons
  MOONS = [
    [10, 15, 7],
    [15, 10, 0],
    [20, 12, 3],
    [0, -3, 13]
  ]

  def initialize
    @moons = MOONS.map(&:dup)
    @vels = [[0] * 3, [0] * 3, [0] * 3, [0] * 3]
    @states = [moons].to_set
    @axis = moons.transpose
  end

  attr_accessor :moons, :vels, :states, :axis

  def run(n)
    n.times do
      update_velocities
      update_positions
    end
    energy
  end

  def update_velocities
    moons.each_with_index do |m1, i|
      moons.each_with_index do |m2, j|
        (0..2).each do |k|
          if m1[k] < m2[k]
            vels[i][k] += 1
          elsif m1[k] > m2[k]
            vels[i][k] -= 1
          end
        end
      end
    end
  end

  def update_positions
    moons.each_with_index do |moon, i|
      (0..2).each do |j|
        moon[j] += vels[i][j]
      end
    end
  end

  def energy
    moons.each_with_index.map do |moon, i|
      moon.map(&:abs).sum * vels[i].map(&:abs).sum
    end.sum
  end

  def cycles
    axis.map do |axe|
      axe_vels = [0] * axe.size
      axe_states = [axe + axe_vels].to_set

      Kernel.loop do
        (0...axe.size).each do |i|
          (0...axe.size).each do |j|
            if axe[i] > axe[j]
              axe_vels[i] -= 1
            elsif axe[i] < axe[j]
              axe_vels[i] += 1
            end
          end
        end

        axe = axe.zip(axe_vels).map(&:sum)
        new_state = axe + axe_vels

        break if axe_states.member?(new_state)

        axe_states << new_state
      end

      axe_states.size
    end
  end
end

print "First problem: #{Moons.new.run(1000)}\n"
print "Second problem: #{Moons.new.cycles.reduce(1, :lcm)}\n"
