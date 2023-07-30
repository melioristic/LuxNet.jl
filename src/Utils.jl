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
    p.base_element.h_scale *
    p.base_element.height *
    p.n_element_v
end

function height(s::Tensor3D)
    s.base_tensor2D.base_element.h_scale *
    s.base_tensor2D.base_element.height *
    (s.base_tensor2D.n_element_v + s.n_stack * abs(s.y_offset_factor))
end


function width(p::Element)
    p.width*p.w_scale
end

function width(tensor2D::Tensor2D)
    tensor2D.base_element.w_scale * tensor2D.base_element.width * tensor2D.n_element_h
end

function width(s:: Tensor3D)
    s.base_tensor2D.base_element.w_scale *
    s.base_tensor2D.base_element.width *
    (s.base_tensor2D.n_element_h + (s.n_stack-1) * abs(s.x_offset_factor))
end


function rightmid(p::Tensor2D)
    x = p.base_element.position.x+width(p)-width(p.base_element)/2
    y = p.base_element.position.y+height(p)/2

    return Point(x, y)
end

function rightmid(s::Tensor3D)
    if s.x_offset_factor>0
        x = s.base_tensor2D.base_element.position.x + width(s.base_tensor2D.base_element)/2
    else
        x = s.base_tensor2D.base_element.position.x +width(s) - width(s.base_tensor2D.base_element)/2
    end
    y = s.base_tensor2D.base_element.position.y + height(s.base_tensor2D)/2 - (height(s) - height(s.base_tensor2D) )/2 

    return Point(x, y)
end

function leftmid(p::Tensor2D)

    x = p.base_element.position.x-width(p.base_element)/2
    y = p.base_element.position.y+height(p)/2

    return Point(x, y)
end

function leftmid(s::Tensor3D)
    if s.x_offset_factor>0
        x = s.base_tensor2D.base_element.position.x - width(s) + width(s.base_tensor2D.base_element)/2
    else
        x = s.base_tensor2D.base_element.position.x - + width(s.base_tensor2D.base_element)/2
    end
    y = s.base_tensor2D.base_element.position.y + height(s.base_tensor2D)/2 - (height(s)-height(s.base_tensor2D))/2
    return Point(x, y)
end

# function rightmid(s::Tensor3D)
# end

# function leftmid(p::Tensor2D)
# end

# function leftmid(s::Tensor3D)
# end