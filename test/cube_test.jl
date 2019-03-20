@testset "Cube Tests" begin

  @testset "A ray intersects a cube at +x" begin
    c = Cube()
    r = Ray(Point(5, 0.5, 0), Agent(-1, 0, 0))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6
  end

  @testset "A ray intersects a cube at -x" begin
    c = Cube()
    r = Ray(Point(-5, 0.5, 0), Agent(1, 0, 0))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6
  end

  @testset "A ray intersects a cube at +y" begin
    c = Cube()
    r = Ray(Point(0.5, 5, 0), Agent(0, -1, 0))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6
  end

  @testset "A ray intersects a cube at -y" begin
    c = Cube()
    r = Ray(Point(0.5, -5, 0), Agent(0, 1, 0))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6
  end

  @testset "A ray intersects a cube at +z" begin
    c = Cube()
    r = Ray(Point(0.5, 0, 5), Agent(0, 0, -1))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6
  end

  @testset "A ray intersects a cube at -z" begin
    c = Cube()
    r = Ray(Point(0.5, 0, -5), Agent(0, 0, 1))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6
  end

  @testset "A ray inside a cube" begin
    c = Cube()
    r = Ray(Point(0, 0.5, 0), Agent(0, 0, 1))
    xs = intersects(c, r)
    @test length(xs) == 2
    @test xs[1].t == -1
    @test xs[2].t == 1
  end

  @testset "A ray misses a cube" begin
    c = Cube()

    r = Ray(Point(-2, 0, 0), Agent(0.2673, 0.5345, 0.8018))
    xs = intersects(c, r)
    @test length(xs) == 0

    r = Ray(Point(0, -2, 0), Agent(0.8018, 0.2673, 0.5345))
    xs = intersects(c, r)
    @test length(xs) == 0

    r = Ray(Point(0, 0, -2), Agent(0.5345, 0.8018, 0.2673))
    xs = intersects(c, r)
    @test length(xs) == 0

    r = Ray(Point(2, 0, 2), Agent(0, 0, -1))
    xs = intersects(c, r)
    @test length(xs) == 0

    r = Ray(Point(0, 0, 2), Agent(0, -1, 0))
    xs = intersects(c, r)
    @test length(xs) == 0

    r = Ray(Point(2, 2, 0), Agent(-1, 0, 0))
    xs = intersects(c, r)
    @test length(xs) == 0
  end

  @testset "The normal on the surface of a cube" begin
    c = Cube()

    normal = normal_at(c, Point(1, 0.5, -0.8))
    @test normal == Agent(1, 0, 0)

    normal = normal_at(c, Point(-1, -0.2, 0.9))
    @test normal == Agent(-1, 0, 0)

    normal = normal_at(c, Point(-0.4, 1, -0.1))
    @test normal == Agent(0, 1, 0)

    normal = normal_at(c, Point(0.3, -1, -0.7))
    @test normal == Agent(0, -1, 0)

    normal = normal_at(c, Point(-0.6, 0.3, 1))
    @test normal == Agent(0, 0, 1)

    normal = normal_at(c, Point(0.4, 0.4, -1))
    @test normal == Agent(0, 0, -1)

    normal = normal_at(c, Point(1, 1, 1))
    @test normal == Agent(1, 0, 0)

    normal = normal_at(c, Point(-1, -1, -1))
    @test normal == Agent(-1, 0, 0)

  end

end
