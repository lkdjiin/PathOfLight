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

end
