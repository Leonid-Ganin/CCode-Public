local listeners = {}
local FOLDER = require 'Core.Modules.interface-folder'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'
local FILTER = require 'Core.Modules.name-filter'

listeners.but_title = function(target)
    EXITS.fonts()
end

listeners.but_add = function(target)
    FONTS.group[8]:setIsLocked(true, 'vertical')
    if FONTS.group.isVisible then
        local data = GET_GAME_CODE(CURRENT_LINK)
        INPUT.new(STR['fonts.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                FILTER.check(event.target.text, function(ev)
                    if ev.isError then
                        INPUT.remove(false)
                        WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                    else
                        INPUT.remove(true, ev.text)
                    end
                end, FONTS.group.blocks, data, 'fonts')
            end
        end, function(e)
            FONTS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                if not e.checkbox then
                    local numFont = 1
                    local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts'

                    local completeImportPicture = function(import)
                        if import.done and import.done == 'ok' then
                            local path = path .. '/Font' .. numFont
                            local folderIsComment = data.folders.fonts[1][3]

                            if folderIsComment then
                                FOLDER.show(FONTS.group.blocks[1], FONTS.group, 'fonts', data, 1, 1)
                            end

                            table.insert(data.resources.fonts, 1, {e.text, 'Font' .. numFont})
                            table.insert(data.folders.fonts[1][2], 1, data.resources.fonts[1])

                            SET_GAME_CODE(CURRENT_LINK, data)
                            FONTS.new(e.text, 2, 'Font' .. numFont)

                            if folderIsComment then
                                FOLDER.hide(nil, FONTS.group, 'fonts', nil, 1, 1, data)
                            end
                        end
                    end

                    while true do
                        local file = io.open(path .. '/Font' .. numFont, 'r')
                        if file then
                            numFont = numFont + 1
                            io.close(file)
                        else
                            GIVE_PERMISSION_DATA()
                            FILE.pickFile(path, completeImportPicture, 'Font' .. numFont, '', '*/*')
                            break
                        end
                    end
                else
                    table.insert(data.folders.fonts, {e.text, {}, false}) SET_GAME_CODE(CURRENT_LINK, data)
                    FONTS.folder(e.text, #FONTS.group.blocks + 1, #data.folders.fonts, false)
                end
            end
        end, nil, STR['scripts.folder'])
    else
        FONTS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = FONTS
    FONTS.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    local list = #FONTS.group.blocks == 0 and {} or {STR['button.remove'], STR['button.rename']}

    FONTS.group[8]:setIsLocked(true, 'vertical')
    if FONTS.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            FONTS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index
                EXITS.add(listeners.but_okay_end)
                FONTS.group[3].isVisible = true
                FONTS.group[4].isVisible = false
                FONTS.group[5].isVisible = false
                FONTS.group[6].isVisible = false
                FONTS.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                FONTS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #FONTS.group.blocks do
                    pcall(function() FONTS.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                FONTS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #FONTS.group.blocks do
                    pcall(function() FONTS.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.find'] then
                FONTS.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['fonts.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    FONTS.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #FONTS.group.data, 1, -1 do
                            FONTS.group.blocks[i].remove(i)
                        end

                        for index, font_config in pairs(data.resources.fonts) do
                            if UTF8.find(UTF8.lower(font_config[1]), UTF8.lower(e.text)) then
                                FONTS.new(font_config[1], #FONTS.group.blocks + 1, font_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        FONTS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay_end = function()
    ALERT = true
    FONTS.group[3].text = ''
    FONTS.group[3].isVisible = false
    FONTS.group[4].isVisible = true
    FONTS.group[5].isVisible = true
    FONTS.group[6].isVisible = true
    FONTS.group[7].isVisible = false

    for i = 1, #FONTS.group.blocks do
        pcall(function()
            FONTS.group.blocks[i].checkbox.isVisible = false
            FONTS.group.blocks[i].checkbox:setState({isOn = false})
        end)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    EXITS.remove()
    FONTS.group[3].text = ''
    FONTS.group[3].isVisible = false
    FONTS.group[4].isVisible = true
    FONTS.group[5].isVisible = true
    FONTS.group[6].isVisible = true
    FONTS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #FONTS.group.data, 1, -1 do
            if not FONTS.group.blocks[i].indexFolder then
                FONTS.group.blocks[i].checkbox.isVisible = false

                if FONTS.group.blocks[i].checkbox.isOn then
                    local indexReal, indexInFolder = FONTS.group.blocks[i].getRealIndex(FONTS.group.blocks[i], data, 'fonts')
                    local indexFolder = FONTS.group.blocks[i].getFolderIndex(FONTS.group.blocks[i])

                    table.remove(data.resources.fonts, indexReal)
                    table.remove(data.folders.fonts[indexFolder][2], indexInFolder)

                    OS_REMOVE(RES_PATH .. '/' .. CURRENT_LINK .. '_' .. FONTS.group.blocks[i].link)
                    OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts/' .. FONTS.group.blocks[i].link)
                    FONTS.group.blocks[i].remove(i)
                end
            end
        end

        for j = 1, #FONTS.group.blocks do
            local y = j == 1 and 25 or FONTS.group.data[j - 1].y + 150
            pcall(function() FONTS.group.blocks[j].y = y end)
            pcall(function() FONTS.group.blocks[j].text.y = y end)
            pcall(function() FONTS.group.blocks[j].polygon.y = y end)
            pcall(function() FONTS.group.blocks[j].checkbox.y = y end)
            pcall(function() FONTS.group.blocks[j].container.y = y end)
            pcall(function() FONTS.group.data[j].y = y end)
        end

        SET_GAME_CODE(CURRENT_LINK, data)
        FONTS.group[8]:setScrollHeight(150 * #FONTS.group.data)

        WINDOW.new(STR['fonts.needexit'], {STR['button.close'], STR['button.okay']}, function(e)
            native.requestExit()
        end, 3)
    elseif INDEX_LIST == 2 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #FONTS.group.blocks, 1, -1 do
            if not FONTS.group.blocks[i].indexFolder then
                FONTS.group.blocks[i].checkbox.isVisible = false

                if FONTS.group.blocks[i].checkbox.isOn then
                    FONTS.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['fonts.changename'], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, FONTS.group.blocks, data, 'fonts')
                        end
                    end, function(e)
                        if e.input then
                            local indexReal, indexInFolder = FONTS.group.blocks[i].getRealIndex(FONTS.group.blocks[i], data, 'fonts')
                            local indexFolder = FONTS.group.blocks[i].getFolderIndex(FONTS.group.blocks[i])
                            data.resources.fonts[indexReal][1] = e.text
                            data.folders.fonts[indexFolder][2][indexInFolder][1] = e.text
                            FONTS.group.blocks[i].text.text = e.text
                            SET_GAME_CODE(CURRENT_LINK, data)
                        end
                    end, FONTS.group.blocks[i].text.text)
                end
            end
        end
    end
end

return function(e)
    if FONTS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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
            display.getCurrentStage():setFocus(nil)
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
