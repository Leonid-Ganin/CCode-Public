local M = {}

M.new = function(title, textListener, inputListener, oldText, textCheckbox, isTextEditor)
    if not M.group then
        ALERT = false
        M.listener = inputListener
        M.group, M.count = display.newGroup(), isTextEditor and 4 or 0
        M.y = isTextEditor and -120 or 0

        local textCheckbox = (_G.type(textCheckbox) ~= 'table' and _G.type(textCheckbox) ~= 'nil') and {textCheckbox} or textCheckbox
        local isAddHeight = textCheckbox or isTextEditor local textCheckbox = textCheckbox or {}
        local bgY = CENTER_Y - (isAddHeight and (#textCheckbox == 2 and 50 or 75) or 100) + M.y
        local bgHeight = isAddHeight and (#textCheckbox == 2 and 200 or 150) or 100

        M.bg = display.newRoundedRect(CENTER_X, bgY, DISPLAY_WIDTH - 100, bgHeight, 20)
            M.bg:setFillColor(0.2, 0.2, 0.22)
            M.bg.height = M.bg.height + (IS_SIM and 46 * M.count or 40 * M.count)
        M.group:insert(M.bg)

        if isTextEditor then
            M.box = native.newTextBox(5000, CENTER_Y - 110 + M.y, DISPLAY_WIDTH - 150, not IS_SIM and 36 + 40 * M.count or 72 + 44 * M.count)
        else
            M.box = native.newTextField(5000, CENTER_Y - 110 + M.y, DISPLAY_WIDTH - 150, not IS_SIM and 36 or 72)
        end

        timer.performWithDelay(0, function()
            if not ALERT then
                M.box.x = CENTER_X
                M.box.isEditable = true
                M.box.hasBackground = false
                M.box.placeholder = title
                M.box.font = native.newFont('ubuntu.ttf', 36)
                M.box.text = type(oldText) == 'string' and oldText or ''

                if system.getInfo 'platform' == 'android' and not IS_SIM then
                    M.box:setTextColor(0.9)
                else
                    M.box:setTextColor(0.1)
                end
            end
        end)

        M.box:addEventListener('userInput', textListener)
        M.box:setSelection(UTF8.len(M.box.text))
        M.group:insert(M.box)

        M.line = display.newRect(M.group, CENTER_X, CENTER_Y - 75 + (IS_SIM and 22 or 18) * M.count + M.y, DISPLAY_WIDTH - 150, 2)
        M.group:insert(M.line) M.checkbox = {}

        if _G.type(textCheckbox) == 'table' and #textCheckbox > 0 then
            local y = (M.bg.y + M.bg.height / 2 + M.line.y) / 2
            local y = #textCheckbox == 2 and y - 25 or y

            for i = 1, #textCheckbox do
                M.checkbox[i] = WIDGET.newSwitch({
                        x = M.line.x - M.line.width / 2 + 35, y = y,
                        style = 'checkbox', width = 70, height = 70
                    })
                M.group:insert(M.checkbox[i])

                M.text = display.newText(textCheckbox[i], M.checkbox[i].x + 35, M.checkbox[i].y - 1, 'ubuntu', 28)
                    M.text.anchorX = 0
                M.group:insert(M.text)

                y = y + 55
            end
        elseif isTextEditor then
            M.buttonOK = display.newRoundedRect(M.line.x + M.line.width / 2 - 50, (M.bg.y + M.bg.height / 2 + M.line.y) / 2 + 2, 100, 60, 10)
                M.text = display.newText(M.group, STR['button.okay'], M.buttonOK.x, M.buttonOK.y, 'ubuntu', 28)
                M.buttonOK.alpha = 0.005
            M.group:insert(M.buttonOK)

            M.buttonOK:addEventListener('touch', function(e)
                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    e.target.click = true
                    e.target.alpha = 0.1
                elseif e.phase == 'moved' and (math.abs(e.xDelta) > 30 or math.abs(e.yDelta) > 30) then
                    display.getCurrentStage():setFocus(nil)
                    e.target.click = false
                    e.target.alpha = 0.005
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    e.target.alpha = 0.005
                    if e.target.click then
                        e.target.click = false
                        M.remove(true, M.box.text)
                    end
                end

                return true
            end)
        end

        M.group:toFront()
        EXITS.add(M.remove, false)
    end
end

M.remove = function(input, text)
    if M and M.group then
        ALERT = true
        native.setKeyboardFocus(nil)
        M.listener({
            input = input, text = text,
            checkbox = M.checkbox[1] and M.checkbox[1].isOn,
            checkbox2 = M.checkbox[2] and M.checkbox[2].isOn
        }) M.group:removeSelf() M.group = nil
    end
end

return M
