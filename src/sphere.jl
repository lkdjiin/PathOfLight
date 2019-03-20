mutable struct Sphere <: Shape
  id::String
  transform
  material
  shadow

  Sphere() = new(string(UUIDs.uuid1()), identity4, Material(), :on)
end

# Helper function to build a sphere made of glass. Mostly used by the tests.
function GlassSphere()
  s = Sphere()
  s.material.transparency = 1.0
  s.material.refractive_index = 1.5
  s
end
