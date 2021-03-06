function normal_at(s::Shape, world_point::Element)
  local_point = world_to_object(s, world_point)
  local_normal = NormalH.normal_at(s, local_point)
  normal_to_world(s, local_normal)
end

module NormalH
  using Main: Element, Agent, Point, Sphere, Cylinder, Plane, Cube, Cone

  function normal_at(shape::Sphere, point::Element)
    point - Point(0, 0, 0)
  end

  function normal_at(shape::Cylinder, point::Element)
    dist = point.x^2 + point.z^2
    if dist < 1 && point.y >= shape.maximum - Main.epsilon
      Agent(0, 1, 0)
    elseif dist < 1 && point.y <= shape.minimum + Main.epsilon
      Agent(0, -1, 0)
    else
      Agent(point.x, 0, point.z)
    end
  end

  function normal_at(shape::Cone, point::Element)
    y = √(point.x^2 + point.z^2)
    if point.y > 0
      y = -y
    end
    Agent(point.x, y, point.z)
  end

  function normal_at(shape::Plane, point::Element)
    Agent(0, 1, 0)
  end

  function normal_at(shape::Cube, point::Element)
    maxc = max(abs(point.x), abs(point.y), abs(point.z))
    if maxc == abs(point.x)
      Agent(point.x, 0, 0)
    elseif maxc == abs(point.y)
      Agent(0, point.y, 0)
    else
      Agent(0, 0, point.z)
    end
  end
end
