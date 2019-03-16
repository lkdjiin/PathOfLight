# A ComposedPattern encapsulates two or more simple patterns (Pattern).
abstract type ComposedPattern end

mutable struct StripeCheckersPattern <: ComposedPattern
  a::StripePattern
  b::StripePattern
  transform

  StripeCheckersPattern(a, b) = new(a, b, identity4)
end

# Main entry to call a ComposedPattern.
function pattern_at(pattern::ComposedPattern, object::Shape,
                    world_point::Element)::Color
  object_point = inv(object.transform) * world_point
  pattern_point = inv(pattern.transform) * object_point
  ComposedPatternH.pattern_at(pattern, pattern_point, object_point)
end

module ComposedPatternH
  using Main: Element, Color, StripeCheckersPattern

  function pattern_at(pattern::StripeCheckersPattern, p::Element,
                      object_point)::Color
    if (Base.floor(p.x) + Base.floor(p.y) + Base.floor(p.z)) % 2 == 0
      pattern_point = inv(pattern.a.transform) * object_point
      Main.pattern_at(pattern.a, pattern_point)
    else
      pattern_point = inv(pattern.b.transform) * object_point
      Main.pattern_at(pattern.b, pattern_point)
    end
  end
end
