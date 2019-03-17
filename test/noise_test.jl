@testset "Noise Tests" begin
  noise = Noise(:perlin_noise, 0.2)
  @test noise.name == :perlin_noise
  @test noise.ratio == 0.2
  @test noise.func == PerlinNoise.noise
  @test noise.func(0, 0, 0) == 0
end
