struct Color
  red::Float64
  green::Float64
  blue::Float64
end

# Sometimes it's easier (or makes sens) to construct a Color from a
# red/green/blue tuple.
function Color((r, g, b))
  Color(r, g, b)
end

function ==(a::Color, b::Color)
  if isapprox(a.red, b.red, atol=epsilon) &&
    isapprox(a.green, b.green, atol=epsilon) &&
    isapprox(a.blue, b.blue, atol=epsilon)
     return true
  else
     return false
  end
end

function !=(a::Color, b::Color)
  return !(a == b)
end

function +(a::Color, b::Color)
  Color(rgb(a) .+ rgb(b))
end

function rgb(x::Color)
  (x.red, x.green, x.blue)
end

function -(a::Color, b::Color)
  Color(rgb(a) .- rgb(b))
end

function *(a::Color, b::Color)
  Color(rgb(a) .* rgb(b))
end

function *(a::Color, scalar::Number)
  Color(rgb(a) .* scalar)
end
