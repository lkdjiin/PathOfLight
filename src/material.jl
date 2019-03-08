struct Material
  color::Color
  ambient::Float64
  diffuse::Float64
  specular::Float64
  shininess::Float64
end

# With default values.
function Material()
  Material(Color(1, 1, 1), 0.1, 0.9, 0.9, 200.0)
end

function color(m::Material, value::Color)
  Material(value, m.ambient, m.diffuse, m.specular, m.shininess)
end

function ambient(m::Material, value::Float64)
  Material(m.color, value, m.diffuse, m.specular, m.shininess)
end

function diffuse(m::Material, value::Float64)
  Material(m.color, m.ambient, value, m.specular, m.shininess)
end

function specular(m::Material, value::Float64)
  Material(m.color, m.ambient, m.diffuse, value, m.shininess)
end

function shininess(m::Material, value::Float64)
  Material(m.color, m.ambient, m.diffuse, m.specular, value)
end
