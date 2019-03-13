@testset "Plane Tests" begin
  @testset "Intersect with a ray parallel to the plane" begin
    p = Plane()
    r = Ray(Point(0, 10, 0), Agent(0, 0, 1))
    xs = intersects(p, r)
    @test isempty(xs)
  end

  @testset "Scenario: Intersect with a coplanar ray" begin
    p = Plane()
    r = Ray(Point(0, 0, 0), Agent(0, 0, 1))
    xs = intersects(p, r)
    @test isempty(xs)
  end

  @testset "A ray intersecting a plane from above" begin
    p = Plane()
    r = Ray(Point(0, 1, 0), Agent(0, -1, 0))
    xs = intersects(p, r)
    @test length(xs) == 1
    @test xs.i1.t == 1
    @test xs.i1.object == p
  end

  @testset "A ray intersecting a plane from below" begin
    p = Plane()
    r = Ray(Point(0, -1, 0), Agent(0, 1, 0))
    xs = intersects(p, r)
    @test length(xs) == 1
    @test xs.i1.t == 1
    @test xs.i1.object == p
  end

end
