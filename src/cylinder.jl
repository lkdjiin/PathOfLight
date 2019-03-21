mutable struct Cylinder <: Shape
  id::String
  transform
  material
  shadow

  Cylinder() = new(string(UUIDs.uuid1()), identity4, Material(), :on)
end
