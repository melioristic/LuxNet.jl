using Colors
using ColorSchemes

function add_alpha(col, alpha)
    return RGBA(col.r, col.g, col.b, alpha)
end

function col_arr(n_elements_each, col...)
    col_list = []
    for each in col
        for i = 1:n_elements_each
            append!(col_list, [each])
        end
    end
    return col_list
end



function height(e::Element)
    e.height*e.h_scale
end

function height(p::Tensor2D)
    p.pixel.h_scale *
    p.pixel.height *
    p.n_pixel_v
end

function height(s::Tensor3D)
    s.pattern.pixel.h_scale *
    s.pattern.pixel.height *
    (s.pattern.n_pixel_v + s.n_stack * abs(s.y_offset_factor))
end


function width(p::Element)
    p.width*p.w_scale
end

function width(pattern::Tensor2D)
    pattern.pixel.w_scale * pattern.pixel.width * pattern.n_pixel_h
end

function width(s:: Tensor3D)
    s.pattern.pixel.w_scale *
    s.pattern.pixel.width *
    (s.pattern.n_pixel_h + (s.n_stack-1) * abs(s.x_offset_factor))
end


function rightmid(p::Tensor2D)
    x = p.pixel.position.x+width(p)-width(p.pixel)/2
    y = p.pixel.position.y+height(p)/2

    return Point(x, y)
end

function rightmid(s::Tensor3D)
    if s.x_offset_factor>0
        x = s.pattern.pixel.position.x + width(s.pattern.pixel)/2
    else
        x = s.pattern.pixel.position.x +width(s) - width(s.pattern.pixel)/2
    end
    y = s.pattern.pixel.position.y + height(s.pattern)/2 - (height(s) - height(s.pattern) )/2 

    return Point(x, y)
end

function leftmid(p::Tensor2D)

    x = p.pixel.position.x-width(p.pixel)/2
    y = p.pixel.position.y+height(p)/2

    return Point(x, y)
end

function leftmid(s::Tensor3D)
    if s.x_offset_factor>0
        x = s.pattern.pixel.position.x - width(s) + width(s.pattern.pixel)/2
    else
        x = s.pattern.pixel.position.x - + width(s.pattern.pixel)/2
    end
    y = s.pattern.pixel.position.y + height(s.pattern)/2 - (height(s)-height(s.pattern))/2
    return Point(x, y)
end

# function rightmid(s::Tensor3D)
# end

# function leftmid(p::Tensor2D)
# end

# function leftmid(s::Tensor3D)
# end