# A ComposedPattern encapsulates two or more simple patterns (Pattern).
abstract type ComposedPattern end

mutable struct StripeCheckersPattern <: ComposedPattern
  a::StripePattern
  b::StripePattern
  transform

  StripeCheckersPattern(a, b) = new(a, b, identity4)
end

# ratio: from 0.0 to 1.0, the blended ratio of a::Pattern. By default
# its value is 0.5, meaning the two patterns contributes equally to the
# resulting color.
#
# Examples:
#
#   pattern.ratio = 0.3
#   # => pattern.a will contributes 30% of the final color
#   # => pattern.b will contributes 70% of the final color
mutable struct BlendedPattern <: ComposedPattern
  a::Pattern
  b::Pattern
  transform
  ratio

  BlendedPattern(a, b) = new(a, b, identity4, 0.5)
end

# Main entry to call a ComposedPattern.
function pattern_at(pattern::ComposedPattern, object::Shape,
                    world_point::Element)::Color
  object_point = world_to_object(object, world_point)
  pattern_point = inv(pattern.transform) * object_point
  ComposedPatternH.pattern_at(pattern, pattern_point, object_point)
end

module ComposedPatternH
  using Main: Element, Color, StripeCheckersPattern, BlendedPattern

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

  function pattern_at(pattern::BlendedPattern, p::Element,
                      object_point)::Color
    pattern_point = inv(pattern.a.transform) * object_point
    color1 = Main.pattern_at(pattern.a, pattern_point)
    pattern_point = inv(pattern.b.transform) * object_point
    color2 = Main.pattern_at(pattern.b, pattern_point)

    color1 * pattern.ratio + color2 * (1.0 - pattern.ratio)
  end
end
