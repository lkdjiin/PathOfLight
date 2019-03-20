# shadow: Sometimes you don't want your object to cast a shadow. In such
#   case set the shadow field to :off. It's :on by default.
mutable struct Plane <: Shape
  id::String
  transform
  material
  shadow

  Plane() = new(string(UUIDs.uuid1()), identity4, Material(), :on)
end
