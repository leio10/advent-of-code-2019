INPUT = <<EOI
#.#.###.#.#....#..##.#....
.....#..#..#..#.#..#.....#
.##.##.##.##.##..#...#...#
#.#...#.#####...###.#.#.#.
.#####.###.#.#.####.#####.
#.#.#.##.#.##...####.#.##.
##....###..#.#..#..#..###.
..##....#.#...##.#.#...###
#.....#.#######..##.##.#..
#.###.#..###.#.#..##.....#
##.#.#.##.#......#####..##
#..##.#.##..###.##.###..##
#..#.###...#.#...#..#.##.#
.#..#.#....###.#.#..##.#.#
#.##.#####..###...#.###.##
#...##..#..##.##.#.##..###
#.#.###.###.....####.##..#
######....#.##....###.#..#
..##.#.####.....###..##.#.
#..#..#...#.####..######..
#####.##...#.#....#....#.#
.#####.##.#.#####..##.#...
#..##..##.#.##.##.####..##
.##..####..#..####.#######
#.#..#.##.#.######....##..
.#.##.##.####......#.##.##
EOI

def input_to_coords(input)
  input.split("\n").each_with_index.map do |line, y|
    line.chars.each_with_index.map do |char, x|
      [x, y] if char == '#'
    end
  end.flatten(1).compact
end

def diff(a, b)
  [a.first - b.first, a.last - b.last]
end

def minimize(asteroid)
  (1..asteroid.map(&:abs).max).to_a.reverse.each do |div|
    return [asteroid.first / div, asteroid.last / div] if (asteroid.first % div).zero? && (asteroid.last % div).zero?
  end
end

asteroids = input_to_coords(INPUT)

first, station = asteroids.map do |asteroid|
  [
    asteroids.map do |another|
      next if asteroid == another

      minimize(diff(asteroid, another))
    end.compact.uniq.count,
    asteroid
  ]
end.max

print "First problem: #{first}\n"

def order(station, asteroid)
  difference = diff(station, asteroid)
  radio = Math.sqrt(difference.first * difference.first + difference.last * difference.last)

  d1 = difference.first.abs.to_f
  d2 = difference.last.abs.to_f

  order = if difference.first <= 0 && difference.last.positive?
            10_000 + d1 / radio / (d2 / radio)
          elsif difference.last <= 0 && difference.first.negative?
            20_000 + d2 / radio / (d1 / radio)
          elsif difference.first >= 0 && difference.last.negative?
            30_000 + d1 / radio / (d2 / radio)
          elsif difference.last >= 0 && difference.first.positive?
            40_000 + d2 / radio / (d1 / radio)
          else
            p 'error!'
          end

  [order, radio, asteroid]
end

bins = asteroids.map do |asteroid|
  next if station == asteroid

  order(station, asteroid)
end.compact.group_by(&:first).sort

n200 = (1..200).map { |i| bins[i - 1].last.last.last } .last
print "Second problem: #{n200.first * 100 + n200.last}\n"
