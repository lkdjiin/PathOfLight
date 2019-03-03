# FIXME PPM files should not have lines longer than 70 characters.
function to_ppm(c::Canvas)
  ppm_header(c.width, c.height) * ppm_data(c.pixels)
end

function ppm_header(width, height)
  "P3\n$width $height\n255\n"
end

function ppm_data(pixels)
  result = ""
  for i in 1:size(pixels)[1]
    result = result * ppm_row(map(rgb, getindex(pixels, i, :))) * "\n"
  end
  result
end

function ppm_row(colors::Array{Tuple{Float64, Float64, Float64}, 1})
  result = collect(Iterators.flatten(colors))
  result = result .* 255
  result = map(x -> round(Int, x), result)
  result = map(x -> x > 255 ? 255 : x, result)
  result = map(x -> x < 0 ? 0 : x, result)
  join(result, " ")
end
