include("PathOfLight.jl")
#= using .PathOfLight =#

start_time = time()

floor = Sphere()
floor.transform = scaling(10, 0.01, 10)
floor.material = Material()
floor.material.color = Color(1, 0.9, 0.9)
floor.material.specular = 0

left_wall = Sphere()
left_wall.transform = translation(0, 0, 5) * rotation_y(-π/4) * rotation_x(π/2) * scaling(10, 0.01, 10)
left_wall.material = floor.material

right_wall = Sphere()
right_wall.transform = translation(0, 0, 5) * rotation_y(π/4) * rotation_x(π/2) * scaling(10, 0.01, 10)
right_wall.material = floor.material

middle = Sphere()
middle.transform = translation(-0.5, 1, 0.5)
middle.material = Material()
middle.material.color = Color(0.4, 1, 0.5)
middle.material.diffuse = 0.8
middle.material.specular = 0.2

right = Sphere()
right.transform = translation(0.6, 0.5, -0.5) * scaling(0.5, 0.5, 0.5)
right.material = Material()
right.material.color = Color(0.75, 0.22, 0.15)
right.material.diffuse = 0.7
right.material.specular = 0.4
right.material.shininess = 20

left = Sphere()
left.transform = translation(-1.5, 1.0, -0.75) * scaling(0.33, 0.33, 0.33)
left.material = Material()
left.material.color = Color(0.8, 0.4, 1)
left.material.diffuse = 0.7
left.material.specular = 0.7

light = PointLight(Point(-10, 10, -10), Color(1, 1, 1))
world = World([floor, left_wall, right_wall, middle, right, left], [light])
t = view_transform(Point(0, 1.5, -5), Point(-0.4, 1, 0), Agent(0, 1, 0))
camera = Camera(800, 400, π/3, transform=t)
canvas = render(camera, world)


# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("camera.ppm", "w")
write(fout, ppm)
close(fout)

elapsed = time() - start_time
println("Done in $elapsed seconds.")

# 100x50   =>  2.4s
# 200x100  =>  2.7s
# 400x200  =>  3.9s
# 800x400  =>  9.3s
