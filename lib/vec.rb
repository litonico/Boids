require 'minitest/autorun'

class Vec2
  attr_accessor :x, :y
  def initialize x, y
    @x = x
    @y = y
  end

  def + other
    Vec2.new @x+other.x, @y+other.y
  end

  def - other
    Vec2.new @x-other.x, @y-other.y
  end

  def scale s
    Vec2.new @x*s, @y*s
  end

  def * s
    Vec2.new @x*s, @y*s
  end

  def == other
    @x == other.x && @y == other.y
  end

  def magnitude
    Math.sqrt(@x**2 + @y**2)
  end

  def normalize
    m = self.magnitude
    if m == 0
      Vec2.new 0, 0
    else
      Vec2.new @x.to_f/m, @y.to_f/m
    end
  end

  def distance_from other
    (other - self).magnitude
  end

end

class VecTest < Minitest::Test
  def test_distance_from_other_vector
    assert_equal Vec2.new(0.0, 0.0).distance_from(Vec2.new(1.0, 0.0)), 1.0
  end
end
