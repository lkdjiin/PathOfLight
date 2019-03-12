@testset "Camera Tests" begin
  @testset "Constructing a camera" begin
    hsize = 160
    vsize = 120
    field_of_view = π/2
    c = Camera(hsize, vsize, field_of_view)
    @test c.hsize == 160
    @test c.vsize == 120
    @test c.field_of_view == π/2
    @test c.transform == identity4
  end

  @testset "The pixel size for a horizontal canvas" begin
    c = Camera(200, 125, π/2)
    @test isapprox(c.pixel_size, 0.01, atol=epsilon)
  end

  @testset "The pixel size for a vertical canvas" begin
    c = Camera(125, 200, π/2)
    @test isapprox(c.pixel_size, 0.01, atol=epsilon)
  end

  @testset "ray_for_pixel()" begin
    @testset "through the center of the canvas" begin
      c = Camera(201, 101, π/2)
      r = ray_for_pixel(c, 100, 50)
      @test r.origin == Point(0, 0, 0)
      @test r.direction == Agent(0, 0, -1)
    end

    @testset "through a corner of the canvas" begin
      c = Camera(201, 101, π/2)
      r = ray_for_pixel(c, 0, 0)
      @test r.origin == Point(0, 0, 0)
      @test r.direction == Agent(0.66519, 0.33259, -0.66851)
    end

    @testset "when the camera is transformed" begin
      transform = rotation_y(π/4) * translation(0, -2, 5)
      c = Camera(201, 101, π/2, transform=transform)
      r = ray_for_pixel(c, 100, 50)
      @test r.origin == Point(0, 2, -5)
      @test r.direction == Agent(√2/2, 0, -√2/2)
    end
  end

  @testset "render()" begin
    @testset "Rendering a world with a camera" begin
      w = default_world()
      from = Point(0, 0, -5)
      to = Point(0, 0, 0)
      up = Agent(0, 1, 0)
      transform = view_transform(from, to, up)
      c = Camera(11, 11, π/2, transform=transform)
      image = render(c, w)
      @test read_pixel(image, x=5, y=5) == Color(0.38066, 0.47583, 0.2855)
    end

    @testset "Canvas has same size as the camera" begin
      w = default_world()
      from = Point(0, 0, -5)
      to = Point(0, 0, 0)
      up = Agent(0, 1, 0)
      transform = view_transform(from, to, up)
      c = Camera(10, 12, π/2, transform=transform)
      image = render(c, w)
      @test c.hsize == image.width
      @test c.vsize == image.height
    end
  end

end
