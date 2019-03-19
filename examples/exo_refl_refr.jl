include("PathOfLight.jl")
start_time = time()

floor = Plane()
floor.transform = rotation_y(0.31415)
floor.material.pattern = CheckersPattern(Color(0.35, 0.35, 0.35), Color(0.65, 0.65, 0.65))
floor.material.specular = 0
floor.material.reflective = 0.4

ceiling = Plane()
ceiling.transform = translation(0, 5, 0)
ceiling.material.color = Color(0.8, 0.8, 0.8)
ceiling.material.ambient = 0.3
ceiling.material.specular = 0

wall_material = Material()
wall_material.pattern = StripePattern(Color(0.45, 0.45, 0.45), Color(0.55, 0.55, 0.55))
wall_material.pattern.transform = rotation_y(1.5708) * scaling(0.25, 0.25, 0.25)
wall_material.ambient = 0
wall_material.diffuse = 0.4
wall_material.specular = 0
wall_material.reflective = 0.3

west_wall = Plane()
west_wall.transform = translation(-5, 0, 0) * rotation_z(1.5708) * rotation_y(1.5708)
west_wall.material = wall_material

east_wall = Plane()
east_wall.transform = translation(5, 0, 0) * rotation_z(1.5708) * rotation_y(1.5708)
east_wall.material = wall_material

north_wall = Plane()
north_wall.transform = translation(0, 0, 5) * rotation_x(1.5708)
north_wall.material = wall_material

s1 = Sphere()
s1.transform = translation(4.6, 0.4, 1) * scaling(0.4, 0.4, 0.4)
s1.material.color = Color(0.8, 0.5, 0.3)
s1.material.shininess = 50

s2 = Sphere()
s2.transform = translation(4.7, 0.3, 0.4) * scaling(0.3, 0.3, 0.3)
s2.material.color = Color(0.9, 0.4, 0.5)
s2.material.shininess = 50

s3 = Sphere()
s3.transform = translation(-1, 0.5, 4.5) * scaling(0.5, 0.5, 0.5)
s3.material.color = Color(0.4, 0.9, 0.6)
s3.material.shininess = 50

s4 = Sphere()
s4.transform = translation(-1.7, 0.3, 4.7) * scaling(0.3, 0.3, 0.3)
s4.material.color = Color(0.4, 0.6, 0.9)
s4.material.shininess = 50

red_s = Sphere()
red_s.transform = translation(-0.6, 1, 0.6)
red_s.material.color = Color(1, 0.3, 0.2)
red_s.material.specular = 0.4
red_s.material.shininess = 5

blue_s = Sphere()
blue_s.transform = translation(0.6, 0.7, -0.6) * scaling(0.7, 0.7, 0.7)
blue_s.material.color = Color(0, 0, 0.2)
blue_s.material.ambient = 0
blue_s.material.diffuse = 0.4
blue_s.material.specular = 0.9
blue_s.material.shininess = 300
blue_s.material.reflective = 0.9
blue_s.material.transparency = 0.9
blue_s.material.refractive_index = 1.5

green_s = Sphere()
green_s.transform = translation(-0.7, 0.5, -0.8) * scaling(0.5, 0.5, 0.5)
green_s.material.color = Color(0, 0.2, 0)
green_s.material.ambient = 0
green_s.material.diffuse = 0.4
green_s.material.specular = 0.9
green_s.material.shininess = 300
green_s.material.reflective = 0.9
green_s.material.transparency = 0.9
green_s.material.refractive_index = 1.5

# ---------------------
light = PointLight(Point(-4.9, 4.9, -1), Color(1, 1, 1))
world = World([floor, ceiling, west_wall, east_wall, north_wall, s1, s2, s3, s4, red_s, blue_s, green_s], [light])
t = view_transform(Point(-2.6, 1.5, -3.9), Point(-0.6, 1, -0.8), Agent(0, 1, 0))
camera = Camera(800, 400, 1.152, transform=t)
canvas = render(camera, world)



# ---- Render file ----
ppm = to_ppm(canvas)
fout = open("scene.ppm", "w")
write(fout, ppm)
close(fout)

elapsed = time() - start_time
println("Done in $elapsed seconds.")
