module PathOfLight

  import LinearAlgebra: det
  import Base: ==, !=, +, -, *, /

  using LinearAlgebra

  export Element, ispoint, isvector, point, vector, negate, magnitude,
         normalize, dot, cross
  include("element.jl")

  export Color
  include("color.jl")

  export Canvas, read_pixel, write_pixel!
  include("canvas.jl")

  export to_ppm
  include("ppm.jl")

  export matrix_compare, identity4, is_invertible
  include("matrix.jl")
end
