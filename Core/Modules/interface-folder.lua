local FILTER = require 'Core.Modules.name-filter'
local M = {}

M.rename = function(target, group, type)
    local type = type == 'resources' and 'others' or type
    INPUT.new(STR['scripts.changename.folder'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            local data = GET_GAME_CODE(CURRENT_LINK)
            FILTER.check(event.target.text, function(ev)
                if ev.isError and ev.typeError == 'filter' then
                    local indexFolder, index = target.getFolderIndex(target) INPUT.remove(false)

                    if #data.folders[type] > 1 and indexFolder ~= 1 then
                        M.show(target, group, type, data, indexFolder, index)

                        for i = 1, #data.folders[type][indexFolder][2] do
                            table.insert(data.folders[type][indexFolder - 1][2], data.folders[type][indexFolder][2][i])
                        end

                        table.remove(data.folders[type], indexFolder)
                        SET_GAME_CODE(CURRENT_LINK, data) target.remove(index)

                        for j = index, #group.blocks do
                            local y = j == 1 and 25 or group.data[j - 1].y + 150
                            pcall(function() group.blocks[j].y = y end)
                            pcall(function() group.blocks[j].text.y = y end)
                            pcall(function() group.blocks[j].polygon.y = y end)
                            pcall(function() group.blocks[j].checkbox.y = y end)
                            pcall(function() group.blocks[j].container.y = y end)
                            pcall(function() group.data[j].y = y end)
                        end

                        group[8]:setScrollHeight(150 * #group.data)
                    end
                elseif ev.isError then
                    INPUT.remove(false)
                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']}, function() end, 5)
                else
                    INPUT.remove(true, ev.text)
                end
            end, group.blocks, data, type)
        end
    end, function(e)
        if e.input then
            local data = GET_GAME_CODE(CURRENT_LINK)
            local indexFolder = target.getFolderIndex(target)
            data.folders[type][indexFolder][1], target.text.text = e.text, e.text
            SET_GAME_CODE(CURRENT_LINK, data)
        end
    end, target.text.text)
end

M.hide = function(target, group, type, isShow, indexFolder, index, data)
    local type = type == 'resources' and 'others' or type

    if not isShow then
        local data = data or GET_GAME_CODE(CURRENT_LINK)
        if target then indexFolder, index = target.getFolderIndex(target) end
        data.folders[type][indexFolder][3] = true SET_GAME_CODE(CURRENT_LINK, data)
    end

    for i = index + 1, #group.blocks do
        if group.blocks[index + 1].indexFolder then
            break
        else
            group.blocks[index + 1].remove(index + 1)
        end
    end

    for j = index + 1, #group.blocks do
        local y = j == 1 and 25 or group.data[j - 1].y + 150
        pcall(function() group.blocks[j].y = y end)
        pcall(function() group.blocks[j].text.y = y end)
        pcall(function() group.blocks[j].polygon.y = y end)
        pcall(function() group.blocks[j].checkbox.y = y end)
        pcall(function() group.blocks[j].container.y = y end)
        pcall(function() group.data[j].y = y end)
    end

    if not isShow then
        group.blocks[index].polygon.yScale = 1.4
        group.blocks[index].polygon:setFillColor(0.4)
        group[8]:setScrollHeight(150 * #group.data)
    end
end

M.show = function(target, group, type, data, indexFolder, index)
    local type = type == 'resources' and 'others' or type
    local data = data or GET_GAME_CODE(CURRENT_LINK)
    if not indexFolder then indexFolder, index = target.getFolderIndex(target) end

    if group.blocks[index + 1] and not group.blocks[index + 1].indexFolder then
        M.hide(target, group, type, true, indexFolder, index)
    end

    data.folders[type][indexFolder][3] = false
    SET_GAME_CODE(CURRENT_LINK, data)

    for i = #data.folders[type][indexFolder][2], 1, -1 do
        local value = data.folders[type][indexFolder][2][i]

        if type == 'scripts' then
            local script = GET_GAME_SCRIPT(CURRENT_LINK, table.indexOf(data.scripts, value), data)
            SCRIPTS.new(script.title, index + 1, script.comment)
        elseif type == 'images' then
            IMAGES.new(value[1], index + 1, value[2], value[3])
        elseif type == 'sounds' then
            SOUNDS.new(value[1], index + 1, value[2])
        elseif type == 'videos' then
            VIDEOS.new(value[1], index + 1, value[2])
        elseif type == 'others' then
            RESOURCES.new(value[1], index + 1, value[2])
        elseif type == 'fonts' then
            FONTS.new(value[1], index + 1, value[2])
        end
    end

    group.blocks[index].polygon.yScale = -1.4
    group.blocks[index].polygon:setFillColor(1)
    group[8]:setScrollHeight(150 * #group.data)
end

return M
