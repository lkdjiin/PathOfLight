# FIXME PPM files should not have lines longer than 70 characters.
function to_ppm(c::Canvas)
  PPMH.header(c.width, c.height) * PPMH.data(c.pixels)
end

module PPMH
  using Main: rgb

  function header(width, height)
    "P3\n$width $height\n255\n"
  end

  function data(pixels)
    result = ""
    for i in 1:size(pixels)[1]
      result = result * PPMH.row(map(rgb, getindex(pixels, i, :))) * "\n"
    end
    result
  end

  function row(colors::Array{Tuple{Float64, Float64, Float64}, 1})
    result = collect(Iterators.flatten(colors))
    result = result .* 255
    result = map(x -> round(Int, x), result)
    result = map(x -> x > 255 ? 255 : x, result)
    result = map(x -> x < 0 ? 0 : x, result)
    join(result, " ")
  end
end
