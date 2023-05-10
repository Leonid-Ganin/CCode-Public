local listeners = {}
local LIST = require 'Core.Modules.interface-list'
local LOGIC = require 'Core.Modules.logic-input'

listeners.but_title = function(target)
    EXITS.blocks()
end

listeners.but_add = function(target)
    BLOCKS.group.isVisible = false
    NEW_BLOCK = require 'Interfaces.new-block'
    NEW_BLOCK.create()
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = BLOCKS
    BLOCKS.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    if #BLOCKS.group.blocks ~= 0 then
        local list = {STR['button.remove'], STR['button.copy'], STR['button.comment'], STR['button.debug'], STR['button.to.buffer']}

        if BLOCKS.custom then
            table.remove(list, 5)
        end

        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        if BLOCKS.group.isVisible then
            LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
                BLOCKS.group[8]:setIsLocked(false, 'vertical')

                if e.index == 4 then
                    GAME_GROUP_OPEN = BLOCKS
                    BLOCKS.group.isVisible = false
                    GAME = require 'Core.Simulation.start' local lua = GAME.new(nil, true)
                    if not IS_SIM then PASTEBOARD.copy('string', lua) else print(lua) end
                    WINDOW.new(STR['game.debug'], {STR['button.okay']}, function(e) BLOCKS.group.isVisible = true end, 1)
                    WINDOW.buttons[1].x = WINDOW.bg.x + WINDOW.bg.width / 4 - 5
                    WINDOW.buttons[1].text.x = WINDOW.buttons[1].x
                elseif e.index == 5 then
                    pcall(function() BUFFER = COPY_TABLE(GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT)) end)
                elseif e.index ~= 0 then
                    ALERT = false
                    INDEX_LIST = e.index
                    EXITS.add(listeners.but_okay_end)
                    BLOCKS.group[3].isVisible = true
                    BLOCKS.group[4].isVisible = false
                    BLOCKS.group[5].isVisible = false
                    BLOCKS.group[6].isVisible = false
                    BLOCKS.group[7].isVisible = true

                    for i = 1, #BLOCKS.group.blocks do
                        local name = BLOCKS.group.blocks[i].data.name
                            BLOCKS.group.blocks[i].x = BLOCKS.group.blocks[i].x + 20
                            BLOCKS.group.blocks[i].checkbox:setState({isOn = false})
                            BLOCKS.group.blocks[i].rects.isVisible = false

                        if UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End' then
                            BLOCKS.group.blocks[i].checkbox.isVisible = true
                        end
                    end

                    MORE_LIST = e.text ~= STR['button.copy']
                    BLOCKS.group[3].text = '(' .. e.text .. ')'
                end
            end, nil, nil, 1)
        else
            BLOCKS.group[8]:setIsLocked(false, 'vertical')
        end
    end
end

listeners.checkLocalData = function(bIndex, pIndex, pType, data)
    local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)

    if pType == 'value' or script.params[bIndex].params[pIndex][1] then
        local name = pType ~= 'value' and script.params[bIndex].params[pIndex][1][1] or ''
        local modify = pType ~= 'value' and script.params[bIndex].params[pIndex][1][2] or ''

        if modify == 'vE' or modify == 'tE' or pType == 'value' then
            local countEvent = 0
            local lastIndexEvent = 1

            for i = 1, #script.params do
                if script.params[i].event then
                    if i > bIndex then break end
                    countEvent = countEvent + 1
                    lastIndexEvent = i
                elseif i > bIndex then
                    break
                end
            end

            local varsE = script.params[lastIndexEvent].vars
            local tablesE = script.params[lastIndexEvent].tables

            if pType == 'value' then
                if type(script.params[bIndex].params[pIndex]) ~= 'table' then
                    script.params[bIndex].params[pIndex] = {}
                end

                for o = #script.params[bIndex].params[pIndex], 1, -1 do
                    local name = script.params[bIndex].params[pIndex][o][1]
                    local modify = script.params[bIndex].params[pIndex][o][2]

                    if (modify == 'vE' and not table.indexOf(varsE, name)) or (modify == 'tE' and not table.indexOf(tablesE, name)) then
                        table.insert(modify == 'vE' and varsE or tablesE, 1, name)
                        -- LOGIC.renameEvent(data, name, '', modify, countEvent, true)
                    end
                end
            else
                if (modify == 'vE' and not table.indexOf(varsE, name)) or (modify == 'tE' and not table.indexOf(tablesE, name)) then
                    table.insert(modify == 'vE' and varsE or tablesE, 1, name)
                    -- LOGIC.renameEvent(data, name, '', modify, countEvent, true)
                end
            end

            SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
        end
    end
end

listeners.but_okay_end = function()
    ALERT = true
    LAST_CHECKBOX = 0
    BLOCKS.group[3].text = ''
    BLOCKS.group[3].isVisible = false
    BLOCKS.group[4].isVisible = true
    BLOCKS.group[5].isVisible = true
    BLOCKS.group[6].isVisible = true
    BLOCKS.group[7].isVisible = false

    for i = 1, #BLOCKS.group.blocks do
        BLOCKS.group.blocks[i].x = BLOCKS.group.blocks[i].x - 20
        BLOCKS.group.blocks[i].checkbox:setState({isOn = false})
        BLOCKS.group.blocks[i].checkbox.isVisible = false
        BLOCKS.group.blocks[i].rects.isVisible = true
    end
end

listeners.but_okay = function(target)
    local data = GET_GAME_CODE(CURRENT_LINK)
    local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)

    ALERT = true
    EXITS.remove()
    LAST_CHECKBOX = 0
    BLOCKS.group[3].text = ''
    BLOCKS.group[3].isVisible = false
    BLOCKS.group[4].isVisible = true
    BLOCKS.group[5].isVisible = true
    BLOCKS.group[6].isVisible = true
    BLOCKS.group[7].isVisible = false

    for i = 1, #BLOCKS.group.blocks do
        BLOCKS.group.blocks[i].x = BLOCKS.group.blocks[i].x - 20
        BLOCKS.group.blocks[i].checkbox.isVisible = false
        BLOCKS.group.blocks[i].rects.isVisible = true
    end

    if INDEX_LIST == 1 then
        for i = 1, #BLOCKS.group.blocks do
            if BLOCKS.group.blocks[i].checkbox.isOn then
                if BLOCKS.group.blocks[i].data.name == '_custom' then
                    for j = 1, #BLOCKS.group.blocks do
                        if BLOCKS.group.blocks[j].checkbox.isOn then
                            BLOCKS.group.blocks[j].checkbox:setState({isOn = false})
                        end
                    end return
                end break
            elseif i == #BLOCKS.group.blocks then
                return
            end
        end

        local function deleteBlock()
            for i = #BLOCKS.group.blocks, 1, -1 do
                if BLOCKS.group.blocks[i].checkbox.isOn then
                    BLOCKS.group.scrollHeight = BLOCKS.group.scrollHeight - BLOCKS.group.blocks[i].block.height + 4
                    if BLOCKS.group.blocks[i].data.event then BLOCKS.group.scrollHeight = BLOCKS.group.scrollHeight - 24 end
                    BLOCKS.group.blocks[i]:removeSelf()
                    table.remove(BLOCKS.group.blocks, i)
                    table.remove(script.params, i)
                end
            end

            for i = 1, #BLOCKS.group.blocks do
                local y = i == 1 and 50 or BLOCKS.group.blocks[i - 1].y + BLOCKS.group.blocks[i - 1].block.height / 2 + BLOCKS.group.blocks[i].height / 2 - 4
                local addY = i == 1 and 24 + (BLOCKS.group.blocks[i].height - 120) / 2 or 24
                if BLOCKS.group.blocks[i].data.event then y = y + addY end BLOCKS.group.blocks[i].y = y
            end

            SET_GAME_CODE(CURRENT_LINK, data)
            SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
            BLOCKS.group[8]:setIsLocked(false, 'vertical')
            BLOCKS.group[8]:setScrollHeight(GET_SCROLL_HEIGHT(BLOCKS.group))
        end

        if LOCAL.confirm then
            BLOCKS.group[8]:setIsLocked(true, 'vertical')
            WINDOW.new(STR['blocks.sure?'], {STR['blocks.delete.no'], STR['blocks.delete.yes']}, function(e)
                if e.index == 2 then
                    deleteBlock()
                else
                    BLOCKS.group[8]:setIsLocked(false, 'vertical')
                    for i = 1, #BLOCKS.group.blocks do
                        if BLOCKS.group.blocks[i].checkbox.isOn then
                            BLOCKS.group.blocks[i].checkbox:setState({isOn = false})
                        end
                    end
                end
            end, 4)
        else
            deleteBlock()
        end
    elseif INDEX_LIST == 2 then
        for i = 1, #BLOCKS.group.blocks do
            if BLOCKS.group.blocks[i].checkbox.isOn then
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})

                if BLOCKS.group.blocks[i].data.name == '_custom' then
                    for j = 1, #BLOCKS.group.blocks do
                        if BLOCKS.group.blocks[j].checkbox.isOn then
                            BLOCKS.group.blocks[j].checkbox:setState({isOn = false})
                        end
                    end return
                end

                local scrollY = select(2, BLOCKS.group[8]:getContentPosition())
                local diffY = BLOCKS.group[8].y - BLOCKS.group[8].height / 2
                local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150
                local blockIndex = i
                local blockData = COPY_TABLE(BLOCKS.group.blocks[i].data)

                if blockData.nested then
                    local endIndex = 1
                    local nestedEndIndex = 1
                    local bName = blockData.name
                    local isEvent = blockData.event

                    if not isEvent then
                        endIndex = #INFO.listNested[blockData.name]
                    end

                    table.insert(script.params, blockIndex, blockData)
                    BLOCKS.new(blockData.name, blockIndex, isEvent, blockData.params, blockData.comment, blockData.nested, blockData.vars, blockData.tables)

                    if #blockData.nested == 0 or isEvent then
                        for j = blockIndex + 2, #BLOCKS.group.blocks do
                            if isEvent and BLOCKS.group.blocks[j + blockIndex - i].data.event then break end
                            blockIndex, blockData = blockIndex + 1, COPY_TABLE(BLOCKS.group.blocks[j + blockIndex - i].data)
                            table.insert(script.params, blockIndex, blockData)
                            BLOCKS.new(blockData.name, blockIndex, blockData.event, blockData.params, blockData.comment, blockData.nested, blockData.vars, blockData.tables)
                            local notNested = not (blockData.nested and #blockData.nested > 0)

                            if not isEvent then
                                if blockData.name == bName and notNested then
                                    nestedEndIndex = nestedEndIndex + 1
                                elseif blockData.name == INFO.listNested[bName][endIndex] then
                                    nestedEndIndex = nestedEndIndex - 1
                                    if nestedEndIndex == 0 then break end
                                end
                            end
                        end
                    end

                    SET_GAME_CODE(CURRENT_LINK, data)
                    SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)

                    if isEvent then
                        local diffScrollY = BLOCKS.group[8].y - BLOCKS.group.blocks[i].y + BLOCKS.group.blocks[i].height / 2
                        BLOCKS.group[8]:scrollToPosition({y = diffScrollY > 0 and 0 or diffScrollY, time = 0})

                        for j = i, #BLOCKS.group.blocks do
                            if BLOCKS.group.blocks[j].data.event and j ~= i then break end

                            for k = 2, #INFO.listName[BLOCKS.group.blocks[j].data.name] do
                                if INFO.listName[BLOCKS.group.blocks[j].data.name][k][1] == 'localvar'
                                or INFO.listName[BLOCKS.group.blocks[j].data.name][k][1] == 'localtable'
                                or INFO.listName[BLOCKS.group.blocks[j].data.name][k][1] == 'var'
                                or INFO.listName[BLOCKS.group.blocks[j].data.name][k][1] == 'table'
                                or INFO.listName[BLOCKS.group.blocks[j].data.name][k][1] == 'value' then
                                    listeners.checkLocalData(j, k - 1, INFO.listName[BLOCKS.group.blocks[j].data.name][k][1], data)
                                end
                            end
                        end
                    else
                        display.getCurrentStage():setFocus(BLOCKS.group.blocks[i])
                        BLOCKS.group.blocks[i].click = true
                        BLOCKS.group.blocks[i].move = true
                        newMoveLogicBlock({target = BLOCKS.group.blocks[i]}, BLOCKS.group, BLOCKS.group[8], nil, true)
                    end
                else
                    table.insert(script.params, blockIndex, blockData)
                    BLOCKS.new(blockData.name, blockIndex, blockData.event, blockData.params, blockData.comment)

                    SET_GAME_CODE(CURRENT_LINK, data)
                    SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
                    display.getCurrentStage():setFocus(BLOCKS.group.blocks[blockIndex])
                    BLOCKS.group.blocks[blockIndex].click = true
                    BLOCKS.group.blocks[blockIndex].move = true
                    newMoveLogicBlock({target = BLOCKS.group.blocks[blockIndex]}, BLOCKS.group, BLOCKS.group[8], nil, true)
                end

                break
            end
        end

        for i = 1, #BLOCKS.group.blocks do
            if BLOCKS.group.blocks[i].checkbox.isOn then
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})
            end
        end
    elseif INDEX_LIST == 3 then
        for i = #BLOCKS.group.blocks, 1, -1 do
            if BLOCKS.group.blocks[i].checkbox.isOn then
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})

                if BLOCKS.group.blocks[i].data.comment then
                    script.params[i].comment = false
                    BLOCKS.group.blocks[i].block:setFillColor(INFO.getBlockColor(BLOCKS.group.blocks[i].data.name, false))
                    BLOCKS.group.blocks[i].data.comment = false
                else
                    script.params[i].comment = true
                    BLOCKS.group.blocks[i].block:setFillColor(INFO.getBlockColor(BLOCKS.group.blocks[i].data.name, true))
                    BLOCKS.group.blocks[i].data.comment = true
                end

                if BLOCKS.group.blocks[i].data.nested then
                    local nestedEndIndex = 1

                    local function nestedFun(t, comment)
                        for j = 1, #t do
                            t[j].comment = comment

                            if t[j].nested and #t[j].nested > 0 then
                                nestedFun(t[j].nested, comment)
                            end
                        end
                    end

                    if #BLOCKS.group.blocks[i].data.nested == 0 then
                        for j = i + 1, #BLOCKS.group.blocks do
                            local name = BLOCKS.group.blocks[j].data.name
                            local isNested = BLOCKS.group.blocks[j].data.nested and #BLOCKS.group.blocks[j].data.nested > 0
                            local notEvent = not BLOCKS.group.blocks[i].data.event
                            if BLOCKS.group.blocks[j].data.event then break end

                            script.params[j].comment = BLOCKS.group.blocks[i].data.comment
                            BLOCKS.group.blocks[j].block:setFillColor(INFO.getBlockColor(BLOCKS.group.blocks[j].data.name, BLOCKS.group.blocks[i].data.comment))
                            BLOCKS.group.blocks[j].data.comment = BLOCKS.group.blocks[i].data.comment

                            if isNested then
                                nestedFun(script.params[j].nested, BLOCKS.group.blocks[j].data.comment)
                            end

                            if notEvent and name == BLOCKS.group.blocks[i].data.name and not isNested then
                                nestedEndIndex = nestedEndIndex + 1
                            elseif notEvent and name == INFO.listNested[BLOCKS.group.blocks[i].data.name][1] then
                                nestedEndIndex = nestedEndIndex - 1
                                if nestedEndIndex == 0 then break end
                            end
                        end
                    else
                        nestedFun(script.params[i].nested, BLOCKS.group.blocks[i].data.comment)
                    end
                end
            end
        end
    elseif INDEX_LIST == 4 then
        for i = 1, #BLOCKS.group.blocks do
            if BLOCKS.group.blocks[i].checkbox.isOn then
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})

                if BLOCKS.group.blocks[i].data.nested and BLOCKS.group.blocks[i].polygon.yScale == 1 then
                    local nestedTable = COPY_TABLE(script.params[i].nested)

                    for j = 1, #nestedTable do
                        local blockIndex, blockData = i + j, COPY_TABLE(nestedTable[j])
                        table.insert(script.params, blockIndex, blockData)
                        BLOCKS.new(blockData.name, blockIndex, blockData.event, blockData.params, blockData.comment, blockData.nested)
                    end

                    BLOCKS.group.blocks[i].polygon.yScale = -1
                    BLOCKS.group.blocks[i].polygon:setFillColor(1)
                    script.params[i].nested, BLOCKS.group.blocks[i].data.nested = {}, {}
                elseif BLOCKS.group.blocks[i].data.nested then
                    if BLOCKS.group.blocks[i].data.event then
                        for j = i + 1, #BLOCKS.group.blocks do
                            if BLOCKS.group.blocks[i + 1].data.event then break end
                            table.insert(BLOCKS.group.blocks[i].data.nested, BLOCKS.group.blocks[i + 1].data)
                            BLOCKS.group.scrollHeight = BLOCKS.group.scrollHeight - BLOCKS.group.blocks[i + 1].block.height + 4
                            BLOCKS.group.blocks[i + 1]:removeSelf() table.remove(BLOCKS.group.blocks, i + 1)
                            table.remove(script.params, i + 1)
                        end
                    elseif INFO.listNested[BLOCKS.group.blocks[i].data.name] then
                        local endIndex = #INFO.listNested[BLOCKS.group.blocks[i].data.name]
                        local insideNestedIndex = i + 1
                        local nestedEndIndex = 1

                        for j = insideNestedIndex, #BLOCKS.group.blocks do
                            if not BLOCKS.group.blocks[insideNestedIndex].data.event then
                                local name = BLOCKS.group.blocks[insideNestedIndex].data.name
                                local notNested = not (BLOCKS.group.blocks[insideNestedIndex].data.nested and #BLOCKS.group.blocks[insideNestedIndex].data.nested > 0)
                                table.insert(BLOCKS.group.blocks[i].data.nested, BLOCKS.group.blocks[insideNestedIndex].data)
                                BLOCKS.group.scrollHeight = BLOCKS.group.scrollHeight - BLOCKS.group.blocks[insideNestedIndex].block.height + 4
                                BLOCKS.group.blocks[insideNestedIndex]:removeSelf() table.remove(BLOCKS.group.blocks, insideNestedIndex)
                                table.remove(script.params, insideNestedIndex)

                                if name == BLOCKS.group.blocks[i].data.name and notNested then
                                    nestedEndIndex = nestedEndIndex + 1
                                elseif name == INFO.listNested[BLOCKS.group.blocks[i].data.name][endIndex] then
                                    nestedEndIndex = nestedEndIndex - 1
                                    if nestedEndIndex == 0 then break end
                                end
                            else
                                insideNestedIndex = insideNestedIndex + 1
                            end
                        end
                    end

                    for i = 1, #BLOCKS.group.blocks do
                        local y = i == 1 and 50 or BLOCKS.group.blocks[i - 1].y + BLOCKS.group.blocks[i - 1].block.height / 2 + BLOCKS.group.blocks[i].height / 2 - 4
                        local addY = i == 1 and 24 + (BLOCKS.group.blocks[i].height - 120) / 2 or 24
                        if BLOCKS.group.blocks[i].data.event then y = y + addY end BLOCKS.group.blocks[i].y = y
                    end

                    if #BLOCKS.group.blocks[i].data.nested > 0 then
                        BLOCKS.group.blocks[i].polygon.yScale = 1
                        BLOCKS.group.blocks[i].polygon:setFillColor(0.25)
                        script.params[i].nested = BLOCKS.group.blocks[i].data.nested
                    end
                end

                BLOCKS.group[8]:setScrollHeight(GET_SCROLL_HEIGHT(BLOCKS.group)) break
            end
        end
    elseif INDEX_LIST == 5 then
        for i = 1, #BLOCKS.group.blocks do
            if BLOCKS.group.blocks[i].checkbox.isOn and BLOCKS.group.blocks[i].data.nested and #BLOCKS.group.blocks[i].data.nested == 0 then
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})

                local blockIndex = i + 1
                local blockData = {name = 'ifElse', params = {{}}, event = false, comment = false}

                table.insert(script.params, blockIndex, blockData)
                BLOCKS.new(blockData.name, blockIndex, blockData.event, blockData.params, blockData.comment)

                SET_GAME_CODE(CURRENT_LINK, data)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)

                for j = 1, #BLOCKS.group.blocks do
                    if BLOCKS.group.blocks[j].checkbox.isOn then
                        BLOCKS.group.blocks[j].checkbox:setState({isOn = false})
                    end
                end

                display.getCurrentStage():setFocus(BLOCKS.group.blocks[blockIndex])
                BLOCKS.group.blocks[blockIndex].click = true
                BLOCKS.group.blocks[blockIndex].move = true
                newMoveLogicBlock({target = BLOCKS.group.blocks[blockIndex]}, BLOCKS.group, BLOCKS.group[8], nil, true)

                break
            end
        end
    end

    if INDEX_LIST ~= 1 then
        for i = 1, #BLOCKS.group.blocks do BLOCKS.group.blocks[i].checkbox:setState({isOn = false}) end
        if INDEX_LIST ~= 2 and INDEX_LIST ~= 5 then SET_GAME_CODE(CURRENT_LINK, data) SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data) end
    end
end

return function(e)
    if e.bIndex then
        listeners.checkLocalData(e.bIndex, e.pIndex, e.pType, e.data)
    elseif BLOCKS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true
            if e.target.button == 'but_list'
                then e.target.width, e.target.height = 52, 52
            else e.target.alpha = 0.6 end
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            e.target.click = false
            if e.target.button == 'but_list'
                then e.target.width, e.target.height = 60, 60
            elseif e.target.button == 'but_title'
                then e.target.alpha = 1
            else e.target.alpha = 0.9 end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            if not e.target.fake then display.getCurrentStage():setFocus(nil) end
            if e.target.click then
                e.target.click = false
                if e.target.button == 'but_list'
                    then e.target.width, e.target.height = 60, 60
                elseif e.target.button == 'but_title'
                    then e.target.alpha = 1
                else e.target.alpha = 0.9 end
                listeners[e.target.button](e.target)
            end
        end
        return true
    end
end
