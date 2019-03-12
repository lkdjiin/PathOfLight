mutable struct Plane <: Shape
  id::String
  transform
  material

  Plane() = new(string(UUIDs.uuid1()), identity4, Material())
end
