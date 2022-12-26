using Colors
using ColorSchemes

function add_alpha(col, alpha)
    return RGBA(col.r, col.g, col.b, alpha)
end

function col_arr(n_elements_each, col...)
    col_list = []
    for each in col
        for i = 1:n_elements_each
            append!(col_list, each)
        end
    end
    return col_list
end

function width(s::StackedPattern)
    s.pattern.pixel.w_scale *
    s.pattern.pixel.width *
    (s.pattern.n_pixel_h + s.n_stack * abs(s.x_offset))
end

function height(s::StackedPattern)
    s.pattern.pixel.h_scale *
    s.pattern.pixel.height *
    (s.pattern.n_pixel_v + s.n_stack * abs(s.y_offset))
end

function width(pattern::Pattern)
    pattern.pixel.w_scale * pattern.pixel.width * pattern.n_pixel_h
end

function width(pixel::Pixel)
    pixel.width * pixel.w_scale
end
