module PathOfLight

  import Base: ==, !=, +, -, *, /

  export Element, ispoint, isvector, point, vector, negate, magnitude,
         normalize, dot, cross
  include("element.jl")

  export Color
  include("color.jl")

  export Canvas, read_pixel, write_pixel
  include("canvas.jl")
end
