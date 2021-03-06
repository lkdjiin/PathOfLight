@testset "World Tests" begin
  @testset "Constructor" begin
    w = World()
    @test isempty(w.objects)
    @test isempty(w.lights)
  end

  @testset "The default world" begin
    light = PointLight(Point(-10, 10, -10), Color(1, 1, 1))
    w = default_world()
    @test in(light, w.lights)
    @test w.objects[1].material.color == Color(0.8, 1.0, 0.6)
    @test w.objects[1].material.diffuse == 0.7
    @test w.objects[1].material.specular == 0.2
    @test w.objects[2].transform == scaling(0.5, 0.5, 0.5)
  end

  @testset "Intersect a world with a ray" begin
    w = default_world()
    r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
    xs = intersect_world(w, r)
    @test length(xs) == 4
    @test xs[1].t == 4.0
    @test xs[2].t == 4.5
    @test xs[3].t == 5.5
    @test xs[4].t == 6.0
  end

  @testset "Shading" begin
    @testset "an intersection" begin
      w = default_world()
      r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
      shape = first(w.objects)
      i = Intersection(shape, 4)
      comps = prepare_computations(i, r)
      c = shade_hit(w, comps)
      @test c == Color(0.38066, 0.47583, 0.2855)
    end

    @testset "an intersection from the inside" begin
      w = default_world()
      w.lights = [PointLight(Point(0, 0.25, 0), Color(1, 1, 1))]
      r = Ray(Point(0, 0, 0), Agent(0, 0, 1))
      shape = w.objects[2]
      i = Intersection(shape, 0.5)
      comps = prepare_computations(i, r)
      c = shade_hit(w, comps)
      @test c == Color(0.90498, 0.90498, 0.90498)
    end
  end

  @testset "color_at()" begin
    @testset "when a ray misses" begin
      w = default_world()
      r = Ray(Point(0, 0, -5), Agent(0, 1, 0))
      c = color_at(w, r)
      @test c == Color(0, 0, 0)
    end

    @testset "when a ray hits" begin
      w = default_world()
      r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
      c = color_at(w, r)
      @test c == Color(0.38066, 0.47583, 0.2855)
    end

    @testset "with an intersection behind the ray" begin
      w = default_world()
      outer = w.objects[1]
      outer.material.ambient = 1.0
      inner = w.objects[2]
      inner.material.ambient = 1.0
      r = Ray(Point(0, 0, 0.75), Agent(0, 0, -1))
      c = color_at(w, r)
      @test c == inner.material.color
    end
  end

  @testset "isshadowed()" begin
    @testset "when nothing is collinear with point and light" begin
      w = default_world()
      p = Point(0, 10, 0)
      @test isshadowed(w, p) == false
    end

    @testset "when an object is between the point and the light" begin
      w = default_world()
      p = Point(10, -10, 10)
      @test isshadowed(w, p) == true
    end

    @testset "when an object is behind the light" begin
      w = default_world()
      p = Point(-20, 20, -20)
      @test isshadowed(w, p) == false
    end

    @testset "when an object is behind the point" begin
      w = default_world()
      p = Point(-2, 2, -2)
      @test isshadowed(w, p) == false
    end
  end

  @testset "reflections" begin
    @testset "The reflected color for a nonreflective material" begin
      w = default_world()
      r = Ray(Point(0, 0, 0), Agent(0, 0, 1))
      shape = w.objects[2]
      shape.material.ambient = 1
      i = Intersection(shape, 1)
      comps = prepare_computations(i, r)
      color = reflected_color(w, comps, 1)
      @test color == Color(0, 0, 0)
    end

    @testset "The reflected color for a reflective material" begin
      w = default_world()
      shape = Plane()
      shape.material.reflective = 0.5
      shape.transform = translation(0, -1, 0)
      push!(w.objects, shape)
      r = Ray(Point(0, 0, -3), Agent(0, -√2/2, √2/2))
      i = Intersection(shape, √2)
      comps = prepare_computations(i, r)
      color = reflected_color(w, comps, 1)
      @test color == Color(0.19033, 0.23791, 0.142749)
    end

    @testset "shade_hit() with a reflective material" begin
      w = default_world()
      shape = Plane()
      shape.material.reflective = 0.5
      shape.transform = translation(0, -1, 0)
      push!(w.objects, shape)
      r = Ray(Point(0, 0, -3), Agent(0, -√2/2, √2/2))
      i = Intersection(shape, √2)
      comps = prepare_computations(i, r)
      color = shade_hit(w, comps)
      @test color == Color(0.87675, 0.92434, 0.82917)
    end

    @testset "color_at() with mutually reflective surfaces" begin
      w = World()
      push!(w.lights, PointLight(Point(0, 0, 0), Color(1, 1, 1)))
      lower = Plane()
      lower.material.reflective = 1.0
      lower.transform = translation(0, -1, 0)
      push!(w.objects, lower)
      upper = Plane()
      upper.material.reflective = 1.0
      upper.transform = translation(0, 1, 0)
      push!(w.objects, upper)
      r = Ray(Point(0, 0, 0), Agent(0, 1, 0))
      @test color_at(w, r) isa Color
    end

    @testset "The reflected color at the maximum recursive depth" begin
      w = default_world()
      shape = Plane()
      shape.material.reflective = 0.5
      shape.transform = translation(0, -1, 0)
      push!(w.objects, shape)
      r = Ray(Point(0, 0, -3), Agent(0, -√2/2, √2/2))
      i = Intersection(shape, √2)
      comps = prepare_computations(i, r)
      color = reflected_color(w, comps, 0)
      @test color == black
    end
  end

  @testset "refractions" begin
    @testset "with an opaque surface" begin
      w = default_world()
      shape = w.objects[1]
      r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
      xs = intersections(Intersection(shape, 4), Intersection(shape, 6))
      comps = prepare_computations(xs[1], r, xs)
      c = refracted_color(w, comps, 5)
      @test c == black
    end

    @testset "at the maximum recursive depth" begin
      w = default_world()
      shape = w.objects[1]
      shape.material.transparency = 1.0
      shape.material.refractive_index = 1.5
      r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
      xs = intersections(Intersection(shape, 4), Intersection(shape, 6))
      comps = prepare_computations(xs[1], r, xs)
      c = refracted_color(w, comps, 0)
      @test c == black
    end

    @testset "under total internal reflection" begin
      w = default_world()
      shape = w.objects[1]
      shape.material.transparency = 1.0
      shape.material.refractive_index = 1.5
      r = Ray(Point(0, 0, √2/2), Agent(0, 1, 0))
      xs = intersections(Intersection(shape, -√2/2), Intersection(shape, √2/2))
      # NOTE: this time you're inside the sphere, so you need
      # to look at the second intersection, xs[2], not xs[1]
      comps = prepare_computations(xs[2], r, xs)
      c = refracted_color(w, comps, 5)
      @test c == black
    end

    @testset "with a refracted ray" begin
      w = default_world()
      a = w.objects[1]
      a.material.ambient = 1.0
      a.material.pattern = TestPattern()
      b = w.objects[2]
      b.material.transparency = 1.0
      b.material.refractive_index = 1.5
      r = Ray(Point(0, 0, 0.1), Agent(0, 1, 0))
      xs = intersections(Intersection(a, -0.9899), Intersection(b, -0.4899),
                         Intersection(b, 0.4899), Intersection(a, 0.9899))
      comps = prepare_computations(xs[3], r, xs)
      c = refracted_color(w, comps, 5)
      @test c == Color(0, 0.99888, 0.04721)
    end

    @testset "shade_hit() with a transparent material" begin
      w = default_world()
      floor = Plane()
      floor.transform = translation(0, -1, 0)
      floor.material.transparency = 0.5
      floor.material.refractive_index = 1.5
      push!(w.objects, floor)
      ball = Sphere()
      ball.material.color = Color(1, 0, 0)
      ball.material.ambient = 0.5
      ball.transform = translation(0, -3.5, -0.5)
      push!(w.objects, ball)
      r = Ray(Point(0, 0, -3), Agent(0, -√2/2, √2/2))
      xs = intersections(Intersection(floor, √2))
      comps = prepare_computations(xs[1], r, xs)
      color = shade_hit(w, comps, 5)
      @test color == Color(0.93642, 0.68642, 0.68642)
    end

    @testset "shade_hit() with a reflective, transparent material" begin
      w = default_world()
      r = Ray(Point(0, 0, -3), Agent(0, -√2/2, √2/2))
      floor = Plane()
      floor.transform = translation(0, -1, 0)
      floor.material.reflective = 0.5
      floor.material.transparency = 0.5
      floor.material.refractive_index = 1.5
      push!(w.objects, floor)
      ball = Sphere()
      ball.material.color = Color(1, 0, 0)
      ball.material.ambient = 0.5
      ball.transform = translation(0, -3.5, -0.5)
      push!(w.objects, ball)
      xs = intersections(Intersection(floor, √2))
      comps = prepare_computations(xs[1], r, xs)
      color = shade_hit(w, comps, 5)
      @test color == Color(0.93391, 0.69643, 0.69243)
    end

  end
end
