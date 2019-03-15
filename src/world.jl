mutable struct World
  objects
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

function shade_hit(w::World, comps)
  shadowed = isshadowed(w, comps.over_point)

  lighting(comps.object.material, comps.object, first(w.lights),
           comps.over_point, comps.eyev, comps.normalv, in_shadow=shadowed)
end

function color_at(w::World, r::Ray)
  inters = intersect_world(w, r)
  h = hit(inters)
  if h == nothing
    return Color(0, 0, 0)
  end
  comps = prepare_computations(h, r)
  shade_hit(w, comps)
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
