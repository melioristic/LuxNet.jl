function drawnet(pixel::Element)
    setline(1.0)
    setcolor(pixel.color)
    b = box(
        pixel.position,
        pixel.width * pixel.w_scale,
        pixel.height * pixel.h_scale,
        action = :fillpreserve,
    )
    sethue(base_scheme[6])
    strokepath()
    sethue("black")
    b
end

function drawnet(pattern::Tensor2D)
    if pattern.text_label.display === true

        if pattern.text_label.str === nothing
            pattern.text_label.str = "$(pattern.n_pixel_v) X $(pattern.n_pixel_h)"
        end

        if (pattern.text_label.position === nothing)
            padding = 20
            y_bottom =
                pattern.pixel.position.y +
                (pattern.pixel.h_scale * pattern.pixel.height * pattern.n_pixel_v) +
                padding

            x_mid = pattern.pixel.position.x + width(pattern) / 2 - width(pattern.pixel) / 2

            pattern.text_label.position =
                Point(x_mid - 3.2 * length(pattern.text_label.str), y_bottom)
        end

        text(pattern.text_label.str, pattern.text_label.position)
        # x = pattern.pixel.position.x - (pattern.pixel.w_scale*pattern.pixel.width*pattern.n_pixel_h)/2 -padding

        # print(x)
        # y_start = pattern.pixel.position.y #- (pattern.pixel.h_scale*pattern.pixel.height*pattern.n_pixel_v)/2
        # y_end = pattern.pixel.position.y + (pattern.pixel.h_scale*pattern.pixel.height*pattern.n_pixel_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end


    for h_index = 1:pattern.n_pixel_h
        new_pattern = deepcopy(pattern)

        if size(pattern.color) == (1,)
            new_pattern.pixel.color = pattern.color[1]
        end

        x = new_pattern.pixel.position.x
        x += (h_index - 1) * new_pattern.pixel.w_scale * new_pattern.pixel.width

        new_pattern.pixel.position = Point(x, new_pattern.pixel.position.y)

        for v_index = 1:pattern.n_pixel_v
            y =
                pattern.pixel.position.y +
                (v_index - 1) * pattern.pixel.h_scale * new_pattern.pixel.height
            new_pattern.pixel.position = Point(new_pattern.pixel.position.x, y)

            if size(pattern.color) == (pattern.n_pixel_v,)
                new_pattern.pixel.color = pattern.color[v_index]
            elseif size(pattern.color) == (pattern.n_pixel_v, pattern.n_pixel_h)
                new_pattern.pixel.color = pattern.color[v_index, h_index]
 
            end

            drawnet(new_pattern.pixel)
        end
    end
end


function drawnet(stacked_pattern::Tensor3D)

    if stacked_pattern.text_label.display === true
        if isnothing(stacked_pattern.text_label.str)
            stacked_pattern.text_label.str = "$(stacked_pattern.pattern.n_pixel_v) X $(stacked_pattern.pattern.n_pixel_h) X $(stacked_pattern.n_stack)"
        end
        if (stacked_pattern.pattern.text_label.position === nothing)
            padding = 20
            y_bottom =
                stacked_pattern.pattern.pixel.position.y + height(stacked_pattern) + padding
            x_mid =
                stacked_pattern.pattern.pixel.position.x +
                width(stacked_pattern.pattern) +
                stacked_pattern.x_offset_factor *
                stacked_pattern.n_stack *
                width(stacked_pattern.pattern.pixel) -
                1.5 * width(stacked_pattern.pattern.pixel)
            stacked_pattern.text_label.position =
                Point(x_mid - 3.2 * length(stacked_pattern.text_label.str), y_bottom)
        end
        text(stacked_pattern.text_label.str, stacked_pattern.text_label.position)
        # x = pattern.pixel.position.x - (pattern.pixel.w_scale*pattern.pixel.width*pattern.n_pixel_h)/2 -padding

        # print(x)
        # y_start = pattern.pixel.position.y #- (pattern.pixel.h_scale*pattern.pixel.height*pattern.n_pixel_v)/2
        # y_end = pattern.pixel.position.y + (pattern.pixel.h_scale*pattern.pixel.height*pattern.n_pixel_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end

    stacked_pattern.pattern.text_label.display = false
    for i = 1:stacked_pattern.n_stack
        drawnet(stacked_pattern.pattern)
        x =
            stacked_pattern.pattern.pixel.position.x +
            stacked_pattern.pattern.pixel.width *
            stacked_pattern.pattern.pixel.w_scale *
            stacked_pattern.x_offset_factor
        y =
            stacked_pattern.pattern.pixel.position.y +
            stacked_pattern.pattern.pixel.height *
            stacked_pattern.pattern.pixel.h_scale *
            stacked_pattern.y_offset_factor

        new_point = Point((x, y))
        stacked_pattern.pattern.pixel.position = new_point
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