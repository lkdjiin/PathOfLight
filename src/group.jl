mutable struct Group <: Shape
  id::String
  transform
  childs::Array{Shape}
  parent::Union{Shape, Nothing}

  Group() = new(string(UUIDs.uuid1()), identity4, [], nothing)
end

function add_child!(g::Group, s::Shape)
  push!(g.childs, s)
  # TODO Think about it: What if `s.parent == g.id` ?
  s.parent = g
end
