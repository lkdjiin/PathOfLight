abstract type Shape end

# shadow: Sometimes you don't want your object to cast a shadow. In such
#   case set the shadow field to :off. It's :on by default.
#
# The minimum and maximum always refer to units on the y axis and are
# defined in object space. By default minimum and maximum are set to
# infinity.
#
# closed: A cone or a Cylinder is hollow by default. Set closed = true
# for it to be capped.
macro shape(name)
  quote
    mutable struct $name <: Shape
      id::String
      transform
      material
      shadow
      minimum
      maximum
      closed::Bool
      parent::Union{Shape, Nothing}

      $name() = new(string(UUIDs.uuid1()),
                    identity4,
                    Material(),
                    :on,
                    -Inf,
                    Inf,
                    false,
                    nothing)
    end
  end
end

# A shape for testing purpose.
@shape TestShape
