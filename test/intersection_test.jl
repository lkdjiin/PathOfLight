@testset "Intersection Tests" begin

  @testset "An intersection encapsulates t and object" begin
    s = Sphere()
    i = Intersection(s, 3.5)
    @test i.t == 3.5
    @test i.object == s
  end

  @testset "Aggregating intersections" begin
    s = Sphere()
    i1 = Intersection(s, 1)
    i2 = Intersection(s, 2)
    xs = intersections(i1, i2)
    @test length(xs) == 2
    @test xs[1].t == 1
    @test xs[2].t == 2
  end

  @testset "Spheres and rays" begin
    @testset "A ray intersects a sphere at two points" begin
      r = Ray(point(0, 0, -5), vector(0, 0, 1))
      s = Sphere()
      xs = intersects(s, r)
      @test length(xs) == 2
      @test xs.i1.t == 4.0
      @test xs.i2.t == 6.0
    end

    @testset "A ray intersects a sphere at a tangent" begin
      r = Ray(point(0, 1, -5), vector(0, 0, 1))
      s = Sphere()
      xs = intersects(s, r)
      @test length(xs) == 2
      @test xs.i1.t == 5.0
      @test xs.i2.t == 5.0
    end

    @testset "A ray misses a sphere" begin
      r = Ray(point(0, 2, -5), vector(0, 0, 1))
      s = Sphere()
      xs = intersects(s, r)
      @test length(xs) == 0
    end

    @testset "A ray originates inside a sphere" begin
      r = Ray(point(0, 0, 0), vector(0, 0, 1))
      s = Sphere()
      xs = intersects(s, r)
      @test length(xs) == 2
      @test xs.i1.t == -1.0
      @test xs.i2.t == 1.0
    end

    @testset "A sphere is behind a ray" begin
      r = Ray(point(0, 0, 5), vector(0, 0, 1))
      s = Sphere()
      xs = intersects(s, r)
      @test length(xs) == 2
      @test xs.i1.t == -6.0
      @test xs.i2.t == -4.0
    end

    @testset "Intersecting a scaled sphere with a ray" begin
      r = Ray(point(0, 0, -5), vector(0, 0, 1))
      s = Sphere()
      s.transform = scaling(2, 2, 2)
      xs = intersects(s, r)
      @test length(xs) == 2
      @test xs.i1.t == 3
      @test xs.i2.t == 7
    end

    @testset "Intersecting a translated sphere with a ray" begin
      r = Ray(point(0, 0, -5), vector(0, 0, 1))
      s = Sphere()
      s.transform = translation(5, 0, 0)
      xs = intersects(s, r)
      @test length(xs) == 0
    end
  end

  @testset "Hit" begin
    @testset "when all intersections have positive t" begin
      s = Sphere()
      i1 = Intersection(s, 1)
      i2 = Intersection(s, 2)
      xs = intersections(i2, i1)
      i = hit(xs)
      @test i == i1
    end

    @testset "when some intersections have negative t" begin
      s = Sphere()
      i1 = Intersection(s, -1)
      i2 = Intersection(s, 1)
      xs = intersections(i2, i1)
      i = hit(xs)
      @test i == i2
    end

    @testset "when all intersections have negative t" begin
      s = Sphere()
      i1 = Intersection(s, -2)
      i2 = Intersection(s, -1)
      xs = intersections(i2, i1)
      i = hit(xs)
      @test i == nothing
    end

    @testset "is always the lowest nonnegative intersection" begin
      s = Sphere()
      i1 = Intersection(s, 5)
      i2 = Intersection(s, 7)
      i3 = Intersection(s, -3)
      i4 = Intersection(s, 2)
      xs = intersections(i1, i2, i3, i4)
      i = hit(xs)
      @test i == i4
    end
  end
end
