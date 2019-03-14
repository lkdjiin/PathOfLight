@testset "Patterns Tests" begin

  @testset "Stripe" begin
    @testset "constructor" begin
      pattern = StripePattern(white, black)
      @test pattern.a == white
      @test pattern.b == black
    end

    @testset "It is constant in y" begin
      pattern = StripePattern(white, black)
      @test PatternH.pattern_at(pattern, Point(0, 0, 0)) == white
      @test PatternH.pattern_at(pattern, Point(0, 1, 0)) == white
      @test PatternH.pattern_at(pattern, Point(0, 2, 0)) == white
    end

    @testset "It is constant in z" begin
      pattern = StripePattern(white, black)
      @test PatternH.pattern_at(pattern, Point(0, 0, 0)) == white
      @test PatternH.pattern_at(pattern, Point(0, 0, 1)) == white
      @test PatternH.pattern_at(pattern, Point(0, 0, 2)) == white
    end

    @testset "It alternates in x" begin
      pattern = StripePattern(red, blue)
      @test PatternH.pattern_at(pattern, Point(0, 0, 0)) == red
      @test PatternH.pattern_at(pattern, Point(0.9, 0, 0)) == red
      @test PatternH.pattern_at(pattern, Point(1, 0, 0)) == blue
      @test PatternH.pattern_at(pattern, Point(-0.1, 0, 0)) == blue
      @test PatternH.pattern_at(pattern, Point(-1, 0, 0)) == blue
      @test PatternH.pattern_at(pattern, Point(-1.1, 0, 0)) == red
    end

    @testset "with an object transformation" begin
      object = Sphere()
      object.transform = scaling(2, 2, 2)
      pattern = StripePattern(red, black)
      c = pattern_at(pattern, object, Point(1.5, 0, 0))
      @test c == red
    end

    @testset "with a pattern transformation" begin
      object = Sphere()
      pattern = StripePattern(blue, black)
      pattern.transform = scaling(2, 2, 2)
      c = pattern_at(pattern, object, Point(1.5, 0, 0))
      @test c == blue
    end

    @testset "with both an object and a pattern transformation" begin
      object = Sphere()
      object.transform = scaling(2, 2, 2)
      pattern = StripePattern(black, white)
      pattern.transform = translation(0.5, 0, 0)
      c = pattern_at(pattern, object, Point(2.5, 0, 0))
      @test c == black
    end
  end

  @testset "Gradient" begin
    @testset "It linearly interpolates between colors" begin
      object = Sphere()
      pattern = GradientPattern(white, black)
      @test pattern_at(pattern, object, Point(0, 0, 0)) == white
      @test pattern_at(pattern, object, Point(0.25, 0, 0)) == Color(0.75, 0.75, 0.75)
      @test pattern_at(pattern, object, Point(0.5, 0, 0)) == Color(0.5, 0.5, 0.5)
      @test pattern_at(pattern, object, Point(0.75, 0, 0)) == Color(0.25, 0.25, 0.25)
    end

  end

end
