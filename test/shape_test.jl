# A shape for testing purpose.
@shape TestShape

function intersects(s::TestShape, ray::Ray)
  transform(ray, inv(s.transform))
end

@testset "Shape Tests" begin

  @testset "It has an ID" begin
    s1 = TestShape()
    s2 = TestShape()
    @test s1.id != s2.id
  end

  @testset "Default transformation" begin
    s = TestShape()
    @test s.transform == identity4
  end

  @testset "Assigning a transformation" begin
    s = TestShape()
    s.transform = translation(2, 3, 4)
    @test s.transform == translation(2, 3, 4)
  end

  @testset "It has a default material" begin
    s = TestShape()
    m = s.material
    @test m == Material()
  end

  @testset "It may be assigned a material" begin
    s = TestShape()
    m = Material()
    m.ambient = 1.0
    s.material = m
    @test s.material == m
  end

  @testset "Intersecting a scaled shape with a ray" begin
    r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
    s = TestShape()
    s.transform = scaling(2, 2, 2)
    object_space_ray = intersects(s, r)
    @test object_space_ray.origin == Point(0, 0, -2.5)
    @test object_space_ray.direction == Agent(0, 0, 0.5)
  end

  @testset "Intersecting a translated shape with a ray" begin
    r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
    s = TestShape()
    s.transform = translation(5, 0, 0)
    object_space_ray = intersects(s, r)
    @test object_space_ray.origin == Point(-5, 0, -5)
    @test object_space_ray.direction == Agent(0, 0, 1)
  end

  @testset "Default parent attribute" begin
    s = TestShape()
    @test s.parent == nothing
  end

end
