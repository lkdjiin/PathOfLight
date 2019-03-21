mutable struct Cylinder <: Shape
  id::String
  transform
  material
  shadow

  # The minimum and maximum always refer to units on the y axis and are
  # defined in object space.
  minimum
  maximum

  Cylinder() = new(string(UUIDs.uuid1()), identity4, Material(), :on, -Inf, Inf)
end
