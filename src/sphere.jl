struct Sphere
  id::String
end

function Sphere()
  Sphere(string(UUIDs.uuid1()))
end
