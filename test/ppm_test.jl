@testset "PPM Tests" begin

  @testset "Constructing the header" begin
    c = Canvas(width=5, height=3)
    ppm = to_ppm(c)
    @test ppm[1:11] == "P3\n5 3\n255\n"
  end

  @testset "Constructing the PPM pixel data" begin
    c = Canvas(width=5, height=3)
    c1 = Color(1.5, 0, 0)
    c2 = Color(0, 0.5, 0)
    c3 = Color(-0.5, 0, 1)
    write_pixel(c, x=0, y=0, color=c1)
    write_pixel(c, x=2, y=1, color=c2)
    write_pixel(c, x=4, y=2, color=c3)
    ppm = split(to_ppm(c), "\n")
    @test ppm[4] == "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0"
    @test ppm[5] == "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0"
    @test ppm[6] == "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
  end

  @testset "PPM files are terminated by a newline character" begin
    c = Canvas(width=5, height=3)
    ppm = to_ppm(c)
    @test ppm[end] == '\n'
  end

end
