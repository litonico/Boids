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
end

class Boids
  attr_accessor :boids, :neighbor_radius
  def initialize
    @boids = []
    @neighbor_radius = 55.0
  end

  def step delta_time
    get_neighbors
    avoid_neighbors 20.0
    move_toward_flock
    align_with_flock

    boids.each do |boid|
      boid.step delta_time
    end
  end

  def get_neighbors
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

  ##
  # Don't hit nearby boids
  #
  def avoid_neighbors radius
    boids.each do |boid|
      boid.neighbors.each do |other_boid|
        distance = boid.position.distance_from(other_boid.position)
        if distance < radius
          direction = (other_boid.position - boid.position).normalize
          boid.acceleration -= direction * 2       # Repulsion slightly
          other_boid.acceleration += direction * 2 # stronger than attraction
        end
      end
    end
  end

  ##
  # Move toward the center of the nearby flock
  #
  def move_toward_flock
    boids.each do |boid|
      num_neighbors = boid.neighbors.length.to_f
      if num_neighbors != 0.0
        sum = Vec2.new 0.0, 0.0
        boid.neighbors.each do |other_boid|
          sum += other_boid.position
        end
        average_pos = Vec2.new sum.x/num_neighbors, sum.y/num_neighbors
        direction = (average_pos - boid.position).normalize
        boid.acceleration += direction
      end
    end
  end

  ##
  # Steer towards the average heading of the nearby flock
  #
  def align_with_flock
    boids.each do |boid|
      num_neighbors = boid.neighbors.length.to_f
      if num_neighbors != 0.0
        velocity_sum = Vec2.new 0.0, 0.0
        boid.neighbors.each do |other_boid|
          velocity_sum += other_boid.velocity
        end
        average_vel = Vec2.new velocity_sum.x/num_neighbors,
                               velocity_sum.y/num_neighbors
        direction = average_vel.normalize
        boid.acceleration += direction
      end
    end
  end
end
