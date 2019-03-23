@testset "Group Tests" begin

  @testset "Creating a new group" begin
    g = Group()
    @test g.transform == identity4
    @test isempty(g.childs)
  end

end
