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

function translation(x, y, z)
  result = copy(identity4)
  result[1, 4] = x
  result[2, 4] = y
  result[3, 4] = z
  result
end

function scaling(x, y, z)
  result = copy(identity4)
  result[1, 1] = x
  result[2, 2] = y
  result[3, 3] = z
  result
end

function rotation_x(radians)
  result = copy(identity4)
  result[2, 2] = cos(radians)
  result[3, 3] = cos(radians)
  result[2, 3] = -sin(radians)
  result[3, 2] = sin(radians)
  result
end

function rotation_y(radians)
  result = copy(identity4)
  result[1, 1] = cos(radians)
  result[3, 3] = cos(radians)
  result[1, 3] = sin(radians)
  result[3, 1] = -sin(radians)
  result
end

function rotation_z(radians)
  result = copy(identity4)
  result[1, 1] = cos(radians)
  result[2, 2] = cos(radians)
  result[1, 2] = -sin(radians)
  result[2, 1] = sin(radians)
  result
end

function shearing(xy, xz, yx, yz, zx, zy)
  result = copy(identity4)
  result[1, 2] = xy
  result[1, 3] = xz
  result[2, 1] = yx
  result[2, 3] = yz
  result[3, 1] = zx
  result[3, 2] = zy
  result
end

function view_transform(from, to, up)
  forwardv = normalize(to - from)
  leftv = cross(forwardv, normalize(up))
  true_upv = cross(leftv, forwardv)

  orientation = [ leftv.x     leftv.y     leftv.z    0.0;
                  true_upv.x  true_upv.y  true_upv.z 0.0;
                 -forwardv.x -forwardv.y -forwardv.z 0.0;
                  0.0         0.0         0.0        1.0]

  orientation * translation(-from.x, -from.y, -from.z)
end
