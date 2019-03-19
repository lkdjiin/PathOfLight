mutable struct World
  objects::Array{Shape}
  lights
end

World() = World([], [])

function default_world()
  s1 = Sphere()
  s1.material.color = Color(0.8, 1.0, 0.6)
  s1.material.diffuse = 0.7
  s1.material.specular = 0.2

  s2 = Sphere()
  s2.transform = scaling(0.5, 0.5, 0.5)

  light = PointLight(Point(-10, 10, -10), Color(1, 1, 1))

  World([s1, s2], [light])
end

function intersect_world(w::World, r::Ray)::Tuple
  result = []
  for obj in w.objects
    inters = intersects(obj, r)
    for i in inters
      push!(result, i)
    end
  end
  Tuple(sort(result, by=x -> x.t))
end

function shade_hit(w::World, comps, remaining=4)
  shadowed = isshadowed(w, comps.over_point)

  surface = lighting(comps.object.material, comps.object, first(w.lights),
                     comps.over_point, comps.eyev, comps.normalv,
                     in_shadow=shadowed)
  reflected = reflected_color(w, comps, remaining)
  refracted = refracted_color(w, comps, remaining)

  material = comps.object.material

  if material.reflective > 0.0 && material.transparency > 0.0
    reflectance = schlick(comps)
    surface + reflected * reflectance + refracted * (1 - reflectance)
  else
    surface + reflected + refracted
  end
end

function color_at(w::World, r::Ray, remaining=4)
  inters = intersect_world(w, r)
  h = hit(inters)
  if h == nothing
    return Color(0, 0, 0)
  end
  comps = prepare_computations(h, r, inters)
  shade_hit(w, comps, remaining)
end

function isshadowed(w::World, p::Element)::Bool
  v = first(w.lights).position - p
  distance = magnitude(v)
  r = Ray(p, normalize(v))
  inters = intersect_world(w, r)
  h = hit(inters)
  if h != nothing && h.t < distance
    true
  else
    false
  end
end

function reflected_color(w::World, comps, remaining)

  if remaining < 1 || comps.object.material.reflective == 0.0
    black
  else
    reflect_ray = Ray(comps.over_point, comps.reflectv)
    color = color_at(w, reflect_ray, remaining - 1)
    color * comps.object.material.reflective
  end
end

function refracted_color(w::World, comps, remaining)
  if remaining < 1
    return black
  end

  if comps.object.material.transparency == 0.0
    return black
  end

  # Find the ratio of first index of refraction to the second.
  # (Yup, this is inverted from the definition of Snell's Law.)
  n_ratio = comps.n1 / comps.n2
  # cos(theta_i) is the same as the dot product of the two vectors
  cos_i = dot(comps.eyev, comps.normalv)
  # Find sin(theta_t)^2 via trigonometric identity
  sin2_t = n_ratio^2 * (1 - cos_i^2)

  if sin2_t > 1.0
    return black
  end

  # Find cos(theta_t) via trigonometric identity
  cos_t = sqrt(1.0 - sin2_t)
  # Compute the direction of the refracted ray
  direction = comps.normalv * (n_ratio * cos_i - cos_t) - comps.eyev * n_ratio
  # Create the refracted ray
  refract_ray = Ray(comps.under_point, direction)
  # Find the color of the refracted ray, making sure to multiply
  # by the transparency value to account for any opacity
  color = color_at(w, refract_ray, remaining - 1) * comps.object.material.transparency

  return color
end

