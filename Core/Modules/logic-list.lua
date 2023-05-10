local LISTENER = require 'Core.Interfaces.blocks'
local BLOCK = require 'Core.Modules.logic-block'
local M = {}

local function getButtonText(comment, nested, name)
    local comment = comment and STR['button.uncomment'] or STR['button.comment']
    local nested = nested and (#nested > 0 and STR['button.show'] or STR['button.hide']) or nil
    local addIfElse = name == 'if' and STR['button.addIfElse'] or nil
    return {STR['button.remove'], STR['button.copy'], comment, nested, addIfElse}
end

M.remove = function()
    pcall(function()
        M.group:removeSelf()
        M.group, ALERT = nil, true
        BLOCKS.group[8]:setIsLocked(false, 'vertical')
    end)
end

M.create = function(data, size, twidth, tsize, needParams)
    local block = display.newGroup()
        block.x = CENTER_X
        block.y = CENTER_Y
        block.params = {}
    local tsize = tsize or 1.0

    local blockWidth = DISPLAY_WIDTH - LEFT_HEIGHT - RIGHT_HEIGHT - 60
    local lengthParams = needParams or #data.params if blockWidth / 116 > 15 then blockWidth = 116 * 15 end
    local blockHeight = 116 + 60 * math.round((lengthParams - 2 < 0 and 0 or lengthParams - 2) / 2, 0)
    local color = type(data.color) == 'table' and COPY_TABLE(data.color) or nil

    local polygon = BLOCK.getPolygonParams(data.event, blockWidth, data.event and blockHeight - 14 or blockHeight)
    local _polygon = display.newPolygon(0, 0, polygon) _polygon.strokeWidth = 4
    local pwidth = (twidth and type(twidth) == 'number') and twidth or _polygon.width _polygon:removeSelf()
    for i = 1, #polygon do polygon[i] = i % 2 == 0 and polygon[i] / size or  polygon[i] / size * tsize end

    if not color then
        local custom = GET_GAME_CUSTOM()
        if INFO.getType(data.name) == 'custom' and UTF8.sub(data.name, 1, 1) ~= '_' then
            local index = UTF8.gsub(data.name, 'custom', '', 1)
            color = (index and custom[index]) and custom[index][5] or nil
            color = type(color) == 'table' and {color[1] / 255, color[2] / 255, color[3] / 255} or {0.36, 0.47, 0.5}
        end
    end

    block.block = display.newPolygon(0, 0, polygon)
        block.block:setFillColor(INFO.getBlockColor(data.name, data.comment, nil, color))
        block.block:setStrokeColor(0.3)
        block.block.strokeWidth = 4
    block:insert(block.block)

    block.text = display.newText({
            text = STR['blocks.' .. data.name], width = block.block.width - 20, height = 38 / size, fontSize = 30 / size,
            align = 'left', x = 10 / size, y = BLOCK.getTextY(lengthParams) / size, font = 'ubuntu'
        })
    block:insert(block.text)

    block.rects = display.newGroup()
    block:insert(block.rects)

    for i = 1, lengthParams do
        local name = STR['blocks.' .. data.name .. '.params']
            and STR['blocks.' .. data.name .. '.params'][i]
            or STR['blocks.params'] .. (i - 1) .. ':'
        local nameX = BLOCK.getParamsNameX(lengthParams, pwidth)[i]
        local nameY = BLOCK.getParamsNameY(lengthParams)[i]

        local lineWidth = BLOCK.getParamsLineWidth(lengthParams, pwidth)[i]
        local lineX = BLOCK.getParamsLineX(lengthParams, pwidth)[i]
        local lineY = nameY + 20

        local textGetHeight = display.newText({
                text = name, align = 'left',
                fontSize = 22, x = 0, y = 5000,
                font = 'ubuntu', width = 143
            })
        if textGetHeight.height > 53 then textGetHeight.height = 53 end

        block.params[i] = {}
        block.params[i].name = display.newText({
                text = name, align = 'left', height = textGetHeight.height / size, width = 143 / size,
                fontSize = 22 / size, x = nameX / size, y = nameY / size, font = 'ubuntu'
            }) textGetHeight:removeSelf()
        block:insert(block.params[i].name)

        block.params[i].line = display.newRect(lineX / size, lineY / size, lineWidth / size, 3 / size)
            block.params[i].line:setFillColor(0.3)
            block.params[i].line.anchorX = 0
        block:insert(block.params[i].line)

        block.params[i].value = display.newText({
                text = BLOCK.getParamsValueText(data.params, i), width = (lineWidth - 5) / size, height = 26 / size,
                y = (lineY - 15) / size, x = lineX / size, font = 'ubuntu', fontSize = 20 / size, align = 'center'
            }) block.params[i].value.anchorX = 0
        block:insert(block.params[i].value)

        if twidth then
            block.params[i].rect = display.newRect(lineX / size, lineY / size, lineWidth / size, 40 / size)
                block.params[i].rect:setFillColor(1)
                block.params[i].rect.alpha = 0.005
                block.params[i].rect.anchorX = 0
                block.params[i].rect.anchorY = 1
                block.params[i].rect.index = i
            block.rects:insert(block.params[i].rect)
        end
    end

    return block
end

M.new = function(target)
    if not M.group and UTF8.sub(target.data.name, UTF8.len(target.data.name) - 2, UTF8.len(target.data.name)) ~= 'End' then
        M.group, ALERT = display.newGroup(), false
        BLOCKS.group[8]:setIsLocked(true, 'vertical')

        local size, nested = 1.6, target.data.nested
        local needParams = #target.data.params > 12 and 12 or #target.data.params
        local theight = 120 + 60 * math.round((needParams - 2 < 0 and 0 or needParams - 2) / 2, 0)
        local height = nested and theight / size + 340 or theight / size + 264
        local width = target.block.width / size + 20 if target.data.name == 'if' then height = height + 76 end

        local bg = display.newRect(CENTER_X, CENTER_Y, DISPLAY_WIDTH * 2, DISPLAY_HEIGHT * 2)
            bg:setFillColor(1, 0.005)
        M.group:insert(bg)

        local rect = display.newRoundedRect(CENTER_X, CENTER_Y, width, height, 20)
            rect:setFillColor(0.2, 0.2, 0.22)
        M.group:insert(rect)

        local comment = target.data.comment
        local name = target.data.name
        local length = #INFO.listName[name] - 1
        local _length = #target.data.params

        if _length > length then
            for i = 1, _length do
                if i > length then
                    table.remove(target.data.params, length + 1)
                end
            end
        elseif length > _length then
            for i = 1, length do
                if i > _length then
                    table.insert(target.data.params, _length + 1, {})
                end
            end
        end

        local block = M.create(target.data, size, nil, nil, needParams)
            block.y = block.y - height / 2 + 10 + theight / 2 / size
            local y = block.y + block.block.height / 2 + 50
        M.group:insert(block)

        for i = 1, #getButtonText(comment, nested, name) do
            local button = display.newRect(CENTER_X, y, width - 25, 66)
                button:setFillColor(0.2, 0.2, 0.22)
            M.group:insert(button)

            button.text = display.newText({
                    text = getButtonText(comment, nested, name)[i], align = 'left', fontSize = 24,
                    x = CENTER_X + 10, y = y, font = 'ubuntu', height = 28, width = width - 40
                }) button.text.id = i
            M.group:insert(button.text)

            button:addEventListener('touch', function(e)
                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    e.target:setFillColor(0.22, 0.22, 0.24)
                    e.target.click = true
                elseif e.phase == 'moved' and math.abs(e.y - e.yStart) > 20 then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22)
                    e.target.click = false
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22)
                    if e.target.click then
                        e.target.click = false
                        INDEX_LIST = e.target.text.id

                        for j = 1, #BLOCKS.group.blocks do
                            BLOCKS.group.blocks[j].x = BLOCKS.group.blocks[j].x + 20
                            BLOCKS.group.blocks[j].checkbox.isVisible = true
                            BLOCKS.group.blocks[j].rects.isVisible = false
                        end

                        onCheckboxPress({target = target}) M.remove()
                        LISTENER({target = {button = 'but_okay', click = true}, phase = 'ended'})
                    end
                end

                return true
            end)

            y = y + 76
        end

        bg:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then
                    e.target.click = false
                    M.remove()
                end
            end return true
        end)

        rect:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
            end return true
        end)
    end
end

return M
