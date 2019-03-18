include("PathOfLight.jl")
using .PathOfLight

canvas = Canvas(width=400, height=400)
blue = Color(0.7, 0.7, 1)
red = Color(1, 0.4, 0.4)
scale = scaling(40, 40, 0)
center = point(canvas.width / 2, canvas.height / 2, 0)
hours = Array{Element}(undef, 12)

hours[12] = scale * point(0, 1, 0)
for i in 1:11
  hours[i] = rotation_z((12-i) * π / 6) * hours[12]
end

write_pixel!(canvas, x=center.x, y=(canvas.height-1) - center.y, color=red)

for i in 1:12
  hours[i] += center
  write_pixel!(canvas, x=hours[i].x, y=(canvas.height-1) - hours[i].y, color=blue)
end

ppm = to_ppm(canvas)
fout = open("clock.ppm", "w")
write(fout, ppm)
close(fout)
