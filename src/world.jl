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

function intersect_world(w::World, r::Ray)
  result = []
  for obj in w.objects
    inters = intersects(obj, r)
    for i in inters
      push!(result, i)
    end
  end
  sort(result, by=x -> x.t)
end

function shade_hit(w::World, comps, remaining=4)
  shadowed = isshadowed(w, comps.over_point)

  surface = lighting(comps.object.material, comps.object, first(w.lights),
                     comps.over_point, comps.eyev, comps.normalv,
                     in_shadow=shadowed)

  reflected = reflected_color(w, comps, remaining)

  surface + reflected
end

function color_at(w::World, r::Ray, remaining=1)
  inters = intersect_world(w, r)
  h = hit(inters)
  if h == nothing
    return Color(0, 0, 0)
  end
  comps = prepare_computations(h, r)
  shade_hit(w, comps, remaining)
end

function isshadowed(w::World, p::Element)
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
