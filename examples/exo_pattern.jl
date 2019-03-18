include("PathOfLight.jl")

start_time = time()

floor = Plane()
floor.material.pattern = CheckersPattern(black, white)
#= floor.material.pattern.transform = scaling(2, 2, 1) =#
#= floor.transform = rotation_x(-pi/2) =#

s = Sphere()
s.transform = translation(0, 1.7, 0) * scaling(1.7, 1.7, 1.7)
s.material.pattern = StripePattern(Color(1, 1, 0), black)
s.material.pattern.transform = scaling(0.1, 0.1, 1)
s.material.noise = Noise(:perlin_noise, 0.2)
#= s.material.shininess = 70 =#

light = PointLight(Point(6, 6, -4), Color(1, 1, 1))
world = World([floor, s], [light])
t = view_transform(Point(0, 2, -7), Point(0, 0.5, 2), Agent(0, 1, 0))
camera = Camera(400, 300, π/3, transform=t)
canvas = render(camera, world)



# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("pattern.ppm", "w")
write(fout, ppm)
close(fout)

elapsed = time() - start_time
println("Done in $elapsed seconds.")
