@testset "Cones Tests" begin

  @testset "Intersecting a cone with a ray" begin
    shape = Cone()

    xs = intersects(shape, Ray(Point(0, 0, -1), normalize(Agent(1, 0, 0))))
    @test length(xs) == 0

    xs = intersects(shape, Ray(Point(0, 0, -5), normalize(Agent(0, 0, 1))))
    @test length(xs) == 2
    @test xs[1].t == 5
    @test xs[2].t == 5

    xs = intersects(shape, Ray(Point(0, 0, -5), normalize(Agent(1, 1, 1))))
    @test length(xs) == 2
    @test isapprox(xs[1].t, 8.66025, atol=epsilon)
    @test isapprox(xs[2].t, 8.66025, atol=epsilon)

    xs = intersects(shape, Ray(Point(1, 1, -5), normalize(Agent(-0.5, -1, 1))))
    @test length(xs) == 2
    @test isapprox(xs[1].t, 4.55006, atol=epsilon)
    @test isapprox(xs[2].t, 49.44994, atol=epsilon)
  end

  @testset "Intersecting a cone with a ray parallel to one of its halves" begin
    shape = Cone()
    direction = normalize(Agent(0, 1, 1))
    r = Ray(Point(0, 0, -1), direction)
    xs = intersects(shape, r)
    @test length(xs) == 1
    @test isapprox(xs[1].t, 0.35355, atol=epsilon)
  end

  @testset "Intersecting a cone's end caps" begin
    shape = Cone()
    shape.minimum = -0.5
    shape.maximum = 0.5
    shape.closed = true

    xs = intersects(shape, Ray(Point(0, 0, -5), normalize(Agent(0, 1, 0))))
    @test length(xs) == 0

    xs = intersects(shape, Ray(Point(0, 0, -0.25), normalize(Agent(0, 1, 1))))
    @test length(xs) == 2

    xs = intersects(shape, Ray(Point(0, 0, -0.25), normalize(Agent(0, 1, 0))))
    @test length(xs) == 4
  end

  @testset "Computing the normal vector on a cone" begin
    shape = Cone()
    @test NormalH.normal_at(shape, Point(0, 0, 0)) == Agent(0, 0, 0)
    @test NormalH.normal_at(shape, Point(1, 1, 1)) == Agent(1, -√2, 1)
    @test NormalH.normal_at(shape, Point(-1, -1, 0)) == Agent(-1, 1, 0)
  end

end
