struct World
  objects
  lights
end

World() = World([], [])

function default_world()
  s1 = Sphere()
  material = color(s1.material, Color(0.8, 1.0, 0.6))
  material = diffuse(material, 0.7)
  material = specular(material, 0.2)
  s1.material = material

  s2 = Sphere()
  s2.transform = scaling(0.5, 0.5, 0.5)

  light = PointLight(point(-10, 10, -10), Color(1, 1, 1))

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
