require './src/boids'
require './lib/thingy'

WINSIZE = 500

class SimulationWindow < Thingy
  attr_reader :simulation
  def initialize
    super WINSIZE, WINSIZE, 16, "Smoothed Particle Hydrodynamics"
    @simulation = Boids.new
    @scale = 15
  end

  def update time
    simulation.step time*0.0001
  end

  def draw time
    clear
    s = WINSIZE.div @scale

    simulation.boids.each do |boid|
      # Boids themselves
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
