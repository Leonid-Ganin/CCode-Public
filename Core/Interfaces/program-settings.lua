local listeners = {}

listeners.title = function(target)
    EXITS.psettings()
end

listeners.build_button = function(target)
    INPUT.new(STR['psettings.enterbuild'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            INPUT.remove(true, event.target.text)
        end
    end, function(e)
        if e.input then
            if tonumber(e.text) then
                local data = GET_GAME_CODE(CURRENT_LINK)
                    data.settings.build = tonumber(e.text)
                    target.value.text = '\'' .. e.text .. '\''
                SET_GAME_CODE(CURRENT_LINK, data)
            else
                WINDOW.new(STR['errors.build'], {STR['button.close'], STR['button.okay']}, function() end, 5)
            end
        end
    end)
end

listeners.version_button = function(target)
    INPUT.new(STR['psettings.enterversion'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            INPUT.remove(true, event.target.text)
        end
    end, function(e)
        if e.input then
            local text = UTF8.lower(e.text)
            local data = GET_GAME_CODE(CURRENT_LINK)
                data.settings.version = text
                target.value.text = '\'' .. text .. '\''
            SET_GAME_CODE(CURRENT_LINK, data)
        end
    end)
end

listeners.package_button = function(target)
    INPUT.new(STR['psettings.enterpackage'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            INPUT.remove(true, event.target.text)
        end
    end, function(e)
        if e.input then
            local filter, text = 'qwertyuiopasdfghjklzxcvbnm1234567890', ''
            local last_point = 0 e.text = UTF8.lower(e.text)

            for i = 1, UTF8.len(e.text) do
                if UTF8.find(filter, UTF8.sub(e.text, i, i), 1, true) then
                    if last_point ~= i - 1 or not tonumber(UTF8.sub(e.text, i, i)) then
                        text = text .. UTF8.sub(e.text, i, i)
                    end
                elseif UTF8.sub(e.text, i, i) == '.' then
                    last_point = i
                    text = text .. '.'
                end
            end

            local index_point, len_text = UTF8.find(text, '.', 1, true), UTF8.len(text)

            if (not (UTF8.find(text, '..', 1, true) or UTF8.sub(text, 1, 1) == '.' or UTF8.sub(text, len_text, len_text) == '.'))
            and len_text > 2 and index_point and UTF8.find(filter, UTF8.sub(text, index_point + 1, index_point + 1)) then
                local data = GET_GAME_CODE(CURRENT_LINK)
                    data.settings.package = text
                    target.value.text = '\'' .. text .. '\''
                SET_GAME_CODE(CURRENT_LINK, data)
            else
                WINDOW.new(STR['errors.package'], {STR['button.close'], STR['button.okay']}, function() end, 5)
            end
        end
    end)
end

listeners.orientation_icon = function(target)
    target.data.settings.orientation = target.data.settings.orientation == 'portrait' and 'landscape' or 'portrait'
    target.rotation = target.rotation + 90 SET_GAME_CODE(CURRENT_LINK, target.data)
end

listeners.icon = function(target)
    local path = DOC_DIR .. '/' .. CURRENT_LINK

    local completeImportPicture = function(import)
        if import.done and import.done == 'ok' then
            local container = target.parent target:removeSelf()

            timer.performWithDelay(100, function()
                local icon = display.newImage(CURRENT_LINK .. '/icon.png', system.DocumentsDirectory)
                    local diffSize = icon.height / icon.width
                    if icon.height > icon.width then
                        icon.height = 90
                        icon.width = 90 / diffSize
                    else
                        icon.width = 90
                        icon.height = 90 * diffSize
                    end
                container:insert(icon, true)

                PROGRAMS.group:removeSelf()
                PROGRAMS.group = nil
                PROGRAMS.create()
                PROGRAMS.group.isVisible = false
            end)
        end
    end

    GIVE_PERMISSION_DATA()
    FILE.pickFile(path, completeImportPicture, 'icon.png', '', 'image/*', nil, nil, nil)
end

return function(e)
    if PSETTINGS.group.isVisible and ALERT then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true
            if e.target.id == 'title' then e.target.alpha = 0.6 end
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            display.getCurrentStage():setFocus(nil)
            e.target.click = false
            if e.target.id == 'title' then e.target.alpha = 1 end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if e.target.id == 'title' then e.target.alpha = 1 end
            if e.target.click then
                e.target.click = false
                listeners[e.target.id](e.target)
            end
        end
        return true
    end
end
