module PathOfLight

  import Base: ==, !=, +, -, *, /

  export Element, ispoint, isvector, point, vector, negate, magnitude,
         normalize, dot, cross

  include("element.jl")
end
