local BLOCK = require 'Core.Modules.logic-block'
local LISTENER = require 'Core.Editor.listener'
local LIST = require 'Core.Modules.logic-list'
local DATA = require 'Core.Editor.data'
local TEXT = require 'Core.Editor.text'
local M = {rScrollParams = {}, scrollY = 0}

local getFontSize = function(i)
    if CENTER_X == 360 then
        return (i == 1 or i == 2) and 24 or 36
    elseif CENTER_X == 641 then
        return (i == 17 or i == 18) and 24 or 36
    end
end

M.create = function(blockName, blockIndex, paramsData, paramsIndex, newOrientation, _, customIndex)
    if newOrientation then
        local index = LISTENER.find(paramsData)
        if index then table.remove(paramsData, index) end
    end

    M.group, M.data = display.newGroup(), COPY_TABLE(blockName == 'customDefault' and paramsData[paramsIndex] or paramsData)
    M.restart = {blockName, blockIndex, M.data, paramsIndex, nil, blockName == 'customDefault', customIndex, paramsData}
    BLOCKS.group.isVisible = false

    local custom, ids = GET_GAME_CUSTOM(), {}
    local data = GET_GAME_CODE(CURRENT_LINK)
    local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)

    DATA.new()
        M.resources = {images = {}, sounds = {}, videos = {}, fonts = {}, others = {}}
        M.vars = {project = COPY_TABLE(data.vars), script = COPY_TABLE(script.vars), event = {}}
        M.tables = {project = COPY_TABLE(data.tables), script = COPY_TABLE(script.tables), event = {}}
        M.funs = {project = COPY_TABLE(data.funs), script = COPY_TABLE(script.funs), custom = {}, _custom = {}}
        M.fun, M.math, M.log, M.device, M.prop = DATA.fun, DATA.math, DATA.log, DATA.device, {
            obj = DATA.prop.obj, text = DATA.prop.text, group = DATA.prop.group,
            widget = DATA.prop.widget, media = DATA.prop.media, files = DATA.prop.files
        }

    for k, v in pairs(data.resources) do
        for i = 1, #v do
            M.resources[k][i] = v[i][1]
        end
    end

    if blockName ~= 'customDefault' then
        for i = blockIndex, 1, -1 do
            if script.params[i].event then
                M.vars.event = script.params[i].vars
                M.tables.event = script.params[i].tables
                break
            end
        end

        for index, block in pairs(custom) do
            if tonumber(index) then
                table.insert(ids, {block[4], tonumber(index)})
            end
        end table.sort(ids, function(a, b) return (a[1] == b[1]) and (a[2] > b[2]) or (a[1] > b[1]) end)

        for _, index in ipairs(ids) do
            table.insert(M.funs.custom, STR['blocks.custom' .. index[2]])
            table.insert(M.funs._custom, 'custom' .. index[2])
        end
    else
        M.vars = {project = {}, script = {}, event = {}}
        M.tables = {project = {}, script = {}, event = {}}
        M.funs = {project = {}, script = {}, custom = {}, _custom = {}}
        M.resources = {images = {}, sounds = {}, videos = {}, fonts = {}, others = {}}
    end

    local buttonsText = {
        STR['editor.button.text'], STR['editor.button.hide'],
        '[', ']', '==', STR['editor.button.local'], '(', ')',
        1, 2, 3, '+', 4, 5, 6, '-', 7, 8, 9, '*',
        '.', 0, ',', '/', 'C', '<-', '->', STR['button.okay']
    }

    local title = display.newText(STR['program.editor'], ZERO_X + 10, ZERO_Y + 10, 'ubuntu', 32)
        title.anchorX = 0
        title.anchorY = 0
        title.id = 'title'
    M.group:insert(title)

    local list = display.newRoundedRect(MAX_X - 50, ZERO_Y + 34, 80, 60, 10)
        list:setFillColor(0.15, 0.15, 0.17)
        list.text = display.newText('⋮', list.x, list.y - 2, 'ubuntu', 40)
        list.text.id = 'list'
    M.group:insert(list)
    M.group:insert(list.text)

    local undo = display.newRoundedRect(MAX_X - 250, ZERO_Y + 34, 80, 60, 10)
        undo:setFillColor(0.15, 0.15, 0.17)
        undo.text = display.newText('⤺', undo.x, undo.y - 18, 'ubuntu', 80)
        undo.text.id = 'undo'
    M.group:insert(undo)
    M.group:insert(undo.text)

    local redo = display.newRoundedRect(MAX_X - 150, ZERO_Y + 34, 80, 60, 10)
        redo:setFillColor(0.15, 0.15, 0.17)
        redo.text = display.newText('⤺', redo.x, redo.y - 18, 'ubuntu', 80)
        redo.text.id = 'redo'
        redo.text.xScale = -1
    M.group:insert(redo)
    M.group:insert(redo.text)

    if CENTER_X == 641 then
        list.y = ZERO_Y + 38
        undo.y = ZERO_Y + 38
        redo.y = ZERO_Y + 38
        list.text.y = list.y - 2
        undo.text.y = undo.y - 18
        redo.text.y = redo.y - 18
    end

    local targetWidth
    local targetData
    local length, _length
    local twidth, size

    if blockName ~= 'customDefault' then
        targetWidth = BLOCKS.group.blocks[blockIndex].block.width
        targetData = COPY_TABLE(BLOCKS.group.blocks[blockIndex].data)
        length, _length = #INFO.listName[targetData.name] - 1, #targetData.params
        twidth, size = CENTER_X == 641 and (MAX_X - ZERO_X - 844) * 1.5 or targetWidth * 1.0, CENTER_X == 641 and 1.5 or 1.0

        if _length > length then
            for i = 1, _length do
                if i > length then
                    table.remove(BLOCKS.group.blocks[blockIndex].data.params, length + 1)
                    table.remove(targetData.params, length + 1)
                end
            end
        elseif length > _length then
            for i = 1, length do
                if i > _length then
                    table.insert(BLOCKS.group.blocks[blockIndex].data.params, _length + 1, {})
                    table.insert(targetData.params, _length + 1, {})
                end
            end
        end
    else
        targetWidth, length = BLOCKS.group.blocks[1].block.width, #paramsData
        targetData = {event = false, name = '', params = paramsData, color = blockIndex}
        twidth, size = CENTER_X == 641 and (MAX_X - ZERO_X - 844) * 1.5 or targetWidth * 1.0, CENTER_X == 641 and 1.5 or 1.0
    end

    local blockScroll = WIDGET.newScrollView({
            x = CENTER_X, y = title.y + title.height + 155,
            width = DISPLAY_WIDTH, height = 250,
            hideScrollBar = false, horizontalScrollDisabled = true,
            isBounceEnabled = true, hideBackground = true
        })
    M.group:insert(blockScroll)

    local block = LIST.create(targetData, size, twidth, 1.0)
        block.x = blockScroll.width / 2
        block.y = block.height / 2 + 12
    blockScroll:insert(block)

    if M.scrollY == 0 and ((paramsIndex > 6 and length % 2 == 0) or (paramsIndex > 5 and length % 2 == 1)) then
        local minusFactor = (paramsIndex > 6 and length % 2 == 0) and 6 or 5
        local indexUp = math.round((paramsIndex - minusFactor) / 2, 0)
        local maxUp = math.round((length - minusFactor) / 2, 0) M.scrollY = -60 * indexUp
        if maxUp > indexUp then M.scrollY = M.scrollY - 60 end
    end

    block.y = block.y < blockScroll.height / 2 and blockScroll.height / 2 or block.y
    blockScroll:scrollToPosition({y = M.scrollY, time = 0}) M.scrollY = 0
    blockScroll:setScrollHeight(block.height + 24)

    for i = 1, length do
        block.params[i].rect:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
                e.target:setFillColor(0.8, 0.8, 1)
                e.target.alpha = 0.2
            elseif e.phase == 'moved' and (math.abs(e.y - e.yStart) > 20 or math.abs(e.x - e.xStart) > 20) then
                blockScroll:takeFocus(e)
                e.target.click = false
                e.target:setFillColor(1)
                e.target.alpha = 0.005
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then
                    e.target.click = false
                    e.target:setFillColor(1)
                    e.target.alpha = 0.005
                    LISTENER.rect(e.target, COPY_TABLE(M.restart), COPY_TABLE(M.data))
                end
            end

            return true
        end)
    end

    local buttons = {}
    local buttonsX = ZERO_X + 54
    local buttonsY = MAX_Y - 655

    if CENTER_X == 641 then
        buttonsY = MAX_Y - 355
        for i = 8, 1, -1 do table.insert(buttonsText, 25, buttonsText[i]) end
        for i = 8, 1, -1 do table.remove(buttonsText, 1) end
    end

    local scrollY = (buttonsY - 45 + blockScroll.y + 130) / 2
    local scrollHeight = buttonsY - 45 - blockScroll.y - 160
    local scrollWidth, scrollX = DISPLAY_WIDTH, CENTER_X

    if CENTER_X == 641 then
        scrollHeight = buttonsY - 95 - title.y - title.height
        scrollY = (title.y + title.height + buttonsY - 35) / 2
        scrollWidth, scrollX, blockScroll.y = 745, ZERO_X + 404, scrollY
    end

    local scroll = WIDGET.newScrollView({
            x = scrollX, y = scrollY,
            width = scrollWidth, height = scrollHeight,
            hideScrollBar = false, horizontalScrollDisabled = true,
            isBounceEnabled = true, backgroundColor = {0.11, 0.11, 0.13}
        })
    M.group:insert(scroll)

    for i = 1, 28 do
        buttons[i] = display.newRoundedRect(buttonsX, buttonsY, 90, 90, 10)
            buttons[i]:setFillColor(0.15, 0.15, 0.17)
        M.group:insert(buttons[i])

        buttons[i].text = display.newText(buttonsText[i], buttonsX, buttonsY, 'ubuntu', getFontSize(i))
            buttons[i].text.id = i == 28 and 'Ok' or i == 1 and 'Text' or i == 2 and 'Hide' or i == 6 and 'Local' or buttons[i].text.text
        M.group:insert(buttons[i].text)

        if CENTER_X == 641 then
            buttons[i].text.id = i == 28 and 'Ok' or i == 17 and 'Text' or i == 18 and 'Hide' or i == 22 and 'Local' or buttons[i].text.text
        end

        buttonsX = i % 4 == 0 and ZERO_X + 54 or buttonsX + 100
        buttonsY = i % 4 == 0 and buttonsY + 100 or buttonsY

        if CENTER_X == 641 and i == 16 then
            buttonsX = buttonsX + 400
            buttonsY = MAX_Y - 355
        elseif CENTER_X == 641 and i > 16 and i % 4 == 0 then
            buttonsX = buttonsX + 400
        end

        buttons[i]:addEventListener('touch', function(e)
            local isSpeedID = e.target.text.id == '->' or e.target.text.id == '<-' or e.target.text.id == 'C' or tonumber(e.target.text.id)

            if e.phase == 'began' and ALERT then
                display.getCurrentStage():setFocus(e.target)
                e.target:setFillColor(0.18, 0.18, 0.2)
                e.target.click = true

                if isSpeedID then
                    pcall(function()
                        if e.target.timer then
                            timer.cancel(e.target.timer)
                            e.target.timer = nil
                        end
                    end)

                    e.target.timer = timer.performWithDelay(400, function()
                        if e.target.click and ALERT then
                            e.target.timer2 = timer.performWithDelay(25, function()
                                M.data, M.cursor, M.backup = LISTENER[e.target.text.id](M.data, M.cursor, M.backup)
                                TEXT.set(TEXT.gen(M.data, M.cursor[2]), scroll)
                            end, 0)
                        end
                    end)
                end
            elseif e.phase == 'moved' and (math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60) and ALERT then
                pcall(function() if e.target.timer2 then timer.cancel(e.target.timer2) e.target.timer2 = nil end end)
                pcall(function() if e.target.timer then timer.cancel(e.target.timer) e.target.timer = nil end end)
                display.getCurrentStage():setFocus(nil)
                e.target:setFillColor(0.15, 0.15, 0.17)
                e.target.click = false
            elseif (e.phase == 'ended' or e.phase == 'cancelled') and ALERT then
                local notHasTimer = true
                display.getCurrentStage():setFocus(nil)
                e.target:setFillColor(0.15, 0.15, 0.17)

                pcall(function()
                    if e.target.timer2 then
                        notHasTimer = false
                        timer.cancel(e.target.timer2)
                        e.target.timer2 = nil
                    end
                end)

                pcall(function()
                    if e.target.timer then
                        timer.cancel(e.target.timer)
                        e.target.timer = nil
                    end
                end)

                if e.target.click then
                    e.target.click = false

                    if notHasTimer then
                        M.data, M.cursor, M.backup = LISTENER[e.target.text.id](M.data, M.cursor, M.backup)

                        if e.target.text.id ~= 'Ok' and e.target.text.id ~= 'Hide' and e.target.text.id ~= 'Text' and e.target.text.id ~= 'Local' then
                            TEXT.set(TEXT.gen(M.data, M.cursor[2]), scroll)
                        end
                    end
                end
            end

            return true
        end)
    end

    local listScroll = WIDGET.newScrollView({
            x = (buttons[28].x + 45 + MAX_X) / 2, y = (buttons[1].y - 45 + MAX_Y - 10) / 2,
            width = MAX_X - buttons[28].x - 65, height = MAX_Y - buttons[1].y + 25,
            hideScrollBar = true, horizontalScrollDisabled = true,
            isBounceEnabled = true, backgroundColor = {0.15, 0.15, 0.17},
        }) listScroll.scrollHeight = 0
    M.group:insert(listScroll)

    listScroll.buttons = {}
    local listButtonsX = listScroll.width / 2
    local listButtonsY = 35
    local listButtonsText = {'var', 'table', 'funs', 'prop', 'fun', 'math', 'log', 'device', 'resource'}

    for i = 1, 9 do
        local listButtonName = 'editor.list.' .. listButtonsText[i]

        if NOOBMODE and (i == 1 or i == 3 or i == 5) then
            listButtonName = listButtonName .. '.noob'
        end

        listScroll.buttons[i] = display.newRect(listButtonsX, listButtonsY, listScroll.width, 70)
            listScroll.buttons[i]:setFillColor(0.11, 0.11, 0.13)
            listScroll.buttons[i].isOpen = false
            listScroll.buttons[i].count = 0
        listScroll:insert(listScroll.buttons[i])

        listScroll.buttons[i].text = display.newText(STR[listButtonName], 20, listButtonsY, 'ubuntu', 28)
            listScroll.buttons[i].text.id = listButtonsText[i]
            listScroll.buttons[i].text.anchorX = 0
        listScroll:insert(listScroll.buttons[i].text)

        listScroll.buttons[i].polygon = display.newPolygon(listScroll.width - 30, listButtonsY, {0, 0, 10, 10, -10, 10})
            listButtonsY = listButtonsY + 70
        listScroll:insert(listScroll.buttons[i].polygon)

        listScroll.scrollHeight = listScroll.scrollHeight + 70
        listScroll.buttons[i]:addEventListener('touch', require('Core.Editor.list').listener)
    end

    for i = 1, #M.rScrollParams - 1 do
        local index = M.rScrollParams[i]
        listScroll.buttons[index].click = true
        require('Core.Editor.list').listener({
            phase = 'ended', target = listScroll.buttons[index],
        }) listScroll:scrollToPosition({y = M.rScrollParams[#M.rScrollParams], time = 0})
    end M.rScrollParams = {}

    local toolbarListener = function(e)
        if e.phase == 'began' and ALERT then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true
            if e.target.id == 'title' then e.target.alpha = 0.6
            else e.target:setFillColor(0.18, 0.18, 0.2) end
        elseif e.phase == 'moved' and (math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60) and ALERT then
            display.getCurrentStage():setFocus(nil)
            e.target.click = false
            if e.target.id == 'title' then e.target.alpha = 1
            else e.target:setFillColor(0.15, 0.15, 0.17) end
        elseif (e.phase == 'ended' or e.phase == 'cancelled') and ALERT then
            display.getCurrentStage():setFocus(nil)
            if e.target.id == 'title' then e.target.alpha = 1
            else e.target:setFillColor(0.15, 0.15, 0.17) end
            if e.target.click then
                e.target.click = false
                if e.target.id == 'title' then
                    EXITS.editor()
                elseif e.target.text.id == 'undo' or e.target.text.id == 'redo' then
                    M.backup, M.data, M.cursor = LISTENER.backup(M.backup, e.target.text.id, M.data, M.cursor)
                    TEXT.set(TEXT.gen(M.data, M.cursor[2]), scroll)
                elseif e.target.text.id == 'list' then
                    LISTENER.list(e.target)
                end
            end
        end

        return true
    end

    title:addEventListener('touch', toolbarListener)
    list:addEventListener('touch', toolbarListener)
    undo:addEventListener('touch', toolbarListener)
    redo:addEventListener('touch', toolbarListener)

    M.data = TEXT.number(M.data)
    M.cursor = {#M.data + 1, 'w'}
    M.data[#M.data + 1] = {'|', '|'}
    M.backup = {{COPY_TABLE(M.data)}, 1}
    TEXT.create(TEXT.gen(M.data, M.cursor[2]), scroll)
end

return M
