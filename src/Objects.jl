using Luxor
using ColorSchemes
using Colors

## Pixel is the most elementary level for the neural network plots


mutable struct Labels
    height::Bool
    width::Bool
    depth::Bool
end

function Labels(; height = false, width = false, depth = false)
    return Labels(height, width, depth)
end

mutable struct Pixel
    position::Point
    height::Float16
    width::Float16
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
    n_pixel_h::Int8
    n_pixel_v::Int8
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
end

function StackedPattern(;
    pattern = Pattern(),
    n_stack = 3,
    color = [base_scheme[6]],
    x_offset_factor = 0.5,
    y_offset_factor = 0.5,
    x = nothing,
    y = nothing,
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
    return StackedPattern(pattern, n_stack, color, x_offset_factor, y_offset_factor)
end