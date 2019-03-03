@testset "Element Tests" begin

  @testset "Comparisons" begin
    @testset "ispoint()" begin
      a = Element(4.3, -4.2, 3.1, 1)
      @test ispoint(a) == true
      a = Element(4.3, -4.2, 3.1, 0)
      @test ispoint(a) == false
    end

    @testset "isvector()" begin
      a = Element(4.3, -4.2, 3.1, 1)
      @test isvector(a) == false
      a = Element(4.3, -4.2, 3.1, 0)
      @test isvector(a) == true
    end

    @testset "==()" begin
      @testset "A vector is not a point" begin
        a = point(1.0, 3.0, 5.0)
        b = vector(1.0, 3.0, 5.0)
        @test !(a == b)
      end

      @testset "Two identical points" begin
        a = point(1.0, 3.0, 5.0)
        b = point(1.0000000000000002, 3.0, 5.0)
        @test a == b
      end

      @testset "Two different points" begin
        a = point(1.0, 3.0, 5.0)
        b = point(1.01, 3.0, 5.0)
        @test !(a == b)
      end

      @testset "Two identical vectors" begin
        a = vector(1.0, 3.0, 5.0)
        b = vector(1.0000000000000002, 3.0, 5.0)
        @test a == b
      end

      @testset "Two different vectors" begin
        a = vector(1.0, 3.0, 5.0)
        b = vector(1.01, 3.0, 5.0)
        @test !(a == b)
      end
    end

    @testset "!=()" begin
      @testset "A vector is not a point" begin
        a = point(1.0, 3.0, 5.0)
        b = vector(1.0, 3.0, 5.0)
        @test a != b
      end

      @testset "Two identical points" begin
        a = point(1.0, 3.0, 5.0)
        b = point(1.0, 3.0, 5.0)
        @test !(a != b)
      end

      @testset "Two different points" begin
        a = point(1.0, 3.0, 5.0)
        b = point(2.0, 3.0, 5.0)
        @test a != b
      end
    end
  end

  @testset "Constructors" begin
    @testset "point()" begin
      a = point(1.2, 3.4, 5.6)
      @test a.x == 1.2
      @test a.y == 3.4
      @test a.z == 5.6
      @test a.w == 1
    end

    @testset "vector()" begin
      a = vector(1.0, 2.0, 3.0)
      @test a.x == 1.0
      @test a.y == 2.0
      @test a.z == 3.0
      @test a.w == 0
    end
  end

  @testset "Basic Operations" begin
    @testset "Adding two elements" begin
      result = point(3, -2, 5) + vector(-2, 3, 1)
      @test result == point(1, 1, 6)
    end

    @testset "Substracting two points" begin
      result = point(3, 2, 1) - point(5, 6, 7)
      @test result == vector(-2, -4, -6)
    end

    @testset "Substracting a vector from a point" begin
      result = point(3, 2, 1) - vector(5, 6, 7)
      @test result == point(-2, -4, -6)
    end

    @testset "Substracting two vectors" begin
      result = vector(3, 2, 1) - vector(5, 6, 7)
      @test result == vector(-2, -4, -6)
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
    @test magnitude(vector(1, 0, 0)) == 1
    @test magnitude(vector(0, 1, 0)) == 1
    @test magnitude(vector(0, 0, 1)) == 1
    @test isapprox(magnitude(vector(1, 2, 3)), sqrt(14), atol=PathOfLight.epsillon)
    @test isapprox(magnitude(vector(-1, -2, -3)), sqrt(14), atol=PathOfLight.epsillon)
  end

  @testset "normalize()" begin
    @test normalize(vector(4, 0, 0)) == vector(1, 0, 0)
    @test normalize(vector(1, 2, 3)) == vector(0.26726, 0.53452, 0.80178)

    @testset "magnitude of a normalized vector" begin
      v = vector(1, 2, 3)
      norm = normalize(v)
      @test magnitude(norm) == 1
    end
  end

  @testset "dot()" begin
    a = vector(1, 2, 3)
    b = vector(2, 3, 4)
    @test dot(a, b) == 20
  end

  @testset "cross()" begin
    a = vector(1, 2, 3)
    b = vector(2, 3, 4)
    @test cross(a, b) == vector(-1, 2, -1)
    @test cross(b, a) == vector(1, -2, 1)
  end
end
