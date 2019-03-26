# shadow: You can disable the cast of a shadow for the whole group by
#   setting this field to `:off`. It's `:on` by default like a normal
#   shape.
mutable struct Group <: Shape
  id::String
  transform
  shadow
  childs::Array{Shape}
  parent::Union{Shape, Nothing}

  Group() = new(string(UUIDs.uuid1()), identity4, :on, [], nothing)
end

function add_child!(g::Group, s::Shape)
  push!(g.childs, s)
  # TODO Think about it: What if `s.parent == g.id` ?
  s.parent = g
end
