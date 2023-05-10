local listeners = {}
local FOLDER = require 'Core.Modules.interface-folder'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'
local FILTER = require 'Core.Modules.name-filter'

listeners.but_title = function(target)
    EXITS.images()
end

listeners.but_add = function(target)
    IMAGES.group[8]:setIsLocked(true, 'vertical')
    if IMAGES.group.isVisible then
        local data = GET_GAME_CODE(CURRENT_LINK)
        INPUT.new(STR['images.entername' .. (NOOBMODE and '.noob' or '')], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                FILTER.check(event.target.text, function(ev)
                    if ev.isError then
                        INPUT.remove(false)
                        WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                    else
                        INPUT.remove(true, ev.text)
                    end
                end, IMAGES.group.blocks, data, 'images')
            end
        end, function(e)
            IMAGES.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                if not e.checkbox2 then
                    local numImage = 1
                    local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Images'

                    local completeImportPicture = function(import)
                        if import.done and import.done == 'ok' then
                            local path = path .. '/Image' .. numImage
                            local isGif = UTF8.sub(import.origFileName, UTF8.len(import.origFileName) - 3) == '.gif'

                            local function insertPicture()
                                local folderIsComment = data.folders.images[1][3]

                                if folderIsComment then
                                    FOLDER.show(IMAGES.group.blocks[1], IMAGES.group, 'images', data, 1, 1)
                                end

                                if IS_IMAGE(CURRENT_LINK .. '/Images/Image' .. numImage, e.checkbox and 'nearest' or 'linear') then
                                    table.insert(data.resources.images, 1, {
                                        e.text, e.checkbox and 'nearest' or 'linear', 'Image' .. numImage
                                    }) table.insert(data.folders.images[1][2], 1, data.resources.images[1]) SET_GAME_CODE(CURRENT_LINK, data)
                                    IMAGES.new(e.text, 2, e.checkbox and 'nearest' or 'linear', 'Image' .. numImage)
                                else
                                    table.insert(data.resources.images, 1, {e.text, 'vector', 'Image' .. numImage})
                                    table.insert(data.folders.images[1][2], 1, data.resources.images[1])
                                    SET_GAME_CODE(CURRENT_LINK, data) IMAGES.new(e.text, 2, 'vector', 'Image' .. numImage)
                                end

                                if folderIsComment then
                                    FOLDER.hide(nil, IMAGES.group, 'images', nil, 1, 1, data)
                                end
                            end

                            if isGif and not NOOBMODE then
                                WINDOW.new(STR['images.gif.convert'], {STR['button.close'], STR['images.gif.okay']}, function(e)
                                    if e.index == 2 then
                                        local width, height, count = GANIN.convert(
                                            DOC_DIR .. '/' .. CURRENT_LINK .. '/Images/Image' .. numImage,
                                            DOC_DIR .. '/' .. CURRENT_LINK .. '/Images/Image' .. numImage
                                        ) width, height, count = unpack(GET_SIZE(
                                            DOC_DIR .. '/' .. CURRENT_LINK .. '/Images/Image' .. numImage,
                                            system.DocumentsDirectory, width, height, count
                                        )) local info = STR['images.gif.complete'] .. '\n'
                                        local info = info .. STR['blocks.newSprite.params'][3] .. ' ' .. width .. '\n'
                                        local info = info .. STR['blocks.newSprite.params'][4] .. ' ' .. height .. '\n'
                                        local info = info .. STR['blocks.newSprite.params'][5] .. ' ' .. count

                                        timer.performWithDelay(1, function()
                                            WINDOW.new(info, {STR['button.close']}, function(e)
                                                insertPicture()
                                            end, 2)

                                            WINDOW.buttons[1].x = WINDOW.bg.x + WINDOW.bg.width / 4 - 5
                                            WINDOW.buttons[1].text.x = WINDOW.buttons[1].x
                                        end)
                                    else
                                        insertPicture()
                                    end
                                end, 4)
                            else
                                insertPicture()
                            end
                        end
                    end

                    while true do
                        local file = io.open(path .. '/Image' .. numImage, 'r')
                        if file then
                            numImage = numImage + 1
                            io.close(file)
                        else
                            GIVE_PERMISSION_DATA()
                            FILE.pickFile(path, completeImportPicture, 'Image' .. numImage, '', 'image/*', nil, nil, nil)
                            break
                        end
                    end
                else
                    table.insert(data.folders.images, {e.text, {}, false}) SET_GAME_CODE(CURRENT_LINK, data)
                    IMAGES.folder(e.text, #IMAGES.group.blocks + 1, #data.folders.images, false)
                end
            end
        end, nil, {STR['images.pixel' .. (NOOBMODE and '.noob' or '')], STR['scripts.folder']})
    else
        IMAGES.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = IMAGES
    IMAGES.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    local list = #IMAGES.group.blocks == 0 and {} or {STR['button.remove'], STR['button.rename']}

    IMAGES.group[8]:setIsLocked(true, 'vertical')
    if IMAGES.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            IMAGES.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index
                EXITS.add(listeners.but_okay_end)
                IMAGES.group[3].isVisible = true
                IMAGES.group[4].isVisible = false
                IMAGES.group[5].isVisible = false
                IMAGES.group[6].isVisible = false
                IMAGES.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                IMAGES.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #IMAGES.group.blocks do
                    pcall(function() IMAGES.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                IMAGES.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #IMAGES.group.blocks do
                    pcall(function() IMAGES.group.blocks[i].checkbox.isVisible = true end)
                end
            elseif e.text == STR['button.find'] then
                IMAGES.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['images.entername' .. (NOOBMODE and '.noob' or '')], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    IMAGES.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #IMAGES.group.data, 1, -1 do
                            IMAGES.group.blocks[i].remove(i)
                        end

                        timer.performWithDelay(10, function()
                            for index, image_config in pairs(data.resources.images) do
                                if UTF8.find(UTF8.lower(image_config[1]), UTF8.lower(e.text)) then
                                    IMAGES.new(image_config[1], #IMAGES.group.blocks + 1, image_config[2], image_config[3])
                                end
                            end
                        end)
                    end
                end)
            end
        end, nil, nil, 1)
    else
        IMAGES.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay_end = function()
    ALERT = true
    IMAGES.group[3].text = ''
    IMAGES.group[3].isVisible = false
    IMAGES.group[4].isVisible = true
    IMAGES.group[5].isVisible = true
    IMAGES.group[6].isVisible = true
    IMAGES.group[7].isVisible = false

    for i = 1, #IMAGES.group.blocks do
        pcall(function()
            IMAGES.group.blocks[i].checkbox.isVisible = false
            IMAGES.group.blocks[i].checkbox:setState({isOn = false})
        end)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    EXITS.remove()
    IMAGES.group[3].text = ''
    IMAGES.group[3].isVisible = false
    IMAGES.group[4].isVisible = true
    IMAGES.group[5].isVisible = true
    IMAGES.group[6].isVisible = true
    IMAGES.group[7].isVisible = false

    if INDEX_LIST == 1 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #IMAGES.group.data, 1, -1 do
            if not IMAGES.group.blocks[i].indexFolder then
                IMAGES.group.blocks[i].checkbox.isVisible = false

                if IMAGES.group.blocks[i].checkbox.isOn then
                    local indexReal, indexInFolder = IMAGES.group.blocks[i].getRealIndex(IMAGES.group.blocks[i], data, 'images')
                    local indexFolder = IMAGES.group.blocks[i].getFolderIndex(IMAGES.group.blocks[i])

                    table.remove(data.resources.images, indexReal)
                    table.remove(data.folders.images[indexFolder][2], indexInFolder)

                    OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Images/' .. IMAGES.group.blocks[i].link)
                    IMAGES.group.blocks[i].remove(i)
                end
            end
        end

        for j = 1, #IMAGES.group.blocks do
            local y = j == 1 and 25 or IMAGES.group.data[j - 1].y + 150
            pcall(function() IMAGES.group.blocks[j].y = y end)
            pcall(function() IMAGES.group.blocks[j].text.y = y end)
            pcall(function() IMAGES.group.blocks[j].polygon.y = y end)
            pcall(function() IMAGES.group.blocks[j].checkbox.y = y end)
            pcall(function() IMAGES.group.blocks[j].container.y = y end)
            pcall(function() IMAGES.group.data[j].y = y end)
        end

        SET_GAME_CODE(CURRENT_LINK, data)
        IMAGES.group[8]:setScrollHeight(150 * #IMAGES.group.data)
    elseif INDEX_LIST == 2 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #IMAGES.group.blocks, 1, -1 do
            if not IMAGES.group.blocks[i].indexFolder then
                IMAGES.group.blocks[i].checkbox.isVisible = false

                if IMAGES.group.blocks[i].checkbox.isOn then
                    IMAGES.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['images.changename' .. (NOOBMODE and '.noob' or '')], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, IMAGES.group.blocks, data, 'images')
                        end
                    end, function(e)
                        if e.input then
                            local indexReal, indexInFolder = IMAGES.group.blocks[i].getRealIndex(IMAGES.group.blocks[i], data, 'images')
                            local indexFolder = IMAGES.group.blocks[i].getFolderIndex(IMAGES.group.blocks[i])
                            data.resources.images[indexReal][1] = e.text
                            data.folders.images[indexFolder][2][indexInFolder][1] = e.text
                            IMAGES.group.blocks[i].text.text = e.text
                            SET_GAME_CODE(CURRENT_LINK, data)
                        end
                    end, IMAGES.group.blocks[i].text.text)
                end
            end
        end
    end
end

return function(e)
    if IMAGES.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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
