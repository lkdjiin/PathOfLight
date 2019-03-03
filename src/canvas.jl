struct Canvas
  width
  height
  pixels
end

function Canvas(;width::Int, height::Int)
  ary = Array{Color, 2}(undef, height, width)
  fill!(ary, Color(0, 0, 0))
  Canvas(width, height, ary)
end

# x and y are zero-based, but Julia's arrays are one-based.
function read_pixel(c::Canvas; x::Int, y::Int)
  c.pixels[y + 1, x + 1]
end

# x and y are zero-based, but Julia's arrays are one-based.
function write_pixel(c::Canvas; x::Int, y::Int, color::Color)
  c.pixels[y + 1, x + 1] = color
end
