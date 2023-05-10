local LISTENER = require 'Core.Modules.params-listener'
local M  = {}

M.getTextY = function(count)
    return -32 - 30 * math.round((count - 2 < 0 and 0 or count - 2) / 2, 0)
end

M.getParamsNameX = function(count, width)
    local result = {90 - width / 2}

    for i = 2, count do
        result[i] = count % 2 == 0 and (i % 2 == 0 and 80 or 90 - width / 2) or (i % 2 == 0 and 90 - width / 2 or 80)
    end

    return result
end

M.getParamsLineX = function(count, width)
    local result = {175 - width / 2}

    for i = 2, count do
        result[i] = count % 2 == 0 and (i % 2 == 0 and 160 or 175 - width / 2) or (i % 2 == 0 and 175 - width / 2 or 160)
    end

    return result
end

M.getParamsNameY = function(count)
    local result = {22 - 30 * math.round((count - 2 < 0 and 0 or count - 2) / 2, 0)}

    for i = 2, count do
        result[i] = count % 2 == 0 and (i % 2 == 0 and result[i-1] or result[i-1] + 60) or (i % 2 == 0 and result[i-1] + 60 or result[i-1])
    end

    return result
end

M.getParamsLineWidth = function(count, width)
    local result = {count % 2 == 0 and width / 2 - 185 or width - 200}

    for i = 2, count do
        result[i] = width / 2 - 185
    end

    return result
end

M.getParamsValueText = function(params, i)
    local result = ''
    local lastFun = false

    if params[i] then
        for _, value in pairs(params[i]) do
            if value[2] == 't' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                -- if UTF8.len(value[1]) > 30 then value[1] = UTF8.sub(value[1], 1, 30) end
                result = result .. '\'' .. value[1]:gsub('\n', ' '):gsub('\r', '') .. '\''
            elseif value[2] == 'n' or value[2] == 'u' or value[2] == 'c' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. value[1]
            elseif value[2] == 'fP' or value[2] == 'fS' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. '$' .. value[1]
            elseif value[2] == 'fC' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. '$' .. (STR['blocks.' .. value[1]] or (BLOCKS.custom and BLOCKS.custom.name or 'a'))
            elseif value[2] == 'tP' or value[2] == 'tS' or value[2] == 'tE' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. '{' .. value[1] .. '}'
            elseif value[2] == 'vP' or value[2] == 'vS' or value[2] == 'vE' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. '"' .. value[1] .. '"'
            elseif value[2] == 'f' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.fun.' .. value[1]]
                lastFun = true
            elseif value[2] == 'm' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.math.' .. value[1]]
                lastFun = true
            elseif value[2] == 'p' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.prop.' .. value[1]]
                lastFun = true
            elseif value[2] == 'sl' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. (STR['blocks.select.' .. value[1]] or value[1])
            elseif value[2] == 'l' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                if STR['editor.list.log.' .. value[1]]
                then result = result .. STR['editor.list.log.' .. value[1]]
                else result = result .. value[1] end
                lastFun = false
            elseif value[2] == 'd' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.device.' .. value[1]]
                lastFun = false
            elseif value[2] == 's' then
                if UTF8.len(result) > 0 and (not lastFun or value[1] ~= '(') then result = result .. ' ' end
                result = result .. value[1]
                if value[1] == ',' then result = result .. ' ' end
            end
        end
    end

    return result
end

M.getPolygonParams = function(event, blockWidth, blockHeight)
    if event then
        return {
            -blockWidth / 2, -blockHeight / 2, -blockWidth / 2, blockHeight / 2,
            blockWidth / 2, blockHeight / 2, blockWidth / 2, -blockHeight / 2,
            blockWidth / 2 - 1, -blockHeight / 2 - 1, blockWidth / 2 - 1, -blockHeight / 2 - 2,
            blockWidth / 2 - 1, -blockHeight / 2 - 3, blockWidth / 2 - 1, -blockHeight / 2 - 4,
            blockWidth / 2 - 2, -blockHeight / 2 - 5, blockWidth / 2 - 2, -blockHeight / 2 - 6,
            blockWidth / 2 - 3, -blockHeight / 2 - 7, blockWidth / 2 - 3, -blockHeight / 2 - 8,
            blockWidth / 2 - 4, -blockHeight / 2 - 9, blockWidth / 2 - 5, -blockHeight / 2 - 10,
            blockWidth / 2 - 6, -blockHeight / 2 - 11, blockWidth / 2 - 7, -blockHeight / 2 - 12,
            blockWidth / 2 - 8, -blockHeight / 2 - 12, blockWidth / 2 - 9, -blockHeight / 2 - 13,
            blockWidth / 2 - 10, -blockHeight / 2 - 13, blockWidth / 2 - 11, -blockHeight / 2 - 14,
            -blockWidth / 2 + 11, -blockHeight / 2 - 14, -blockWidth / 2 + 10, -blockHeight / 2 - 13,
            -blockWidth / 2 + 9, -blockHeight / 2 - 13, -blockWidth / 2 + 8, -blockHeight / 2 - 12,
            -blockWidth / 2 + 7, -blockHeight / 2 - 12, -blockWidth / 2 + 6, -blockHeight / 2 - 11,
            -blockWidth / 2 + 5, -blockHeight / 2 - 10, -blockWidth / 2 + 4, -blockHeight / 2 - 9,
            -blockWidth / 2 + 3, -blockHeight / 2 - 8, -blockWidth / 2 + 3, -blockHeight / 2 - 7,
            -blockWidth / 2 + 2, -blockHeight / 2 - 6, -blockWidth / 2 + 2, -blockHeight / 2 - 5,
            -blockWidth / 2 + 1, -blockHeight / 2 - 4, -blockWidth / 2 + 1, -blockHeight / 2 - 3,
            -blockWidth / 2 + 1, -blockHeight / 2 - 2, -blockWidth / 2 + 1, -blockHeight / 2 - 1
        }
    else
        return {
            -blockWidth / 2, -blockHeight / 2, -blockWidth / 2, blockHeight / 2,
            blockWidth / 2, blockHeight / 2, blockWidth / 2, -blockHeight / 2
        }
    end
end

M.new = function(name, scroll, group, index, event, params, comment, nested, vars, tables)
    local blockWidth, size = DISPLAY_WIDTH - LEFT_HEIGHT - RIGHT_HEIGHT - 60, SIZE
    local lengthParams = #INFO.listName[name] - 1 if blockWidth / 116 > 15 then blockWidth = 116 * 15 end
    local blockHeight = 116 + 60 * math.round((lengthParams - 2 < 0 and 0 or lengthParams - 2) / 2, 0)
    local blockParams = M.getPolygonParams(event, blockWidth, event and blockHeight - 14 or blockHeight)

    local blockHeight, blockWidth = blockHeight / size, blockWidth / size
    local _polygon = display.newPolygon(0, 0, blockParams) _polygon.strokeWidth = 4
    local pwidth = _polygon.width _polygon:removeSelf() for i = 1, #blockParams do blockParams[i] = blockParams[i] / size end

    local y = index == 1 and 50 or group.blocks[index - 1].y + group.blocks[index - 1].block.height / 2 + (blockHeight + 4) / 2 - 4
    local addY = index == 1 and 24 + (blockHeight - 116) / 2 or 24
    if event then y = y + addY end table.insert(group.blocks, index, display.newGroup())

    local custom, color = GET_GAME_CUSTOM()
    if INFO.getType(name) == 'custom' and UTF8.sub(name, 1, 1) ~= '_' then
        local index = UTF8.gsub(name, 'custom', '', 1)
        color = (index and custom[index]) and custom[index][5] or nil
        color = type(color) == 'table' and {color[1] / 255, color[2] / 255, color[3] / 255} or {0.36, 0.47, 0.5}
    end

    group.blocks[index].data = {event = event, comment = comment, name = name, params = params, nested = nested, vars = vars, tables = tables}
    group.blocks[index].x, group.blocks[index].y, BLOCK_CENTER_X = scroll.width / 2, y, scroll.width / 2

    group.blocks[index].block = display.newPolygon(0, 0, blockParams)
        group.blocks[index].block:setFillColor(INFO.getBlockColor(name, comment, nil, color))
        group.blocks[index].block:setStrokeColor(0.3)
        group.blocks[index].block.strokeWidth = 4
        group.blocks[index]:addEventListener('touch', require 'Core.Modules.logic-listener')
    group.blocks[index]:insert(group.blocks[index].block)

    for i = index + 1, #group.blocks do
        group.blocks[i].y = group.blocks[i].y + (group.blocks[index].block.height - 4 + (event and 24 or 0))
    end

    group.blocks[index].text = display.newText({
            text = STR['blocks.' .. name], width = blockWidth - 20, height = 38 / size, fontSize = 30 / size,
            align = 'left', x = 10 / size, y = M.getTextY(lengthParams) / size, font = 'ubuntu'
        })
    group.blocks[index]:insert(group.blocks[index].text)

    if nested then
        local polygonX = group.blocks[index].block.x + group.blocks[index].block.width / 2 - 25
        local polygonY = group.blocks[index].block.y - group.blocks[index].block.height / 2 + 20

        group.blocks[index].polygon = display.newPolygon(polygonX, polygonY, {0, 0, 10 / size, 10 / size, -10 / size, 10 / size})
            group.blocks[index].polygon.yScale = #nested > 0 and 1 or -1
            group.blocks[index].polygon:setFillColor(#nested > 0 and 0.25 or 1)
        group.blocks[index]:insert(group.blocks[index].polygon)
    end

    group.blocks[index].checkbox = WIDGET.newSwitch({
            x = (-scroll.width / 2 + group.blocks[index].block.x - group.blocks[index].block.width / 2) / 2 - 10, y = 0,
            style = 'checkbox', width = 50, height = 50, onPress = function(event) event.target:setState({isOn = not event.target.isOn}) end
        }) group.blocks[index].checkbox.isVisible = false
    group.blocks[index]:insert(group.blocks[index].checkbox)

    group.scrollHeight = group.scrollHeight + group.blocks[index].block.height - 4
    if event then group.scrollHeight = group.scrollHeight + 24 end

    group.blocks[index].params = {}
    group.blocks[index].rects = display.newGroup()
    group.blocks[index]:insert(group.blocks[index].rects)

    for i = 1, lengthParams do
        local textGetHeight = display.newText({
            text = STR['blocks.' .. name .. '.params'][i], align = 'left',
            fontSize = 22 / size, x = 0, y = 5000, font = 'ubuntu', width = 143 / size
        }) if textGetHeight.height / size > 53 / size then textGetHeight.height = 53 / size end

        local nameY = M.getParamsNameY(lengthParams)[i]
        local width = pwidth

        group.blocks[index].params[i] = {}
        group.blocks[index].params[i].name = display.newText({
                text = STR['blocks.' .. name .. '.params'][i], align = 'left', height = textGetHeight.height, fontSize = 22 / size,
                x = M.getParamsNameX(lengthParams, width)[i] / size, y = nameY / size, font = 'ubuntu', width = 143 / size
            }) textGetHeight:removeSelf()
        group.blocks[index]:insert(group.blocks[index].params[i].name)

        group.blocks[index].params[i].line = display.newRect(M.getParamsLineX(lengthParams, width)[i] / size, (nameY + 20) / size, M.getParamsLineWidth(lengthParams, width)[i] / size, 3 / size)
            group.blocks[index].params[i].line:setFillColor(0.3)
            group.blocks[index].params[i].line.anchorX = 0
        group.blocks[index]:insert(group.blocks[index].params[i].line)

        group.blocks[index].params[i].value = display.newText({
                text = M.getParamsValueText(params, i), height = 26 / size, width = (M.getParamsLineWidth(lengthParams, width)[i] - 5) / size,
                x = M.getParamsLineX(lengthParams, width)[i] / size, y = (nameY + 5) / size, font = 'ubuntu', fontSize = 20 / size, align = 'center'
            }) group.blocks[index].params[i].value.anchorX = 0
        group.blocks[index]:insert(group.blocks[index].params[i].value)

        group.blocks[index].params[i].rect = display.newRect(M.getParamsLineX(lengthParams, width)[i] / size, (nameY + 20) / size, M.getParamsLineWidth(lengthParams, width)[i] / size, 40 / size)
            group.blocks[index].params[i].rect:setFillColor(1)
            group.blocks[index].params[i].rect.alpha = 0.005
            group.blocks[index].params[i].rect.anchorX = 0
            group.blocks[index].params[i].rect.anchorY = 1
            group.blocks[index].params[i].rect.index = i
        group.blocks[index].rects:insert(group.blocks[index].params[i].rect)

        group.blocks[index].params[i].rect:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
                e.target:setFillColor(0.8, 0.8, 1)
                e.target.alpha = 0.2
            elseif e.phase == 'moved' and math.abs(e.y - e.yStart) > 20 then
                BLOCKS.group[8]:takeFocus(e)
                e.target.click = false
                e.target:setFillColor(1)
                e.target.alpha = 0.005
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then
                    e.target.click = false
                    e.target:setFillColor(1)
                    e.target.alpha = 0.005
                    LISTENER.open(e.target)
                end
            end

            return true
        end)
    end

    group.blocks[index].getIndex = function(target)
        for i = 1, #group.blocks do
            if group.blocks[i] == target then
                return i
            end
        end
    end

    scroll:insert(group.blocks[index])
    scroll:setScrollHeight(GET_SCROLL_HEIGHT(group))
end

return M
