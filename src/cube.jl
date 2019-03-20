mutable struct Cube <: Shape
  id::String
  transform
  material
  shadow

  Cube() = new(string(UUIDs.uuid1()), identity4, Material(), :on)
end

