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

  @testset "Translating a ray" begin
    r = Ray(point(1, 2, 3), vector(0, 1, 0))
    m = translation(3, 4, 5)
    r2 = transform(r, m)
    @test r2.origin == point(4, 6, 8)
    @test r2.direction == vector(0, 1, 0)
  end

  @testset "Scaling a ray" begin
    r = Ray(point(1, 2, 3), vector(0, 1, 0))
    m = scaling(2, 3, 4)
    r2 = transform(r, m)
    @test r2.origin == point(2, 6, 12)
    @test r2.direction == vector(0, 3, 0)
  end

end
