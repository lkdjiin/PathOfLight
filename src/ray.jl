struct Ray
  origin::Element
  direction::Element
end

function location(r::Ray, distance::Float64)
  r.origin + r.direction * distance
end

function transform(ray, matrix)::Ray
  Ray(matrix * ray.origin, matrix * ray.direction)
end
