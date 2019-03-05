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
end
