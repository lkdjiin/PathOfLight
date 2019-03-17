struct Noise
  name
  ratio
  func

  function Noise(name, ratio)
    if name == :perlin_noise
      func = PerlinNoise.noise
    else
      func = nothing
    end
    new(name, ratio, func)
  end
end

