function drawnet(element::Element)
    setline(1.0)
    setcolor(element.color)

    left_top = Point(element.position.x + (element.width * element.w_scale)/2, element.position.y + (element.height * element.h_scale)/2 )

    b = box(
        left_top,
        element.width * element.w_scale,
        element.height * element.h_scale,
        action = :fillpreserve,
    )
    sethue(base_scheme[6])
    strokepath()
    sethue("black")
    b
end

function drawnet(tensor2D::Tensor2D)
    tensor2D = deepcopy(tensor2D)
    if tensor2D.text_label.display === true

        if tensor2D.text_label.str === nothing
            tensor2D.text_label.str = "$(tensor2D.n_element_v) X $(tensor2D.n_element_h)"
        end

        if (tensor2D.text_label.position === nothing)
            padding = 20
            y_bottom =
                tensor2D.base_element.position.y +
                (tensor2D.base_element.h_scale * tensor2D.base_element.height * tensor2D.n_element_v) +
                padding

            x_mid = tensor2D.base_element.position.x + width(tensor2D) / 2 - width(tensor2D.base_element) / 2

            tensor2D.text_label.position =
                Point(x_mid - 3.2 * length(tensor2D.text_label.str), y_bottom)
        end

        text(tensor2D.text_label.str, tensor2D.text_label.position)
        # x = tensor2D.base_element.position.x - (tensor2D.base_element.w_scale*tensor2D.base_element.width*tensor2D.n_element_h)/2 -padding

        # print(x)
        # y_start = tensor2D.base_element.position.y #- (tensor2D.base_element.h_scale*tensor2D.base_element.height*tensor2D.n_element_v)/2
        # y_end = tensor2D.base_element.position.y + (tensor2D.base_element.h_scale*tensor2D.base_element.height*tensor2D.n_element_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end


    for h_index = 1:tensor2D.n_element_h
        new_tensor2D = deepcopy(tensor2D)

        if size(tensor2D.color) == (1,)
            new_tensor2D.base_element.color = tensor2D.color[1]
        end

        x = new_tensor2D.base_element.position.x
        x += (h_index - 1) * new_tensor2D.base_element.w_scale * new_tensor2D.base_element.width

        new_tensor2D.base_element.position = Point(x, new_tensor2D.base_element.position.y)

        for v_index = 1:tensor2D.n_element_v
            y =
                tensor2D.base_element.position.y +
                (v_index - 1) * tensor2D.base_element.h_scale * new_tensor2D.base_element.height
            new_tensor2D.base_element.position = Point(new_tensor2D.base_element.position.x, y)

            if size(tensor2D.color) == (tensor2D.n_element_v,)
                new_tensor2D.base_element.color = tensor2D.color[v_index]
            elseif size(tensor2D.color) == (tensor2D.n_element_v, tensor2D.n_element_h)
                new_tensor2D.base_element.color = tensor2D.color[v_index, h_index]
 
            end

            drawnet(new_tensor2D.base_element)
        end
    end
end


function drawnet(tensor3D::Tensor3D)

    if tensor3D.text_label.display === true
        if isnothing(tensor3D.text_label.str)
            tensor3D.text_label.str = " $(tensor3D.base_tensor2D.n_element_h) X $(tensor3D.base_tensor2D.n_element_v) X $(tensor3D.n_stack)"
        end

        if (tensor3D.base_tensor2D.text_label.position === nothing)
            padding = 20
            y_bottom =
                tensor3D.base_tensor2D.base_element.position.y + height(tensor3D) + padding
            x_mid =
                tensor3D.base_tensor2D.base_element.position.x +
                width(tensor3D.base_tensor2D) +
                tensor3D.x_offset_factor *
                tensor3D.n_stack *
                width(tensor3D.base_tensor2D.base_element) -
                1.5 * width(tensor3D.base_tensor2D.base_element)
            tensor3D.text_label.position =
                Point(x_mid - 3.2 * length(tensor3D.text_label.str), y_bottom)
        end
        text(tensor3D.text_label.str, tensor3D.text_label.position)
        # x = tensor2D.base_element.position.x - (tensor2D.base_element.w_scale*tensor2D.base_element.width*tensor2D.n_element_h)/2 -padding

        # print(x)
        # y_start = tensor2D.base_element.position.y #- (tensor2D.base_element.h_scale*tensor2D.base_element.height*tensor2D.n_element_v)/2
        # y_end = tensor2D.base_element.position.y + (tensor2D.base_element.h_scale*tensor2D.base_element.height*tensor2D.n_element_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end

    tensor3D.base_tensor2D.text_label.display = false


    for i = 1:tensor3D.n_stack
        new_tensor3D = deepcopy(tensor3D)
        x =
            tensor3D.base_tensor2D.base_element.position.x + 
            (i-1)*
            tensor3D.base_tensor2D.base_element.width *
            tensor3D.base_tensor2D.base_element.w_scale *
            tensor3D.x_offset_factor
        y =
            tensor3D.base_tensor2D.base_element.position.y +
            (i-1)*
            tensor3D.base_tensor2D.base_element.height *
            tensor3D.base_tensor2D.base_element.h_scale *
            tensor3D.y_offset_factor

        new_point = Point((x, y))
        new_tensor3D.base_tensor2D.base_element.position = new_point
        drawnet(new_tensor3D.base_tensor2D)

    end

end

## Check what happened here

function drawnet(link::HorizontalLink)
    # arrowheadangle = atan((link.finish.y-link.c2.y)/(link.finish.x-link.c2.x)) 
    sethue(link.color)
    arrow(link.start, link.c1, link.c2, link.finish, linewidth=link.linewidth, arrowheadlength = 15)
    sethue("black")
end

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