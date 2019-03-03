include("../src/PathOfLight.jl")

using Test
using .PathOfLight

# FIXME We must be in the project root directory for the following to
# work.
for file in readdir("test")
  if length(file) > 8 && file[end-7:end] == "_test.jl"
    include(file)
  end
end
