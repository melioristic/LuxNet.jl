using LuxNet
using Test


@testset "LuxNet.jl" begin
    @test Element().height == 10
    @test Element(height=7).height == 7
    # Write your tests here.
end
