mutable struct Sphere <: Shape
  id::String
  transform
  material
end

function Sphere()
  Sphere(string(UUIDs.uuid1()), identity4, Material())
end

# Helper function to build a sphere made of glass. Mostly used by the tests.
function GlassSphere()
  s = Sphere(string(UUIDs.uuid1()), identity4, Material())
  s.material.transparency = 1.0
  s.material.refractive_index = 1.5
  s
end
