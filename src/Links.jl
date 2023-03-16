using Luxor
using ColorSchemes
using Colors

mutable struct HorizontalLink
    start::Point
    c1::Point
    c2::Point
    finish::Point
    color::Colorant
    linewidth::Float64
end 

function HorizontalLink(;start=Point(-50,-50), c1 = nothing, c2=nothing, finish = Point(50,50), color=base_scheme[7], linewidth= 3)
    if c1===nothing
        c1 = Point(start.x+3/4*(finish.x-start.x), start.y)
    end

    if c2 ===nothing
        c2 = Point(start.x+1/4*(finish.x-start.x), finish.y)    
    end

    HorizontalLink(start, c1, c2, finish, color, linewidth)
end