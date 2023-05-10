local FOLDER = require 'Core.Modules.interface-folder'
local M = {}

M.new = function(e, scroll, group, type)
    pcall(function()
        if #group.blocks > 1 and not e.target.indexFolder then
            ALERT = false
            scroll:setIsLocked(true, 'vertical')
            M.index = e.target.getIndex(e.target)
            M.data = GET_GAME_CODE(CURRENT_LINK)
            M.indexReal, M.indexInFolder = e.target.getRealIndex(e.target, M.data, type)
            M.indexFolder = e.target.getFolderIndex(e.target)
            M.diffY = scroll.y - scroll.height / 2

            e.target.alpha = 1
            e.target.x = e.target.x + 40
            pcall(function() e.target.text.x = e.target.text.x + 40 end)
            pcall(function() e.target.polygon.x = e.target.polygon.x + 40 end)
            pcall(function() e.target.container.x = e.target.container.x + 40 end)
            pcall(function() e.target.checkbox.x = e.target.checkbox.x + 40 end)
        end
    end)
end

M.upd = function(e, scroll, group, type)
    if #group.blocks > 1 and not e.target.indexFolder then
        local scrollY = select(2, scroll:getContentPosition())

        e.target.y = e.y - scrollY - M.diffY
        e.target.text.y = e.y - scrollY - M.diffY
        e.target.container.y = e.y - scrollY - M.diffY
        e.target.checkbox.y = e.y - scrollY - M.diffY

        e.target:toFront()
        e.target.text:toFront()
        e.target.container:toFront()
        e.target.checkbox:toFront()

        if e.y > group[4].y - 150 and (math.abs(scrollY) < 150 * (#group.data) - scroll.height + 50 or scrollY > 0) then
            scroll:scrollToPosition({y = scrollY - 15, time = 0})
        elseif e.y < group[3].y + 150 and scrollY < 0 then
            scroll:scrollToPosition({y = scrollY + 15, time = 0})
        end

        if e.target.y - group.data[M.index].y > 150 then
            if group.data[M.index + 1] then
                local diffY = math.round((e.target.y - group.data[M.index].y) / 150)
                local x, y, text = group.data[M.index].x, group.data[M.index].y, group.data[M.index].text
                local script = M.data.scripts[M.indexReal]
                local resource = M.data.resources.others[M.indexReal]
                local image = M.data.resources.images[M.indexReal]
                local sound = M.data.resources.sounds[M.indexReal]
                local video = M.data.resources.videos[M.indexReal]
                local font = M.data.resources.fonts[M.indexReal]

                if not diffY then
                    diffY = math.round((e.target.y - group.data[M.index].y) / 150)
                end

                if M.index + diffY > #group.data then
                    diffY = #group.data - M.index
                end

                for i = 1, diffY do
                    pcall(function() group.blocks[M.index + i].y = group.blocks[M.index + i].y - 150 end)
                    pcall(function() group.blocks[M.index + i].text.y = group.blocks[M.index + i].text.y - 150 end)
                    pcall(function() group.blocks[M.index + i].polygon.y = group.blocks[M.index + i].polygon.y - 150 end)
                    pcall(function() group.blocks[M.index + i].container.y = group.blocks[M.index + i].container.y - 150 end)
                    pcall(function() group.blocks[M.index + i].checkbox.y = group.blocks[M.index + i].checkbox.y - 150 end)
                    pcall(function() group.data[M.index + i].y = group.blocks[M.index + i].y end)
                end

                local r_type = type == 'resources' and 'others' or type
                local value = type == 'resources' and resource or type == 'images' and image
                or type == 'sounds' and sound or type == 'videos' and video or font

                if type == 'scripts' then
                    table.remove(M.data.scripts, M.indexReal)
                    table.remove(M.data.folders.scripts[M.indexFolder][2], M.indexInFolder)
                else
                    table.remove(M.data.resources[r_type], M.indexReal)
                    table.remove(M.data.folders[r_type][M.indexFolder][2], M.indexInFolder)
                end

                table.remove(group.data, M.index)
                table.insert(group.blocks, M.index + diffY + 1, e.target)
                table.remove(group.blocks, M.index)

                M.index = M.index + diffY
                M.indexReal, M.indexInFolder = e.target.getRealIndex(e.target, M.data, type)
                M.indexFolder = e.target.getFolderIndex(e.target)

                if type == 'scripts' then
                    table.insert(M.data.scripts, M.indexReal, script)
                    table.insert(M.data.folders.scripts[M.indexFolder][2], M.indexInFolder, script)
                else
                    table.insert(M.data.resources[r_type], M.indexReal, value)
                    table.insert(M.data.folders[r_type][M.indexFolder][2], M.indexInFolder, value)
                end

                table.insert(group.data, M.index, {x = x, y = group.data[M.index - 1].y + 150, text = text})
            end
        elseif group.data[M.index].y - e.target.y > 150 then
            if group.data[M.index - 1] then
                local diffY = math.round((group.data[M.index].y - e.target.y) / 150)
                local x, y, text = group.data[M.index].x, group.data[M.index].y, group.data[M.index].text
                local script = M.data.scripts[M.indexReal]
                local resource = M.data.resources.others[M.indexReal]
                local image = M.data.resources.images[M.indexReal]
                local sound = M.data.resources.sounds[M.indexReal]
                local video = M.data.resources.videos[M.indexReal]
                local font = M.data.resources.fonts[M.indexReal]

                if not diffY then
                    diffY = math.round((group.data[M.index].y - e.target.y) / 150)
                end

                if M.index - diffY < 1 then
                    diffY = M.index - 1
                end

                if M.index - diffY > 1 then
                    for i = 1, diffY do
                        pcall(function() group.blocks[M.index - i].y = group.blocks[M.index - i].y + 150 end)
                        pcall(function() group.blocks[M.index - i].text.y = group.blocks[M.index - i].text.y + 150 end)
                        pcall(function() group.blocks[M.index - i].polygon.y = group.blocks[M.index - i].polygon.y + 150 end)
                        pcall(function() group.blocks[M.index - i].container.y = group.blocks[M.index - i].container.y + 150 end)
                        pcall(function() group.blocks[M.index - i].checkbox.y = group.blocks[M.index - i].checkbox.y + 150 end)
                        pcall(function() group.data[M.index - i].y = group.blocks[M.index - i].y end)
                    end

                    local r_type = type == 'resources' and 'others' or type
                    local value = type == 'resources' and resource or type == 'images' and image
                    or type == 'sounds' and sound or type == 'videos' and video or font

                    if type == 'scripts' then
                        table.remove(M.data.scripts, M.indexReal)
                        table.remove(M.data.folders.scripts[M.indexFolder][2], M.indexInFolder)
                    else
                        table.remove(M.data.resources[r_type], M.indexReal)
                        table.remove(M.data.folders[r_type][M.indexFolder][2], M.indexInFolder)
                    end

                    table.remove(group.data, M.index)
                    table.insert(group.blocks, M.index - diffY, e.target)
                    table.remove(group.blocks, M.index + 1)

                    M.index = M.index - diffY
                    M.indexReal, M.indexInFolder = e.target.getRealIndex(e.target, M.data, type)
                    M.indexFolder = e.target.getFolderIndex(e.target)

                    if type == 'scripts' then
                        table.insert(M.data.scripts, M.indexReal, script)
                        table.insert(M.data.folders.scripts[M.indexFolder][2], M.indexInFolder, script)
                    else
                        table.insert(M.data.resources[r_type], M.indexReal, value)
                        table.insert(M.data.folders[r_type][M.indexFolder][2], M.indexInFolder, value)
                    end

                    table.insert(group.data, M.index, {x = x, y = group.data[M.index - 1].y + 150, text = text})
                end
            end
        end
    end
end

M.stop = function(e, scroll, group, type)
    if #group.blocks > 1 and not e.target.indexFolder then
        ALERT = true
        scroll:setIsLocked(false, 'vertical')
        SET_GAME_CODE(CURRENT_LINK, M.data)

        e.target.alpha = 0.9
        e.target.x = e.target.x - 40
        pcall(function() e.target.text.x = e.target.text.x - 40 end)
        pcall(function() e.target.polygon.x = e.target.polygon.x - 40 end)
        pcall(function() e.target.container.x = e.target.container.x - 40 end)
        pcall(function() e.target.checkbox.x = e.target.checkbox.x - 40 end)

        e.target.y = group.data[M.index].y
        pcall(function() e.target.text.y = group.data[M.index].y end)
        pcall(function() e.target.polygon.y = group.data[M.index].y end)
        pcall(function() e.target.container.y = group.data[M.index].y end)
        pcall(function() e.target.checkbox.y = group.data[M.index].y end)

        local r_type = type == 'resources' and 'others' or type
        if M.data.folders[r_type][M.indexFolder][3] then
            indexFolder, _, index = e.target.getFolderIndex(e.target)
            FOLDER.hide(nil, group, type, nil, indexFolder, index)
        end
    end
end

return M
