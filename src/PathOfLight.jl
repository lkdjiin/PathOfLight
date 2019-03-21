import LinearAlgebra: det
import UUIDs: uuid1
import Base: ==, !=, +, -, *, /

using LinearAlgebra
using UUIDs

include("noise.jl")
include("perlin.jl")
include("element.jl")
include("color.jl")
include("canvas.jl")
include("ppm.jl")
include("matrix.jl")
include("ray.jl")
include("shape.jl")
include("sphere.jl")
include("plane.jl")
include("cube.jl")
include("cylinder.jl")
include("intersection.jl")
include("normal.jl")
include("light.jl")
include("pattern.jl")
include("composed_pattern.jl")
include("material.jl")
include("world.jl")
include("camera.jl")
