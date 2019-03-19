mutable struct Material
  color::Color
  ambient::Float64
  diffuse::Float64
  specular::Float64
  shininess::Float64
  pattern::Union{Pattern, ComposedPattern, Nothing}
  noise::Union{Noise, Nothing}
  reflective::Float64
  transparency::Float64
  refractive_index::Float64
end

# With default values.
#   color: white
#   ambient: 0.1 (from 0 to 1)
#   diffuse: 0.9 (from 0 to 1)
#   specular: 0.9 (from 0 to 1)
#   shininess: 200.0 (a tiny spotlight)
#   pattern: nothing
#   noise: nothing
#   reflective: 0.0 (from 0 no reflections to 1 full reflection)
#   transparency: 0.0 (so it's opaque)
#   refractive_index: 1.0 (the value for the vacuum/air)
function Material()
  Material(white, 0.1, 0.9, 0.9, 200.0, nothing, nothing, 0.0, 0.0, 1.0)
end

function ==(m1::Material, m2::Material)
  m1.color == m2.color &&
    isapprox(m1.ambient, m2.ambient, atol=epsilon) &&
    isapprox(m1.diffuse, m2.diffuse, atol=epsilon) &&
    isapprox(m1.specular, m2.specular, atol=epsilon) &&
    isapprox(m1.shininess, m2.shininess, atol=epsilon)
end

function lighting(m::Material, object::Shape, light::PointLight, point::Element,
                  eyev::Element, normalv::Element;
                  in_shadow=false)

  color = MaterialH.compute_color(m, object, point, light)
  lightv = MaterialH.light_source_direction(light, point)
  ambient = color * m.ambient

  if in_shadow
    return ambient
  end

  # light_dot_normal represents the cosine of the angle between the
  # light vector and the normal vector. A negative number means the
  # light is on the other side of the surface.
  light_dot_normal = dot(lightv, normalv)

  if light_dot_normal < 0
    diffuse = Color(0, 0, 0)
    specular = Color(0, 0, 0)
  else
    diffuse = color * m.diffuse * light_dot_normal
    specular = MaterialH.compute_specular(m, light, lightv, normalv, eyev)
  end

  ambient + diffuse + specular
end

module MaterialH
  using Main: pattern_at, normalize, reflect, dot, Color, PerlinNoise, Point,
              Material

  function compute_color(m::Material, object, point, light)
    if m.pattern == nothing
      color = m.color
    else
      if m.noise == nothing
        color = pattern_at(m.pattern, object, point)
      else
        delta = m.noise.func(point.x, point.y, point.z) * m.noise.ratio
        new_point = Point(point.x + delta, point.y + delta, point.z + delta)
        color = pattern_at(m.pattern, object, new_point)
      end
    end

    color * light.intensity
  end

  function light_source_direction(light, point)
    normalize(light.position - point)
  end

  function compute_specular(m, light, lightv, normalv, eyev)
    # reflect_dot_eye represents the cosine of the angle between the
    # reflection vector and the eye vector. A negative number means the
    # light reflects away from the eye.
    reflectv = reflect(-lightv, normalv)
    reflect_dot_eye = dot(reflectv, eyev)
    if reflect_dot_eye <= 0
      specular = Color(0, 0, 0)
    else
      # Compute the specular contribution
      factor = reflect_dot_eye ^ m.shininess
      specular = light.intensity * m.specular * factor
    end
    specular
  end
end
