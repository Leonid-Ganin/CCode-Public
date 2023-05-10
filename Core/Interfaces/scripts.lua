local listeners = {}
local FOLDER = require 'Core.Modules.interface-folder'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'
local FILTER = require 'Core.Modules.name-filter'

listeners.but_title = function(target)
    EXITS.scripts()
end

listeners.but_add = function(target)
    SCRIPTS.group[8]:setIsLocked(true, 'vertical')
    if SCRIPTS.group.isVisible then
        local data = GET_GAME_CODE(CURRENT_LINK)
        INPUT.new(STR['scripts.entername' .. (NOOBMODE and '.noob' or '')], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                FILTER.check(event.target.text, function(ev)
                    if ev.isError then
                        INPUT.remove(false)
                        WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                    else
                        INPUT.remove(true, ev.text)
                    end
                end, SCRIPTS.group.blocks, data, 'scripts')
            end
        end, function(e)
            SCRIPTS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                local scrollY = select(2, SCRIPTS.group[8]:getContentPosition())
                local diffY = SCRIPTS.group[8].y - SCRIPTS.group[8].height / 2
                local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150
                local j, i = #data.scripts + 1, #SCRIPTS.group.blocks + 1
                local folderIsComment, indexFolder, kFolder

                if not e.checkbox then
                    for i = 1, #SCRIPTS.group.data do
                        if SCRIPTS.group.data[i].y > targetY then
                            local j = SCRIPTS.group.blocks[i].getRealIndex(SCRIPTS.group.blocks[i], data, 'scripts')
                            table.insert(data.scripts, j, GET_INDEX_SCRIPT(CURRENT_LINK))

                            local indexInFolder = 1
                            for k = i - 1, 1, -1 do
                                if SCRIPTS.group.blocks[k].indexFolder then
                                    indexFolder = SCRIPTS.group.blocks[k].getFolderIndex(SCRIPTS.group.blocks[k])
                                    folderIsComment, kFolder = data.folders.scripts[indexFolder][3], k
                                    indexInFolder = folderIsComment and indexInFolder + #data.folders.scripts[indexFolder][2] or indexInFolder

                                    if folderIsComment then
                                        FOLDER.show(SCRIPTS.group.blocks[k], SCRIPTS.group, 'scripts', data, indexFolder, kFolder)
                                    end

                                    table.insert(data.folders.scripts[indexFolder][2], indexInFolder, data.scripts[j]) break
                                else
                                    indexInFolder = indexInFolder + 1
                                end
                            end

                            SET_GAME_SCRIPT(CURRENT_LINK, {
                                title = e.text, params = {}, vars = {}, tables = {}, funs = {}, comment = false
                            }, j, data) SET_GAME_CODE(CURRENT_LINK, data) SCRIPTS.new(e.text, i, false)

                            if folderIsComment then
                                FOLDER.hide(nil, SCRIPTS.group, 'scripts', nil, indexFolder, kFolder, data)
                            end return
                        end
                    end
                end

                if e.checkbox then
                    table.insert(data.folders.scripts, {e.text, {}, false})
                    SET_GAME_CODE(CURRENT_LINK, data) SCRIPTS.folder(e.text, i, #data.folders.scripts, false)
                else
                    table.insert(data.scripts, j, GET_INDEX_SCRIPT(CURRENT_LINK))

                    local indexInFolder = 1
                    for k = i - 1, 1, -1 do
                        if SCRIPTS.group.blocks[k].indexFolder then
                            indexFolder = SCRIPTS.group.blocks[k].getFolderIndex(SCRIPTS.group.blocks[k])
                            folderIsComment, kFolder = data.folders.scripts[indexFolder][3], k
                            indexInFolder = folderIsComment and indexInFolder + #data.folders.scripts[indexFolder][2] or indexInFolder

                            if folderIsComment then
                                FOLDER.show(SCRIPTS.group.blocks[k], SCRIPTS.group, 'scripts', data, indexFolder, kFolder)
                            end

                            table.insert(data.folders.scripts[indexFolder][2], indexInFolder, data.scripts[j]) break
                        else
                            indexInFolder = indexInFolder + 1
                        end
                    end

                    SET_GAME_SCRIPT(CURRENT_LINK, {
                        title = e.text, params = {}, vars = {}, tables = {}, funs = {}, comment = false
                    }, j, data) SET_GAME_CODE(CURRENT_LINK, data) SCRIPTS.new(e.text, i, false)

                    if folderIsComment then
                        FOLDER.hide(nil, SCRIPTS.group, 'scripts', nil, indexFolder, kFolder, data)
                    end
                end
            end
        end, nil, STR['scripts.folder'])
    else
        SCRIPTS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
    GAME_GROUP_OPEN = SCRIPTS
    SCRIPTS.group.isVisible = false
    GAME = require 'Core.Simulation.start'
    GAME.new()
end

listeners.but_list = function(target)
    if #SCRIPTS.group.blocks > 0 then
        SCRIPTS.group[8]:setIsLocked(true, 'vertical')
        if SCRIPTS.group.isVisible then
            LIST.new({STR['button.remove'], STR['button.rename'], STR['button.copy'], STR['button.from.buffer'], STR['button.comment']},
                MAX_X, target.y - target.height / 2, 'down', function(e)
                    SCRIPTS.group[8]:setIsLocked(false, 'vertical')

                    if e.index == 5 then e.index = 6 end
                    if e.index ~= 0 and e.index ~= 4 then
                        ALERT = false
                        INDEX_LIST = e.index
                        EXITS.add(listeners.but_okay_end)
                        SCRIPTS.group[3].isVisible = true
                        SCRIPTS.group[4].isVisible = false
                        SCRIPTS.group[5].isVisible = false
                        SCRIPTS.group[6].isVisible = false
                        SCRIPTS.group[7].isVisible = true
                    end

                    if e.index == 6 then
                        MORE_LIST = true
                        SCRIPTS.group[3].text = '(' .. STR['button.comment'] .. ')'

                        for i = 1, #SCRIPTS.group.blocks do
                            pcall(function() SCRIPTS.group.blocks[i].checkbox.isVisible = true end)
                        end
                    elseif e.index == 1 then
                        MORE_LIST = true
                        SCRIPTS.group[3].text = '(' .. STR['button.remove'] .. ')'

                        for i = 1, #SCRIPTS.group.blocks do
                            pcall(function() SCRIPTS.group.blocks[i].checkbox.isVisible = true end)
                        end
                    elseif e.index == 2 then
                        MORE_LIST = false
                        SCRIPTS.group[3].text = '(' .. STR['button.rename'] .. ')'

                        for i = 1, #SCRIPTS.group.blocks do
                            pcall(function() SCRIPTS.group.blocks[i].checkbox.isVisible = true end)
                        end
                    elseif e.index == 3 then
                        MORE_LIST = false
                        SCRIPTS.group[3].text = '(' .. STR['button.copy'] .. ')'

                        for i = 1, #SCRIPTS.group.blocks do
                            pcall(function() SCRIPTS.group.blocks[i].checkbox.isVisible = true end)
                        end
                    elseif e.index == 5 then
                        SCRIPTS.group[8]:setIsLocked(true, 'vertical')
                        INPUT.new(STR['scripts.entername' .. (NOOBMODE and '.noob' or '')], function(event)
                            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                                INPUT.remove(true, event.target.text)
                            end
                        end, function(e)
                            SCRIPTS.group[8]:setIsLocked(false, 'vertical')

                            if e.input then
                                local data = GET_GAME_CODE(CURRENT_LINK)

                                for i = #SCRIPTS.group.data, 1, -1 do
                                    SCRIPTS.group.blocks[i].remove(i)
                                end

                                timer.performWithDelay(10, function()
                                    for index, _ in ipairs(data.scripts) do
                                        local script_config = GET_GAME_SCRIPT(CURRENT_LINK, index, data)
                                        if UTF8.find(UTF8.lower(script_config.title), UTF8.lower(e.text)) then
                                            SCRIPTS.new(script_config.title, #SCRIPTS.group.blocks + 1, script_config.comment)
                                        end
                                    end
                                end)
                            end
                        end)
                    elseif e.index == 4 and type(BUFFER) == 'table' and type(BUFFER.params) == 'table' and #BUFFER.params > 0 then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        FILTER.check(BUFFER.title, function(ev)
                            if ev.isError then
                                WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                            else
                                local data = GET_GAME_CODE(CURRENT_LINK)
                                local scrollY = select(2, SCRIPTS.group[8]:getContentPosition())
                                local diffY = SCRIPTS.group[8].y - SCRIPTS.group[8].height / 2
                                local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150
                                local j, i = #data.scripts + 1, #SCRIPTS.group.blocks + 1
                                local folderIsComment, indexFolder, kFolder

                                for i = 1, #SCRIPTS.group.data do
                                    if SCRIPTS.group.data[i].y > targetY then
                                        local j = SCRIPTS.group.blocks[i].getRealIndex(SCRIPTS.group.blocks[i], data, 'scripts')
                                        table.insert(data.scripts, j, GET_INDEX_SCRIPT(CURRENT_LINK))

                                        local indexInFolder = 1
                                        for k = i - 1, 1, -1 do
                                            if SCRIPTS.group.blocks[k].indexFolder then
                                                indexFolder = SCRIPTS.group.blocks[k].getFolderIndex(SCRIPTS.group.blocks[k])
                                                folderIsComment, kFolder = data.folders.scripts[indexFolder][3], k indexInFolder =
                                                folderIsComment and indexInFolder + #data.folders.scripts[indexFolder][2] or indexInFolder

                                                if folderIsComment then
                                                    FOLDER.show(SCRIPTS.group.blocks[k], SCRIPTS.group, 'scripts', data, indexFolder, kFolder)
                                                end

                                                table.insert(data.folders.scripts[indexFolder][2], indexInFolder, data.scripts[j]) break
                                            else
                                                indexInFolder = indexInFolder + 1
                                            end
                                        end

                                        SET_GAME_SCRIPT(CURRENT_LINK, COPY_TABLE(BUFFER), j, data) SET_GAME_CODE(CURRENT_LINK, data)
                                        SCRIPTS.new(BUFFER.title, i, BUFFER.comment) BUFFER = {}

                                        if folderIsComment then
                                            FOLDER.hide(nil, SCRIPTS.group, 'scripts', nil, indexFolder, kFolder, data)
                                        end return
                                    end
                                end

                                table.insert(data.scripts, j, GET_INDEX_SCRIPT(CURRENT_LINK))

                                local indexInFolder = 1
                                for k = i - 1, 1, -1 do
                                    if SCRIPTS.group.blocks[k].indexFolder then
                                        indexFolder = SCRIPTS.group.blocks[k].getFolderIndex(SCRIPTS.group.blocks[k])
                                        folderIsComment, kFolder = data.folders.scripts[indexFolder][3], k indexInFolder =
                                        folderIsComment and indexInFolder + #data.folders.scripts[indexFolder][2] or indexInFolder

                                        if folderIsComment then
                                            FOLDER.show(SCRIPTS.group.blocks[k], SCRIPTS.group, 'scripts', data, indexFolder, kFolder)
                                        end

                                        table.insert(data.folders.scripts[indexFolder][2], indexInFolder, data.scripts[j]) break
                                    else
                                        indexInFolder = indexInFolder + 1
                                    end
                                end

                                SET_GAME_SCRIPT(CURRENT_LINK, COPY_TABLE(BUFFER), j, data) SET_GAME_CODE(CURRENT_LINK, data)
                                SCRIPTS.new(BUFFER.title, i, BUFFER.comment) BUFFER = {}

                                if folderIsComment then
                                    FOLDER.hide(nil, SCRIPTS.group, 'scripts', nil, indexFolder, kFolder, data)
                                end
                            end
                        end, SCRIPTS.group.blocks, data, 'scripts')
                    end
            end, nil, nil, 1)
        else
            SCRIPTS.group[8]:setIsLocked(false, 'vertical')
        end
    end
end

listeners.but_okay_end = function()
    ALERT = true
    SCRIPTS.group[3].text = ''
    SCRIPTS.group[3].isVisible = false
    SCRIPTS.group[4].isVisible = true
    SCRIPTS.group[5].isVisible = true
    SCRIPTS.group[6].isVisible = true
    SCRIPTS.group[7].isVisible = false

    for i = 1, #SCRIPTS.group.blocks do
        pcall(function()
            SCRIPTS.group.blocks[i].checkbox.isVisible = false
            SCRIPTS.group.blocks[i].checkbox:setState({isOn = false})
        end)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    EXITS.remove()
    SCRIPTS.group[3].text = ''
    SCRIPTS.group[3].isVisible = false
    SCRIPTS.group[4].isVisible = true
    SCRIPTS.group[5].isVisible = true
    SCRIPTS.group[6].isVisible = true
    SCRIPTS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #SCRIPTS.group.data, 1, -1 do
            if not SCRIPTS.group.blocks[i].indexFolder then
                SCRIPTS.group.blocks[i].checkbox.isVisible = false

                if SCRIPTS.group.blocks[i].checkbox.isOn then
                    local data = GET_GAME_CODE(CURRENT_LINK)
                    local indexReal, indexInFolder = SCRIPTS.group.blocks[i].getRealIndex(SCRIPTS.group.blocks[i], data, 'scripts')
                    local indexFolder = SCRIPTS.group.blocks[i].getFolderIndex(SCRIPTS.group.blocks[i])
                    DEL_GAME_SCRIPT(CURRENT_LINK, indexReal, data)
                    table.remove(data.scripts, indexReal)
                    table.remove(data.folders.scripts[indexFolder][2], indexInFolder)
                    SET_GAME_CODE(CURRENT_LINK, data)
                    SCRIPTS.group.blocks[i].remove(i)
                end
            end
        end

        for j = 1, #SCRIPTS.group.blocks do
            local y = j == 1 and 25 or SCRIPTS.group.data[j - 1].y + 150
            pcall(function() SCRIPTS.group.blocks[j].y = y end)
            pcall(function() SCRIPTS.group.blocks[j].text.y = y end)
            pcall(function() SCRIPTS.group.blocks[j].polygon.y = y end)
            pcall(function() SCRIPTS.group.blocks[j].checkbox.y = y end)
            pcall(function() SCRIPTS.group.blocks[j].container.y = y end)
            pcall(function() SCRIPTS.group.data[j].y = y end)
        end

        SCRIPTS.group[8]:setScrollHeight(150 * #SCRIPTS.group.data)
    elseif INDEX_LIST == 2 then
        for i = #SCRIPTS.group.blocks, 1, -1 do
            if not SCRIPTS.group.blocks[i].indexFolder then
                SCRIPTS.group.blocks[i].checkbox.isVisible = false

                if SCRIPTS.group.blocks[i].checkbox.isOn then
                    SCRIPTS.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['scripts.changename' .. (NOOBMODE and '.noob' or '')], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            local data = GET_GAME_CODE(CURRENT_LINK)
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, SCRIPTS.group.blocks, data, 'scripts')
                        end
                    end, function(e)
                        if e.input then
                            local indexReal = SCRIPTS.group.blocks[i].getRealIndex(SCRIPTS.group.blocks[i], data, 'scripts')
                            local script = GET_GAME_SCRIPT(CURRENT_LINK, indexReal, data)
                            script.title, SCRIPTS.group.blocks[i].text.text = e.text, e.text
                            SET_GAME_SCRIPT(CURRENT_LINK, script, indexReal, data)
                        end
                    end, SCRIPTS.group.blocks[i].text.text)
                end
            end
        end
    elseif INDEX_LIST == 3 then
        for i = #SCRIPTS.group.blocks, 1, -1 do
            if not SCRIPTS.group.blocks[i].indexFolder then
                SCRIPTS.group.blocks[i].checkbox.isVisible = false

                if SCRIPTS.group.blocks[i].checkbox.isOn then
                    SCRIPTS.group.blocks[i].checkbox:setState({isOn = false})
                    INPUT.new(STR['scripts.entername' .. (NOOBMODE and '.noob' or '')], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            local data = GET_GAME_CODE(CURRENT_LINK)
                            FILTER.check(event.target.text, function(ev)
                                if ev.isError then
                                    INPUT.remove(false)
                                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                                else
                                    INPUT.remove(true, ev.text)
                                end
                            end, SCRIPTS.group.blocks, data, 'scripts')
                        end
                    end, function(e)
                        if e.input then
                            local data = GET_GAME_CODE(CURRENT_LINK)
                            local indexReal = SCRIPTS.group.blocks[i].getRealIndex(SCRIPTS.group.blocks[i], data, 'scripts')
                            local script = GET_GAME_SCRIPT(CURRENT_LINK, indexReal, data)
                            local scrollY = select(2, SCRIPTS.group[8]:getContentPosition())
                            local diffY = SCRIPTS.group[8].y - SCRIPTS.group[8].height / 2
                            local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150
                            local folderIsComment, indexFolder, kFolder

                            for u = 1, #SCRIPTS.group.data do
                                if SCRIPTS.group.data[u].y > targetY then
                                    local j = SCRIPTS.group.blocks[u].getRealIndex(SCRIPTS.group.blocks[u], data, 'scripts')
                                    table.insert(data.scripts, j, GET_INDEX_SCRIPT(CURRENT_LINK))

                                    local indexInFolder = 1
                                    for k = u - 1, 1, -1 do
                                        if SCRIPTS.group.blocks[k].indexFolder then
                                            indexFolder = SCRIPTS.group.blocks[k].getFolderIndex(SCRIPTS.group.blocks[k])
                                            folderIsComment, kFolder = data.folders.scripts[indexFolder][3], k indexInFolder =
                                            folderIsComment and indexInFolder + #data.folders.scripts[indexFolder][2] or indexInFolder

                                            if folderIsComment then
                                                FOLDER.show(SCRIPTS.group.blocks[k], SCRIPTS.group, 'scripts', data, indexFolder, kFolder)
                                            end

                                            table.insert(data.folders.scripts[indexFolder][2], indexInFolder, data.scripts[j]) break
                                        else
                                            indexInFolder = indexInFolder + 1
                                        end
                                    end

                                    SET_GAME_SCRIPT(CURRENT_LINK, {
                                        title = e.text, params = script.params,
                                        vars = script.vars, tables = script.tables, funs = script.funs, comment = script.comment
                                    }, j, data) SET_GAME_CODE(CURRENT_LINK, data) SCRIPTS.new(e.text, u, script.comment)

                                    if folderIsComment then
                                        FOLDER.hide(nil, SCRIPTS.group, 'scripts', nil, indexFolder, kFolder, data)
                                    end return
                                end
                            end

                            local j, i = #data.scripts + 1, #SCRIPTS.group.blocks + 1
                            table.insert(data.scripts, j, GET_INDEX_SCRIPT(CURRENT_LINK))

                            local indexInFolder = 1
                            for k = i - 1, 1, -1 do
                                if SCRIPTS.group.blocks[k].indexFolder then
                                    indexFolder = SCRIPTS.group.blocks[k].getFolderIndex(SCRIPTS.group.blocks[k])
                                    folderIsComment, kFolder = data.folders.scripts[indexFolder][3], k indexInFolder =
                                    folderIsComment and indexInFolder + #data.folders.scripts[indexFolder][2] or indexInFolder

                                    if folderIsComment then
                                        FOLDER.show(SCRIPTS.group.blocks[k], SCRIPTS.group, 'scripts', data, indexFolder, kFolder)
                                    end

                                    table.insert(data.folders.scripts[indexFolder][2], indexInFolder, data.scripts[j]) break
                                else
                                    indexInFolder = indexInFolder + 1
                                end
                            end

                            SET_GAME_SCRIPT(CURRENT_LINK, {
                                title = e.text, params = script.params,
                                vars = script.vars, tables = script.tables, funs = script.funs, comment = script.comment
                            }, j, data) SET_GAME_CODE(CURRENT_LINK, data) SCRIPTS.new(e.text, i, script.comment)

                            if folderIsComment then
                                FOLDER.hide(nil, SCRIPTS.group, 'scripts', nil, indexFolder, kFolder, data)
                            end
                        end
                    end, SCRIPTS.group.blocks[i].text.text)
                end
            end
        end
    elseif INDEX_LIST == 6 then
        local data = GET_GAME_CODE(CURRENT_LINK)

        for i = #SCRIPTS.group.data, 1, -1 do
            if not SCRIPTS.group.blocks[i].indexFolder then
                SCRIPTS.group.blocks[i].checkbox.isVisible = false

                if SCRIPTS.group.blocks[i].checkbox.isOn then
                    SCRIPTS.group.blocks[i].checkbox:setState({isOn = false})
                    SCRIPTS.group.blocks[i].icon:removeSelf()

                    if SCRIPTS.group.blocks[i].turn then
                        SCRIPTS.group.blocks[i].turn = false
                        SCRIPTS.group.blocks[i].icon = display.newImage('Sprites/iconComment.png')
                    else
                        SCRIPTS.group.blocks[i].turn = true
                        SCRIPTS.group.blocks[i].icon = display.newImage('Sprites/iconScript.png')
                    end

                    local indexReal = SCRIPTS.group.blocks[i].getRealIndex(SCRIPTS.group.blocks[i], data, 'scripts')
                    local script = GET_GAME_SCRIPT(CURRENT_LINK, indexReal, data)
                    script.comment = not SCRIPTS.group.blocks[i].turn
                    SET_GAME_SCRIPT(CURRENT_LINK, script, indexReal, data)

                    SCRIPTS.group.blocks[i].container:insert(SCRIPTS.group.blocks[i].icon, true)
                end
            end
        end
    end
end

return function(e)
    if SCRIPTS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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
