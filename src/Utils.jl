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
