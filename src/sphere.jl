mutable struct Sphere
  id::String
  transform
end

function Sphere()
  Sphere(string(UUIDs.uuid1()), identity4)
end
