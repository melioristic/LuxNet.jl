function drawnet(pixel::Pixel)
    setline(1.0)
    setcolor(pixel.color)
    b = box(pixel.position, pixel.width*pixel.w_scale, pixel.height*pixel.h_scale, action = :fillpreserve)
    sethue(cmap_base[6])
    strokepath()
    sethue("black")
    b
end

function drawnet(pattern::Pattern)
    for h_index=1:pattern.n_pixel_h
        new_pattern = deepcopy(pattern)

        if size(pattern.color) == (1,)
            new_pattern.pixel.color = pattern.color[1]
        end        

        x = new_pattern.pixel.position.x
        x += (h_index-1)*new_pattern.pixel.w_scale*new_pattern.pixel.width
  
        new_pattern.pixel.position = Point(x, new_pattern.pixel.position.y) 

        for v_index=1:pattern.n_pixel_v 
            y = pattern.pixel.position.y+(v_index-1)*pattern.pixel.h_scale*new_pattern.pixel.height
            new_pattern.pixel.position = Point(new_pattern.pixel.position.x, y )

            if size(pattern.color) == (pattern.n_pixel_v, )
                new_pattern.pixel.color = pattern.color[v_index]
            end 
            drawnet(new_pattern.pixel)
        end
    end
end


function drawnet(stacked_pattern::StackedPattern)
    for i=1:stacked_pattern.n_stack
        drawnet(stacked_pattern.pattern)
        x = stacked_pattern.pattern.pixel.position.x + stacked_pattern.pattern.pixel.width*stacked_pattern.pattern.pixel.w_scale*stacked_pattern.x_offset
        y = stacked_pattern.pattern.pixel.position.y + stacked_pattern.pattern.pixel.height*stacked_pattern.pattern.pixel.h_scale*stacked_pattern.y_offset

        new_point = Point((x,y))
        stacked_pattern.pattern.pixel.position = new_point
    end

end
