@testset "Sphere Tests" begin

  @testset "It has an ID" begin
    s1 = Sphere()
    s2 = Sphere()
    @test s1.id != s2.id
  end

end
