include("PathOfLight.jl")

start_time = time()


floor = Plane()
floor.material.ambient = 0.3
floor.material.shininess = 2

ceiling = Plane()
ceiling.transform = translation(0, 12, 0)
ceiling.material.color = Color(1, 0.5, 0)
ceiling.material.ambient = 0.25
ceiling.material.shininess = 20

m = Material()
m.color = Color(1, 1, 1)
m.ambient = 0.4
#= m.shininess = 10 =#

middle = Sphere()
middle.material = m

s1 = Sphere()
s1.material = m
s1.transform = translation(-4, 0, 0)

s2 = Sphere()
s2.material = m
s2.transform = translation(4, 0, 0)

s3 = Sphere()
s3.material = m
s3.transform = translation(-4, 0, 4)

s4 = Sphere()
s4.material = m
s4.transform = translation(4, 0, 4)

s5 = Sphere()
s5.material = m
s5.transform = translation(0, 0, 4)

s6 = Sphere()
s6.material = m
s6.transform = translation(-4, 0, -4)

s7 = Sphere()
s7.material = m
s7.transform = translation(4, 0, -4)

s8 = Sphere()
s8.material = m
s8.transform = translation(0, 0, -4)



#= right = Sphere() =#
#= right.transform = translation(0.6, 0.5, -0.5) * scaling(0.5, 0.5, 0.5) =#
#= right.material = Material() =#
#= right.material.color = Color(0.75, 0.22, 0.15) =#
#= right.material.diffuse = 0.7 =#
#= right.material.specular = 0.4 =#
#= right.material.shininess = 20 =#

#= left = Sphere() =#
#= left.transform = translation(-1.5, 0.33, -0.75) * scaling(0.33, 0.33, 0.33) =#
#= left.material = Material() =#
#= left.material.color = Color(0.8, 0.4, 1) =#
#= left.material.diffuse = 0.7 =#
#= left.material.specular = 0.7 =#

light = PointLight(Point(0, 2, 100), Color(1, 1, 1))
world = World([floor, ceiling, middle, s1, s2, s3, s4, s5, s6, s7, s8], [light])
t = view_transform(Point(0, 2, -7), Point(0, 0.5, 2), Agent(0, 1, 0))
camera = Camera(1200, 600, π/1.8, transform=t)
canvas = render(camera, world)



# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("plane.ppm", "w")
write(fout, ppm)
close(fout)

elapsed = time() - start_time
println("Done in $elapsed seconds.")
