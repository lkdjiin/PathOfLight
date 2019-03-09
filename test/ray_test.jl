@testset "Ray Tests" begin
  @testset "Creating and querying a ray" begin
    origin = Point(1, 2, 3)
    direction = Agent(4, 5, 6)
    r = Ray(origin, direction)
    @test r.origin == origin
    @test r.direction == direction
  end

  @testset "Computing a point from a distance" begin
    r = Ray(Point(2, 3, 4), Agent(1, 0, 0))
    @test location(r, 0.0) == Point(2, 3, 4)
    @test location(r, 1.0) == Point(3, 3, 4)
    @test location(r, -1.0) == Point(1, 3, 4)
    @test location(r, 2.5) == Point(4.5, 3, 4)
  end

  @testset "Translating a ray" begin
    r = Ray(Point(1, 2, 3), Agent(0, 1, 0))
    m = translation(3, 4, 5)
    r2 = transform(r, m)
    @test r2.origin == Point(4, 6, 8)
    @test r2.direction == Agent(0, 1, 0)
  end

  @testset "Scaling a ray" begin
    r = Ray(Point(1, 2, 3), Agent(0, 1, 0))
    m = scaling(2, 3, 4)
    r2 = transform(r, m)
    @test r2.origin == Point(2, 6, 12)
    @test r2.direction == Agent(0, 3, 0)
  end

end
