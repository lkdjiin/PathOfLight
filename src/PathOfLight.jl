module PathOfLight

  import LinearAlgebra: det
  import UUIDs: uuid1
  import Base: ==, !=, +, -, *, /

  using LinearAlgebra
  using UUIDs

  export Element, ispoint, isvector, point, vector, negate, magnitude,
         normalize, dot, cross
  include("element.jl")

  export Color
  include("color.jl")

  export Canvas, read_pixel, write_pixel!
  include("canvas.jl")

  export to_ppm
  include("ppm.jl")

  export matrix_compare, identity4, is_invertible, translation, scaling,
         rotation_x, rotation_y, rotation_z, shearing
  include("matrix.jl")

  export Ray, location, transform
  include("ray.jl")

  export Sphere
  include("sphere.jl")

  export Intersection, intersects, intersections, hit
  include("intersection.jl")
end
