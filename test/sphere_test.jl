@testset "Sphere Tests" begin

  @testset "It has an ID" begin
    s1 = Sphere()
    s2 = Sphere()
    @test s1.id != s2.id
  end

  @testset "Intersect sets the object on the intersection" begin
    r = Ray(point(0, 0, -5), vector(0, 0, 1))
    s = Sphere()
    xs = intersects(s, r)
    @test length(xs) == 2
    @test xs.i1.object == s
    @test xs.i2.object == s
  end

  @testset "A sphere's default transformation" begin
    s = Sphere()
    @test s.transform == identity4
  end

  @testset "Changing a sphere's transformation" begin
    s = Sphere()
    t = translation(2, 3, 4)
    s.transform = t
    @test s.transform == t
  end

end
