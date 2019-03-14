struct StripePattern
  a::Color
  b::Color
end

function stripe_at(pattern, point)
  if Base.floor(point.x) % 2 == 0
    pattern.a
  else
    pattern.b
  end
end
