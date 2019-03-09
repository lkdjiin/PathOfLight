@testset "Normal Tests" begin
  @testset "on a sphere at a point on the x axis" begin
    s = Sphere()
    n = normal_at(s, Point(1, 0, 0))
    @test n == Agent(1, 0, 0)
  end

  @testset "on a sphere at a point on the y axis" begin
    s = Sphere()
    n = normal_at(s, Point(0, 1, 0))
    @test n == Agent(0, 1, 0)
  end

  @testset "on a sphere at a point on the z axis" begin
    s = Sphere()
    n = normal_at(s, Point(0, 0, 1))
    @test n == Agent(0, 0, 1)
  end

  @testset "on a sphere at a nonaxial point" begin
    s = Sphere()
    n = normal_at(s, Point(√3/3, √3/3, √3/3))
    @test n == Agent(√3/3, √3/3, √3/3)
  end

  @testset "The normal is a normalized vector" begin
    s = Sphere()
    n = normal_at(s, Point(√3/3, √3/3, √3/3))
    @test n == normalize(n)
  end

  @testset "Computing the normal on a translated sphere" begin
    s = Sphere()
    s.transform = translation(0, 1, 0)
    n = normal_at(s, Point(0, 1.70711, -0.70711))
  end

  @testset "Computing the normal on a transformed sphere" begin
    s = Sphere()
    s.transform = scaling(1, 0.5, 1) * rotation_z(π / 5)
    n = normal_at(s, Point(0, √2/2, -√2/2))
    @test n == Agent(0, 0.97014, -0.24254)
  end

end
