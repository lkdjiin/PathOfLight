@testset "Cylinder Tests" begin
  @testset "A ray misses a cylinder" begin
    xs = intersects(Cylinder(), Ray(Point(1, 0, 0), normalize(Agent(0, 1, 0))))
    @test length(xs) == 0

    xs = intersects(Cylinder(), Ray(Point(0, 0, 0), normalize(Agent(0, 1, 0))))
    @test length(xs) == 0

    xs = intersects(Cylinder(), Ray(Point(0, 0, -5), normalize(Agent(1, 1, 1))))
    @test length(xs) == 0
  end

  @testset "A ray strikes a cylinder" begin
    r = Ray(Point(1, 0, -5), normalize(Agent(0, 0, 1)))
    xs = intersects(Cylinder(), r)
    @test length(xs) == 2
    @test xs[1].t == 5
    @test xs[2].t == 5

    r = Ray(Point(0, 0, -5), normalize(Agent(0, 0, 1)))
    xs = intersects(Cylinder(), r)
    @test length(xs) == 2
    @test xs[1].t == 4
    @test xs[2].t == 6

    r = Ray(Point(0.5, 0, -5), normalize(Agent(0.1, 1, 1)))
    xs = intersects(Cylinder(), r)
    @test length(xs) == 2
    @test isapprox(xs[1].t, 6.80798, atol=epsilon)
    @test isapprox(xs[2].t, 7.08872, atol=epsilon)
  end

  @testset "Normal vector on a cylinder" begin
    n = normal_at(Cylinder(), Point(1, 0, 0))
    @test n == Agent(1, 0, 0)

    n = normal_at(Cylinder(), Point(0, 5, -1))
    @test n == Agent(0, 0, -1)

    n = normal_at(Cylinder(), Point(0, -2, 1))
    @test n == Agent(0, 0, 1)

    n = normal_at(Cylinder(), Point(-1, 1, 0))
    @test n == Agent(-1, 0, 0)
  end

  @testset "The default minimum and maximum for a cylinder" begin
    c = Cylinder()
    @test c.minimum == -Inf
    @test c.maximum == Inf
  end

  @testset "Intersecting a constrained cylinder" begin
    cyl = Cylinder()
    cyl.minimum = 1
    cyl.maximum = 2

    r = Ray(Point(0, 1.5, 0), normalize(Agent(0.1, 1, 0)))
    xs = intersects(cyl, r)
    @test length(xs) == 0

    r = Ray(Point(0, 3, -5), normalize(Agent(0, 0, 1)))
    xs = intersects(cyl, r)
    @test length(xs) == 0

    r = Ray(Point(0, 0, -5), normalize(Agent(0, 0, 1)))
    xs = intersects(cyl, r)
    @test length(xs) == 0

    r = Ray(Point(0, 2, -5), normalize(Agent(0, 0, 1)))
    xs = intersects(cyl, r)
    @test length(xs) == 0

    r = Ray(Point(0, 1, -5), normalize(Agent(0, 0, 1)))
    xs = intersects(cyl, r)
    @test length(xs) == 0

    r = Ray(Point(0, 1.5, -2), normalize(Agent(0, 0, 1)))
    xs = intersects(cyl, r)
    @test length(xs) == 2
  end

  @testset "The default closed value for a cylinder" begin
    c = Cylinder()
    @test c.closed == false
  end

  @testset "Intersecting the caps of a closed cylinder" begin
    cyl = Cylinder()
    cyl.minimum = 1
    cyl.maximum = 2
    cyl.closed = true

    xs = intersects(cyl, Ray(Point(0, 3, 0), normalize(Agent(0, -1, 0))))
    @test length(xs) == 2

    xs = intersects(cyl, Ray(Point(0, 3, -2), normalize(Agent(0, -1, 2))))
    @test length(xs) == 2

    xs = intersects(cyl, Ray(Point(0, 4, -2), normalize(Agent(0, -1, 1))))
    @test length(xs) == 2

    xs = intersects(cyl, Ray(Point(0, 0, -2), normalize(Agent(0, 1, 2))))
    @test length(xs) == 2

    xs = intersects(cyl, Ray(Point(0, -1, -2), normalize(Agent(0, 1, 1))))
    @test length(xs) == 2
  end

  @testset "The normal vector on a cylinder's end caps" begin
    cyl = Cylinder()
    cyl.minimum = 1
    cyl.maximum = 2
    cyl.closed = true

    n = normal_at(cyl, Point(0, 1, 0))
    @test n == Agent(0, -1, 0)

    n = normal_at(cyl, Point(0.5, 1, 0))
    @test n == Agent(0, -1, 0)

    n = normal_at(cyl, Point(0, 1, 0.5))
    @test n == Agent(0, -1, 0)

    n = normal_at(cyl, Point(0, 2, 0))
    @test n == Agent(0, 1, 0)

    n = normal_at(cyl, Point(0.5, 2, 0))
    @test n == Agent(0, 1, 0)

    n = normal_at(cyl, Point(0, 2, 0.5))
    @test n == Agent(0, 1, 0)

  end

end
