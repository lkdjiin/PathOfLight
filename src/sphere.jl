@shape Sphere

# Helper function to build a sphere made of glass. Mostly used by the tests.
function GlassSphere()
  s = Sphere()
  s.material.transparency = 1.0
  s.material.refractive_index = 1.5
  s
end
