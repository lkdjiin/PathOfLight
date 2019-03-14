mutable struct StripePattern
  a::Color
  b::Color
  transform

  StripePattern(a, b) = new(a, b, identity4)
end

function stripe_at(pattern, point)
  if Base.floor(point.x) % 2 == 0
    pattern.a
  else
    pattern.b
  end
end

function stripe_at_object(pattern::StripePattern, object::Shape,
                          world_point::Element)
  object_point = inv(object.transform) * world_point
  pattern_point = inv(pattern.transform) * object_point
  stripe_at(pattern, pattern_point)
end
