@testset "Sphere Tests" begin

  @testset "It is a shape" begin
    s = Sphere()
    @test s isa Shape
  end

  @testset "Intersect sets the object on the intersection" begin
    r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
    s = Sphere()
    xs = intersects(s, r)
    @test length(xs) == 2
    @test xs[1].object == s
    @test xs[2].object == s
  end

  @testset "helper for producing a sphere with a glassy material" begin
    s = GlassSphere()
    @test s.transform == identity4
    @test s.material.transparency == 1.0
    @test s.material.refractive_index == 1.5
  end

end
