function normal_at(s::Sphere, world_point::Element)
  object_point = inv(s.transform) * world_point
  object_normal = object_point - Point(0, 0, 0)
  world_normal = permutedims(inv(s.transform)) * object_normal
  normalize(Agent(world_normal))
end
