include("PathOfLight.jl")
using .PathOfLight

canvas = Canvas(width=200, height=200)
#= red = Color(0.5, 0.2, 0.6) =#
ray_origin = point(0, 0, -5)
wall_z = 10
wall_size = 7.0
pixel_size = wall_size / canvas.width
half = wall_size / 2

shape = Sphere()
shape.transform = rotation_z(pi / 4) * scaling(0.7, 1, 1)
material = Material()
material = color(material, Color(0.5, 0.2, 0.6))
shape.material = material

light_position = point(2, 15, -12)
light_color = Color(1, 1, 1)
light = PointLight(light_position, light_color)

for y in 0:canvas.height - 1
  world_y = half - pixel_size * y

  for x in 0:canvas.height - 1
    world_x = -half + pixel_size * x
    position = point(world_x, world_y, wall_z)
    r = Ray(ray_origin, normalize(position - ray_origin))
    xs = intersects(shape, r)
    h = hit(xs)
    if h != nothing
      p = location(r, h.t)
      normal = normal_at(h.object, p)
      eye = - r.direction
      col = lighting(h.object.material, light, p, eye, normal)
      write_pixel!(canvas, x=x, y=y, color=col)
    end
  end
end


# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("sphere.ppm", "w")
write(fout, ppm)
close(fout)
