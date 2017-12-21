require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Particle
  attr_reader :p, :a, :v

  def initialize(line)
    /p=<(?<px>-?\d+),(?<py>-?\d+),(?<pz>-?\d+)>, v=<(?<vx>-?\d+),(?<vy>-?\d+),(?<vz>-?\d+)>, a=<(?<ax>-?\d+),(?<ay>-?\d+),(?<az>-?\d+)>/ =~ line
    @p = [px, py, pz].map(&:to_i)
    @v = [vx, vy, vz].map(&:to_i)
    @a = [ax, ay, az].map(&:to_i)
  end
end

class Adv20_a < TestFramework
  def logic(t)
    particles = t.split("\n").map { |l| Particle.new l }
    particles.find_index(particles.min_by { |p| p.a.map(&:abs).sum })
  end
end

class Adv20_b < TestFramework
  def logic(t)
    particles = t.split("\n").map { |l| Particle.new l }
    5000.times do
      particles.group_by { |part| part.p }
          .map { |_, v| v }
          .select { |v| v.size > 1 }
          .flatten
          .each { |v| particles.delete v }
      particles.each do |particle|
        particle.v[0] += particle.a[0]
        particle.v[1] += particle.a[1]
        particle.v[2] += particle.a[2]
        particle.p[0] += particle.v[0]
        particle.p[1] += particle.v[1]
        particle.p[2] += particle.v[2]
      end
    end
    particles.count
  end
end

adva = Adv20_a.new({ 'p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>' => 0 }, 20)
# adva.test
# puts adva.run

advb = Adv20_b.new({ 'p=<-6,0,0>, v=<3,0,0>, a=<0,0,0>
p=<-4,0,0>, v=<2,0,0>, a=<0,0,0>
p=<-2,0,0>, v=<1,0,0>, a=<0,0,0>
p=<3,0,0>, v=<-1,0,0>, a=<0,0,0>' => 1 }, 20)
# advb.test
puts advb.run
