@testset "Ray Tests" begin
  @testset "Creating and querying a ray" begin
    origin = point(1, 2, 3)
    direction = vector(4, 5, 6)
    r = Ray(origin, direction)
    @test r.origin == origin
    @test r.direction == direction
  end

  @testset "Computing a point from a distance" begin
    r = Ray(point(2, 3, 4), vector(1, 0, 0))
    @test location(r, 0.0) == point(2, 3, 4)
    @test location(r, 1.0) == point(3, 3, 4)
    @test location(r, -1.0) == point(1, 3, 4)
    @test location(r, 2.5) == point(4.5, 3, 4)
  end

end
