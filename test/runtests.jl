start_time = time()

include("../src/PathOfLight.jl")

using Test

@testset "PathOfLight Tests" begin
  # FIXME We must be in the project root directory for the following to
  # work.
  if length(ARGS) > 0
    for e in ARGS
      include(e * "_test.jl")
    end
  else
    for file in readdir("test")
      if length(file) > 8 && file[end-7:end] == "_test.jl"
        include(file)
      end
    end
  end
end

now = time() - start_time
println("Done in $now seconds.")
