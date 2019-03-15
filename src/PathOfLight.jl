import LinearAlgebra: det
import UUIDs: uuid1
import Base: ==, !=, +, -, *, /

using LinearAlgebra
using UUIDs

export Element, Point, Agent, ispoint, isvector, negate, magnitude,
       normalize, dot, cross, reflect
include("element.jl")

export Color, rbg
include("color.jl")

export Canvas, read_pixel, write_pixel!
include("canvas.jl")

export to_ppm
include("ppm.jl")

export matrix_compare, identity4, is_invertible, translation, scaling,
       rotation_x, rotation_y, rotation_z, shearing, view_transform
include("matrix.jl")

export Ray, location, transform
include("ray.jl")

export Shape
include("shape.jl")
export Sphere
include("sphere.jl")
export Plane
include("plane.jl")

export Intersection, intersects, intersections, hit, prepare_computations
include("intersection.jl")

export normal_at
include("normal.jl")

export PointLight
include("light.jl")

export StripePattern, GradientPattern, RingPattern, CheckersPattern, RadialGradientPattern, pattern_at
include("pattern.jl")

export Material, lighting
include("material.jl")

export World, default_world, intersect_world, shade_hit, color_at, isshadowed
include("world.jl")

export Camera, ray_for_pixel, render
include("camera.jl")

