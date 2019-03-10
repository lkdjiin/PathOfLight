struct Camera
  hsize::Float64
  vsize::Float64
  field_of_view::Float64
  transform
  pixel_size
  half_width
  half_height
end

function Camera(hsize, vsize, field_of_view; transform=identity4)
  half_view = tan(field_of_view / 2)
  aspect = hsize / vsize

  if aspect >= 1
    half_width = half_view
    half_height = half_view / aspect
  else
    half_width = half_view * aspect
    half_height = half_view
  end

  pixel_size = (half_width * 2) / hsize

  Camera(hsize, vsize, field_of_view, transform, pixel_size, half_width, half_height)
end

function ray_for_pixel(c::Camera, x, y)
  # the offset from the edge of the canvas to the pixel's center
  xoffset = (x + 0.5) * c.pixel_size
  yoffset = (y + 0.5) * c.pixel_size

  # the untransformed coordinates of the pixel in world space.
  # (remember that the camera looks toward -z, so +x is to the *left*.)
  world_x = c.half_width - xoffset
  world_y = c.half_height - yoffset

  # using the camera matrix, transform the canvas point and the origin,
  # and then compute the ray's direction vector.
  # (remember that the canvas is at z=-1)
  pixel = inv(c.transform) * Point(world_x, world_y, -1)
  origin = inv(c.transform) * Point(0, 0, 0)
  direction = normalize(pixel - origin)

  Ray(origin, direction)
end

function render(c::Camera, w::World)::Canvas
  hsize = round(Int, c.hsize)
  vsize = round(Int, c.hsize)
  image = Canvas(width=hsize, height=vsize)
  for y in 0:vsize - 1
    for x in 0:hsize - 1
      ray = ray_for_pixel(c, x, y)
      color = color_at(w, ray)
      write_pixel!(image, x=x, y=y, color=color)
    end
  end

  image
end
