include("PathOfLight.jl")
using .PathOfLight

projectile = (point(0, 1, 0), normalize(vector(1, 1.8, 0)) * 9.25)
environ = (vector(0, -0.1, 0), vector(-0.015, 0, 0))
canvas = Canvas(width=600, height=400)
red = Color(1, 0, 0)

function tick(env, proj)
  position = proj[1] + proj[2]
  velocity = proj[2] + env[1] + env[2]
  (position, velocity)
end

function draw()
  write_pixel!(canvas, x=projectile[1].x, y=400 - projectile[1].y, color=red)
  while true
    global projectile = tick(environ, projectile)
    if projectile[1].y >= 0
      write_pixel!(canvas, x=projectile[1].x, y=400 - projectile[1].y, color=red)
    else
      break
    end
  end
end

draw()

ppm = to_ppm(canvas)
fout = open("projectile.ppm", "w")
write(fout, ppm)
close(fout)
