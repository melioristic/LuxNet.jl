using Luxor
using ColorSchemes
using Colors

## Pixel is the most elementary level for the neural network plots

mutable struct Labels
    str::Union{Nothing,String}
    position::Union{Nothing,Point}
    display::Bool
end

function Labels(; str = nothing, position = nothing, display = true)
    Labels(str, position, display)
end

mutable struct Pixel
    position::Point
    height::Float64
    width::Float64
    color::Colorant
    h_scale::Number
    w_scale::Number
    labels::Labels
end

function Pixel(;
    position = Point(0, 0),
    height = 10,
    width = 10,
    color = base_scheme[1],
    h_scale = 1,
    w_scale = 1,
    labels = Labels(),
)
    return Pixel(position, height, width, color, h_scale, w_scale, labels)
end


## Pattern builds on pixlels, it can be 1-D or 2-D pattern

mutable struct Pattern
    pixel::Pixel
    n_pixel_h::Int64
    n_pixel_v::Int64
    color::Array
    labels::Labels
end

function Pattern(;
    pixel = Pixel(),
    n_pixel_h = 5,
    n_pixel_v = 10,
    color = [Pixel().color],
    x = nothing,
    y = nothing,
    labels = Labels(),
)
    if !(x === nothing)
        x -= (n_pixel_h * pixel.w_scale * pixel.width) / 2
        pixel.position = Point(x, pixel.position.y)
    end

    if !(y === nothing)
        y -= (n_pixel_v * pixel.h_scale * pixel.height) / 2
        pixel.position = Point(pixel.position.x, y)
    end

    Pattern(pixel, n_pixel_h, n_pixel_v, color, labels)
end


## StackedPattern is the a level higher than Pattern

mutable struct StackedPattern
    pattern::Pattern
    n_stack::Int8
    color::Array
    x_offset::Float16
    y_offset::Float16
    labels::Labels
end

function StackedPattern(;
    pattern = Pattern(),
    n_stack = 3,
    color = [base_scheme[6]],
    x_offset_factor = 0.5,
    y_offset_factor = 0.5,
    x = nothing,
    y = nothing,
    labels = Labels(),
)
    if !(x === nothing)
        x -=
            pattern.pixel.w_scale *
            pattern.pixel.width *
            (pattern.n_pixel_h + n_stack * x_offset_factor) / 2
        pattern.pixel.position = Point(x, pattern.pixel.position.y)
    end

    if !(y === nothing)
        y -=
            pattern.pixel.h_scale *
            pattern.pixel.height *
            (pattern.n_pixel_v + n_stack * y_offset_factor) / 2

        pattern.pixel.position = Point(pattern.pixel.position.x, y)
    end
    return StackedPattern(pattern, n_stack, color, x_offset_factor, y_offset_factor, labels)
end


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