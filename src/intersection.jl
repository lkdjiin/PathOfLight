struct Intersection
  object
  t
end

# Find the two points (named t1 and t2) of a ray that intersect with a
# sphere.
#
# When there is only one intersection ( the ray is tangent to the
# sphere) t1 == t2.
#
# Returns a tuple of t1 and t2, or an empty tuple if there is no
# intersections.
function intersects(sphere::Sphere, ray::Ray)::Tuple
  object_space_ray = transform(ray, inv(sphere.transform))

  d = discriminant(object_space_ray)

  if d.discr < 0
    return ()
  end

  t1 = (-d.b - sqrt(d.discr)) / (2 * d.a)
  t2 = (-d.b + sqrt(d.discr)) / (2 * d.a)

  i1=Intersection(sphere, t1)
  i2=Intersection(sphere, t2)

  return (i1, i2)
end

function intersects(cone::Cone, ray::Ray)::Tuple
  xs = []

  osr = transform(ray, inv(cone.transform))

  a = osr.direction.x ^ 2 - osr.direction.y ^ 2 + osr.direction.z ^ 2
  b = 2 * osr.origin.x * osr.direction.x - 2 * osr.origin.y * osr.direction.y + 2 * osr.origin.z * osr.direction.z
  c = osr.origin.x ^ 2 - osr.origin.y ^ 2 + osr.origin.z ^ 2

  if isapprox(a, 0.0, atol=epsilon) && isapprox(b, 0.0, atol=epsilon)
    # ray miss the cone.
  elseif isapprox(a, 0.0, atol=epsilon)
    push!(xs, Intersection(cone, -c / 2b))
  else
    discr = b^2 - 4 * a * c
    if discr < 0.0
      # I think (as in «not sure, fucking math!») that here the ray miss
      # the cone and can't hit a cap.
      return ()
    end

    t1 = (-b - √(discr)) / (2 * a)
    t2 = (-b + √(discr)) / (2 * a)

    # XXX Why are we doing that?
    if t1 > t2
      t1, t2 = t2, t1
    end

    y1 = osr.origin.y + t1 * osr.direction.y
    if cone.minimum < y1 < cone.maximum
      push!(xs, Intersection(cone, t1))
    end
    y2 = osr.origin.y + t2 * osr.direction.y
    if cone.minimum < y2 < cone.maximum
      push!(xs, Intersection(cone, t2))
    end
  end

  IntersectionH.intersect_caps!(cone, osr, xs)

  Tuple(xs)
end

function intersects(cylinder::Cylinder, ray::Ray)::Tuple
  xs = []

  # Convert world space ray to object space ray
  osr = transform(ray, inv(cylinder.transform))

  a = osr.direction.x^2 + osr.direction.z^2

  # ray isn't parallel to the y axis
  if !isapprox(0, a, atol=epsilon)
    b = 2 * osr.origin.x * osr.direction.x + 2 * osr.origin.z * osr.direction.z
    c = osr.origin.x^2 + osr.origin.z^2 - 1
    discr = b^2 - 4 * a * c

    # ray does not intersect the cylinder
    if discr < 0
      return ()
    end

    t1 = (-b - √(discr)) / (2 * a)
    t2 = (-b + √(discr)) / (2 * a)

    # XXX Why are we doing that?
    if t1 > t2
      t1, t2 = t2, t1
    end

    y1 = osr.origin.y + t1 * osr.direction.y
    if cylinder.minimum < y1 < cylinder.maximum
      push!(xs, Intersection(cylinder, t1))
    end
    y2 = osr.origin.y + t2 * osr.direction.y
    if cylinder.minimum < y2 < cylinder.maximum
      push!(xs, Intersection(cylinder, t2))
    end
  end

  IntersectionH.intersect_caps!(cylinder, osr, xs)

  Tuple(xs)
end

function intersects(cube::Cube, ray::Ray)::Tuple
  object_space_ray = transform(ray, inv(cube.transform))
  xtmin, xtmax = IntersectionH.check_axis(object_space_ray.origin.x,
                                          object_space_ray.direction.x)
  ytmin, ytmax = IntersectionH.check_axis(object_space_ray.origin.y,
                                          object_space_ray.direction.y)
  ztmin, ztmax = IntersectionH.check_axis(object_space_ray.origin.z,
                                          object_space_ray.direction.z)
  tmin = max(xtmin, ytmin, ztmin)
  tmax = min(xtmax, ytmax, ztmax)

  if tmin > tmax
    return ()
  end

  (Intersection(cube, tmin), Intersection(cube, tmax))
end

function intersects(plane::Plane, ray::Ray)::Tuple
  object_space_ray = transform(ray, inv(plane.transform))

  if abs(object_space_ray.direction.y) < epsilon
    return ()
  end

  t = -object_space_ray.origin.y / object_space_ray.direction.y
  (Intersection(plane, t), )
end

function intersects(group::Group, ray::Ray)::Tuple
  object_space_ray = transform(ray, inv(group.transform))

  xs = []
  for e in group.childs
    inters = intersects(e, object_space_ray)
    xs = vcat(xs, [x for x=inters])
  end
  xs = sort(xs, by=x -> x.t)
  Tuple(xs)
end

# Remember: the sphere is centered at the world origin and its radius is
# always 1.
function discriminant(ray)
  # The vector from the sphere's center, to the ray origin.
  sphere_to_ray = ray.origin - Point(0, 0, 0)

  a = dot(ray.direction, ray.direction)
  b = 2 * dot(ray.direction, sphere_to_ray)
  c = dot(sphere_to_ray, sphere_to_ray) - 1
  d = b^2 - 4 * a * c
  (discr=d, a=a, b=b)
end

function intersections(args...)
  args
end

# inters: a tuple from `intersections()`
function hit(inters)
  pool = [i for i in inters]
  pool = filter(x -> x.t >= 0, pool)
  if isempty(pool)
    return nothing
  end
  pool = sort(pool, by=x -> x.t)
  first(pool)
end

# Returns
#   - t:
#   - object:
#   - point:
#   - over_point: a point very slightly over the point of interest.
#   - under_point: a point very slightly under the point of interest.
#   - eyev: Agent
#   - normalv: Agent
#   - inside: Boolean, true means inside the object.
#   - reflectv: Agent
#   - n1: entry refractive index
#   - n2: exit refractive index
function prepare_computations(i::Intersection, r::Ray,
                              list_of_intersections=())::NamedTuple
  t = Float64(i.t)
  point = location(r, t)
  eyev = -r.direction
  normalv = normal_at(i.object, point)
  inside = false

  if dot(normalv, eyev) < 0
    inside = true
    normalv = -normalv
  end

  delta = normalv * epsilon
  over_point = point + delta
  under_point = point - delta
  reflectv = reflect(r.direction, normalv)

  if isempty(list_of_intersections)
    list_of_intersections = (i,)
  end
  n1, n2 = IntersectionH.refractive_indices(list_of_intersections, i)

  (t=t, object=i.object, point=point, over_point=over_point,
   under_point=under_point, eyev=eyev, normalv=normalv, inside=inside,
   reflectv=reflectv, n1=n1, n2=n2)
end

# Christophe Schlick designed a fast implementation of an approximation
# to the Fresnel Effect.
function schlick(comps)
  # find the cosine of the angle between the eye and normal vectors
  cos = dot(comps.eyev, comps.normalv)

  # total internal reflection can only occur if n1 > n2
  if comps.n1 > comps.n2
    n = comps.n1 / comps.n2
    sin2_t = n^2 * (1.0 - cos^2)
    if sin2_t > 1.0
      return 1.0
    end
    # compute cosine of theta_t using trig identity
    cos_t = sqrt(1.0 - sin2_t)
    # when n1 > n2, use cos(theta_t) instead
    cos = cos_t
  end

  r0 = ((comps.n1 - comps.n2) / (comps.n1 + comps.n2))^2
  return r0 + (1 - r0) * (1 - cos)^5
end

module IntersectionH
  using Main: Intersection, Ray, Cylinder, Cone

  function refractive_indices(inters::Tuple, hit::Intersection)
    containers = []
    n1 = nothing
    n2 = nothing

    for elem in inters
      if elem == hit
        if isempty(containers)
          n1 = 1.0
        else
          n1 = last(containers).material.refractive_index
        end
      end

      idx = findfirst(x -> x == elem.object, containers)
      if idx == nothing
        push!(containers, elem.object)
      else
        deleteat!(containers, idx)
      end

      if elem == hit
        if isempty(containers)
          n2 = 1.0
        else
          n2 = last(containers).material.refractive_index
        end
        break
      end
    end

    (n1, n2)
  end

  function check_axis(origin, direction)
    tmin_numerator = (-1 - origin)
    tmax_numerator = (1 - origin)

    tmin = tmin_numerator / direction
    tmax = tmax_numerator / direction

    if tmin > tmax
      tmin, tmax = tmax, tmin
    end

    return tmin, tmax
  end

  function check_cap(ray::Ray, t)
    x = ray.origin.x + t * ray.direction.x
    z = ray.origin.z + t * ray.direction.z
    return (x^2 + z^2) <= 1
  end

  function intersect_caps!(cyl::Cylinder, ray::Ray, xs)
    # caps only matter if the cylinder is closed, and might possibly be
    # intersected by the ray.
    if cyl.closed == false || isapprox(ray.direction.y, 0.0, atol=Main.epsilon)
      return
    end
    # check for an intersection with the lower end cap by intersecting
    # the ray with the plane at y=cyl.minimum
    t = (cyl.minimum - ray.origin.y) / ray.direction.y
    if check_cap(ray, t)
      push!(xs, Intersection(cyl, t))
    end
    # check for an intersection with the upper end cap by intersecting
    # the ray with the plane at y=cyl.maximum
    t = (cyl.maximum - ray.origin.y) / ray.direction.y
    if check_cap(ray, t)
      push!(xs, Intersection(cyl, t))
    end
  end

  function check_cap(ray::Ray, t, radius)
    x = ray.origin.x + t * ray.direction.x
    z = ray.origin.z + t * ray.direction.z
    x^2 + z^2 < radius ^ 2
  end

  function intersect_caps!(cone::Cone, ray::Ray, xs)
    if cone.closed == false || isapprox(ray.direction.y, 0.0, atol=Main.epsilon)
      return
    end

    t = (cone.minimum - ray.origin.y) / ray.direction.y
    if check_cap(ray, t, cone.minimum)
      push!(xs, Intersection(cone, t))
    end

    t = (cone.maximum - ray.origin.y) / ray.direction.y
    if check_cap(ray, t, cone.maximum)
      push!(xs, Intersection(cone, t))
    end
  end

end
