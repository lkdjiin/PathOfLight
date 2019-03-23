mutable struct TestShape <: Shape
  id::String
  parent::Union{Shape, Nothing}
  transform
  material
  saved_ray # Only for testing purpose

  TestShape() = new(string(UUIDs.uuid1()), nothing, identity4, Material())
end

function intersects(s::TestShape, ray::Ray)
  object_space_ray = transform(ray, inv(s.transform))
  s.saved_ray = object_space_ray
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
    xs = intersects(s, r)
    @test s.saved_ray.origin == Point(0, 0, -2.5)
    @test s.saved_ray.direction == Agent(0, 0, 0.5)
  end

  @testset "Intersecting a translated shape with a ray" begin
    r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
    s = TestShape()
    s.transform = translation(5, 0, 0)
    xs = intersects(s, r)
    @test s.saved_ray.origin == Point(-5, 0, -5)
    @test s.saved_ray.direction == Agent(0, 0, 1)
  end

  @testset "Default parent attribute" begin
    s = TestShape()
    @test s.parent == nothing
  end

end
