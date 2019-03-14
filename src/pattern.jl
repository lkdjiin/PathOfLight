abstract type Pattern end

mutable struct StripePattern <: Pattern
  a::Color
  b::Color
  transform

  StripePattern(a, b) = new(a, b, identity4)
end

mutable struct GradientPattern <: Pattern
  a::Color
  b::Color
  transform

  GradientPattern(a, b) = new(a, b, identity4)
end

function pattern_at(pattern::Pattern, object::Shape,
                    world_point::Element)::Color
  object_point = inv(object.transform) * world_point
  pattern_point = inv(pattern.transform) * object_point
  PatternH.pattern_at(pattern, pattern_point)
end

module PatternH
  using Main: StripePattern, GradientPattern, Element, Color

  function pattern_at(pattern::StripePattern, point::Element)::Color
    if Base.floor(point.x) % 2 == 0
      pattern.a
    else
      pattern.b
    end
  end

  function pattern_at(pattern::GradientPattern, point::Element)::Color
    pattern.a + (pattern.b - pattern.a) * (point.x - Base.floor(point.x))
  end

end
