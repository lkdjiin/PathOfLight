const epsilon = 0.00001::Float64

struct Element
  x::Float64
  y::Float64
  z::Float64
  w::Float64
end

Point(x, y, z) = Element(x, y, z, 1.0)

Agent(x, y, z) = Element(x, y, z, 0.0)

Agent(el::Element) = Element(el.x, el.y, el.z, 0)

function ispoint(x::Element)
  x.w == 1
end

function isvector(x::Element)
  x.w == 0
end

function ==(a::Element, b::Element)
  if a.w ≠ b.w
    return false
  end
  if isapprox(a.x, b.x, atol=epsilon) && isapprox(a.y, b.y, atol=epsilon) &&
                                          isapprox(a.z, b.z, atol=epsilon)
     return true
  else
     return false
  end
end

function !=(a::Element, b::Element)
  return !(a == b)
end

function +(a::Element, b::Element)
  Element(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
end

function -(a::Element, b::Element)
  Element(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
end

function -(a::Element)
  Element(0 - a.x, 0 - a.y, 0 - a.z, 0 - a.w)
end

function *(a::Element, scalar)
  Element(a.x * scalar, a.y * scalar, a.z * scalar, a.w * scalar)
end

function /(a::Element, scalar)
  Element(a.x / scalar, a.y / scalar, a.z / scalar, a.w / scalar)
end

function magnitude(a::Element)
  sqrt(a.x^2 + a.y^2 + a.z^2 + a.w^2)
end

function normalize(a::Element)
  m = magnitude(a)
  Element(a.x / m, a.y / m, a.z / m, a.w / m)
end

function dot(a::Element, b::Element)
  a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
end

function cross(a::Element, b::Element)
  Agent(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

function reflect(v::Element, normal::Element)
  v - normal * 2 * dot(v, normal)
end
