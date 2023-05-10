local listeners = {}

listeners.title = function()
    EXITS.robodog()
end

listeners.toolbar = function(e)
    if e.target.tag then
        local index = ({dogs = 2, ach = 4, shop = 6, learn = 8})[e.target.tag]

        for i = 2, 8, 2 do
            if ROBODOG.group[i].isOn and i ~= index then
                ROBODOG.group[i].isOn = false
                ROBODOG.group[i].alpha = 0.1
                break
            elseif ROBODOG.group[i].isOn and i == index then
                return
            end
        end

        e.target.isOn = true
        e.target.alpha = 0.3

        listeners[e.target.tag](e)
    end
end

listeners.dogs = function(e)
    print(1)
end

listeners.ach = function(e)
    print(2)
end

listeners.shop = function(e)
    print(3)
end

listeners.learn = function(e)
    print(4)
end

listeners.face = function()
    local y_frame = ROBODOG.face.y + ROBODOG.face.height / 2 + 50

    for i = 1, 5 do
        local _y_frame = MAX_Y + DISPLAY_HEIGHT / 2

        pcall(function() transition.to(ROBODOG.frames[i], {y = y_frame}) end)
        pcall(function() transition.to(ROBODOG.frames[i].content, {y = y_frame - 3}) end)
        y_frame = i % 5 == 0 and y_frame + DISPLAY_WIDTH / 6 or y_frame

        for j = 1, 40 do
            pcall(function()
                transition.to(ROBODOG['frames' .. i][j], {y = _y_frame})
                transition.to(ROBODOG['frames' .. i][j].content, {y = _y_frame})
                _y_frame = j % 6 == 0 and _y_frame + DISPLAY_WIDTH / 7 or _y_frame
            end)
        end
    end ROBODOG.group.isOpen = false
end

listeners.frame = function(e)
    if not ((LOCAL.dog.face == 3 or LOCAL.dog.face == 6 or LOCAL.dog.face == 15) and e.i == 3) then
        local y_frame = ROBODOG.face.y + ROBODOG.face.height / 2 + 50

        for i = 1, 5 do
            pcall(function() transition.to(ROBODOG.frames[i], {y = MAX_Y + DISPLAY_HEIGHT / 2}) end)
            pcall(function() transition.to(ROBODOG.frames[i].content, {y = MAX_Y + DISPLAY_HEIGHT / 2}) end)
        end

        for i = 1, 40 do
            pcall(function()
                transition.to(ROBODOG['frames' .. e.i][i], {y = y_frame})
                transition.to(ROBODOG['frames' .. e.i][i].content, {y = y_frame - 3})
                y_frame = i % 6 == 0 and y_frame + DISPLAY_WIDTH / 7 or y_frame
            end)
        end ROBODOG.group.isOpen = true
    end
end

listeners.frames = function(e)
    if (LOCAL.dog.face == 3 or LOCAL.dog.face == 6 or LOCAL.dog.face == 15) then
        if e.i == 1 and not (e.j == 3 or e.j == 6 or e.j == 15) then
            ROBODOG.ears.fill = {
                type = 'image', filename = ROBODOG.getPath(3, 1)
            } ROBODOG.frames[3].content.fill = {
                type = 'image', filename = ROBODOG.getPath(3, 1)
            } LOCAL.dog.ears = 1
        end
    end

    ROBODOG[({'face', 'eyes', 'ears', 'mouth', 'accessories'})[e.i]].fill = {
        type = 'image', filename = ROBODOG.getPath(e.i, e.j)
    } ROBODOG.frames[e.i].content.fill = {
        type = 'image', filename = ROBODOG.getPath(e.i, e.j)
    } LOCAL.dog[({'face', 'eyes', 'ears', 'mouth', 'accessories'})[e.i]] = e.j

    if e.i == 1 and (e.j == 3 or e.j == 6 or e.j == 15) then
        ROBODOG.ears.fill = {
            type = 'image', filename = ROBODOG.getPath(3, 36)
        } ROBODOG.frames[3].content.fill = {
            type = 'image', filename = ROBODOG.getPath(3, 36)
        } LOCAL.dog.ears = 36
    end

    NEW_DATA()
end

return function(e, type)
    if ALERT then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            if type == 'title' then e.target.alpha = 0.6 end
            e.target.click = true
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            display.getCurrentStage():setFocus(nil)
            if type == 'title' then e.target.alpha = 1 end
            e.target.click = false
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if type == 'title' then e.target.alpha = 1 end
            if e.target.click then
                e.target.click = false
                listeners[type](e)
            end
        end
    end

    return true
end
