@testset "Light Tests" begin
  @testset "A point light has a position and intensity" begin
    intensity = Color(1, 1, 1)
    position = point(0, 0, 0)
    light = PointLight(position, intensity)
    @test light.position == position
    @test light.intensity == intensity
  end
end
