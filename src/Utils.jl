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
    p.element.h_scale *
    p.element.height *
    p.n_element_v
end

function height(s::Tensor3D)
    s.tensor2D.element.h_scale *
    s.tensor2D.element.height *
    (s.tensor2D.n_element_v + s.n_stack * abs(s.y_offset_factor))
end


function width(p::Element)
    p.width*p.w_scale
end

function width(tensor2D::Tensor2D)
    tensor2D.element.w_scale * tensor2D.element.width * tensor2D.n_element_h
end

function width(s:: Tensor3D)
    s.tensor2D.element.w_scale *
    s.tensor2D.element.width *
    (s.tensor2D.n_element_h + (s.n_stack-1) * abs(s.x_offset_factor))
end


function rightmid(p::Tensor2D)
    x = p.element.position.x+width(p)-width(p.element)/2
    y = p.element.position.y+height(p)/2

    return Point(x, y)
end

function rightmid(s::Tensor3D)
    if s.x_offset_factor>0
        x = s.tensor2D.element.position.x + width(s.tensor2D.element)/2
    else
        x = s.tensor2D.element.position.x +width(s) - width(s.tensor2D.element)/2
    end
    y = s.tensor2D.element.position.y + height(s.tensor2D)/2 - (height(s) - height(s.tensor2D) )/2 

    return Point(x, y)
end

function leftmid(p::Tensor2D)

    x = p.element.position.x-width(p.element)/2
    y = p.element.position.y+height(p)/2

    return Point(x, y)
end

function leftmid(s::Tensor3D)
    if s.x_offset_factor>0
        x = s.tensor2D.element.position.x - width(s) + width(s.tensor2D.element)/2
    else
        x = s.tensor2D.element.position.x - + width(s.tensor2D.element)/2
    end
    y = s.tensor2D.element.position.y + height(s.tensor2D)/2 - (height(s)-height(s.tensor2D))/2
    return Point(x, y)
end

# function rightmid(s::Tensor3D)
# end

# function leftmid(p::Tensor2D)
# end

# function leftmid(s::Tensor3D)
# end