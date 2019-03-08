module PathOfLight

  import LinearAlgebra: det
  import UUIDs: uuid1
  import Base: ==, !=, +, -, *, /

  using LinearAlgebra
  using UUIDs

  export Element, ispoint, isvector, point, vector, negate, magnitude,
         normalize, dot, cross, reflect
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

  export Intersection, intersects, intersections, hit, prepare_computations
  include("intersection.jl")

  export normal_at
  include("normal.jl")

  export PointLight
  include("light.jl")

  export Material, color, ambient, diffuse, specular, shininess, lighting
  include("material.jl")

  export World, default_world, intersect_world
  include("world.jl")
end
