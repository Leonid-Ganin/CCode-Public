local M = {}

M.new = function(title, buttons, listener, dog)
    if not M.group then
        ALERT, dog = false, dog or 5
        M.listener = listener or (function() end)
        M.group, M.buttons = display.newGroup(), {}

        M.bg = display.newRoundedRect(CENTER_X, CENTER_Y - 100, DISPLAY_WIDTH - 100, #buttons > 0 and 110 or 36, 20)
            M.bg:setFillColor(0.2, 0.2, 0.22)
        M.group:insert(M.bg)

        M.title = display.newText({
                text = title, width = DISPLAY_WIDTH - 150, x = CENTER_X,
                y = CENTER_Y, font = 'ubuntu', fontSize = 30
            }) M.title.anchorY = 0
        M.group:insert(M.title)

        M.title.height = M.title.height > DISPLAY_HEIGHT - 300 and DISPLAY_HEIGHT - 300 or M.title.height
        M.bg.height = M.bg.height + M.title.height
        M.title.y = M.bg.y - M.bg.height / 2 + 15

        if dog then
            M.dog0 = display.newImage('Sprites/ccdog0.png', CENTER_X, M.bg.y - M.bg.height / 2 - 75)
                M.dog0.width = 250
                M.dog0.height = 250
                M.dog0.isVisible = false
            M.group:insert(M.dog0)

            M.dog = ROBODOG.getDog(CENTER_X, M.bg.y - M.bg.height / 2 - 75, 250, 250, dog)
            M.dog:addEventListener('touch', function(e)
                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    M.dog.isVisible = false
                    M.dog0.isVisible = true
                    e.target.click = true
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    M.dog.isVisible = true
                    M.dog0.isVisible = false
                    if e.target.click then e.target.click = false end
                end return true
            end) M.group:insert(M.dog)
        end

        for i = 1, #buttons do
            M.buttons[i] = display.newRect(M.bg.x - M.bg.width / 4 + 5, M.bg.y + M.bg.height / 2 - 10, M.bg.width / 2 - 30, 60)
                M.buttons[i].x = i == 2 and M.bg.x + M.bg.width / 4 - 5 or M.buttons[i].x
                M.buttons[i]:setFillColor(0.2, 0.2, 0.22)
                M.buttons[i].anchorY = 1
                M.buttons[i].id = i
            M.group:insert(M.buttons[i])

            M.buttons[i].text = display.newText({
                    text = buttons[i], width = M.buttons[i].width - 10, align = 'center',
                    x = M.buttons[i].x, y = M.buttons[i].y - M.buttons[i].height / 2, font = 'ubuntu', fontSize = 22
                }) M.buttons[i].text.height = M.buttons[i].text.height > M.buttons[i].height - 10 and M.buttons[i].height - 10 or M.buttons[i].text.height
            M.group:insert(M.buttons[i].text)

            M.buttons[i]:addEventListener('touch', function(e)
                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    e.target:setFillColor(0.24, 0.24, 0.26)
                    e.target.click = true
                elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22)
                    e.target.click = false
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22)
                    if e.target.click then
                        e.target.click = false
                        M.remove(e.target.id)
                    end
                end

                return true
            end)
        end

        M.group:toFront()
        if #buttons > 0 then EXITS.add(M.remove, 0) end
    end
end

M.remove = function(index)
    pcall(function()
        if M and M.group then
            ALERT = true
            M.listener({index = index})
            M.group:removeSelf()
            M.group = nil
        end
    end)
end

return M
