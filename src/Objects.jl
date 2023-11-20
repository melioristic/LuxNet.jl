using Luxor
using ColorSchemes
using Colors

## Element is the most elementary level for the neural network plots

mutable struct Label
    str::Union{Nothing,String}
    position::Union{Nothing,Point}
    display::Bool
end

function Label(; str=nothing, position=nothing, display=true)
    return Label(str, position, display)
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
    position=Point(0, 0),
    height=10,
    width=10,
    color=base_scheme[1],
    h_scale=1,
    w_scale=1,
    text_label=Label()
)
    return Element(position, height, width, color, h_scale, w_scale, text_label)
end


## Tensor2D builds on elements, it can be 1-D or 2-D tensor2D

mutable struct Tensor2D
    base_element::Element
    n_element_h::Int64
    n_element_v::Int64
    color::Array
    text_label::Label
end

function Tensor2D(;
    n_element_h=5,
    n_element_v=10,
    color=[Element().color],
    position = Point(0,0),
    height = Element().height,
    width = Element().width,
    h_scale=Element().h_scale,
    w_scale=Element().w_scale,
    text_label = Label()
)
    x = position.x - (n_element_h * w_scale * width) / 2    
    y = position.y -  (n_element_v * h_scale * height) / 2
    
    base_element=Element(position = Point(x,y), height=height, width=width, h_scale=h_scale, w_scale=w_scale)

    Tensor2D(base_element, n_element_h, n_element_v, color, text_label)
end


## Tensor3D is a stack of Tensor2D

mutable struct Tensor3D
    base_tensor2D::Tensor2D
    n_stack::Int64
    color::Array
    x_offset_factor::Float16
    y_offset_factor::Float16
    text_label::Label
end

function Tensor3D(;
    n_stack=3,
    n_element_h=5,
    n_element_v=10,
    color=[Element().color],
    x_offset_factor=0.5,
    y_offset_factor=0.5,
    position = Point(0,0),
    height = Element().height,
    width = Element().width,
    h_scale=Element().h_scale,
    w_scale=Element().w_scale,
    text_label=Label()
)

    x = position.x - (w_scale * width * (n_stack - 1)  * x_offset_factor) / 2
 
    y = position.y - (h_scale * height * ( n_stack -1) * y_offset_factor) / 2

    base_tensor2D = Tensor2D(n_element_h=n_element_h,
        n_element_v=n_element_v,
        color=color,
        position = Point(x,y),
        height = height,
        width = width,
        h_scale=h_scale,
        w_scale=w_scale,
        )
        
    
    return Tensor3D(base_tensor2D, n_stack, color, x_offset_factor, y_offset_factor, text_label)
end

Base.deepcopy(m::Element) = Element([ deepcopy(getfield(m, k)) for k = 1:length(fieldnames(Element)) ]...)
Base.deepcopy(m::Tensor2D) = Tensor2D([ deepcopy(getfield(m, k)) for k = 1:length(fieldnames(Tensor2D)) ]...)
Base.deepcopy(m::Tensor3D) = Tensor3D([ deepcopy(getfield(m, k)) for k = 1:length(fieldnames(Tensor3D)) ]...)
