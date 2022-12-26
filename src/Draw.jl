function drawnet(pixel::Pixel)
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

function drawnet(pattern::Pattern)
    if pattern.labels.display === true

        if pattern.labels.str === nothing
            pattern.labels.str = "$(pattern.n_pixel_v) X $(pattern.n_pixel_h)"
        end

        if (pattern.labels.position === nothing)
            padding = 20
            y_bottom =
                pattern.pixel.position.y +
                (pattern.pixel.h_scale * pattern.pixel.height * pattern.n_pixel_v) +
                padding

            x_mid = pattern.pixel.position.x + width(pattern) / 2 - width(pattern.pixel) / 2

            pattern.labels.position =
                Point(x_mid - 3.2 * length(pattern.labels.str), y_bottom)
        end

        text(pattern.labels.str, pattern.labels.position)
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
            end

            drawnet(new_pattern.pixel)
        end
    end
end


function drawnet(stacked_pattern::StackedPattern)
    if stacked_pattern.labels.display === true
        if stacked_pattern.pattern.labels.str === nothing
            stacked_pattern.labels.str = "$(stacked_pattern.pattern.n_pixel_v) X $(stacked_pattern.pattern.n_pixel_h) X $(stacked_pattern.n_stack)"
        end

        if (stacked_pattern.pattern.labels.position === nothing)
            padding = 20
            y_bottom =
                stacked_pattern.pattern.pixel.position.y + height(stacked_pattern) + padding
            x_mid =
                stacked_pattern.pattern.pixel.position.x +
                width(stacked_pattern.pattern) +
                stacked_pattern.x_offset *
                stacked_pattern.n_stack *
                width(stacked_pattern.pattern.pixel) -
                1.5 * width(stacked_pattern.pattern.pixel)
            stacked_pattern.labels.position =
                Point(x_mid - 3.2 * length(stacked_pattern.labels.str), y_bottom)
        end

        text(stacked_pattern.labels.str, stacked_pattern.labels.position)
        # x = pattern.pixel.position.x - (pattern.pixel.w_scale*pattern.pixel.width*pattern.n_pixel_h)/2 -padding

        # print(x)
        # y_start = pattern.pixel.position.y #- (pattern.pixel.h_scale*pattern.pixel.height*pattern.n_pixel_v)/2
        # y_end = pattern.pixel.position.y + (pattern.pixel.h_scale*pattern.pixel.height*pattern.n_pixel_v)
        # arrow(Point(x, y_start), Point(x, (y_start+y_end)/2), Point(x, (y_start+y_end)/2), Point(x, y_end), startarrow = true)
    end

    stacked_pattern.pattern.labels.display = false
    for i = 1:stacked_pattern.n_stack
        drawnet(stacked_pattern.pattern)
        x =
            stacked_pattern.pattern.pixel.position.x +
            stacked_pattern.pattern.pixel.width *
            stacked_pattern.pattern.pixel.w_scale *
            stacked_pattern.x_offset
        y =
            stacked_pattern.pattern.pixel.position.y +
            stacked_pattern.pattern.pixel.height *
            stacked_pattern.pattern.pixel.h_scale *
            stacked_pattern.y_offset

        new_point = Point((x, y))
        stacked_pattern.pattern.pixel.position = new_point
    end

end
