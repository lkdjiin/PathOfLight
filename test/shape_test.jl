
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

  @testset "Converting a point from world to object space" begin
    g1 = Group()
    g1.transform = rotation_y(π/2)
    g2 = Group()
    g2.transform = scaling(2, 2, 2)
    add_child!(g1, g2)
    s = Sphere()
    s.transform = translation(5, 0, 0)
    add_child!(g2, s)
    p = world_to_object(s, Point(-2, 0, -10))
    @test p == Point(0, 0, -1)
  end

  @testset "Converting a normal from object to world space" begin
    g1 = Group()
    g1.transform = rotation_y(π/2)
    g2 = Group()
    g2.transform = scaling(1, 2, 3)
    add_child!(g1, g2)
    s = Sphere()
    s.transform = translation(5, 0, 0)
    add_child!(g2, s)
    n = normal_to_world(s, Agent(√3/3, √3/3, √3/3))
    @test n == Agent(0.28571, 0.42857, -0.85714)
  end

  @testset "Finding the normal on a child object" begin
    g1 = Group()
    g1.transform = rotation_y(π/2)
    g2 = Group()
    g2.transform = scaling(1, 2, 3)
    add_child!(g1, g2)
    s = Sphere()
    s.transform = translation(5, 0, 0)
    add_child!(g2, s)
    n = normal_at(s, Point(1.7321, 1.1547, -5.5774))
    @test n == Agent(0.2857, 0.42854, -0.85716)
  end

end
