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

mutable struct RingPattern <: Pattern
  a::Color
  b::Color
  transform

  RingPattern(a, b) = new(a, b, identity4)
end

mutable struct CheckersPattern <: Pattern
  a::Color
  b::Color
  transform

  CheckersPattern(a, b) = new(a, b, identity4)
end

mutable struct RadialGradientPattern <: Pattern
  a::Color
  b::Color
  transform

  RadialGradientPattern(a, b) = new(a, b, identity4)
end

# Main entry to call a simple Pattern.
function pattern_at(pattern::Pattern, object::Shape,
                    world_point::Element)::Color
  object_point = inv(object.transform) * world_point
  pattern_point = inv(pattern.transform) * object_point
  PatternH.pattern_at(pattern, pattern_point)
end

# Typically called by a ComposedPatternH function.
function pattern_at(p::Pattern, pp::Element)
  PatternH.pattern_at(p, pp)
end

module PatternH
  using Main: StripePattern, GradientPattern, RingPattern, CheckersPattern,
              RadialGradientPattern, Element, Color, magnitude

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

  function pattern_at(pattern::RingPattern, p::Element)::Color
    if Base.floor(sqrt(p.x ^ 2 + p.z ^ 2)) % 2 == 0.0
      pattern.a
    else
      pattern.b
    end
  end

  function pattern_at(pattern::RadialGradientPattern, p::Element)::Color
    distance = pattern.b - pattern.a
    m = magnitude(p)
    fraction = m - Base.floor(m)
    pattern.a + distance * fraction
  end

  function pattern_at(pattern::CheckersPattern, p::Element)::Color
    if (Base.floor(p.x) + Base.floor(p.y) + Base.floor(p.z)) % 2 == 0
      pattern.a
    else
      pattern.b
    end
  end
end
