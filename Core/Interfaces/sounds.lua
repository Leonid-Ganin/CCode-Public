local listeners = {}
local FOLDER = require 'Core.Modules.interface-folder'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'
local FILTER = require 'Core.Modules.name-filter'

listeners.but_title = function(target)
    EXITS.sounds()
end

listeners.but_add = function(target)
    SOUNDS.group[8]:setIsLocked(true, 'vertical')
    if SOUNDS.group.isVisible then
        local data = GET_GAME_CODE(CURRENT_LINK)
        INPUT.new(STR['sounds.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                FILTER.check(event.target.text, function(ev)
                    if ev.isError then
                        INPUT.remove(false)
                        WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                    else
                        INPUT.remove(true, ev.text)
                    end
                end, SOUNDS.group.blocks, data, 'sounds')
            end
        end, function(e)
            SOUNDS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                if not e.checkbox then
                    local numSound = 1
                    local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Sounds'

                    local completeImportPicture = function(import)
                        if import.done and import.done == 'ok' then
                            local path = path .. '/Sound' .. numSound
                            local folderIsComment = data.folders.sounds[1][3]

                            if folderIsComment then
                                FOLDER.show(SOUNDS.group.blocks[1], SOUNDS.group, 'sounds', data, 1, 1)
                            end

                            table.insert(data.resources.sounds, 1, {e.text, 'Sound' .. numSound})
                            table.insert(data.folders.sounds[1][2], 1, data.resources.sounds[1])

                            SET_GAME_CODE(CURRENT_LINK, data)
                            SOUNDS.new(e.text, 2, 'Sound' .. numSound)

                            if folderIsComment then
                                FOLDER.hide(nil, SOUNDS.group, 'sounds', nil, 1, 1, data)
                            end
                        end
                    end

                    while true do
                        local file = io.open(path .. '/Sound' .. numSound, 'r')
                        if file then
                            numSound = numSound + 1
                            io.close(file)
                        else
                            GIVE_PERMISSION_DATA()
                            FILE.pickFile(path, completeImportPicture, 'Sound' .. numSound, '', 'audio/*', nil, nil, nil)
                            break
                        end
                    end
                else
                    table.insert(data.folders.sounds, {e.text, {}, false}) SET_GAME_CODE(CURRENT_LINK, data)
                    SOUNDS.folder(e.text, #SOUNDS.group.blocks + 1, #data.folders.sounds, false)
                end
            end
        end, nil, STR['scripts.folder'])
    else
        SOUNDS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = SOUNDS
    SOUNDS.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    local list = #SOUNDS.group.blocks == 0 and {} or {STR['button.remove'], STR['button.rename']}

    SOUNDS.group[8]:setIsLocked(true, 'vertical')
    if SOUNDS.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            SOUNDS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index
                EXITS.add(listeners.but_okay_end)
                SOUNDS.group[3].isVisible = true
                SOUNDS.group[4].isVisible = false
                SOUNDS.group[5].isVisible = false
                SOUNDS.group[6].isVisible = false
                SOUNDS.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                SOUNDS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #SOUNDS.group.blocks do
                    pcall(function() SOUNDS.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                SOUNDS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #SOUNDS.group.blocks do
                    pcall(function() SOUNDS.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.find'] then
                SOUNDS.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['sounds.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    SOUNDS.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #SOUNDS.group.data, 1, -1 do
                            SOUNDS.group.blocks[i].remove(i)
                        end

                        for index, sound_config in pairs(data.resources.sounds) do
                            if UTF8.find(UTF8.lower(sound_config[1]), UTF8.lower(e.text)) then
                                SOUNDS.new(sound_config[1], #SOUNDS.group.blocks + 1, sound_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        SOUNDS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay_end = function()
    ALERT = true
    SOUNDS.group[3].text = ''
    SOUNDS.group[3].isVisible = false
    SOUNDS.group[4].isVisible = true
    SOUNDS.group[5].isVisible = true
    SOUNDS.group[6].isVisible = true
    SOUNDS.group[7].isVisible = false

    for i = 1, #SOUNDS.group.blocks do
        pcall(function()
            SOUNDS.group.blocks[i].checkbox.isVisible = false
            SOUNDS.group.blocks[i].checkbox:setState({isOn = false})
        end)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    EXITS.remove()
    SOUNDS.group[3].text = ''
    SOUNDS.group[3].isVisible = false
    SOUNDS.group[4].isVisible = true
    SOUNDS.group[5].isVisible = true
    SOUNDS.group[6].isVisible = true
    SOUNDS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #SOUNDS.group.data, 1, -1 do
            if not SOUNDS.group.blocks[i].indexFolder then
                SOUNDS.group.blocks[i].checkbox.isVisible = false

                if SOUNDS.group.blocks[i].checkbox.isOn then
                    local indexReal, indexInFolder = SOUNDS.group.blocks[i].getRealIndex(SOUNDS.group.blocks[i], data, 'sounds')
                    local indexFolder = SOUNDS.group.blocks[i].getFolderIndex(SOUNDS.group.blocks[i])

                    table.remove(data.resources.sounds, indexReal)
                    table.remove(data.folders.sounds[indexFolder][2], indexInFolder)

                    OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Sounds/' .. SOUNDS.group.blocks[i].link)
                    SOUNDS.group.blocks[i].remove(i)
                end
            end
        end

        for j = 1, #SOUNDS.group.blocks do
            local y = j == 1 and 25 or SOUNDS.group.data[j - 1].y + 150
            pcall(function() SOUNDS.group.blocks[j].y = y end)
            pcall(function() SOUNDS.group.blocks[j].text.y = y end)
            pcall(function() SOUNDS.group.blocks[j].polygon.y = y end)
            pcall(function() SOUNDS.group.blocks[j].checkbox.y = y end)
            pcall(function() SOUNDS.group.blocks[j].container.y = y end)
            pcall(function() SOUNDS.group.data[j].y = y end)
        end

        SET_GAME_CODE(CURRENT_LINK, data)
        SOUNDS.group[8]:setScrollHeight(150 * #SOUNDS.group.data)
    elseif INDEX_LIST == 2 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #SOUNDS.group.blocks, 1, -1 do
            if not SOUNDS.group.blocks[i].indexFolder then
                SOUNDS.group.blocks[i].checkbox.isVisible = false

                if SOUNDS.group.blocks[i].checkbox.isOn then
                    SOUNDS.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['sounds.changename'], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, SOUNDS.group.blocks, data, 'sounds')
                        end
                    end, function(e)
                        if e.input then
                            local indexReal, indexInFolder = SOUNDS.group.blocks[i].getRealIndex(SOUNDS.group.blocks[i], data, 'sounds')
                            local indexFolder = SOUNDS.group.blocks[i].getFolderIndex(SOUNDS.group.blocks[i])
                            data.resources.sounds[indexReal][1] = e.text
                            data.folders.sounds[indexFolder][2][indexInFolder][1] = e.text
                            SOUNDS.group.blocks[i].text.text = e.text
                            SET_GAME_CODE(CURRENT_LINK, data)
                        end
                    end, SOUNDS.group.blocks[i].text.text)
                end
            end
        end
    end
end

return function(e)
    if SOUNDS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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
