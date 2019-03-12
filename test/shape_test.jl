mutable struct TestShape <: Shape
  id::String
  transform
  material

  TestShape() = new(string(UUIDs.uuid1()), identity4, Material())
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

end
