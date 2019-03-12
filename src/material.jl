mutable struct Material
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

function ==(m1::Material, m2::Material)
  m1.color == m2.color &&
    isapprox(m1.ambient, m2.ambient, atol=epsilon) &&
    isapprox(m1.diffuse, m2.diffuse, atol=epsilon) &&
    isapprox(m1.specular, m2.specular, atol=epsilon) &&
    isapprox(m1.shininess, m2.shininess, atol=epsilon)
end

function lighting(m::Material, light::PointLight, point::Element,
                  eyev::Element, normalv::Element;
                  in_shadow=false)
  # Combine the surface color with the light's color/intensity.
  effective_color = m.color * light.intensity

  # Find the direction to the light source.
  lightv = normalize(light.position - point)

  # Compute the ambient contribution.
  ambient = effective_color * m.ambient

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
    # Compute the diffuse contribution
    diffuse = effective_color * m.diffuse * light_dot_normal

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
  end

  ambient + diffuse + specular
end
