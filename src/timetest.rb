require './src/procedural_boids'
require './src/oo_boids'
require './lib/thingy'
require 'benchmark/ips'

WINSIZE = 500

oo_sim = OOBoids::Boids.new
procedural_sim = ProceduralBoids::Boids.new

(1..10).each do |x|
  (1..10).each do |y|
    v = Vec2.new x*50*rand+250, y*50*rand+250
    oo_sim.boids << OOBoids::Boid.new(v)
    procedural_sim.boids << ProceduralBoids::Boid.new(v)
  end
end

Benchmark.ips do |x|
  x.report("OO Boids") do |max|
    oo_sim.step 0.25
  end

  x.report("Procedural Boids") do |max|
    procedural_sim.step 0.25
  end

  x.compare!
end
