@testset "Group Tests" begin

  @testset "Creating a new group" begin
    g = Group()
    @test g.transform == identity4
    @test isempty(g.childs)
  end

  @testset "Adding a child to a group" begin
    g = Group()
    s = TestShape()
    add_child!(g, s)
    @test !isempty(g.childs)
    @test first(g.childs) == s
    @test s.parent == g
  end

  @testset "Intersecting a ray with an empty group" begin
    g = Group()
    r = Ray(Point(0, 0, 0), Agent(0, 0, 1))
    xs = intersects(g, r)
    @test isempty(xs)
  end

  @testset "Intersecting a ray with a nonempty group" begin
    g = Group()
    s1 = Sphere()
    s2 = Sphere()
    s2.transform = translation(0, 0, -3)
    s3 = Sphere()
    s3.transform = translation(5, 0, 0)
    add_child!(g, s1)
    add_child!(g, s2)
    add_child!(g, s3)
    r = Ray(Point(0, 0, -5), Agent(0, 0, 1))
    xs = intersects(g, r)
    @test length(xs) == 4
    @test xs[1].object.id == s2.id
    @test xs[2].object.id == s2.id
    @test xs[3].object.id == s1.id
    @test xs[4].object.id == s1.id
  end

end
