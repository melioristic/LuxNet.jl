function drawnet(element::Element)
    setline(1.0)
    setcolor(element.color)
    b = box(
        element.position,
        element.width * element.w_scale,
        element.height * element.h_scale,
        action = :fillpreserve,
    )
    sethue(base_scheme[6])
    strokepath()
    sethue("black")
    b
end

function drawnet(pattern::Tensor2D)
    pattern = deepcopy(pattern)
    if pattern.text_label.display === true

        if pattern.text_label.str === nothing
            pattern.text_label.str = "$(pattern.n_element_v) X $(pattern.n_element_h)"
        end

        if (pattern.text_label.position === nothing)
            padding = 20
            y_bottom =
                pattern.element.position.y +
                (pattern.element.h_scale * pattern.element.height * pattern.n_element_v) +
                padding

            x_mid = pattern.element.position.x + width(pattern) / 2 - width(pattern.element) / 2

            pattern.text_label.position =
                Point(x_mid - 3.2 * length(pattern.text_label.str), y_bottom)
        end

        text(pattern.text_label.str, pattern.text_label.position)
        # x = pattern.element.position.x - (pattern.element.w_scale*pattern.element.width*pattern.n_element_h)/2 -padding

        # print(x)
        # y_start = pattern.element.position.y #- (pattern.element.h_scale*pattern.element.height*pattern.n_element_v)/2
        # y_end = pattern.element.position.y + (pattern.element.h_scale*pattern.element.height*pattern.n_element_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end


    for h_index = 1:pattern.n_element_h
        new_pattern = deepcopy(pattern)

        if size(pattern.color) == (1,)
            new_pattern.element.color = pattern.color[1]
        end

        x = new_pattern.element.position.x
        x += (h_index - 1) * new_pattern.element.w_scale * new_pattern.element.width

        new_pattern.element.position = Point(x, new_pattern.element.position.y)

        for v_index = 1:pattern.n_element_v
            y =
                pattern.element.position.y +
                (v_index - 1) * pattern.element.h_scale * new_pattern.element.height
            new_pattern.element.position = Point(new_pattern.element.position.x, y)

            if size(pattern.color) == (pattern.n_element_v,)
                new_pattern.element.color = pattern.color[v_index]
            elseif size(pattern.color) == (pattern.n_element_v, pattern.n_element_h)
                new_pattern.element.color = pattern.color[v_index, h_index]
 
            end

            drawnet(new_pattern.element)
        end
    end
end


function drawnet(tensor3D::Tensor3D)

    if tensor3D.text_label.display === true
        if isnothing(tensor3D.text_label.str)
            tensor3D.text_label.str = "$(tensor3D.pattern.n_element_v) X $(tensor3D.pattern.n_element_h) X $(tensor3D.n_stack)"
        end
        if (tensor3D.pattern.text_label.position === nothing)
            padding = 20
            y_bottom =
                tensor3D.pattern.element.position.y + height(tensor3D) + padding
            x_mid =
                tensor3D.pattern.element.position.x +
                width(tensor3D.pattern) +
                tensor3D.x_offset_factor *
                tensor3D.n_stack *
                width(tensor3D.pattern.element) -
                1.5 * width(tensor3D.pattern.element)
            tensor3D.text_label.position =
                Point(x_mid - 3.2 * length(tensor3D.text_label.str), y_bottom)
        end
        text(tensor3D.text_label.str, tensor3D.text_label.position)
        # x = pattern.element.position.x - (pattern.element.w_scale*pattern.element.width*pattern.n_element_h)/2 -padding

        # print(x)
        # y_start = pattern.element.position.y #- (pattern.element.h_scale*pattern.element.height*pattern.n_element_v)/2
        # y_end = pattern.element.position.y + (pattern.element.h_scale*pattern.element.height*pattern.n_element_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end

    tensor3D.pattern.text_label.display = false
    for i = 1:tensor3D.n_stack
        drawnet(tensor3D.pattern)
        x =
            tensor3D.pattern.element.position.x +
            tensor3D.pattern.element.width *
            tensor3D.pattern.element.w_scale *
            tensor3D.x_offset_factor
        y =
            tensor3D.pattern.element.position.y +
            tensor3D.pattern.element.height *
            tensor3D.pattern.element.h_scale *
            tensor3D.y_offset_factor

        new_point = Point((x, y))
        tensor3D.pattern.element.position = new_point
    end

end

## Check what happened here

# function drawnet(link::HorizontalLink)
#     # arrowheadangle = atan((link.finish.y-link.c2.y)/(link.finish.x-link.c2.x)) 
#     sethue(link.color)
#     arrow(link.start, link.c1, link.c2, link.finish, linewidth=link.linewidth, arrowheadlength = 15)
#     sethue("black")
# end

function multilinetext(str_array, p)
    p = Point(p.x, p.y - 8*size(str_array,1)+14)
    for i in eachindex(str_array)
        text(str_array[i], p)
        p = Point(p.x, p.y+15)
    end
end

function drawnet(array_struct::Union{Vector{Any},Vector{Tensor3D}, Vector{Tensor2D},Vector{Element}})
    for each in array_struct
        drawnet(each)
    end
end