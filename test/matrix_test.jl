@testset "Matrix Tests" begin

  @testset "Comparison" begin
    x = [1 2 3; 4 5 6.1]
    y = [1 2 3; 4 5 6.100001]
    @test x != y
    @test matrix_compare(x, y)

    @testset "with different sizes" begin
    x = [1 2 3; 4 5 6.1]
    y = [1 2; 4 5]
    @test matrix_compare(x, y) == false
    end
  end

  @testset "Multiplying two matrices" begin
    x = [1  2  3  4;
         5  6  7  8;
         9  8  7  6;
         5  4  3  2]
    y = [-2 1  2  3;
         3  2  1  -1;
         4  3  6  5;
         1  2  7  8]
    result = x * y
    @test result == [20 22  50  48;
                     44 54  114  108;
                     40 58  110  102;
                     16 26  46  42]
  end

  @testset "Multiplying a matrix by an element" begin
    a = [1  2  3  4;
         2  4  4  2;
         8  6  4  1;
         0  0  0  1]
    b = Element(1, 2, 3, 1)
    @test a * b == Element(18, 24, 33, 1)
  end

  @testset "Multiplying a matrix by the identity matrix" begin
    a = [1  2  3  4;
         2  4  4  2;
         8  6  4  1;
         0  0  0  1]
    @test a * identity4 == a
  end

  @testset "Multiplying the 4x4 identity matrix by an element" begin
    a = Element(1, 2, 3, 4)
    @test identity4 * a == a
  end

  @testset "Transposing a matrix" begin
    # This test shows how to transpose a matrix in Julia.
    a = [0  9  3  0;
         9  8  0  8;
         1  8  5  3;
         0  0  5  8]
    b = [0  9  1  0;
         9  8  8  0;
         3  0  5  5;
         0  8  3  8]
    @test permutedims(a) == b
    # One can also use transpose(a) or even Array(transpose(a)).
  end

  @testset "Inverting a matrix" begin
    # This test shows how to inverse a matrix in Julia.
    a = [ -5   2   6  -8;
           1  -5   1   8;
           7   7  -6  -7;
           1  -3   7   4]
    b = [ 0.218045    0.451128   0.240602   -0.0451128;
         -0.808271   -1.45677   -0.443609    0.520677;
         -0.0789474  -0.223684  -0.0526316   0.197368;
         -0.522556   -0.81391   -0.300752    0.306391]
    @test matrix_compare(inv(a), b)
  end

  @testset "Is a matrix invertible?" begin
    a = [ -5   2   6  -8;
           1  -5   1   8;
           7   7  -6  -7;
           1  -3   7   4]
    @test is_invertible(a) == true
    b = [-4 2 -2 -3;
          9 6 2 6;
          0 -5 1 -5;
          0 0 0 0]
    @test is_invertible(b) == false
  end

  @testset "Translation matrices" begin
    @testset "translation()" begin
      expected = [1.0 0.0 0.0 2.0;
                  0.0 1.0 0.0 3.0;
                  0.0 0.0 1.0 4.0;
                  0.0 0.0 0.0 1.0]
      @test expected == translation(2, 3, 4)
    end

    @testset "Multiplying by a translation matrix" begin
      transform = translation(5, -3, 2)
      p = Point(-3, 4, 5)
      @test transform * p == Point(2, 1, 7)
    end

    @testset "Multiplying by the inverse of a translation matrix" begin
      transform = translation(5, -3, 2)
      inversed = inv(transform)
      p = Point(-3, 4, 5)
      @test inversed * p == Point(-8, 7, 3)
    end

    @testset "Translation does not affect vectors" begin
      transform = translation(5, -3, 2)
      v = Agent(-3, 4, 5)
      @test transform * v == v
    end
  end

  @testset "Scaling matrices" begin
    @testset "A scaling matrix applied to a point" begin
      transform = scaling(2, 3, 4)
      p = Point(-4, 6, 8)
      @test transform * p == Point(-8, 18, 32)
    end

    @testset "A scaling matrix applied to a vector" begin
      transform = scaling(2, 3, 4)
      v = Agent(-4, 6, 8)
      @test transform * v == Agent(-8, 18, 32)
    end

    @testset "Multiplying by the inverse of a scaling matrix" begin
      transform = scaling(2, 3, 4)
      inversed = inv(transform)
      v = Agent(-4, 6, 8)
      @test inversed * v == Agent(-2, 2, 2)
    end

    @testset "Reflection is scaling by a negative value" begin
      transform = scaling(-1, 1, 1)
      p = Point(2, 3, 4)
      @test transform * p == Point(-2, 3, 4)
    end
  end

  @testset "Rotation" begin
    @testset "around the X Axis" begin
      @testset "by a full quarter" begin
        p = Point(0, 1, 0)
        full_quarter = rotation_x(π / 2)
        @test full_quarter * p == Point(0, 0, 1)
      end

      @testset "by half a quarter" begin
        p = Point(0, 1, 0)
        half_quarter = rotation_x(π / 4)
        @test half_quarter * p == Point(0, √2 / 2, √2 / 2)
      end

      @testset "The inverse rotates in the opposite direction" begin
        p = Point(0, 1, 0)
        half_quarter = rotation_x(π / 4)
        inversed = inv(half_quarter)
        @test inversed * p == Point(0, √2 / 2, -√2 / 2)
      end
    end

    @testset "around the Y Axis" begin
      @testset "rotation_y()" begin
        p = Point(0, 0, 1)
        half_quarter = rotation_y(π / 4)
        full_quarter = rotation_y(π / 2)
        @test half_quarter * p == Point(√2/2, 0, √2/2)
        @test full_quarter * p == Point(1, 0, 0)
      end
    end

    @testset "around the Z Axis" begin
      @testset "Rotating a point around the z axis" begin
        p = Point(0, 1, 0)
        half_quarter = rotation_z(π / 4)
        full_quarter = rotation_z(π / 2)
        @test half_quarter * p == Point(-√2/2, √2/2, 0)
        @test full_quarter * p == Point(-1, 0, 0)
      end
    end
  end

  @testset "Shearing" begin
    @testset "moves x in proportion to y" begin
      transform = shearing(1, 0, 0, 0, 0, 0)
      p = Point(2, 3, 4)
      @test transform * p == Point(5, 3, 4)
    end

    @testset "moves x in proportion to z" begin
      transform = shearing(0, 1, 0, 0, 0, 0)
      p = Point(2, 3, 4)
      @test transform * p == Point(6, 3, 4)
    end

    @testset "moves y in proportion to x" begin
      transform = shearing(0, 0, 1, 0, 0, 0)
      p = Point(2, 3, 4)
      @test transform * p == Point(2, 5, 4)
    end

    @testset "moves y in proportion to z" begin
      transform = shearing(0, 0, 0, 1, 0, 0)
      p = Point(2, 3, 4)
      @test transform * p == Point(2, 7, 4)
    end

    @testset "moves z in proportion to x" begin
      transform = shearing(0, 0, 0, 0, 1, 0)
      p = Point(2, 3, 4)
      @test transform * p == Point(2, 3, 6)
    end

    @testset "moves z in proportion to y" begin
      transform = shearing(0, 0, 0, 0, 0, 1)
      p = Point(2, 3, 4)
      @test transform * p == Point(2, 3, 7)
    end
  end

  @testset "Chained transformations must be applied in reverse order" begin
    p = Point(1, 0, 1)
    a = rotation_x(π / 2)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)
    t = c * b * a
    @test t * p == Point(15, 0, 7)
  end

  @testset "view_transform()" begin
    @testset "The default orientation" begin
      from = Point(0, 0, 0)
      to = Point(0, 0, -1)
      up = Agent(0, 1, 0)
      t = view_transform(from, to, up)
      @test t == identity4
    end

    @testset "When looking in positive z direction" begin
      from = Point(0, 0, 0)
      to = Point(0, 0, 1)
      up = Agent(0, 1, 0)
      t = view_transform(from, to, up)
      @test t == scaling(-1, 1, -1)
    end

    @testset "It moves the world" begin
      from = Point(0, 0, 8)
      to = Point(0, 0, 0)
      up = Agent(0, 1, 0)
      t = view_transform(from, to, up)
      @test t == translation(0, 0, -8)
    end

    @testset "An arbitrary view transformation" begin
      from = Point(1, 3, 2)
      to = Point(4, -2, 8)
      up = Agent(1, 1, 0)
      t = view_transform(from, to, up)

      expected = [-0.50709  0.50709  0.67612  -2.36643;
                   0.76772  0.60609  0.12122  -2.82843;
                  -0.35857  0.59761 -0.71714   0.00000;
                  0.00000  0.00000  0.00000   1.00000]

      @test matrix_compare(expected, t)
    end
  end
end
