require './lib/vec'

class Boid
  attr_accessor :position, :velocity, :acceleration, :neighbors
  def initialize pos
    @position = pos
    @velocity = Vec2.new 0.0, 0.0
    @acceleration = Vec2.new 0.0, 0.0
    @neighbors = []
  end

  def step dt
    @velocity += @acceleration*dt
    @velocity = @velocity.clamp 10.0 # Maximum speed is 10 px/step
    @position += @velocity*dt
    @acceleration = Vec2.new 0.0, 0.0
  end

  ##
  # Steer towards the average heading of the nearby flock
  #
  def align_with_flock
    num_neighbors = self.neighbors.length.to_f
    if num_neighbors != 0.0
      velocity_sum = Vec2.new 0.0, 0.0
      self.neighbors.each do |other_boid|
        velocity_sum += other_boid.velocity
      end
      average_vel = Vec2.new velocity_sum.x/num_neighbors,
                              velocity_sum.y/num_neighbors
      direction = average_vel.normalize
      self.acceleration += direction
    end
  end

  ##
  # Don't hit nearby boids
  #
  def avoid_neighbors radius
    self.neighbors.each do |other_boid|
      distance = self.position.distance_from(other_boid.position)
      if distance < radius
        direction = (other_boid.position - self.position).normalize
        self.acceleration -= direction * 2       # Repulsion slightly
        other_boid.acceleration += direction * 2 # stronger than attraction
      end
    end
  end

  ##
  # Move toward the center of the nearby flock
  #
  def move_toward_flock
    num_neighbors = self.neighbors.length.to_f
    if num_neighbors != 0.0
      sum = Vec2.new 0.0, 0.0
      self.neighbors.each do |other_boid|
        sum += other_boid.position
      end
      average_pos = Vec2.new sum.x/num_neighbors, sum.y/num_neighbors
      direction = (average_pos - self.position).normalize
      self.acceleration += direction
    end
  end
end


class Boids
  attr_accessor :boids, :neighbor_radius
  def initialize
    @boids = []
    @neighbor_radius = 55.0
  end

  def step delta_time
    set_neighbors

    boids.each do |boid|
      boid.avoid_neighbors 20.0
      boid.move_toward_flock
      boid.align_with_flock

      boid.step delta_time
    end
  end

  def set_neighbors
    # Reset neighbors
    boids.each do |boid|
      boid.neighbors = []
    end

    # Set each pair of close boids as each other's neighbor
    boids.combination(2).each do |boid1, boid2|
      if boid1.position.distance_from(boid2.position) < @neighbor_radius
        boid1.neighbors << boid2
        boid2.neighbors << boid1
      end
    end
  end

  ## TODO(Lito)
  # At random intervals, one bird heads unshakably toward a random point.
  # After it gets there, it reverts back to normal behavior
  def one_boird_wanders
  end
end
