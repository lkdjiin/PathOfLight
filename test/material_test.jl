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
  end

  @testset "lighting()" begin
    @testset "with the eye between the light and the surface" begin
      m = Material()
      position = Point(0, 0, 0)

      eyev = Agent(0, 0, -1)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 0, -10), Color(1, 1, 1))
      result = lighting(m, light, position, eyev, normalv)
      @test result == Color(1.9, 1.9, 1.9)
    end

    @testset "with the surface in shadow" begin
      m = Material()
      position = Point(0, 0, 0)

      eyev = Agent(0, 0, -1)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 0, -10), Color(1, 1, 1))
      result = lighting(m, light, position, eyev, normalv, in_shadow=true)
      @test result == Color(0.1, 0.1, 0.1)
    end

    @testset "with the eye between light and surface, eye offset 45°" begin
      m = Material()
      position = Point(0, 0, 0)

      eyev = Agent(0, √2/2, -√2/2)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 0, -10), Color(1, 1, 1))
      result = lighting(m, light, position, eyev, normalv)
      @test result == Color(1.0, 1.0, 1.0)
    end

    @testset "with eye opposite surface, light offset 45°" begin
      m = Material()
      position = Point(0, 0, 0)

      eyev = Agent(0, 0, -1)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 10, -10), Color(1, 1, 1))
      result = lighting(m, light, position, eyev, normalv)
      @test result == Color(0.7364, 0.7364, 0.7364)
    end

    @testset "with eye in the path of the reflection vector" begin
      m = Material()
      position = Point(0, 0, 0)

      eyev = Agent(0, -√2/2, -√2/2)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 10, -10), Color(1, 1, 1))
      result = lighting(m, light, position, eyev, normalv)
      @test result == Color(1.6364, 1.6364, 1.6364)
    end

    @testset "with the light behind the surface" begin
      m = Material()
      position = Point(0, 0, 0)

      eyev = Agent(0, 0, -1)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 0, 10), Color(1, 1, 1))
      result = lighting(m, light, position, eyev, normalv)
      @test result == Color(0.1, 0.1, 0.1)
    end

    @testset "with a pattern applied" begin
      m = Material()
      m.pattern = StripePattern(white, black)
      m.ambient = 1
      m.diffuse = 0
      m.specular = 0
      eyev = Agent(0, 0, -1)
      normalv = Agent(0, 0, -1)
      light = PointLight(Point(0, 0, -10), Color(1, 1, 1))
      c1 = lighting(m, light, Point(0.9, 0, 0), eyev, normalv, in_shadow=false)
      c2 = lighting(m, light, Point(1.1, 0, 0), eyev, normalv, in_shadow=false)
      @test c1 == white
      @test c2 == black
    end

  end

end
