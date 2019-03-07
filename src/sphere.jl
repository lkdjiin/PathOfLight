struct Sphere
  id::String
end

function sphere()
  Sphere(string(UUIDs.uuid1()))
end
