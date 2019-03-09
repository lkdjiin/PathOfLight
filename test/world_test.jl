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

end
