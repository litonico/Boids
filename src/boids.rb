require './lib/vec'

class Boid
  attr_accessor :position, :velocity, :neighbors
  def initialize pos
    @position = pos
    @velocity = Vec2.new 0.0, 0.0
    @neighbors = []
  end

  def step dt
    @position += @velocity*dt
  end
end

class Boids
  attr_reader :boids
  def initialize
    # Instantiate boids
    @boids = []
    (0..2).each do |x|
      (0..2).each do |y|
        boids << Boid.new(Vec2.new(x+1, y+1))
      end
    end
    @neighbor_radius = 5
  end

  def step delta_time
    get_neighbors
    avoid_neighbors 1.1
    move_toward_flock
    align_with_flock

    boids.each do |boid|
      boid.step delta_time
    end
  end

  def get_neighbors
    boids.combination(2).each do |boid1, boid2|
      if boid1.position.distance_from(boid2.position) < @neighbor_radius
        boid1.neighbors << boid2
        boid2.neighbors << boid1
      end
    end
  end
  #
  # Don't hit nearby boids
  #
  def avoid_neighbors radius
    boids.each do |boid|
      boid.neighbors.each do |other_boid|
        if boid.position.distance_from(other_boid.position) < radius
          #TODO: Why do these vectors get so big?
          direction = (other_boid.position - boid.position).normalize
          boid.velocity -= direction * 0.5
          other_boid.velocity += direction * 0.5
        end
      end
    end
  end

  ##
  # Move toward the center of the nearby flock
  #
  def move_toward_flock
    boids.each do |boid|
      boid.neighbors.each do |other_boid|
      end
    end
  end

  ##
  # Steet towards the average heading of the nearby flock
  #
  def align_with_flock
    boids.each do |boid|
    end
  end
end
