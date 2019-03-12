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
    @test xs.i1.object == s
    @test xs.i2.object == s
  end

end
