@testset "Canvas Tests" begin

  @testset "Creating a canvas" begin
    c = Canvas(width=3, height=2)
    @test c.width == 3
    @test c.height == 2
  end

  @testset "Reading pixels" begin
    c = Canvas(width=3, height=2)
    for height in 1:c.height
      for width in 1:c.width
        # x and y are zero-based.
        @test read_pixel(c, x=width - 1, y=height - 1) == Color(0, 0, 0)
      end
    end
  end

  @testset "Writing a pixel" begin
    c = Canvas(width=10, height=20)
    red = Color(1, 0, 0)
    write_pixel(c, x=0, y=0, color=red)
    @test read_pixel(c, x=0, y=0) == red
  end
end
