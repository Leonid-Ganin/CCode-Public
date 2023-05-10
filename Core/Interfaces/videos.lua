local listeners = {}
local FOLDER = require 'Core.Modules.interface-folder'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'
local FILTER = require 'Core.Modules.name-filter'

listeners.but_title = function(target)
    EXITS.videos()
end

listeners.but_add = function(target)
    VIDEOS.group[8]:setIsLocked(true, 'vertical')
    if VIDEOS.group.isVisible then
        local data = GET_GAME_CODE(CURRENT_LINK)
        INPUT.new(STR['videos.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                FILTER.check(event.target.text, function(ev)
                    if ev.isError then
                        INPUT.remove(false)
                        WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                    else
                        INPUT.remove(true, ev.text)
                    end
                end, VIDEOS.group.blocks, data, 'videos')
            end
        end, function(e)
            VIDEOS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                if not e.checkbox then
                    local numVideo = 1
                    local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Videos'

                    local completeImportPicture = function(import)
                        if import.done and import.done == 'ok' then
                            local path = path .. '/Video' .. numVideo
                            local folderIsComment = data.folders.videos[1][3]

                            if folderIsComment then
                                FOLDER.show(VIDEOS.group.blocks[1], VIDEOS.group, 'videos', data, 1, 1)
                            end

                            table.insert(data.resources.videos, 1, {e.text, 'Video' .. numVideo})
                            table.insert(data.folders.videos[1][2], 1, data.resources.videos[1])

                            SET_GAME_CODE(CURRENT_LINK, data)
                            VIDEOS.new(e.text, 2, 'Video' .. numVideo)

                            if folderIsComment then
                                FOLDER.hide(nil, VIDEOS.group, 'videos', nil, 1, 1, data)
                            end
                        end
                    end

                    while true do
                        local file = io.open(path .. '/Video' .. numVideo, 'r')
                        if file then
                            numVideo = numVideo + 1
                            io.close(file)
                        else
                            GIVE_PERMISSION_DATA()
                            FILE.pickFile(path, completeImportPicture, 'Video' .. numVideo, '', 'video/*', nil, nil, nil)
                            break
                        end
                    end
                else
                    table.insert(data.folders.videos, {e.text, {}, false}) SET_GAME_CODE(CURRENT_LINK, data)
                    VIDEOS.folder(e.text, #VIDEOS.group.blocks + 1, #data.folders.videos, false)
                end
            end
        end, nil, STR['scripts.folder'])
    else
        VIDEOS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = VIDEOS
    VIDEOS.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    local list = #VIDEOS.group.blocks == 0 and {} or {STR['button.remove'], STR['button.rename']}

    VIDEOS.group[8]:setIsLocked(true, 'vertical')
    if VIDEOS.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            VIDEOS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index
                EXITS.add(listeners.but_okay_end)
                VIDEOS.group[3].isVisible = true
                VIDEOS.group[4].isVisible = false
                VIDEOS.group[5].isVisible = false
                VIDEOS.group[6].isVisible = false
                VIDEOS.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                VIDEOS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #VIDEOS.group.blocks do
                    pcall(function() VIDEOS.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                VIDEOS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #VIDEOS.group.blocks do
                    pcall(function() VIDEOS.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.find'] then
                VIDEOS.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['videos.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    VIDEOS.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #VIDEOS.group.data, 1, -1 do
                            VIDEOS.group.blocks[i].remove(i)
                        end

                        for index, video_config in pairs(data.resources.videos) do
                            if UTF8.find(UTF8.lower(video_config[1]), UTF8.lower(e.text)) then
                                VIDEOS.new(video_config[1], #VIDEOS.group.blocks + 1, video_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        VIDEOS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay_end = function()
    ALERT = true
    VIDEOS.group[3].text = ''
    VIDEOS.group[3].isVisible = false
    VIDEOS.group[4].isVisible = true
    VIDEOS.group[5].isVisible = true
    VIDEOS.group[6].isVisible = true
    VIDEOS.group[7].isVisible = false

    for i = 1, #VIDEOS.group.blocks do
        pcall(function()
            VIDEOS.group.blocks[i].checkbox.isVisible = false
            VIDEOS.group.blocks[i].checkbox:setState({isOn = false})
        end)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    EXITS.remove()
    VIDEOS.group[3].text = ''
    VIDEOS.group[3].isVisible = false
    VIDEOS.group[4].isVisible = true
    VIDEOS.group[5].isVisible = true
    VIDEOS.group[6].isVisible = true
    VIDEOS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #VIDEOS.group.data, 1, -1 do
            if not VIDEOS.group.blocks[i].indexFolder then
                VIDEOS.group.blocks[i].checkbox.isVisible = false

                if VIDEOS.group.blocks[i].checkbox.isOn then
                    local indexReal, indexInFolder = VIDEOS.group.blocks[i].getRealIndex(VIDEOS.group.blocks[i], data, 'videos')
                    local indexFolder = VIDEOS.group.blocks[i].getFolderIndex(VIDEOS.group.blocks[i])

                    table.remove(data.resources.videos, indexReal)
                    table.remove(data.folders.videos[indexFolder][2], indexInFolder)

                    OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Videos/' .. VIDEOS.group.blocks[i].link)
                    VIDEOS.group.blocks[i].remove(i)
                end
            end
        end

        for j = 1, #VIDEOS.group.blocks do
            local y = j == 1 and 25 or VIDEOS.group.data[j - 1].y + 150
            pcall(function() VIDEOS.group.blocks[j].y = y end)
            pcall(function() VIDEOS.group.blocks[j].text.y = y end)
            pcall(function() VIDEOS.group.blocks[j].polygon.y = y end)
            pcall(function() VIDEOS.group.blocks[j].checkbox.y = y end)
            pcall(function() VIDEOS.group.blocks[j].container.y = y end)
            pcall(function() VIDEOS.group.data[j].y = y end)
        end

        SET_GAME_CODE(CURRENT_LINK, data)
        VIDEOS.group[8]:setScrollHeight(150 * #VIDEOS.group.data)
    elseif INDEX_LIST == 2 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #VIDEOS.group.blocks, 1, -1 do
            if not VIDEOS.group.blocks[i].indexFolder then
                VIDEOS.group.blocks[i].checkbox.isVisible = false

                if VIDEOS.group.blocks[i].checkbox.isOn then
                    VIDEOS.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['videos.changename'], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, VIDEOS.group.blocks, data, 'videos')
                        end
                    end, function(e)
                        if e.input then
                            local indexReal, indexInFolder = VIDEOS.group.blocks[i].getRealIndex(VIDEOS.group.blocks[i], data, 'videos')
                            local indexFolder = VIDEOS.group.blocks[i].getFolderIndex(VIDEOS.group.blocks[i])
                            data.resources.videos[indexReal][1] = e.text
                            data.folders.videos[indexFolder][2][indexInFolder][1] = e.text
                            VIDEOS.group.blocks[i].text.text = e.text
                            SET_GAME_CODE(CURRENT_LINK, data)
                        end
                    end, VIDEOS.group.blocks[i].text.text)
                end
            end
        end
    end
end

return function(e)
    if VIDEOS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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
