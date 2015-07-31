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

  def / s
    Vec2.new @x/s, @y/s
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

  def clamp s
    m = self.magnitude
    if m == 0.0
      Vec2.new 0, 0
    elsif m > s
      self.scale s.to_f/m
    else
      self
    end
  end

end

V_ZERO = Vec2.new 0.0, 0.0
