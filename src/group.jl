mutable struct Group <: Shape
  id::String
  transform
  childs::Array{Shape}

  Group() = new(string(UUIDs.uuid1()), identity4, [])
end
