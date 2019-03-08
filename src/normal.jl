function normal_at(s::Sphere, world_point::Element)
  object_point = inv(s.transform) * world_point
  object_normal = object_point - point(0, 0, 0)
  world_normal = permutedims(inv(s.transform)) * object_normal
  normalize(vector(world_normal))
end
