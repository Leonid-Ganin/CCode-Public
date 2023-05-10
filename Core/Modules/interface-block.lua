local FOLDER = require 'Core.Modules.interface-folder'
local MOVE = require 'Core.Modules.interface-move'
local M = {}

local listener = function(e, scroll, group, type)
    if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target.click, e.target.move = true, false
        e.target.alpha = e.target.indexFolder and e.target.alpha or 0.6
        e.target.text.alpha = e.target.indexFolder and 0.7 or e.target.text.alpha

        if type ~= 'program' and type ~= 'programs' and ALERT then
            e.target.timer = timer.performWithDelay(300, function()
                e.target.alpha = e.target.indexFolder and e.target.alpha or 0.9
                e.target.text.alpha = e.target.indexFolder and 1 or e.target.text.alpha
                e.target.move = true if e.target.indexFolder then FOLDER.rename(e.target, group, type)
                else MOVE.new(e, scroll, group, type) end
            end)
        elseif type == 'programs' and not ALERT then
            e.target.alpha = 0.9
        end
    elseif e.phase == 'moved' then
        if math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30 then
            if not e.target.move then
                scroll:takeFocus(e)
                e.target.alpha = e.target.indexFolder and e.target.alpha or 0.9
                e.target.text.alpha = e.target.indexFolder and 1 or e.target.text.alpha
                e.target.click = false

                if e.target.timer then
                    if not e.target.timer._removed then
                        timer.cancel(e.target.timer)
                    end
                end
            end
        end

        if e.target.move then
            MOVE.upd(e, scroll, group, type)
        end
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        if e.target.click then
            e.target.click = false
            e.target.alpha = e.target.indexFolder and e.target.alpha or 0.9
            e.target.text.alpha = e.target.indexFolder and 1 or e.target.text.alpha

            if e.target.indexFolder then
                if e.target.move then
                    e.target.move = false
                elseif ALERT then
                    if e.target.commentFolder then
                        e.target.commentFolder = false
                        FOLDER.show(e.target, group, type)
                    else
                        e.target.commentFolder = true
                        FOLDER.hide(e.target, group, type)
                    end
                end

                if e.target.timer then
                    if not e.target.timer._removed then
                        timer.cancel(e.target.timer)
                    end
                end
            elseif not e.target.checkbox.isVisible then
                if type == 'programs' and ALERT then
                    local data = GET_GAME_CODE(e.target.link)

                    if tonumber(data.build) > 1170 then
                        data = _supportOldestVersion(data, e.target.link)

                        local index = table.indexOf(LOCAL.apps, e.target.link)
                        local app = LOCAL.apps[index]

                        table.remove(LOCAL.apps, index)
                        table.insert(LOCAL.apps, app)

                        PROGRAMS.group:removeSelf()
                        PROGRAMS.group = nil
                        PROGRAMS.create()

                        PROGRAMS.isVisible = false
                        PROGRAM = require 'Interfaces.program'
                        PROGRAM.create(e.target.text.text, data.noobmode)
                        PROGRAM.group.isVisible = true

                        CURRENT_LINK = e.target.link
                        LOCAL.last = e.target.text.text
                        LOCAL.last_link = CURRENT_LINK
                        MENU.group[9].text = LOCAL.last
                        NEW_DATA()
                    end
                elseif type == 'program' and ALERT then
                    if e.target.text.text == STR['program.scripts'] or e.target.text.text == STR['program.scenarios'] then
                        group.isVisible = false
                        SCRIPTS = require 'Interfaces.scripts'
                        SCRIPTS.create()
                        SCRIPTS.group.isVisible = true
                    elseif e.target.text.text == STR['program.images'] or e.target.text.text == STR['program.pictures'] then
                        group.isVisible = false
                        IMAGES = require 'Interfaces.images'
                        IMAGES.create()
                        IMAGES.group.isVisible = true
                    elseif e.target.text.text == STR['program.sounds'] then
                        group.isVisible = false
                        SOUNDS = require 'Interfaces.sounds'
                        SOUNDS.create()
                        SOUNDS.group.isVisible = true
                    elseif e.target.text.text == STR['program.videos'] then
                        group.isVisible = false
                        VIDEOS = require 'Interfaces.videos'
                        VIDEOS.create()
                        VIDEOS.group.isVisible = true
                    elseif e.target.text.text == STR['program.fonts'] then
                        group.isVisible = false
                        FONTS = require 'Interfaces.fonts'
                        FONTS.create()
                        FONTS.group.isVisible = true
                    elseif e.target.text.text == STR['program.resources'] then
                        group.isVisible = false
                        RESOURCES = require 'Interfaces.resources'
                        RESOURCES.create()
                        RESOURCES.group.isVisible = true
                    elseif e.target.text.text == STR['menu.settings'] then
                        group.isVisible = false
                        PSETTINGS = require 'Interfaces.program-settings'
                        PSETTINGS.create()
                        PSETTINGS.group.isVisible = true
                    elseif e.target.text.text == STR['program.export'] then
                        group:removeSelf() group = nil
                        PROGRAMS.group.isVisible = true
                        require('Core.Share.export').new(CURRENT_LINK)
                    elseif e.target.text.text == STR['program.build'] then
                        group:removeSelf() group = nil
                        PROGRAMS.group.isVisible = true
                        require('Core.Share.build').new(CURRENT_LINK)
                    elseif e.target.text.text == STR['program.aab'] then
                        group:removeSelf() group = nil
                        PROGRAMS.group.isVisible = true
                        require('Core.Share.build').new(CURRENT_LINK, true)
                    end
                elseif type == 'scripts' then
                    if e.target.move then
                        e.target.move = false
                        MOVE.stop(e, scroll, group, type)
                    elseif ALERT then
                        LAST_CHECKBOX = 0
                        CURRENT_SCRIPT = e.target.getRealIndex(e.target, nil, 'scripts')
                        group.isVisible = false
                        BLOCKS = require 'Interfaces.blocks'
                        BLOCKS.create()
                        BLOCKS.group.isVisible = true
                    end

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                elseif type == 'resources' then
                    if e.target.move then
                        e.target.move = false
                        MOVE.stop(e, scroll, group, type)
                    end

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                elseif type == 'images' then
                    if e.target.move then
                        e.target.move = false
                        MOVE.stop(e, scroll, group, type)
                    elseif ALERT then
                        local group_image = display.newGroup() ALERT = false
                        IMAGES.group[8]:setIsLocked(true, 'vertical')

                        local shadow = display.newRect(CENTER_X, CENTER_Y, DISPLAY_WIDTH, DISPLAY_HEIGHT)
                            shadow.color = 0
                            shadow:setFillColor(0)
                        group_image:insert(shadow)

                        display.setDefault('magTextureFilter', e.target.filter == 'linear' and 'linear' or 'nearest')
                        display.setDefault('minTextureFilter', e.target.filter == 'linear' and 'linear' or 'nearest')

                        local icon = display.newImage(CURRENT_LINK .. '/Images/' .. e.target.link, system.DocumentsDirectory)
                            local diffSize = icon.height / icon.width
                            if icon.height > icon.width then
                                icon.height = 600
                                icon.width = 600 / diffSize
                            else
                                icon.width = 600
                                icon.height = 600 * diffSize
                            end icon.x, icon.y = CENTER_X, CENTER_Y
                        group_image:insert(icon)

                        PHYSICS.start()
                        PHYSICS.setDrawMode('hybrid')
                        PHYSICS.addBody(icon, 'static')

                        shadow:addEventListener('touch', function(e)
                            if e.phase == 'began' then
                                shadow.color = shadow.color == 0 and 1 or 0
                                shadow:setFillColor(shadow.color)
                            end return true
                        end)

                        icon:addEventListener('touch', function(e)
                            if e.phase == 'began' then
                                timer.performWithDelay(1, function()
                                    PHYSICS.setDrawMode('normal')
                                    shadow:setFillColor(shadow.color)
                                end)
                            end return true
                        end)

                        local keyMaster
                        keyMaster = function(event)
                            if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and not ALERT then
                                if group_image and group_image.isVisible then
                                    PHYSICS.setDrawMode('normal') PHYSICS.removeBody(icon)
                                    PHYSICS.stop() group_image:removeSelf() ALERT = true
                                    Runtime:removeEventListener('key', keyMaster)
                                    IMAGES.group[8]:setIsLocked(false, 'vertical')
                                end
                            end
                        end

                        Runtime:addEventListener('key', keyMaster)
                    end

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                elseif type == 'sounds' then
                    if e.target.move then
                        e.target.move = false
                        MOVE.stop(e, scroll, group, type)
                    elseif ALERT then
                        local group_sound = display.newGroup() ALERT = false
                        SOUNDS.group[8]:setIsLocked(true, 'vertical')

                        local shadow = display.newRect(CENTER_X, CENTER_Y, DISPLAY_WIDTH, DISPLAY_HEIGHT)
                            shadow.color = 0
                            shadow:setFillColor(0)
                        group_sound:insert(shadow)

                        local text = display.newText({
                                text = e.target.text.text, x = CENTER_X, y = CENTER_Y,
                                width = 600, font = 'ubuntu', fontSize = 50, align = 'center'
                            }) text:setFillColor(1)
                        group_sound:insert(text)

                        local musicStream = audio.loadStream(CURRENT_LINK .. '/Sounds/' .. e.target.link, system.DocumentsDirectory)
                        local musicPlay = audio.play(musicStream, {channel = audio.findFreeChannel(), loops = -1})

                        local keyMaster
                        keyMaster = function(event)
                            if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and not ALERT then
                                if group_sound and group_sound.isVisible then
                                    audio.stop(musicPlay) musicPlay = nil
                                    audio.dispose(musicStream) musicStream = nil

                                    group_sound:removeSelf() ALERT = true
                                    Runtime:removeEventListener('key', keyMaster)
                                    SOUNDS.group[8]:setIsLocked(false, 'vertical')
                                end
                            end
                        end

                        Runtime:addEventListener('key', keyMaster)
                    end

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                elseif type == 'videos' then
                    if e.target.move then
                        e.target.move = false
                        MOVE.stop(e, scroll, group, type)
                    elseif ALERT then
                        local group_video = display.newGroup() ALERT = false
                        VIDEOS.group[8]:setIsLocked(true, 'vertical')

                        local shadow = display.newRect(CENTER_X, CENTER_Y, DISPLAY_WIDTH, DISPLAY_HEIGHT)
                            shadow.color = 0
                            shadow:setFillColor(0)
                        group_video:insert(shadow)

                        local video = native.newVideo(CENTER_X, CENTER_Y, DISPLAY_WIDTH, DISPLAY_HEIGHT)
                        video:load(CURRENT_LINK .. '/Videos/' .. e.target.link, system.DocumentsDirectory)
                        video:play()

                        local keyMaster
                        keyMaster = function(event)
                            if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and not ALERT then
                                if group_video and group_video.isVisible then
                                    video:pause()
                                    video:removeSelf()
                                    video = nil

                                    group_video:removeSelf() ALERT = true
                                    Runtime:removeEventListener('key', keyMaster)
                                    VIDEOS.group[8]:setIsLocked(false, 'vertical')
                                end
                            end
                        end

                        Runtime:addEventListener('key', keyMaster)
                    end

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                elseif type == 'fonts' then
                    if e.target.move then
                        e.target.move = false
                        MOVE.stop(e, scroll, group, type)
                    elseif ALERT then
                        local font_link = CURRENT_LINK .. '_' .. e.target.link
                        local group_font = display.newGroup() ALERT = false
                        FONTS.group[8]:setIsLocked(true, 'vertical')

                        local shadow = display.newRect(CENTER_X, CENTER_Y, DISPLAY_WIDTH, DISPLAY_HEIGHT)
                            shadow.color = 0
                            shadow:setFillColor(0)
                        group_font:insert(shadow)

                        local new_font = io.open(DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts/' .. e.target.link, 'rb')
                        local main_font = io.open(RES_PATH .. '/' .. font_link, 'wb')

                        if main_font and new_font then
                            main_font:write(new_font:read('*a'))
                            io.close(new_font)
                            io.close(main_font)
                        end

                        local text = display.newText({
                                text = '1234567890\nabcdefghijklmnopqrstuvwxyz',
                                x = CENTER_X, y = CENTER_Y, width = 600, font = font_link, fontSize = 60, align = 'center'
                            }) text:setFillColor(1)
                        group_font:insert(text)

                        local keyMaster
                        keyMaster = function(event)
                            if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and not ALERT then
                                if group_font and group_font.isVisible then
                                    group_font:removeSelf() ALERT = true
                                    Runtime:removeEventListener('key', keyMaster)
                                    FONTS.group[8]:setIsLocked(false, 'vertical')
                                end
                            end
                        end

                        Runtime:addEventListener('key', keyMaster)
                    end

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                end
            else
                local group
                if type == 'programs' then
                    group = PROGRAMS.group
                elseif type == 'scripts' then
                    group = SCRIPTS.group
                elseif type == 'images' then
                    group = IMAGES.group
                elseif type == 'sounds' then
                    group = SOUNDS.group
                elseif type == 'videos' then
                    group = VIDEOS.group
                elseif type == 'resources' then
                    group = RESOURCES.group
                elseif type == 'fonts' then
                    group = FONTS.group
                end

                if group then
                    if not MORE_LIST then
                        for i = 1, #group.blocks do
                            if (not group.blocks[i].indexFolder) and group.blocks[i].checkbox.isOn then
                                if group.blocks[i] ~= e.target then
                                    group.blocks[i].checkbox:setState({isOn = false})
                                end
                            end
                        end
                    end

                    e.target.checkbox:setState({isOn=not e.target.checkbox.isOn})
                end
            end
        end
    end
end

M.new = function(text, scroll, group, type, index, filter, link, comment, indexFolder, commentFolder)
    local y = index == 1 and 25 or group.data[index - 1].y + 150
    local text, type = tostring(text), tostring(type) if index == 1 and (type == 'programs' or type == 'program') then y = 75 end
    table.insert(group.blocks, index, {})

    for i = index + 1, #group.blocks do
        group.blocks[i].y = group.blocks[i].y + 150
        pcall(function() group.blocks[i].text.y = group.blocks[i].text.y + 150 end)
        pcall(function() group.blocks[i].polygon.y = group.blocks[i].polygon.y + 150 end)
        pcall(function() group.blocks[i].checkbox.y = group.blocks[i].checkbox.y + 150 end)
        pcall(function() group.blocks[i].container.y = group.blocks[i].container.y + 150 end)
        group.data[i - 1].y = group.blocks[i].y
    end

    if indexFolder then
        local blockWidth = scroll.width - RIGHT_HEIGHT - 100

        group.blocks[index] = display.newRect(scroll.width / 2, y, scroll.width - RIGHT_HEIGHT, 125)
            group.blocks[index].alpha = 0.005
            group.blocks[index].index = #group.data + 1
        scroll:insert(group.blocks[index])

        group.blocks[index].text = display.newText({
                text = text, x = scroll.width / 2, y = y,
                font = 'ubuntu', fontSize = 40, align = 'left', width = blockWidth - 40, height = 54
            }) group.blocks[index].indexFolder = indexFolder
            group.blocks[index].commentFolder = commentFolder
        scroll:insert(group.blocks[index].text)

        local testText, textWidth = display.newText({
                text = text, x = 5000, y = 5000,
                font = 'ubuntu', fontSize = 40, align = 'left', height = 54
            }) textWidth = testText.width
        testText:removeSelf()

        local polygonX = group.blocks[index].x + blockWidth / 2 - 20 - blockWidth + 10
        local polygonY = group.blocks[index].y

        group.blocks[index].polygon = display.newPolygon(polygonX, polygonY, {0, 0, 10, 10, -10, 10})
            group.blocks[index].polygon.yScale = commentFolder and 1.4 or -1.4
            group.blocks[index].polygon:setFillColor(commentFolder and 0.4 or 1)
        scroll:insert(group.blocks[index].polygon)
    else
        group.blocks[index] = display.newRoundedRect(scroll.width / 2, y, scroll.width - RIGHT_HEIGHT - 100, 125, 20)
            group.blocks[index].alpha = 0.9
            group.blocks[index].index = #group.data + 1
            group.blocks[index]:setFillColor(25/255, 26/255, 32/255)
        scroll:insert(group.blocks[index])

        group.blocks[index].text = display.newText({
                text = text, x = scroll.width / 2 + 64, y = y,
                font = 'ubuntu', fontSize = 40, align = 'left',
                width = group.blocks[index].width - 160, height = 50
            })
        scroll:insert(group.blocks[index].text)

        group.blocks[index].container = display.newContainer(94, 94)
            group.blocks[index].container:translate(scroll.width / 2 - group.blocks[index].width / 2 + 62, y)
            group.blocks[index].container:setMask(MASK)
            group.blocks[index].container.maskScaleX = 0.094
            group.blocks[index].container.maskScaleY = 0.094
        scroll:insert(group.blocks[index].container)

        if link then
            group.blocks[index].link = link
        end

        if filter then
            group.blocks[index].filter = filter
        end

        if filter and (filter == 'linear' or filter == 'nearest' or filter == 'vector') then
            display.setDefault('magTextureFilter', filter ~= 'linear' and 'nearest' or 'linear')
            display.setDefault('minTextureFilter', filter ~= 'linear' and 'nearest' or 'linear')
        end

        if type == 'programs' then
            local file = io.open(DOC_DIR .. '/' .. link .. '/icon.png', 'r')
            if file then link = link .. '/icon.png' io.close(file) else link = nil end
        end

        if link and (type == 'images' or type == 'programs') then
            local path = type == 'images' and CURRENT_LINK .. '/Images/' .. link or link

            group.blocks[index].icon = display.newImage(path, system.DocumentsDirectory)
                local diffSize = group.blocks[index].icon.height / group.blocks[index].icon.width
                if group.blocks[index].icon.height > group.blocks[index].icon.width then
                    group.blocks[index].icon.height = 94 * diffSize
                    group.blocks[index].icon.width = 94
                else
                    group.blocks[index].icon.width = 94 / diffSize
                    group.blocks[index].icon.height = 94
                end
            group.blocks[index].container:insert(group.blocks[index].icon, true)

            display.setDefault('magTextureFilter', 'linear')
            display.setDefault('minTextureFilter', 'linear')
        elseif type == 'program' then
            local paths = {
                default = {'Script', 'Sprite', 'Level', 'Sound', 'Video', 'Font', 'Res', 'Setting', 'Export', 'Build', 'Aab'},
                noob = {'Script', 'Sprite', 'Level', 'Sound', 'Font', 'Setting', 'Export', 'Build'}
            } local path = NOOBMODE and paths.noob[index] or paths.default[index]

            if path ~= '' then
                group.blocks[index].icon = display.newImage('Sprites/icon' .. path .. '.png')
                group.blocks[index].container:insert(group.blocks[index].icon, true)
            end
        elseif type == 'scripts' then
            group.blocks[index].turn = not comment
            group.blocks[index].icon = display.newImage('Sprites/icon' .. (group.blocks[index].turn and 'Script' or 'Comment') .. '.png')
            group.blocks[index].container:insert(group.blocks[index].icon, true)
        elseif type == 'sounds' then
            group.blocks[index].icon = display.newImage('Sprites/iconSound.png')
            group.blocks[index].container:insert(group.blocks[index].icon, true)
        elseif type == 'videos' then
            group.blocks[index].icon = display.newImage('Sprites/iconVideo.png')
            group.blocks[index].container:insert(group.blocks[index].icon, true)
        elseif type == 'resources' then
            group.blocks[index].icon = display.newImage('Sprites/iconRes.png')
            group.blocks[index].container:insert(group.blocks[index].icon, true)
        elseif type == 'fonts' then
            group.blocks[index].icon = display.newImage('Sprites/iconFont.png')
            group.blocks[index].container:insert(group.blocks[index].icon, true)
        else
            group.blocks[index].icon = display.newRect(group.blocks[index].container.x, y, 94, 94)
                group.blocks[index].icon:setFillColor(0.15, 0.15, 0.17)
            group.blocks[index].container:insert(group.blocks[index].icon, true)
        end

        group.blocks[index].checkbox = WIDGET.newSwitch({
                x = (group.blocks[index].x - group.blocks[index].width / 2) / 2, y = y, style = 'checkbox', width = 50, height = 50,
                onPress = function(event) event.target:setState({isOn=not event.target.isOn}) end
            }) group.blocks[index].checkbox.isVisible = false
        scroll:insert(group.blocks[index].checkbox)
    end

    group.blocks[index]:addEventListener('touch', function(e)
        if group.isVisible then
            listener(e, scroll, group, type)
            return true
        end
    end)

    group.blocks[index].getIndex = function(target)
        for i = 1, #group.blocks do
            if group.blocks[i] == target then
                return i
            end
        end
    end

    group.blocks[index].getRealIndex = function(target, data, type)
        local data = data or GET_GAME_CODE(CURRENT_LINK)
        local folderIsComment = false
        local folderCount = 0
        local blockCount = 0
        local index = 0

        for i = 1, #group.blocks do
            if group.blocks[i].indexFolder then
                folderCount, blockCount = folderCount + 1, 0
                folderIsComment = group.blocks[i].commentFolder

                if folderIsComment then
                    index = index + #data.folders[type][folderCount][2]
                end
            else
                index, blockCount = folderIsComment and index or index + 1, blockCount + 1
            end

            if group.blocks[i] == target then
                return folderIsComment and index + 1 or index, folderIsComment and #data.folders[type][folderCount][2] + 1 or blockCount
            end
        end
    end

    group.blocks[index].getFolderIndex = function(target)
        local folderCount = 0
        local folderIndex

        for i = 1, #group.blocks do
            if group.blocks[i].indexFolder then
                folderCount, folderIndex = folderCount + 1, i
            end

            if group.blocks[i] == target then
                return folderCount, i, folderIndex
            end
        end
    end

    group.blocks[index].remove = function(index)
        pcall(function() group.blocks[index].text:removeSelf() end)
        pcall(function() group.blocks[index].icon:removeSelf() end)
        pcall(function() group.blocks[index].polygon:removeSelf() end)
        pcall(function() group.blocks[index].checkbox:removeSelf() end)
        pcall(function() group.blocks[index].container:removeSelf() end)
        pcall(function() group.blocks[index]:removeSelf() end)
        table.remove(group.data, index)
        table.remove(group.blocks, index)
    end

    table.insert(group.data, index, {x = group.blocks[index].x, y = group.blocks[index].y, text = text})
    scroll:setScrollHeight(150 * #group.data)
end

return M
