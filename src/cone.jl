mutable struct Cone <: Shape
  id::String
  transform
  material
  shadow

  # The minimum and maximum always refer to units on the y axis and are
  # defined in object space. By default minimum and maximum are set to
  # infinity.
  minimum
  maximum

  # A cone is hollow by default. Set closed = true for it to be
  # capped.
  closed

  Cone() = new(string(UUIDs.uuid1()), identity4, Material(), :on, -Inf, Inf,
                   false)
end