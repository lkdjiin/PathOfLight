include("PathOfLight.jl")
start_time = time()

floor = Plane()
floor.material.pattern = CheckersPattern(black, white)

wall = Plane()
wall.material.pattern = StripePattern(Color(0, 0, 0.2), white)
wall.material.pattern.transform = rotation_y(pi/2) * scaling(2, 1, 1)
wall.transform = translation(0, 0, 15) * rotation_x(pi/2)

s = Sphere()
s.transform = translation(0, 1.5, 0) * scaling(1.5, 1.5, 1.5)
#= s.material.pattern = StripePattern(Color(0.5, 0.5, 0.5), Color(0.5, 0.5, 0.5)) =#
s.material.color = Color(0, 0, 0.2)
s.material.transparency = 0
s.material.reflective = 0.9
s.material.diffuse = 0.4
s.material.ambient = 0
s.material.specular = 0.9
s.material.shininess = 300.0
s.material.refractive_index = 1.5

light = PointLight(Point(6, 20, -4), Color(1, 1, 1))
world = World([floor, wall, s], [light])
t = view_transform(Point(0, 2, -5), Point(0, 0, 0), Agent(0, 1, 0))
camera = Camera(400, 400, π/4, transform=t)
canvas = render(camera, world)



# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("transparency.ppm", "w")
write(fout, ppm)
close(fout)

elapsed = time() - start_time
println("Done in $elapsed seconds.")
