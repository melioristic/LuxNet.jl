using LuxNet
using Test


@testset "LuxNet.jl" begin
    @test Pixel().height == 10
    @test Pixel(height=7).height == 7
    # Write your tests here.
end
