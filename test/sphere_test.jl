@testset "Sphere Tests" begin

  @testset "It has an ID" begin
    s1 = sphere()
    s2 = sphere()
    @test s1.id != s2.id
  end

end
