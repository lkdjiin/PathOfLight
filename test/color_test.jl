@testset "Color Tests" begin

  @testset "Accessing composants" begin
    c = Color(-0.5, 0.4, 1.7)
    @test (c.red, c.green, c.blue) == (-0.5, 0.4, 1.7)
  end

  @testset "Creating with a tuple" begin
    rgb = (1, 2, 3)
    c = Color(rgb)
    @test (c.red, c.green, c.blue) == (1, 2, 3)
  end

  @testset "Basic Operations" begin
    @testset "Adding colors" begin
      c1 = Color(0.9, 0.6, 0.75)
      c2 = Color(0.7, 0.1, 0.25)
      @test c1 + c2 == Color(1.6, 0.7, 1.0)
    end

    @testset "Substracting colors" begin
      c1 = Color(0.9, 0.6, 0.75)
      c2 = Color(0.7, 0.1, 0.25)
      @test c1 - c2 == Color(0.2, 0.5, 0.5)
    end

    @testset "Multiplying a color by a scalar" begin
      result = Color(0.2, 0.3, 0.4) * 2.0
      @test result == Color(0.4, 0.6, 0.8)
    end

    @testset "Multiplying two colors" begin
      c1 = Color(1, 0.2, 0.4)
      c2 = Color(0.9, 1, 0.1)
      @test c1 * c2 == Color(0.9, 0.2, 0.04)
    end
  end
end
