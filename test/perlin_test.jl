@testset "Perlin Noise Tests" begin
  x = 0.0
  y = 0.0
  z = 0.0
  @test PerlinNoise.noise(x, y, z) == 0.0
end
