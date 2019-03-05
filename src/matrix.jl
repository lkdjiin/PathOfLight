const identity4 = [1.0 0.0 0.0 0.0;
                   0.0 1.0 0.0 0.0;
                   0.0 0.0 1.0 0.0;
                   0.0 0.0 0.0 1.0]

function matrix_compare(a, b)
  if size(a) != size(b)
    return false
  end

  for i in eachindex(a)
    if !isapprox(a[i], b[i], atol=epsillon)
      return false
    end
  end

  true
end

function *(matrix::Array{Float64,2}, el::Element)
  x, y, z, w = matrix * [el.x, el.y, el.z, el.w]
  Element(x, y, z, w)
end

function *(matrix::Array{Int64,2}, el::Element)
  *(map(Float64, matrix), el)
end

function is_invertible(matrix)
  LinearAlgebra.det(matrix) > 0
end
