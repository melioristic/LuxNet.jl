using Luxor
using ColorSchemes
using Colors

## Element is the most elementary level for the neural network plots

mutable struct Label
    str::Union{Nothing,String}
    position::Union{Nothing,Point}
    display::Bool
end

function Label(; str = nothing, position = nothing, display = true)
    Label(str, position, display)
end

mutable struct Element
    position::Point
    height::Float64
    width::Float64
    color::Colorant
    h_scale::Number
    w_scale::Number
    text_label::Label
end

function Element(;
    position = Point(0, 0),
    height = 10,
    width = 10,
    color = base_scheme[1],
    h_scale = 1,
    w_scale = 1,
    text_label = Label()
)
    return Element(position, height, width, color, h_scale, w_scale, text_label)
end


## Tensor2D builds on pixlels, it can be 1-D or 2-D pattern

mutable struct Tensor2D
    pixel::Element
    n_pixel_h::Int64
    n_pixel_v::Int64
    color::Array
    text_label::Label
end

function Tensor2D(;
    pixel = Element(),
    n_pixel_h = 5,
    n_pixel_v = 10,
    color = [Element().color],
    x = nothing,
    y = nothing,
    text_label = Label()
)
    if !(x === nothing)
        x -= (n_pixel_h * pixel.w_scale * pixel.width) / 2
        pixel.position = Point(x, pixel.position.y)
    end

    if !(y === nothing)
        y -= (n_pixel_v * pixel.h_scale * pixel.height) / 2
        pixel.position = Point(pixel.position.x, y)
    end

    Tensor2D(pixel, n_pixel_h, n_pixel_v, color, text_label)
end


## Tensor3D is the a level higher than Tensor2D

mutable struct Tensor3D
    pattern::Pattern
    n_stack::Int64
    color::Array
    x_offset_factor::Float16
    y_offset_factor::Float16
    text_label::Label
end

function Tensor3D(;
    pattern = Tensor2D(),
    n_stack = 3,
    color = [base_scheme[6]],
    x_offset_factor = 0.5,
    y_offset_factor = 0.5,
    x = nothing,
    y = nothing,
    text_label = Label(),
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
    return Tensor3D(pattern, n_stack, color, x_offset_factor, y_offset_factor, text_label)
end


