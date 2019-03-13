function normal_at(s::Sphere, world_point::Element)
  object_point = inv(s.transform) * world_point
  object_normal = object_point - Point(0, 0, 0)
  world_normal = permutedims(inv(s.transform)) * object_normal
  normalize(Agent(world_normal))
end

function normal_at(p::Plane, world_point::Element)
  local_point = inv(p.transform) * world_point
  local_normal = Agent(0, 1, 0)
  world_normal = permutedims(inv(p.transform)) * local_normal
  normalize(Agent(world_normal))
end
