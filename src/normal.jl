function normal_at(s::Sphere, world_point::Element)
  object_point = inv(s.transform) * world_point
  object_normal = object_point - Point(0, 0, 0)
  world_normal = permutedims(inv(s.transform)) * object_normal
  normalize(Agent(world_normal))
end

function normal_at(c::Cylinder, world_point::Element)
  local_point = inv(c.transform) * world_point
  local_normal = Agent(local_point.x, 0, local_point.z)
  world_normal = permutedims(inv(c.transform)) * local_normal
  normalize(Agent(world_normal))
end

function normal_at(p::Plane, world_point::Element)
  local_point = inv(p.transform) * world_point
  local_normal = Agent(0, 1, 0)
  world_normal = permutedims(inv(p.transform)) * local_normal
  normalize(Agent(world_normal))
end

function normal_at(c::Cube, world_point::Element)
  local_point = inv(c.transform) * world_point

  maxc = max(abs(local_point.x), abs(local_point.y), abs(local_point.z))
  if maxc == abs(local_point.x)
    local_normal = Agent(local_point.x, 0, 0)
  elseif maxc == abs(local_point.y)
    local_normal = Agent(0, local_point.y, 0)
  else
    local_normal = Agent(0, 0, local_point.z)
  end

  world_normal = permutedims(inv(c.transform)) * local_normal
  normalize(Agent(world_normal))
end
