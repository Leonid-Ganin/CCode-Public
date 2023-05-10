local listeners = {}

listeners.but_myprogram = function(target)
    MENU.group.isVisible = false
    PROGRAMS = require 'Interfaces.programs'
    PROGRAMS.create()
    PROGRAMS.group.isVisible = true
end

function _supportOldestVersion(data, link)
    local script = GET_GAME_SCRIPT(link, 1, data)

    if not data.folders then
        data.folders = {
            scripts = {{'1', data.scripts, false}},
            images = {{'1', data.resources.images, false}},
            sounds = {{'1', data.resources.sounds, false}},
            videos = {{'1', data.resources.videos, false}},
            others = {{'1', data.resources.others, false}},
            fonts = {{'1', data.resources.fonts, false}}
        }
    end

    if script and script.custom then
        DEL_GAME_SCRIPT(link, 1, data)
        table.remove(data.scripts, 1)
        SET_GAME_CODE(link, data)
    end

    if tonumber(data.build) < BUILD then
        data.build = tostring(BUILD)
        SET_GAME_CODE(link, data)
    end

    return data
end

listeners.but_continue = function(target)
    if LOCAL.last == '' then
        MENU.group.isVisible = false
        PROGRAMS = require 'Interfaces.programs'
        PROGRAMS.create()
        PROGRAMS.group.isVisible = true
    else
        local data = GET_GAME_CODE(LOCAL.last_link)

        if tonumber(data.build) > 1170 then
            data = _supportOldestVersion(data, LOCAL.last_link)

            MENU.group.isVisible = false
            PROGRAMS = require 'Interfaces.programs'
            PROGRAMS.create()
            CURRENT_LINK = LOCAL.last_link

            PROGRAMS.group.isVisible = false
            PROGRAM = require 'Interfaces.program'
            PROGRAM.create(LOCAL.last, data.noobmode)
            PROGRAM.group.isVisible = true
        end
    end
end

listeners.but_settings = function(target)
    MENU.group.isVisible = false
    SETTINGS = require 'Interfaces.settings'
    SETTINGS.create()
    SETTINGS.group.isVisible = true
end

listeners.but_social = function(target)
    system.openURL('https://discord.gg/7eYnvAgXdX')
end

listeners.but_dogs = function(target)
    MENU.group.isVisible = false
    ROBODOG = require 'Interfaces.robodog'
    ROBODOG.create()
    ROBODOG.group.isVisible = true
end

return function(e)
    if MENU.group.isVisible and ALERT then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true
            if e.target.button == 'but_social'
            then e.target.alpha = 0.7
            else e.target.alpha = 0.6 end
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            e.target.click = false
            if e.target.button == 'but_social'
            then e.target.alpha = 1
            else e.target.alpha = 0.9 end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if e.target.click then
                e.target.click = false
                if e.target.button == 'but_social'
                then e.target.alpha = 1
                else e.target.alpha = 0.9 end
                listeners[e.target.button](e.target)
            end
        end
        return true
    end
end
