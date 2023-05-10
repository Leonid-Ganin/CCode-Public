local CUSTOM = require 'Core.Modules.custom-block'
local BLOCK = require 'Core.Modules.logic-block'
local M = {}

local function showTypeScroll(event)
    if event.phase == 'began' then
        display.getCurrentStage():setFocus(event.target)
        event.target.click = true
    elseif event.phase == 'moved' then
        if math.abs(event.x - event.xStart) > 30 or math.abs(event.y - event.yStart) > 30 then
            display.getCurrentStage():setFocus(nil)
            event.target.click = false
        end
    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        if event.target.click then event.target.click = false
            if M.group.currentIndex ~= event.target.index and (not INFO.listDeleteType[event.target.index] or not NOOBMODE) then
                if M.group.types[event.target.index].currentScroll == 3 then
                    M.group.types[event.target.index].scroll3.isVisible = true
                elseif M.group.types[event.target.index].currentScroll == 2 then
                    M.group.types[event.target.index].scroll2.isVisible = true
                else
                    M.group.types[event.target.index].scroll.isVisible = true
                end

                if M.group.types[M.group.currentIndex].currentScroll == 3 then
                    M.group.types[M.group.currentIndex].scroll3.isVisible = false
                elseif M.group.types[M.group.currentIndex].currentScroll == 2 then
                    M.group.types[M.group.currentIndex].scroll2.isVisible = false
                else
                    M.group.types[M.group.currentIndex].scroll.isVisible = false
                end

                M.group[4].isVisible = event.target.index == 1
                M.group[3].isVisible = event.target.index == 1 or event.target.index == 15 or event.target.index == 5
                or event.target.index == 9 or event.target.index == 6 or event.target.index == 7 or event.target.index == 4
                or event.target.index == 2 or event.target.index == 3 or event.target.index == 11
                 or event.target.index == 8 or event.target.index == 12
                for i = 5, 10 do M.group[i].isVisible = event.target.index == 15 end
                for i = 19, 20 do M.group[i].isVisible = event.target.index == 15 end
                for i = 11, 14 do M.group[i].isVisible = event.target.index == 9 end
                for i = 15, 18 do M.group[i].isVisible = event.target.index == 6 end
                for i = 33, 34 do M.group[i].isVisible = event.target.index == 6 end
                for i = 21, 24 do M.group[i].isVisible = event.target.index == 3 end
                for i = 25, 28 do M.group[i].isVisible = event.target.index == 2 end
                for i = 29, 32 do M.group[i].isVisible = event.target.index == 7 end
                for i = 35, 38 do M.group[i].isVisible = event.target.index == 11 end
                for i = 39, 42 do M.group[i].isVisible = event.target.index == 5 end
                for i = 43, 46 do M.group[i].isVisible = event.target.index == 4 end
                for i = 47, 48 do M.group[i].isVisible = event.target.index == 7 end
                for i = 49, 52 do M.group[i].isVisible = event.target.index == 8 end
                for i = 53, 56 do M.group[i].isVisible = event.target.index == 12 end
                M.group.currentIndex = event.target.index

                if NOOBMODE and (event.target.index == 2 or event.target.index == 4
                or event.target.index == 5 or event.target.index == 6 or event.target.index == 7) then
                    for i = 25, 28 do M.group[i].isVisible = false end
                    for i = 15, 18 do M.group[i].isVisible = false end
                    for i = 33, 34 do M.group[i].isVisible = false end
                    for i = 29, 32 do M.group[i].isVisible = false end
                    for i = 39, 42 do M.group[i].isVisible = false end
                    for i = 43, 46 do M.group[i].isVisible = false end
                    for i = 47, 48 do M.group[i].isVisible = false end
                    M.group[3].isVisible = false
                end
            elseif NOOBMODE and INFO.listDeleteType[event.target.index] and M.group.isVisible then
                WINDOW.new(STR['blocks.type.noobmode'], {STR['button.okay']}, function(e) end, 5)
                WINDOW.buttons[1].x = WINDOW.bg.x + WINDOW.bg.width / 4 - 5
                WINDOW.buttons[1].text.x = WINDOW.buttons[1].x

                timer.performWithDelay(1, function()
                    pcall(function() if not M.group or not M.group.isVisible then WINDOW.remove(0) end end)
                end)
            end
        end
    end

    return true
end

local function newBlockListener(event)
    pcall(function()
        if event.phase == 'began' then
            display.getCurrentStage():setFocus(event.target)
            event.target.click = true
            event.target.alpha = 0.8
        elseif event.phase == 'moved' then
            if math.abs(event.x - event.xStart) > 30 or math.abs(event.y - event.yStart) > 30 then
                if M.group.types[event.target.index[1]].currentScroll == 3 then
                    M.group.types[event.target.index[1]].scroll3:takeFocus(event)
                elseif M.group.types[event.target.index[1]].currentScroll == 2 then
                    M.group.types[event.target.index[1]].scroll2:takeFocus(event)
                else
                    M.group.types[event.target.index[1]].scroll:takeFocus(event)
                end
                event.target.click = false
                event.target.alpha = 1
            end
        elseif event.phase == 'ended' or event.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            event.target.alpha = 1
            if event.target.click then
                event.target.click = false
                if M.group[7].isOn and event.target.index[1] == 15 then
                    local custom, name = GET_GAME_CUSTOM(), M.listBlock[INFO.listType[event.target.index[1]]][event.target.index[2]]

                    for index, block in pairs(custom) do
                        if 'custom' .. index == name then
                            CUSTOM.newBlock(block[1], block[6], block[2], index, block[5] or {0.36 * 255, 0.47 * 255, 0.5 * 255}) break
                        end
                    end
                elseif M.group[19].isOn and event.target.index[1] == 15 then
                    local name = M.listBlock[INFO.listType[event.target.index[1]]][event.target.index[2]]
                    local custom = GET_GAME_CUSTOM() local _index = tostring(custom.len + 1)

                    for i = 1, custom.len do
                        if not custom[tostring(i)] then
                            _index = tostring(i) break
                        end
                    end

                    for index, block in pairs(custom) do
                        if 'custom' .. index == name then
                            local blockParams = (function() local t = {} for i = 1, #custom[index][2] do t[i] = {'value'} end return t end)()

                            custom.len = custom.len + 1
                            custom[_index] = {
                                custom[index][1],
                                COPY_TABLE(custom[index][2]),
                                type(custom[index][3]) == 'table' and COPY_TABLE(custom[index][3]) or custom[index][3],
                                os.time(),
                                custom[index][5] or {0.36 * 255, 0.47 * 255, 0.5 * 255}
                            }

                            STR['blocks.custom' .. _index] = custom[_index][1]
                            STR['blocks.custom' .. _index .. '.params'] = custom[_index][2]
                            LANG.ru['blocks.custom' .. _index] = custom[_index][1]
                            LANG.ru['blocks.custom' .. _index .. '.params'] = custom[_index][2]
                            INFO.listName['custom' .. _index] = {'custom', unpack(blockParams)}

                            table.insert(INFO.listBlock.custom, 1, 'custom' .. _index)
                            table.insert(INFO.listBlock.everyone, 'custom' .. _index)

                            M.listBlock = COPY_TABLE(INFO.listBlock)
                            SET_GAME_CUSTOM(custom)
                            M.custom(2) break
                        end
                    end
                elseif M.group[9].isOn and event.target.index[1] == 15 then
                    local name = M.listBlock[INFO.listType[event.target.index[1]]][event.target.index[2]]
                    local custom, data = GET_GAME_CUSTOM(), GET_GAME_CODE(CURRENT_LINK)

                    for index, block in pairs(custom) do
                        if 'custom' .. index == name then
                            for i = 1, #INFO.listBlock.custom do
                                if INFO.listBlock.custom[i] == name then table.remove(INFO.listBlock.custom, i) break end
                            end

                            for i = 1, #INFO.listBlock.everyone do
                                if INFO.listBlock.everyone[i] == name then table.remove(INFO.listBlock.everyone, i) break end
                            end

                            for i = 1, #data.scripts do
                                local script, isChange = GET_GAME_SCRIPT(CURRENT_LINK, i, data)
                                for j = #script.params, 1, -1 do
                                    if script.params[j].name == name then
                                        table.remove(script.params, j) isChange = true
                                    end
                                end if isChange then SET_GAME_SCRIPT(CURRENT_LINK, script, i, data) end
                            end

                            INFO.listName[name] = nil
                            BLOCKS.group:removeSelf() BLOCKS.group = nil
                            BLOCKS.create() BLOCKS.custom = nil
                            BLOCKS.group.isVisible = false
                            custom[index] = nil custom.len = custom.len - 1

                            M.listBlock = COPY_TABLE(INFO.listBlock)
                            SET_GAME_CUSTOM(custom)
                            M.custom(2) break
                        end
                    end
                else
                    EXITS.new_block()

                    local data = GET_GAME_CODE(CURRENT_LINK)
                    local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)
                    local scrollY = select(2, BLOCKS.group[8]:getContentPosition())
                    local diffY = BLOCKS.group[8].y - BLOCKS.group[8].height / 2
                    local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150
                    local blockName = M.listBlock[INFO.listType[event.target.index[1]]][event.target.index[2]]
                    local blockEvent = M.group.currentIndex == 2 or INFO.getType(blockName) == 'events'
                    local blockIndex = #BLOCKS.group.blocks + 1
                    local blockParams = {
                        name = blockName, params = {}, event = blockEvent, comment = false,
                        nested = blockEvent and {} or nil, vars = blockEvent and {} or nil, tables = blockEvent and {} or nil
                    }

                    for i = 1, #INFO.listName[blockName] - 1 do
                        if LOCAL.autoplace then
                            if type(INFO.listName[blockName][i + 1][2]) == 'table' and type(INFO.listName[blockName][i + 1][2][1]) == 'table' then
                                blockParams.params[i] = {}

                                for j = 1, #INFO.listName[blockName][i + 1][2] do
                                    blockParams.params[i][j] = INFO.listName[blockName][i + 1][2][j] or {}
                                end
                            else
                                if type(INFO.listName[blockName][i + 1][2]) == 'table' and #INFO.listName[blockName][i + 1][2] == 0 then
                                    blockParams.params[i] = {}
                                else
                                    blockParams.params[i] = {INFO.listName[blockName][i + 1][2]} or {}
                                end
                            end
                        else
                            blockParams.params[i] = {}
                        end
                    end

                    for i = 1, #BLOCKS.group.blocks do
                        if BLOCKS.group.blocks[i].y > targetY then
                            blockIndex = i break
                        end
                    end

                    if not blockEvent and #BLOCKS.group.blocks == 0 then
                        table.insert(script.params, 1, {
                            name = 'onStart', params = {{}}, event = true, comment = false,
                            nested = {}, vars = {}, tables = {}
                        }) BLOCKS.new('onStart', 1, true, {{}}, false, {}, {}, {}) blockIndex = 2
                    end

                    if INFO.listNested[blockName] then
                        blockParams.nested = {}
                        for i = 1, #INFO.listNested[blockName] do
                            table.insert(script.params, blockIndex, {
                                name = INFO.listNested[blockName][i], params = {{}}, event = false, comment = false
                            }) BLOCKS.new(INFO.listNested[blockName][i], blockIndex, false, {{}}, false)
                        end
                    end

                    native.setKeyboardFocus(nil)
                    table.insert(script.params, blockIndex, blockParams)
                    SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
                    BLOCKS.new(blockName, blockIndex, blockEvent, COPY_TABLE(blockParams.params), false, blockParams.nested, blockParams.vars, blockParams.tables)

                    if #BLOCKS.group.blocks > 2 then
                        display.getCurrentStage():setFocus(BLOCKS.group.blocks[blockIndex])
                        BLOCKS.group.blocks[blockIndex].click = true
                        BLOCKS.group.blocks[blockIndex].move = true
                        newMoveLogicBlock({target = BLOCKS.group.blocks[blockIndex]}, BLOCKS.group, BLOCKS.group[8], true)
                    end
                end
            end
        end
    end)

    return true
end

local function textListener(event)
    if event.phase == 'editing' then
        M.boxText = event.target.text
        M.group.types[1].scroll:removeSelf()
        M.group.types[1].scroll = WIDGET.newScrollView({
                x = CENTER_X, y = (M.group[3].y + 2 + M.group[2].y) / 2,
                width = DISPLAY_WIDTH, height = M.group[2].y - M.group[3].y + 2,
                hideBackground = true, hideScrollBar = false,
                horizontalScrollDisabled = true, isBounceEnabled = true,
            })
        M.group:insert(M.group.types[1].scroll)

        local lastY = 90
        local scrollHeight = 50

        for j = 1, #M.listBlock.everyone do
            local notCustom = not (BLOCKS.custom and INFO.getType(M.listBlock.everyone[j]) == 'custom' and j ~= 1)

            if UTF8.find(UTF8.lower(STR['blocks.' .. M.listBlock.everyone[j]]), UTF8.lower(M.boxText), 1, true) and notCustom then
                local event = INFO.getType(M.listBlock.everyone[j]) == 'events'

                M.group.types[1].blocks[j] = display.newPolygon(0, 0, BLOCK.getPolygonParams(event, DISPLAY_WIDTH - RIGHT_HEIGHT - 60, event and 102 or 116))
                    M.group.types[1].blocks[j].x = DISPLAY_WIDTH / 2
                    M.group.types[1].blocks[j].y = lastY
                    M.group.types[1].blocks[j]:setFillColor(INFO.getBlockColor(M.listBlock.everyone[j]))
                    M.group.types[1].blocks[j]:setStrokeColor(0.3)
                    M.group.types[1].blocks[j].strokeWidth = 4
                    M.group.types[1].blocks[j].index = {1, j}
                    M.group.types[1].blocks[j]:addEventListener('touch', newBlockListener)
                M.group.types[1].scroll:insert(M.group.types[1].blocks[j])

                M.group.types[1].blocks[j].text = display.newText({
                        text = STR['blocks.' .. M.listBlock.everyone[j]],
                        x = DISPLAY_WIDTH / 2 - M.group.types[1].blocks[j].width / 2 + 20,
                        y = lastY, width = M.group.types[1].blocks[j].width - 40,
                        height = 40, font = 'ubuntu', fontSize = 32, align = 'left'
                    }) M.group.types[1].blocks[j].text.anchorX = 0
                M.group.types[1].scroll:insert(M.group.types[1].blocks[j].text)

                lastY = lastY + 140
                scrollHeight = scrollHeight + 140
            end
        end

        M.group.types[1].scroll.isVisible = M.group.currentIndex == 1
        M.group.types[1].scroll:setScrollHeight(scrollHeight)
    end
end

M.remove = function()
    pcall(function()
        M.group[4]:removeSelf()
        M.group:removeSelf()
        M.group = nil
    end)
end

M.custom = function(i)
    M.listBlock = COPY_TABLE(INFO.listBlock)

    if i == 1 then
        M.group.isVisible = false
        M.group.types[15].isVisible = false
        M.group.types[15].text.isVisible = false
        M.group.types[15].scroll.isVisible = false
        M.group.currentIndex = 1 M.group[4].text = ''
        textListener({phase = 'editing', target = M.group[4]})
    elseif i == 2 then
        M.group.isVisible = true
        M.group.types[15].isVisible = true
        M.group.types[15].text.isVisible = true
        M.group.types[15].scroll.isVisible = true
        M.group.currentIndex = 15 M.group[4].text = ''

        for i = 1, 14 do
            pcall(function()
                M.group.types[i].scroll.isVisible = false
                M.group.types[i].scroll2.isVisible = false
                M.group.types[i].scroll3.isVisible = false
            end)
        end

        M.group[3].isVisible = true
        M.group[4].isVisible = false M.group[5].alpha = 0.1
        M.group[7].alpha, M.group[7].isOn = 0.1, false
        M.group[9].alpha, M.group[9].isOn = 0.1, false
        M.group[19].alpha, M.group[19].isOn = 0.1, false

        for i = 5, 10 do M.group[i].isVisible = M.group.currentIndex == 15 end
        for i = 19, 20 do M.group[i].isVisible = M.group.currentIndex == 15 end
        for i = 11, 14 do M.group[i].isVisible = M.group.currentIndex == 9 end
        for i = 15, 18 do M.group[i].isVisible = M.group.currentIndex == 6 end
        for i = 33, 34 do M.group[i].isVisible = M.group.currentIndex == 6 end
        for i = 21, 24 do M.group[i].isVisible = M.group.currentIndex == 3 end
        for i = 25, 28 do M.group[i].isVisible = M.group.currentIndex == 2 end
        for i = 29, 32 do M.group[i].isVisible = M.group.currentIndex == 7 end
        for i = 35, 38 do M.group[i].isVisible = M.group.currentIndex == 11 end
        for i = 39, 42 do M.group[i].isVisible = M.group.currentIndex == 5 end
        for i = 43, 46 do M.group[i].isVisible = M.group.currentIndex == 4 end
        for i = 47, 48 do M.group[i].isVisible = M.group.currentIndex == 7 end
        for i = 49, 52 do M.group[i].isVisible = M.group.currentIndex == 8 end
        for i = 53, 56 do M.group[i].isVisible = M.group.currentIndex == 12 end

        M.group.types[15].scroll:removeSelf()
        M.group.types[15].scroll = WIDGET.newScrollView({
                x = CENTER_X, y = (M.group[3].y + 2 + M.group[2].y) / 2,
                width = DISPLAY_WIDTH, height = M.group[2].y - M.group[3].y + 2,
                hideBackground = true, hideScrollBar = false,
                horizontalScrollDisabled = true, isBounceEnabled = true,
            })
        M.group:insert(M.group.types[15].scroll)

        local lastY = 90
        local scrollHeight = 50
        local custom = GET_GAME_CUSTOM()

        for j = 1, #M.listBlock.custom do
            if INFO.getType(M.listBlock.custom[j]) == 'custom' and UTF8.sub(M.listBlock.custom[j], 1, 1) ~= '_' then
                local index = UTF8.gsub(M.listBlock.custom[j], 'custom', '', 1)
                color = (index and custom[index]) and custom[index][5] or nil
                color = type(color) == 'table' and {color[1] / 255, color[2] / 255, color[3] / 255} or {0.36, 0.47, 0.5}
            end

            M.group.types[15].blocks[j] = display.newPolygon(0, 0, BLOCK.getPolygonParams(false, DISPLAY_WIDTH - RIGHT_HEIGHT - 60, 116))
                M.group.types[15].blocks[j].x = DISPLAY_WIDTH / 2
                M.group.types[15].blocks[j].y = lastY
                M.group.types[15].blocks[j]:setFillColor(INFO.getBlockColor(M.listBlock.custom[j], nil, nil, color))
                M.group.types[15].blocks[j]:setStrokeColor(0.3)
                M.group.types[15].blocks[j].strokeWidth = 4
                M.group.types[15].blocks[j].index = {15, j}
                M.group.types[15].blocks[j]:addEventListener('touch', newBlockListener)
            M.group.types[15].scroll:insert(M.group.types[15].blocks[j])

            M.group.types[15].blocks[j].text = display.newText({
                    text = STR['blocks.' .. M.listBlock.custom[j]],
                    x = DISPLAY_WIDTH / 2 - M.group.types[15].blocks[j].width / 2 + 20,
                    y = lastY, width = M.group.types[15].blocks[j].width - 40,
                    height = 40, font = 'ubuntu', fontSize = 32, align = 'left'
                }) M.group.types[15].blocks[j].text.anchorX = 0
            M.group.types[15].scroll:insert(M.group.types[15].blocks[j].text)

            lastY = lastY + 140
            scrollHeight = scrollHeight + 140
        end

        M.group.types[15].scroll.isVisible = true
        M.group.types[15].scroll:setScrollHeight(scrollHeight)

        M.boxText = '' M.group[4].text = ''
        textListener({phase = 'editing', target = M.group[4]})
    end
end

M.noob = function()
    if NOOBMODE then
        for i, type in pairs(INFO.listDeleteType) do
            M.group.types[i]:setFillColor(INFO.getBlockColor(nil, nil, type, nil, true))
        end
    end
end

M.create = function()
    if M.group then
        M.group.isVisible = true

        if M.group.types[M.group.currentIndex].currentScroll == 3 then
            M.group.types[M.group.currentIndex].scroll3.isVisible = true
        elseif M.group.types[M.group.currentIndex].currentScroll == 2 then
            M.group.types[M.group.currentIndex].scroll2.isVisible = true
        else
            M.group.types[M.group.currentIndex].scroll.isVisible = true
        end

        M.group[3].isVisible = M.group.currentIndex == 1 or M.group.currentIndex == 15 or M.group.currentIndex == 5
        or M.group.currentIndex == 9 or M.group.currentIndex == 6 or M.group.currentIndex == 7 or M.group.currentIndex == 4
        or M.group.currentIndex == 3 or M.group.currentIndex == 2 or M.group.currentIndex == 11
        or M.group.currentIndex == 8 or M.group.currentIndex == 12
        M.group[4].isVisible, M.group[5].alpha = M.group.currentIndex == 1, 0.1
        M.group[7].alpha, M.group[7].isOn = 0.1, false
        M.group[9].alpha, M.group[9].isOn = 0.1, false
        M.group[19].alpha, M.group[19].isOn = 0.1, false

        for i = 5, 10 do M.group[i].isVisible = M.group.currentIndex == 15 end
        for i = 19, 20 do M.group[i].isVisible = M.group.currentIndex == 15 end
        for i = 11, 14 do M.group[i].isVisible = M.group.currentIndex == 9 end
        for i = 15, 18 do M.group[i].isVisible = M.group.currentIndex == 6 end
        for i = 33, 34 do M.group[i].isVisible = M.group.currentIndex == 6 end
        for i = 21, 24 do M.group[i].isVisible = M.group.currentIndex == 3 end
        for i = 25, 28 do M.group[i].isVisible = M.group.currentIndex == 2 end
        for i = 29, 32 do M.group[i].isVisible = M.group.currentIndex == 7 end
        for i = 35, 38 do M.group[i].isVisible = M.group.currentIndex == 11 end
        for i = 39, 42 do M.group[i].isVisible = M.group.currentIndex == 5 end
        for i = 43, 46 do M.group[i].isVisible = M.group.currentIndex == 4 end
        for i = 47, 48 do M.group[i].isVisible = M.group.currentIndex == 7 end
        for i = 49, 52 do M.group[i].isVisible = M.group.currentIndex == 8 end
        for i = 53, 56 do M.group[i].isVisible = M.group.currentIndex == 12 end

        if NOOBMODE and (M.group.currentIndex == 2 or M.group.currentIndex == 4
        or M.group.currentIndex == 5 or M.group.currentIndex == 6 or M.group.currentIndex == 7) then
            for i = 25, 28 do M.group[i].isVisible = false end
            for i = 15, 18 do M.group[i].isVisible = false end
            for i = 33, 34 do M.group[i].isVisible = false end
            for i = 29, 32 do M.group[i].isVisible = false end
            for i = 39, 42 do M.group[i].isVisible = false end
            for i = 43, 46 do M.group[i].isVisible = false end
            for i = 47, 48 do M.group[i].isVisible = false end
            M.group[3].isVisible = false
        end

        if M.boxText ~= '' then
            M.boxText = '' M.group[4].text = ''
            textListener({phase = 'editing', target = M.group[4]})
        end M.noob()
    else
        M.group = display.newGroup()
        M.group.types = {}
        M.group.currentIndex = 1
        M.noobmode = NOOBMODE
        M.boxText = ''
        M.listBlock = COPY_TABLE(INFO.listBlock)
        M.listDelimiter = COPY_TABLE(INFO.listDelimiter)

        if NOOBMODE then
            M.listBlock = COPY_TABLE(INFO.listBlockNoob)
            M.listDelimiter = COPY_TABLE(INFO.listDelimiterNoob)
        end

        local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
            bg.width = CENTER_X == 641 and DISPLAY_HEIGHT or DISPLAY_WIDTH
            bg.height = CENTER_X == 641 and DISPLAY_WIDTH or DISPLAY_HEIGHT
            bg.rotation = CENTER_X == 641 and 90 or 0
        M.group:insert(bg)

        local line = display.newRect(CENTER_X, MAX_Y - 275, DISPLAY_WIDTH, 2)
            line:setFillColor(0.45)
        M.group:insert(line)

        local find = display.newRect(CENTER_X, ZERO_Y + 80, DISPLAY_WIDTH - RIGHT_HEIGHT - 60, 2)
            find:setFillColor(0.9)
        M.group:insert(find)

        local box = native.newTextField(5000, ZERO_Y + 50, DISPLAY_WIDTH - RIGHT_HEIGHT - 70, not IS_SIM and 28 or 56)
            timer.performWithDelay(0, function()
                if M.group and M.group.isVisible and box then
                    box.x = CENTER_X
                    box.isEditable = true
                    box.hasBackground = false
                    box.placeholder = STR['button.block.find']
                    box.font = native.newFont('ubuntu', 28)

                    pcall(function() if system.getInfo 'platform' == 'android' and not IS_SIM and box then
                        box:setTextColor(0.9)
                    else
                        box:setTextColor(0.1)
                    end end)
                end
            end) box:addEventListener('userInput', textListener)
        M.group:insert(box)

        local buttonListeners = function(e)
            if M.group and M.group.isVisible then
                local allowedTag = false
                if e.target.tag then
                    allowedTag = e.target.tag == 'groups' or e.target.tag == 'tags' or e.target.tag == 'vars2' or e.target.tag == 'vars1'
                    or e.target.tag == 'control2' or e.target.tag == 'control1' or e.target.tag == 'physics1' or e.target.tag == 'physics2'
                    or e.target.tag == 'events2' or e.target.tag == 'events1' or e.target.tag == 'control3'
                    or e.target.tag == 'widgets1' or e.target.tag == 'widgets2' or e.target.tag == 'media' or e.target.tag == 'files'
                    or e.target.tag == 'objects' or e.target.tag == 'filters' or e.target.tag == 'physics3' or e.target.tag == 'camera'
                    or e.target.tag == 'transition' or e.target.tag == 'particles' or e.target.tag == 'snapshot'
                end

                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    e.target.alpha = (allowedTag and e.target.isOn) and 0.3 or 0.2
                    e.target.click = true
                elseif e.phase == 'moved' and (math.abs(e.xDelta) > 30 or math.abs(e.yDelta) > 30) then
                    display.getCurrentStage():setFocus(nil)
                    e.target.alpha = ((e.target.tag == 'change' or e.target.tag == 'remove') and e.target.isOn) and 0.3
                    or ((allowedTag and e.target.isOn) and 0.3 or 0.1)
                    e.target.click = false
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    if e.target.click then
                        e.target.click = false
                        e.target.alpha = (allowedTag and e.target.isOn) and 0.3 or 0.1
                        if e.target.tag == 'create' then
                            CUSTOM.newBlock()
                        elseif e.target.tag == 'change' then
                            e.target.alpha = e.target.isOn and 0.1 or 0.3
                            e.target.isOn = not e.target.isOn
                            M.group[9].alpha = e.target.isOn and 0.1 or M.group[9].alpha
                            M.group[9].isOn = (function() if e.target.isOn then return false else return M.group[9].isOn end end)()
                            M.group[19].alpha = e.target.isOn and 0.1 or M.group[19].alpha
                            M.group[19].isOn = (function() if e.target.isOn then return false else return M.group[19].isOn end end)()
                        elseif e.target.tag == 'remove' then
                            e.target.alpha = e.target.isOn and 0.1 or 0.3
                            e.target.isOn = not e.target.isOn
                            M.group[7].alpha = e.target.isOn and 0.1 or M.group[7].alpha
                            M.group[7].isOn = (function() if e.target.isOn then return false else return M.group[7].isOn end end)()
                            M.group[19].alpha = e.target.isOn and 0.1 or M.group[19].alpha
                            M.group[19].isOn = (function() if e.target.isOn then return false else return M.group[19].isOn end end)()
                        elseif e.target.tag == 'copy' then
                            e.target.alpha = e.target.isOn and 0.1 or 0.3
                            e.target.isOn = not e.target.isOn
                            M.group[7].alpha = e.target.isOn and 0.1 or M.group[7].alpha
                            M.group[7].isOn = (function() if e.target.isOn then return false else return M.group[7].isOn end end)()
                            M.group[9].alpha = e.target.isOn and 0.1 or M.group[9].alpha
                            M.group[9].isOn = (function() if e.target.isOn then return false else return M.group[9].isOn end end)()
                        elseif e.target.tag == 'tags' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[11].isOn = false M.group[11].alpha = 0.1
                            M.group.types[9].scroll.isVisible = false M.group.types[9].scroll2.isVisible = true M.group.types[9].currentScroll = 2
                        elseif e.target.tag == 'groups' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[13].isOn = false M.group[13].alpha = 0.1
                            M.group.types[9].scroll.isVisible = true M.group.types[9].scroll2.isVisible = false M.group.types[9].currentScroll = 1
                        elseif e.target.tag == 'control3' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3
                            M.group[15].isOn = false M.group[15].alpha = 0.1 M.group[17].isOn = false M.group[17].alpha = 0.1
                            M.group.types[6].scroll.isVisible = false M.group.types[6].scroll2.isVisible = false
                            M.group.types[6].scroll3.isVisible = true M.group.types[6].currentScroll = 3
                        elseif e.target.tag == 'control2' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3
                            M.group[15].isOn = false M.group[15].alpha = 0.1 M.group[33].isOn = false M.group[33].alpha = 0.1
                            M.group.types[6].scroll.isVisible = false M.group.types[6].scroll2.isVisible = true
                            M.group.types[6].scroll3.isVisible = false M.group.types[6].currentScroll = 2
                        elseif e.target.tag == 'control1' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3
                            M.group[17].isOn = false M.group[17].alpha = 0.1 M.group[33].isOn = false M.group[33].alpha = 0.1
                            M.group.types[6].scroll.isVisible = true M.group.types[6].scroll2.isVisible = false
                            M.group.types[6].scroll3.isVisible = false M.group.types[6].currentScroll = 1
                        elseif e.target.tag == 'vars2' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[21].isOn = false M.group[21].alpha = 0.1
                            M.group.types[3].scroll.isVisible = false M.group.types[3].scroll2.isVisible = true M.group.types[3].currentScroll = 2
                        elseif e.target.tag == 'vars1' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[23].isOn = false M.group[23].alpha = 0.1
                            M.group.types[3].scroll.isVisible = true M.group.types[3].scroll2.isVisible = false M.group.types[3].currentScroll = 1
                        elseif e.target.tag == 'events2' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[25].isOn = false M.group[25].alpha = 0.1
                            M.group.types[2].scroll.isVisible = false M.group.types[2].scroll2.isVisible = true M.group.types[2].currentScroll = 2
                        elseif e.target.tag == 'events1' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[27].isOn = false M.group[27].alpha = 0.1
                            M.group.types[2].scroll.isVisible = true M.group.types[2].scroll2.isVisible = false M.group.types[2].currentScroll = 1
                        elseif e.target.tag == 'physics3' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3
                            M.group[29].isOn = false M.group[29].alpha = 0.1 M.group[31].isOn = false M.group[31].alpha = 0.1
                            M.group.types[7].scroll.isVisible = false M.group.types[7].scroll2.isVisible = false
                            M.group.types[7].scroll3.isVisible = true M.group.types[7].currentScroll = 3
                        elseif e.target.tag == 'physics2' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3
                            M.group[29].isOn = false M.group[29].alpha = 0.1 M.group[47].isOn = false M.group[47].alpha = 0.1
                            M.group.types[7].scroll.isVisible = false M.group.types[7].scroll2.isVisible = true
                            M.group.types[7].scroll3.isVisible = false M.group.types[7].currentScroll = 2
                        elseif e.target.tag == 'physics1' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3
                            M.group[31].isOn = false M.group[31].alpha = 0.1 M.group[47].isOn = false M.group[47].alpha = 0.1
                            M.group.types[7].scroll.isVisible = true M.group.types[7].scroll2.isVisible = false
                            M.group.types[7].scroll3.isVisible = false M.group.types[7].currentScroll = 1
                        elseif e.target.tag == 'widgets2' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[35].isOn = false M.group[35].alpha = 0.1
                            M.group.types[11].scroll.isVisible = false M.group.types[11].scroll2.isVisible = true M.group.types[11].currentScroll = 2
                        elseif e.target.tag == 'widgets1' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[37].isOn = false M.group[37].alpha = 0.1
                            M.group.types[11].scroll.isVisible = true M.group.types[11].scroll2.isVisible = false M.group.types[11].currentScroll = 1
                        elseif e.target.tag == 'files' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[39].isOn = false M.group[39].alpha = 0.1
                            M.group.types[5].scroll.isVisible = false M.group.types[5].scroll2.isVisible = true M.group.types[5].currentScroll = 2
                        elseif e.target.tag == 'media' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[41].isOn = false M.group[41].alpha = 0.1
                            M.group.types[5].scroll.isVisible = true M.group.types[5].scroll2.isVisible = false M.group.types[5].currentScroll = 1
                        elseif e.target.tag == 'filters' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[43].isOn = false M.group[43].alpha = 0.1
                            M.group.types[4].scroll.isVisible = false M.group.types[4].scroll2.isVisible = true M.group.types[4].currentScroll = 2
                        elseif e.target.tag == 'objects' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[45].isOn = false M.group[45].alpha = 0.1
                            M.group.types[4].scroll.isVisible = true M.group.types[4].scroll2.isVisible = false M.group.types[4].currentScroll = 1
                        elseif e.target.tag == 'camera' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[53].isOn = false M.group[53].alpha = 0.1
                            M.group.types[12].scroll.isVisible = false M.group.types[12].scroll2.isVisible = true M.group.types[12].currentScroll = 2
                        elseif e.target.tag == 'snapshot' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[55].isOn = false M.group[55].alpha = 0.1
                            M.group.types[12].scroll.isVisible = true M.group.types[12].scroll2.isVisible = false M.group.types[12].currentScroll = 1
                        elseif e.target.tag == 'particles' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[49].isOn = false M.group[49].alpha = 0.1
                            M.group.types[8].scroll.isVisible = false M.group.types[8].scroll2.isVisible = true M.group.types[8].currentScroll = 2
                        elseif e.target.tag == 'transition' and not e.target.isOn then
                            e.target.isOn = true e.target.alpha = 0.3 M.group[51].isOn = false M.group[51].alpha = 0.1
                            M.group.types[8].scroll.isVisible = true M.group.types[8].scroll2.isVisible = false M.group.types[8].currentScroll = 1
                        end
                    end
                end
            else
                display.getCurrentStage():setFocus(nil)
            end

            return true
        end

        local width = (DISPLAY_WIDTH - RIGHT_HEIGHT - 60) / 4
        local width2 = (DISPLAY_WIDTH - RIGHT_HEIGHT - 60) / 3
        local width3 = (DISPLAY_WIDTH - RIGHT_HEIGHT - 60) / 2

        local button = display.newRect(find.x - find.width / 2 + width / 2, ZERO_Y + 50, width, 56)
            button.alpha = 0.1
            button.tag = 'create'
            button:addEventListener('touch', buttonListeners)
        M.group:insert(button)

        local buttonText = display.newText(STR['blocks.create.block'], button.x, button.y, 'ubuntu', 28)
            button.isVisible = false
            buttonText.isVisible = false
        M.group:insert(buttonText)

        local button2 = display.newRect(button.x + width / 2 + width / 2, ZERO_Y + 50, width, 56)
            button2.isOn = false
            button2.alpha = 0.1
            button2.tag = 'change'
            button2:addEventListener('touch', buttonListeners)
        M.group:insert(button2)

        local button2Text = display.newText(STR['button.change'], button2.x, button2.y, 'ubuntu', 28)
            button2.isVisible = false
            button2Text.isVisible = false
        M.group:insert(button2Text)

        local button3 = display.newRect(button2.x + width, ZERO_Y + 50, width, 56)
            button3.isOn = false
            button3.alpha = 0.1
            button3.tag = 'remove'
            button3:addEventListener('touch', buttonListeners)
        M.group:insert(button3)

        local button3Text = display.newText(STR['button.remove'], button3.x, button3.y, 'ubuntu', 28)
            button3.isVisible = false
            button3Text.isVisible = false
        M.group:insert(button3Text)

        local buttonGroup = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonGroup.isOn = true
            buttonGroup.alpha = 0.3
            buttonGroup.tag = 'groups'
            buttonGroup:addEventListener('touch', buttonListeners)
        M.group:insert(buttonGroup)

        local buttonGroupText = display.newText(STR['blocks.create.groups'], buttonGroup.x, buttonGroup.y, 'ubuntu', 28)
            buttonGroup.isVisible = false
            buttonGroupText.isVisible = false
        M.group:insert(buttonGroupText)

        local buttonTag = display.newRect(buttonGroup.x + width3, ZERO_Y + 50, width3, 56)
            buttonTag.isOn = false
            buttonTag.alpha = 0.1
            buttonTag.tag = 'tags'
            buttonTag:addEventListener('touch', buttonListeners)
        M.group:insert(buttonTag)

        local buttonTagText = display.newText(STR['blocks.create.tags'], buttonTag.x, buttonTag.y, 'ubuntu', 28)
            buttonTag.isVisible = false
            buttonTagText.isVisible = false
        M.group:insert(buttonTagText)

        local buttonControl1 = display.newRect(find.x - find.width / 2 + width2 / 2, ZERO_Y + 50, width2, 56)
            buttonControl1.isOn = true
            buttonControl1.alpha = 0.3
            buttonControl1.tag = 'control1'
            buttonControl1:addEventListener('touch', buttonListeners)
        M.group:insert(buttonControl1)

        local buttonControl1Text = display.newText('1', buttonControl1.x, buttonControl1.y, 'ubuntu', 28)
            buttonControl1.isVisible = false
            buttonControl1Text.isVisible = false
        M.group:insert(buttonControl1Text)

        local buttonControl2 = display.newRect(buttonControl1.x + width2, ZERO_Y + 50, width2, 56)
            buttonControl2.isOn = false
            buttonControl2.alpha = 0.1
            buttonControl2.tag = 'control2'
            buttonControl2:addEventListener('touch', buttonListeners)
        M.group:insert(buttonControl2)

        local buttonControl2Text = display.newText('2', buttonControl2.x, buttonControl2.y, 'ubuntu', 28)
            buttonControl2.isVisible = false
            buttonControl2Text.isVisible = false
        M.group:insert(buttonControl2Text)

        local button4 = display.newRect(button3.x + width, ZERO_Y + 50, width, 56)
            button4.isOn = false
            button4.alpha = 0.1
            button4.tag = 'copy'
            button4:addEventListener('touch', buttonListeners)
        M.group:insert(button4)

        local button4Text = display.newText(STR['blocks.create.copy'], button4.x, button4.y, 'ubuntu', 28)
            button4.isVisible = false
            button4Text.isVisible = false
        M.group:insert(button4Text)

        local buttonVars1 = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonVars1.isOn = true
            buttonVars1.alpha = 0.3
            buttonVars1.tag = 'vars1'
            buttonVars1:addEventListener('touch', buttonListeners)
        M.group:insert(buttonVars1)

        local buttonVars1Text = display.newText('1', buttonVars1.x, buttonVars1.y, 'ubuntu', 28)
            buttonVars1.isVisible = false
            buttonVars1Text.isVisible = false
        M.group:insert(buttonVars1Text)

        local buttonVars2 = display.newRect(buttonVars1.x + width3, ZERO_Y + 50, width3, 56)
            buttonVars2.isOn = false
            buttonVars2.alpha = 0.1
            buttonVars2.tag = 'vars2'
            buttonVars2:addEventListener('touch', buttonListeners)
        M.group:insert(buttonVars2)

        local buttonVars2Text = display.newText('2', buttonVars2.x, buttonVars2.y, 'ubuntu', 28)
            buttonVars2.isVisible = false
            buttonVars2Text.isVisible = false
        M.group:insert(buttonVars2Text)

        local buttonEvents1 = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonEvents1.isOn = true
            buttonEvents1.alpha = 0.3
            buttonEvents1.tag = 'events1'
            buttonEvents1:addEventListener('touch', buttonListeners)
        M.group:insert(buttonEvents1)

        local buttonEvents1Text = display.newText('1', buttonEvents1.x, buttonEvents1.y, 'ubuntu', 28)
            buttonEvents1.isVisible = false
            buttonEvents1Text.isVisible = false
        M.group:insert(buttonEvents1Text)

        local buttonEvents2 = display.newRect(buttonEvents1.x + width3, ZERO_Y + 50, width3, 56)
            buttonEvents2.isOn = false
            buttonEvents2.alpha = 0.1
            buttonEvents2.tag = 'events2'
            buttonEvents2:addEventListener('touch', buttonListeners)
        M.group:insert(buttonEvents2)

        local buttonEvents2Text = display.newText('2', buttonEvents2.x, buttonEvents2.y, 'ubuntu', 28)
            buttonEvents2.isVisible = false
            buttonEvents2Text.isVisible = false
        M.group:insert(buttonEvents2Text)

        local buttonPhysics1 = display.newRect(find.x - find.width / 2 + width2 / 2, ZERO_Y + 50, width2, 56)
            buttonPhysics1.isOn = true
            buttonPhysics1.alpha = 0.3
            buttonPhysics1.tag = 'physics1'
            buttonPhysics1:addEventListener('touch', buttonListeners)
        M.group:insert(buttonPhysics1)

        local buttonPhysics1Text = display.newText('1', buttonPhysics1.x, buttonPhysics1.y, 'ubuntu', 28)
            buttonPhysics1.isVisible = false
            buttonPhysics1Text.isVisible = false
        M.group:insert(buttonPhysics1Text)

        local buttonPhysics2 = display.newRect(buttonPhysics1.x + width2, ZERO_Y + 50, width2, 56)
            buttonPhysics2.isOn = false
            buttonPhysics2.alpha = 0.1
            buttonPhysics2.tag = 'physics2'
            buttonPhysics2:addEventListener('touch', buttonListeners)
        M.group:insert(buttonPhysics2)

        local buttonPhysics2Text = display.newText('2', buttonPhysics2.x, buttonPhysics2.y, 'ubuntu', 28)
            buttonPhysics2.isVisible = false
            buttonPhysics2Text.isVisible = false
        M.group:insert(buttonPhysics2Text)

        local buttonControl3 = display.newRect(buttonControl2.x + width2, ZERO_Y + 50, width2, 56)
            buttonControl3.isOn = false
            buttonControl3.alpha = 0.1
            buttonControl3.tag = 'control3'
            buttonControl3:addEventListener('touch', buttonListeners)
        M.group:insert(buttonControl3)

        local buttonControl3Text = display.newText('3', buttonControl3.x, buttonControl3.y, 'ubuntu', 28)
            buttonControl3.isVisible = false
            buttonControl3Text.isVisible = false
        M.group:insert(buttonControl3Text)

        local buttonWidgets1 = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonWidgets1.isOn = true
            buttonWidgets1.alpha = 0.3
            buttonWidgets1.tag = 'widgets1'
            buttonWidgets1:addEventListener('touch', buttonListeners)
        M.group:insert(buttonWidgets1)

        local buttonWidgets1Text = display.newText('1', buttonWidgets1.x, buttonWidgets1.y, 'ubuntu', 28)
            buttonWidgets1.isVisible = false
            buttonWidgets1Text.isVisible = false
        M.group:insert(buttonWidgets1Text)

        local buttonWidgets2 = display.newRect(buttonWidgets1.x + width3, ZERO_Y + 50, width3, 56)
            buttonWidgets2.isOn = false
            buttonWidgets2.alpha = 0.1
            buttonWidgets2.tag = 'widgets2'
            buttonWidgets2:addEventListener('touch', buttonListeners)
        M.group:insert(buttonWidgets2)

        local buttonWidgets2Text = display.newText('2', buttonWidgets2.x, buttonWidgets2.y, 'ubuntu', 28)
            buttonWidgets2.isVisible = false
            buttonWidgets2Text.isVisible = false
        M.group:insert(buttonWidgets2Text)

        local buttonMedia = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonMedia.isOn = true
            buttonMedia.alpha = 0.3
            buttonMedia.tag = 'media'
            buttonMedia:addEventListener('touch', buttonListeners)
        M.group:insert(buttonMedia)

        local buttonMediaText = display.newText(STR['blocks.create.media'], buttonMedia.x, buttonMedia.y, 'ubuntu', 28)
            buttonMedia.isVisible = false
            buttonMediaText.isVisible = false
        M.group:insert(buttonMediaText)

        local buttonFiles = display.newRect(buttonMedia.x + width3, ZERO_Y + 50, width3, 56)
            buttonFiles.isOn = false
            buttonFiles.alpha = 0.1
            buttonFiles.tag = 'files'
            buttonFiles:addEventListener('touch', buttonListeners)
        M.group:insert(buttonFiles)

        local buttonFilesText = display.newText(STR['blocks.create.files'], buttonFiles.x, buttonFiles.y, 'ubuntu', 28)
            buttonFiles.isVisible = false
            buttonFilesText.isVisible = false
        M.group:insert(buttonFilesText)

        local buttonObjects = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonObjects.isOn = true
            buttonObjects.alpha = 0.3
            buttonObjects.tag = 'objects'
            buttonObjects:addEventListener('touch', buttonListeners)
        M.group:insert(buttonObjects)

        local buttonObjectsText = display.newText(STR['blocks.create.objects'], buttonObjects.x, buttonObjects.y, 'ubuntu', 28)
            buttonObjects.isVisible = false
            buttonObjectsText.isVisible = false
        M.group:insert(buttonObjectsText)

        local buttonFilters = display.newRect(buttonObjects.x + width3, ZERO_Y + 50, width3, 56)
            buttonFilters.isOn = false
            buttonFilters.alpha = 0.1
            buttonFilters.tag = 'filters'
            buttonFilters:addEventListener('touch', buttonListeners)
        M.group:insert(buttonFilters)

        local buttonFiltersText = display.newText(STR['blocks.create.filters'], buttonFilters.x, buttonFilters.y, 'ubuntu', 28)
            buttonFilters.isVisible = false
            buttonFiltersText.isVisible = false
        M.group:insert(buttonFiltersText)

        local buttonPhysics3 = display.newRect(buttonPhysics2.x + width2, ZERO_Y + 50, width2, 56)
            buttonPhysics3.isOn = false
            buttonPhysics3.alpha = 0.1
            buttonPhysics3.tag = 'physics3'
            buttonPhysics3:addEventListener('touch', buttonListeners)
        M.group:insert(buttonPhysics3)

        local buttonPhysics3Text = display.newText('3', buttonPhysics3.x, buttonPhysics3.y, 'ubuntu', 28)
            buttonPhysics3.isVisible = false
            buttonPhysics3Text.isVisible = false
        M.group:insert(buttonPhysics3Text)

        local buttonTransition = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonTransition.isOn = true
            buttonTransition.alpha = 0.3
            buttonTransition.tag = 'transition'
            buttonTransition:addEventListener('touch', buttonListeners)
        M.group:insert(buttonTransition)

        local buttonTransitionText = display.newText(STR['blocks.create.transition'], buttonTransition.x, buttonTransition.y, 'ubuntu', 28)
            buttonTransition.isVisible = false
            buttonTransitionText.isVisible = false
        M.group:insert(buttonTransitionText)

        local buttonParticles = display.newRect(buttonTransition.x + width3, ZERO_Y + 50, width3, 56)
            buttonParticles.isOn = false
            buttonParticles.alpha = 0.1
            buttonParticles.tag = 'particles'
            buttonParticles:addEventListener('touch', buttonListeners)
        M.group:insert(buttonParticles)

        local buttonParticlesText = display.newText(STR['blocks.create.particles'], buttonParticles.x, buttonParticles.y, 'ubuntu', 28)
            buttonParticles.isVisible = false
            buttonParticlesText.isVisible = false
        M.group:insert(buttonParticlesText)

        local buttonSnapshot = display.newRect(find.x - find.width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
            buttonSnapshot.isOn = true
            buttonSnapshot.alpha = 0.3
            buttonSnapshot.tag = 'snapshot'
            buttonSnapshot:addEventListener('touch', buttonListeners)
        M.group:insert(buttonSnapshot)

        local buttonSnapshotText = display.newText(STR['blocks.create.snapshot'], buttonSnapshot.x, buttonSnapshot.y, 'ubuntu', 28)
            buttonSnapshot.isVisible = false
            buttonSnapshotText.isVisible = false
        M.group:insert(buttonSnapshotText)

        local buttonCamera = display.newRect(buttonSnapshot.x + width3, ZERO_Y + 50, width3, 56)
            buttonCamera.isOn = false
            buttonCamera.alpha = 0.1
            buttonCamera.tag = 'camera'
            buttonCamera:addEventListener('touch', buttonListeners)
        M.group:insert(buttonCamera)

        local buttonCameraText = display.newText(STR['blocks.create.camera'], buttonCamera.x, buttonCamera.y, 'ubuntu', 28)
            buttonCamera.isVisible = false
            buttonCameraText.isVisible = false
        M.group:insert(buttonCameraText)

        local width = CENTER_X == 360 and DISPLAY_WIDTH / 5 - 24 or DISPLAY_WIDTH / 6
        local x, y = ZERO_X + 20, MAX_Y - 220
        local custom = GET_GAME_CUSTOM()

        for i = 1, BLOCKS.custom and #INFO.listType - 1 or #INFO.listType do
            M.group.types[i] = display.newRoundedRect(x, y, width, 62, 11)
                M.group.types[i].index = i
                M.group.types[i].blocks = {}
                M.group.types[i].anchorX = 0
                M.group.types[i]:setFillColor(INFO.getBlockColor(nil, nil, INFO.listType[i]))
                M.group.types[i]:addEventListener('touch', showTypeScroll)
            M.group:insert(M.group.types[i])

            local typeName = 'blocks.' .. INFO.listType[i]
            if NOOBMODE and (i == 4 or i == 5 or i == 8 or i == 10) then typeName = typeName .. 'Noob' end
            local text = display.newText({text = STR[typeName], x = 0, y = 0, width = width - 5, font = 'sans.ttf', fontSize = 19})
            local textheight = text.height > 48 and 48 or text.height text:removeSelf()
            local allowedIndex = i == 1 or i == 15 or i == 9 or i == 6 or i == 3
            or i == 2 or i == 7 or i == 11 or i == 5 or i == 4 or i == 8 or i == 12
            if NOOBMODE and (i == 2 or i == 4 or i == 5 or i == 6 or i == 7) then allowedIndex = false end

            M.group.types[i].text = display.newText({
                    text = STR[typeName], font = 'ubuntu', fontSize = 19, align = 'center',
                    x = x + width / 2, y = y, width = width - 5, height = textheight
                })
            M.group:insert(M.group.types[i].text)

            M.group.types[i].scroll = WIDGET.newScrollView({
                    x = CENTER_X, y = ((allowedIndex and find.y + 2 or ZERO_Y + 1) + line.y) / 2,
                    width = DISPLAY_WIDTH, height = line.y - (allowedIndex and find.y + 2 or ZERO_Y + 1),
                    hideBackground = true, hideScrollBar = false,
                    horizontalScrollDisabled = true, isBounceEnabled = true
                }) M.group.types[i].currentScroll = 1
            M.group:insert(M.group.types[i].scroll)

            if M.listDelimiter[INFO.listType[i]] then
                M.group.types[i].scroll2 = WIDGET.newScrollView({
                        x = CENTER_X, y = ((allowedIndex and find.y + 2 or ZERO_Y + 1) + line.y) / 2,
                        width = DISPLAY_WIDTH, height = line.y - (allowedIndex and find.y + 2 or ZERO_Y + 1),
                        hideBackground = true, hideScrollBar = false,
                        horizontalScrollDisabled = true, isBounceEnabled = true
                    }) M.group.types[i].scroll2.isVisible = false
                M.group:insert(M.group.types[i].scroll2)

                if #M.listDelimiter[INFO.listType[i]] > 1 then
                    M.group.types[i].scroll3 = WIDGET.newScrollView({
                            x = CENTER_X, y = ((allowedIndex and find.y + 2 or ZERO_Y + 1) + line.y) / 2,
                            width = DISPLAY_WIDTH, height = line.y - (allowedIndex and find.y + 2 or ZERO_Y + 1),
                            hideBackground = true, hideScrollBar = false,
                            horizontalScrollDisabled = true, isBounceEnabled = true
                        }) M.group.types[i].scroll3.isVisible = false
                    M.group:insert(M.group.types[i].scroll3)
                end
            end

            if i ~= 1 then M.group.types[i].scroll.isVisible = false end
            if i % 5 == 0 then y, x = y + 85, ZERO_X + 20 else x = x + width + 20 end

            local lastY = 90
            local scrollHeight = 50
            local scroll2Height = 50
            local scroll3Height = 50
            local startDelimiter = 1

            if INFO.listType[i] ~= 'none' then
                for j = 1, #M.listBlock[INFO.listType[i]] do
                    local name = M.listBlock[INFO.listType[i]][j]
                    local notCustom = not (BLOCKS.custom and INFO.getType(name) == 'custom' and j ~= 1)

                    if M.listDelimiter[INFO.listType[i]] and name == M.listDelimiter[INFO.listType[i]][1] and startDelimiter ~= 2 then
                        startDelimiter = 2
                        lastY = 90
                    elseif M.listDelimiter[INFO.listType[i]] and name == M.listDelimiter[INFO.listType[i]][2] and startDelimiter ~= 3 then
                        startDelimiter = 3
                        lastY = 90
                    end

                    if UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End' and name ~= 'ifElse' and notCustom then
                        local event, color = INFO.listType[i] == 'events' or INFO.getType(name) == 'events'

                        if INFO.getType(name) == 'custom' and UTF8.sub(name, 1, 1) ~= '_' then
                            local index = UTF8.gsub(name, 'custom', '', 1)
                            color = (index and custom[index]) and custom[index][5] or nil
                            color = type(color) == 'table' and {color[1] / 255, color[2] / 255, color[3] / 255} or {0.36, 0.47, 0.5}
                        end

                        M.group.types[i].blocks[j] = display.newPolygon(0, 0, BLOCK.getPolygonParams(event, DISPLAY_WIDTH - LEFT_HEIGHT - RIGHT_HEIGHT - 60, event and 102 or 116))
                            M.group.types[i].blocks[j].x = DISPLAY_WIDTH / 2
                            M.group.types[i].blocks[j].y = lastY
                            M.group.types[i].blocks[j]:setFillColor(INFO.getBlockColor(name, nil, nil, color))
                            M.group.types[i].blocks[j]:setStrokeColor(0.3)
                            M.group.types[i].blocks[j].strokeWidth = 4
                            M.group.types[i].blocks[j].index = {i, j}
                        M.group.types[i].blocks[j]:addEventListener('touch', newBlockListener)

                        if startDelimiter == 3 then
                            M.group.types[i].scroll3:insert(M.group.types[i].blocks[j])
                        elseif startDelimiter == 2 then
                            M.group.types[i].scroll2:insert(M.group.types[i].blocks[j])
                        else
                            M.group.types[i].scroll:insert(M.group.types[i].blocks[j])
                        end

                        M.group.types[i].blocks[j].text = display.newText({
                                text = STR['blocks.' .. name],
                                x = DISPLAY_WIDTH / 2 - M.group.types[i].blocks[j].width / 2 + 20,
                                y = lastY, width = M.group.types[i].blocks[j].width - 40,
                                height = 40, font = 'ubuntu', fontSize = 32, align = 'left'
                            })
                        M.group.types[i].blocks[j].text.anchorX = 0

                        if startDelimiter == 3 then
                            M.group.types[i].scroll3:insert(M.group.types[i].blocks[j].text)
                        elseif startDelimiter == 2 then
                            M.group.types[i].scroll2:insert(M.group.types[i].blocks[j].text)
                        else
                            M.group.types[i].scroll:insert(M.group.types[i].blocks[j].text)
                        end

                        lastY = lastY + 140
                        scrollHeight = startDelimiter == 1 and scrollHeight + 140 or scrollHeight
                        scroll2Height = startDelimiter == 2 and scroll2Height + 140 or scroll2Height
                        scroll3Height = startDelimiter == 3 and scroll3Height + 140 or scroll3Height
                    end
                end
            end

            if startDelimiter > 2 then
                M.group.types[i].scroll3:setScrollHeight(scroll3Height)
            end

            if startDelimiter > 1 then
                M.group.types[i].scroll2:setScrollHeight(scroll2Height)
            end

            M.group.types[i].scroll:setScrollHeight(scrollHeight)
        end M.noob()
    end
end

return M
