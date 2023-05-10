local listeners = {}
local FOLDER = require 'Core.Modules.interface-folder'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'
local FILTER = require 'Core.Modules.name-filter'

listeners.but_title = function(target)
    EXITS.resources()
end

listeners.but_add = function(target)
    RESOURCES.group[8]:setIsLocked(true, 'vertical')
    if RESOURCES.group.isVisible then
        local data = GET_GAME_CODE(CURRENT_LINK)
        INPUT.new(STR['resources.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                FILTER.check(event.target.text, function(ev)
                    if ev.isError then
                        INPUT.remove(false)
                        WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                    else
                        INPUT.remove(true, ev.text)
                    end
                end, RESOURCES.group.blocks, data, 'others')
            end
        end, function(e)
            RESOURCES.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                if not e.checkbox then
                    local numResource = 1
                    local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Resources'

                    local completeImportPicture = function(import)
                        if import.done and import.done == 'ok' then
                            local path = path .. '/Resource' .. numResource
                            local folderIsComment = data.folders.others[1][3]

                            if folderIsComment then
                                FOLDER.show(RESOURCES.group.blocks[1], RESOURCES.group, 'others', data, 1, 1)
                            end

                            table.insert(data.resources.others, 1, {e.text, 'Resource' .. numResource})
                            table.insert(data.folders.others[1][2], 1, data.resources.others[1])

                            SET_GAME_CODE(CURRENT_LINK, data)
                            RESOURCES.new(e.text, 2, 'Resource' .. numResource)

                            if folderIsComment then
                                FOLDER.hide(nil, RESOURCES.group, 'others', nil, 1, 1, data)
                            end
                        end
                    end

                    while true do
                        local file = io.open(path .. '/Resource' .. numResource, 'r')
                        if file then
                            numResource = numResource + 1
                            io.close(file)
                        else
                            GIVE_PERMISSION_DATA()
                            FILE.pickFile(path, completeImportPicture, 'Resource' .. numResource, '', '*/*', nil, nil, nil)
                            break
                        end
                    end
                else
                    table.insert(data.folders.others, {e.text, {}, false}) SET_GAME_CODE(CURRENT_LINK, data)
                    RESOURCES.folder(e.text, #RESOURCES.group.blocks + 1, #data.folders.others, false)
                end
            end
        end, nil, STR['scripts.folder'])
    else
        RESOURCES.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = RESOURCES
    RESOURCES.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    local list = #RESOURCES.group.blocks == 0 and {} or {STR['button.remove'], STR['button.rename']}

    RESOURCES.group[8]:setIsLocked(true, 'vertical')
    if RESOURCES.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            RESOURCES.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index
                EXITS.add(listeners.but_okay_end)
                RESOURCES.group[3].isVisible = true
                RESOURCES.group[4].isVisible = false
                RESOURCES.group[5].isVisible = false
                RESOURCES.group[6].isVisible = false
                RESOURCES.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                RESOURCES.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #RESOURCES.group.blocks do
                    pcall(function() RESOURCES.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                RESOURCES.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #RESOURCES.group.blocks do
                    pcall(function() RESOURCES.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.find'] then
                RESOURCES.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['resources.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    RESOURCES.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #RESOURCES.group.data, 1, -1 do
                            RESOURCES.group.blocks[i].remove(i)
                        end

                        for index, resource_config in pairs(data.resources.others) do
                            if UTF8.find(UTF8.lower(resource_config[1]), UTF8.lower(e.text)) then
                                RESOURCES.new(resource_config[1], #RESOURCES.group.blocks + 1, resource_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        RESOURCES.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay_end = function()
    ALERT = true
    RESOURCES.group[3].text = ''
    RESOURCES.group[3].isVisible = false
    RESOURCES.group[4].isVisible = true
    RESOURCES.group[5].isVisible = true
    RESOURCES.group[6].isVisible = true
    RESOURCES.group[7].isVisible = false

    for i = 1, #RESOURCES.group.blocks do
        pcall(function()
            RESOURCES.group.blocks[i].checkbox.isVisible = false
            RESOURCES.group.blocks[i].checkbox:setState({isOn = false})
        end)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    EXITS.remove()
    RESOURCES.group[3].text = ''
    RESOURCES.group[3].isVisible = false
    RESOURCES.group[4].isVisible = true
    RESOURCES.group[5].isVisible = true
    RESOURCES.group[6].isVisible = true
    RESOURCES.group[7].isVisible = false

    if INDEX_LIST == 1 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #RESOURCES.group.data, 1, -1 do
            if not RESOURCES.group.blocks[i].indexFolder then
                RESOURCES.group.blocks[i].checkbox.isVisible = false

                if RESOURCES.group.blocks[i].checkbox.isOn then
                    local indexReal, indexInFolder = RESOURCES.group.blocks[i].getRealIndex(RESOURCES.group.blocks[i], data, 'others')
                    local indexFolder = RESOURCES.group.blocks[i].getFolderIndex(RESOURCES.group.blocks[i])

                    table.remove(data.resources.others, indexReal)
                    table.remove(data.folders.others[indexFolder][2], indexInFolder)

                    OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Resources/' .. RESOURCES.group.blocks[i].link)
                    RESOURCES.group.blocks[i].remove(i)
                end
            end
        end

        for j = 1, #RESOURCES.group.blocks do
            local y = j == 1 and 25 or RESOURCES.group.data[j - 1].y + 150
            pcall(function() RESOURCES.group.blocks[j].y = y end)
            pcall(function() RESOURCES.group.blocks[j].text.y = y end)
            pcall(function() RESOURCES.group.blocks[j].polygon.y = y end)
            pcall(function() RESOURCES.group.blocks[j].checkbox.y = y end)
            pcall(function() RESOURCES.group.blocks[j].container.y = y end)
            pcall(function() RESOURCES.group.data[j].y = y end)
        end

        SET_GAME_CODE(CURRENT_LINK, data)
        RESOURCES.group[8]:setScrollHeight(150 * #RESOURCES.group.data)
    elseif INDEX_LIST == 2 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #RESOURCES.group.blocks, 1, -1 do
            if not RESOURCES.group.blocks[i].indexFolder then
                RESOURCES.group.blocks[i].checkbox.isVisible = false

                if RESOURCES.group.blocks[i].checkbox.isOn then
                    RESOURCES.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['resources.changename'], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, RESOURCES.group.blocks, data, 'others')
                        end
                    end, function(e)
                        if e.input then
                            local indexReal, indexInFolder = RESOURCES.group.blocks[i].getRealIndex(RESOURCES.group.blocks[i], data, 'others')
                            local indexFolder = RESOURCES.group.blocks[i].getFolderIndex(RESOURCES.group.blocks[i])
                            data.resources.others[indexReal][1] = e.text
                            data.folders.others[indexFolder][2][indexInFolder][1] = e.text
                            RESOURCES.group.blocks[i].text.text = e.text
                            SET_GAME_CODE(CURRENT_LINK, data)
                        end
                    end, RESOURCES.group.blocks[i].text.text)
                end
            end
        end
    end
end

return function(e)
    if RESOURCES.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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
