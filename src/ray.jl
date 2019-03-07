struct Ray
  origin::Element
  direction::Element
end

function location(r::Ray, distance::Float64)
  r.origin + r.direction * distance
end
