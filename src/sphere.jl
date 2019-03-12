mutable struct Sphere <: Shape
  id::String
  transform
  material
end

function Sphere()
  Sphere(string(UUIDs.uuid1()), identity4, Material())
end
