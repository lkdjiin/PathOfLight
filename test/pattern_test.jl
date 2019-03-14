@testset "Patterns Tests" begin

  @testset "Stripe" begin
    @testset "constructor" begin
      pattern = StripePattern(white, black)
      @test pattern.a == white
      @test pattern.b == black
    end

    @testset "It is constant in y" begin
      pattern = StripePattern(white, black)
      @test stripe_at(pattern, Point(0, 0, 0)) == white
      @test stripe_at(pattern, Point(0, 1, 0)) == white
      @test stripe_at(pattern, Point(0, 2, 0)) == white
    end

    @testset "It is constant in z" begin
      pattern = StripePattern(white, black)
      @test stripe_at(pattern, Point(0, 0, 0)) == white
      @test stripe_at(pattern, Point(0, 0, 1)) == white
      @test stripe_at(pattern, Point(0, 0, 2)) == white
    end

    @testset "It alternates in x" begin
      pattern = StripePattern(red, blue)
      @test stripe_at(pattern, Point(0, 0, 0)) == red
      @test stripe_at(pattern, Point(0.9, 0, 0)) == red
      @test stripe_at(pattern, Point(1, 0, 0)) == blue
      @test stripe_at(pattern, Point(-0.1, 0, 0)) == blue
      @test stripe_at(pattern, Point(-1, 0, 0)) == blue
      @test stripe_at(pattern, Point(-1.1, 0, 0)) == red
    end

    @testset "with an object transformation" begin
      object = Sphere()
      object.transform = scaling(2, 2, 2)
      pattern = StripePattern(red, black)
      c = stripe_at_object(pattern, object, Point(1.5, 0, 0))
      @test c == red
    end

    @testset "with a pattern transformation" begin
      object = Sphere()
      pattern = StripePattern(blue, black)
      pattern.transform = scaling(2, 2, 2)
      c = stripe_at_object(pattern, object, Point(1.5, 0, 0))
      @test c == blue
    end

    @testset "with both an object and a pattern transformation" begin
      object = Sphere()
      object.transform = scaling(2, 2, 2)
      pattern = StripePattern(black, white)
      pattern.transform = translation(0.5, 0, 0)
      c = stripe_at_object(pattern, object, Point(2.5, 0, 0))
      @test c == black
    end

  end

end
