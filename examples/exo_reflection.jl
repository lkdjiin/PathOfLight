include("PathOfLight.jl")

start_time = time()

floor = Plane()
floor.material.pattern = CheckersPattern(black, white)
floor.material.pattern.transform = scaling(2, 2, 2)
floor.material.reflective = 0.7
floor.material.ambient = 0.3

wall = Plane()
wall.material.pattern = StripePattern(Color(0, 0, 0.2), white)
wall.material.pattern.transform = rotation_y(pi/2) * scaling(2, 1, 1)
wall.transform = translation(0, 0, 15) * rotation_x(pi/2)

s = Sphere()
s.transform = translation(0, 1.5, 0) * scaling(1.5, 1.5, 1.5)
s.material.color = Color(1, 1, 0)
s.material.reflective = 0.4
s.material.shininess = 10

s2 = Sphere()
s2.transform = translation(-4, 1.2, 1) * scaling(1.2, 1.2, 1.2)
s2.material.color = red
s2.material.reflective = 0.2

s3 = Sphere()
s3.transform = translation(4, 1.3, -1) * scaling(1.3, 1.3, 1.3)
s3.material.color = Color(0.7, 0.7, 0.7)
s3.material.reflective = 0.2

light = PointLight(Point(6, 6, -4), Color(1, 1, 1))
world = World([floor, wall, s, s2, s3], [light])
t = view_transform(Point(0, 2, -7), Point(0, 0.5, 2), Agent(0, 1, 0))
camera = Camera(1000, 600, π/2, transform=t)
canvas = render(camera, world)



# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("reflection.ppm", "w")
write(fout, ppm)
close(fout)

elapsed = time() - start_time
println("Done in $elapsed seconds.")
