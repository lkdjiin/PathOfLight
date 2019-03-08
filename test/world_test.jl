@testset "World Tests" begin
  @testset "Constructor" begin
    w = World()
    @test isempty(w.objects)
    @test isempty(w.lights)
  end

  @testset "The default world" begin
    light = PointLight(point(-10, 10, -10), Color(1, 1, 1))
    w = default_world()
    @test in(light, w.lights)
    @test w.objects[1].material.color == Color(0.8, 1.0, 0.6)
    @test w.objects[1].material.diffuse == 0.7
    @test w.objects[1].material.specular == 0.2
    @test w.objects[2].transform == scaling(0.5, 0.5, 0.5)
  end

  @testset "Intersect a world with a ray" begin
    w = default_world()
    r = Ray(point(0, 0, -5), vector(0, 0, 1))
    xs = intersect_world(w, r)
    @test length(xs) == 4
    @test xs[1].t == 4.0
    @test xs[2].t == 4.5
    @test xs[3].t == 5.5
    @test xs[4].t == 6.0
  end

end
