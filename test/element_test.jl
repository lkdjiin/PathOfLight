@testset "Element Tests" begin

  @testset "Comparisons" begin
    @testset "ispoint()" begin
      a = Element(4.3, -4.2, 3.1, 1.0)
      @test ispoint(a) == true
      a = Element(4.3, -4.2, 3.1, 0.0)
      @test ispoint(a) == false
    end

    @testset "isvector()" begin
      a = Element(4.3, -4.2, 3.1, 1.0)
      @test isvector(a) == false
      a = Element(4.3, -4.2, 3.1, 0.0)
      @test isvector(a) == true
    end

    @testset "==()" begin
      @testset "A vector is not a point" begin
        a = Point(1.0, 3.0, 5.0)
        b = Agent(1.0, 3.0, 5.0)
        @test !(a == b)
      end

      @testset "Two identical points" begin
        a = Point(1.0, 3.0, 5.0)
        b = Point(1.0000000000000002, 3.0, 5.0)
        @test a == b
      end

      @testset "Two different points" begin
        a = Point(1.0, 3.0, 5.0)
        b = Point(1.01, 3.0, 5.0)
        @test !(a == b)
      end

      @testset "Two identical vectors" begin
        a = Agent(1.0, 3.0, 5.0)
        b = Agent(1.0000000000000002, 3.0, 5.0)
        @test a == b
      end

      @testset "Two different vectors" begin
        a = Agent(1.0, 3.0, 5.0)
        b = Agent(1.01, 3.0, 5.0)
        @test !(a == b)
      end
    end

    @testset "!=()" begin
      @testset "A vector is not a point" begin
        a = Point(1.0, 3.0, 5.0)
        b = Agent(1.0, 3.0, 5.0)
        @test a != b
      end

      @testset "Two identical points" begin
        a = Point(1.0, 3.0, 5.0)
        b = Point(1.0, 3.0, 5.0)
        @test !(a != b)
      end

      @testset "Two different points" begin
        a = Point(1.0, 3.0, 5.0)
        b = Point(2.0, 3.0, 5.0)
        @test a != b
      end
    end
  end

  @testset "Constructors" begin
    @testset "Point()" begin
      a = Point(1.2, 3.4, 5.6)
      @test a.x == 1.2
      @test a.y == 3.4
      @test a.z == 5.6
      @test a.w == 1.0
    end

    @testset "Agent()" begin
      a = Agent(1.0, 2.0, 3.0)
      @test a.x == 1.0
      @test a.y == 2.0
      @test a.z == 3.0
      @test a.w == 0
    end

    @testset "vector from a point" begin
      p = Point(1, 2, 3)
      @test Agent(p) == Agent(1, 2, 3)
    end
  end

  @testset "Basic Operations" begin
    @testset "Adding two elements" begin
      result = Point(3, -2, 5) + Agent(-2, 3, 1)
      @test result == Point(1, 1, 6)
    end

    @testset "Substracting two points" begin
      result = Point(3, 2, 1) - Point(5, 6, 7)
      @test result == Agent(-2, -4, -6)
    end

    @testset "Substracting a vector from a point" begin
      result = Point(3, 2, 1) - Agent(5, 6, 7)
      @test result == Point(-2, -4, -6)
    end

    @testset "Substracting two vectors" begin
      result = Agent(3, 2, 1) - Agent(5, 6, 7)
      @test result == Agent(-2, -4, -6)
    end

    @testset "Negating an element" begin
      @test -(Element(1, -2, 3, -4)) == Element(-1, 2, -3, 4)
    end

    @testset "Multiplying an element by a scalar" begin
      result = Element(1, -2, 3, -4) * 3.5
      @test result == Element(3.5, -7, 10.5, -14)
    end

    @testset "Multiplying an element by a fraction" begin
      result = Element(1, -2, 3, -4) * 0.5
      @test result == Element(0.5, -1, 1.5, -2)
    end

    @testset "Dividing an element by a scalar" begin
      result = Element(1, -2, 3, -4) / 2
      @test result == Element(0.5, -1, 1.5, -2)
    end
  end

  @testset "magnitude()" begin
    @test magnitude(Agent(1, 0, 0)) == 1
    @test magnitude(Agent(0, 1, 0)) == 1
    @test magnitude(Agent(0, 0, 1)) == 1
    @test isapprox(magnitude(Agent(1, 2, 3)),
                   sqrt(14), atol=PathOfLight.epsillon)
    @test isapprox(magnitude(Agent(-1, -2, -3)),
                   sqrt(14), atol=PathOfLight.epsillon)
  end

  @testset "normalize()" begin
    @test PathOfLight.normalize(Agent(4, 0, 0)) == Agent(1, 0, 0)
    @test PathOfLight.normalize(Agent(1, 2, 3)) ==
          Agent(0.26726, 0.53452, 0.80178)

    @testset "magnitude of a normalized vector" begin
      v = Agent(1, 2, 3)
      norm = PathOfLight.normalize(v)
      @test magnitude(norm) == 1
    end
  end

  @testset "dot()" begin
    a = Agent(1, 2, 3)
    b = Agent(2, 3, 4)
    @test PathOfLight.dot(a, b) == 20
  end

  @testset "cross()" begin
    a = Agent(1, 2, 3)
    b = Agent(2, 3, 4)
    @test PathOfLight.cross(a, b) == Agent(-1, 2, -1)
    @test PathOfLight.cross(b, a) == Agent(1, -2, 1)
  end

  @testset "reflect()" begin
    @testset "Reflecting a vector approaching at 45°" begin
      v = Agent(1, -1, 0)
      n = Agent(0, 1, 0)
      r = reflect(v, n)
      @test r == Agent(1, 1, 0)
    end

    @testset "Reflecting a vector off a slanted surface" begin
      v = Agent(0, -1, 0)
      n = Agent(√2/2, √2/2, 0)
      r = reflect(v, n)
      @test r == Agent(1, 0, 0)
    end
  end

end
