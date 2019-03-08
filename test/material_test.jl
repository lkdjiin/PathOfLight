@testset "Material Tests" begin

  @testset "Constructors" begin
    @testset "Default constructor with default material" begin
      m = Material()
      @test m.color == Color(1, 1, 1)
      @test m.ambient == 0.1
      @test m.diffuse == 0.9
      @test m.specular == 0.9
      @test m.shininess == 200.0
    end

    @testset "Changing color" begin
      m = Material()
      m = color(m, Color(0, 0, 0))
      @test m.color == Color(0, 0, 0)
    end

    @testset "Changing ambient" begin
      m = Material()
      m = ambient(m, 1.0)
      @test m.ambient == 1.0
    end

    @testset "Changing diffuse" begin
      m = Material()
      m = diffuse(m, 1.0)
      @test m.diffuse == 1.0
    end

    @testset "Changing specular" begin
      m = Material()
      m = specular(m, 1.0)
      @test m.specular == 1.0
    end

    @testset "Changing shininess" begin
      m = Material()
      m = shininess(m, 1.0)
      @test m.shininess == 1.0
    end





  end
end
