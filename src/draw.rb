require './src/boids'
require './lib/thingy'

WINSIZE = 500

class SimulationWindow < Thingy
  attr_reader :simulation
  def initialize
    super WINSIZE, WINSIZE, 16, "Smoothed Particle Hydrodynamics"
    @simulation = Boids.new
    # Add a bunch of boids to the simulation
    (1..10).each do |x|
      (1..10).each do |y|
        b = Boid.new(Vec2.new x*50*rand+250, y*50*rand+250)
        simulation.boids << b
      end
    end
  end

  def update time
    simulation.step 0.25
  end

  def wrap  vec
    Vec2.new vec.x % WINSIZE,
             vec.y % WINSIZE
  end

  def draw time
    clear

    s = 1.0 # Scale of simulation

    simulation.boids.each do |boid|
      # Wrap birds around the screen
      # TODO(Lito): Neighbors check and calculations should wrap
      boid.position = wrap boid.position

      # Boids themselves
      # TODO(Lito): Boids should be colored according
      # to their number of neighbors
      ellipse(
        (boid.position.x*s).to_i,
        (boid.position.y*s).to_i,
        5,
        5,
        :white
      )

      # Velocity vectors
      line(
        # start
        (boid.position.x*s).to_i,
        (boid.position.y*s).to_i,
        # end
        ((boid.position.x+boid.velocity.x)*s).to_i,
        ((boid.position.y+boid.velocity.y)*s).to_i,
        :red
      )

    end
  end
end

SimulationWindow.new.run
