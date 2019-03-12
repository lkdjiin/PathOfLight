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
function intersects(sphere::Sphere, ray::Ray)
  object_space_ray = transform(ray, inv(sphere.transform))
  d = discriminant(object_space_ray)

  if d.discr < 0
    return ()
  end

  t1 = (-d.b - sqrt(d.discr)) / (2 * d.a)
  t2 = (-d.b + sqrt(d.discr)) / (2 * d.a)

  i1=Intersection(sphere, t1)
  i2=Intersection(sphere, t2)

  return (i1=i1, i2=i2)
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

function prepare_computations(i::Intersection, r::Ray)
  t = Float64(i.t)
  point = location(r, t)
  eyev = -r.direction
  normalv = normal_at(i.object, point)
  inside = false

  if dot(normalv, eyev) < 0
    inside = true
    normalv = -normalv
  end

  over_point = point + normalv * epsilon

  (t=t, object=i.object, point=point, over_point=over_point, eyev=eyev,
   normalv=normalv, inside=inside)
end
