local M = {}

if 'Объект' then
    M['obj.touch'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GAME.group.objects[name]._touch or false
        end) return isComplete and result
    end

    M['obj.var'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GAME.group.objects[name]._data or {}
        end) return isComplete and result or {}
    end

    M['obj.tag'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GAME.group.objects[name]._tag or ''
        end) return isComplete and result or ''
    end

    M['obj.pos_x'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GET_X(GAME.group.objects[name].x, GAME.group.objects[name]) or 0
        end) return isComplete and result or 0
    end

    M['obj.pos_y'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GET_Y(GAME.group.objects[name].y, GAME.group.objects[name]) or 0
        end) return isComplete and result or 0
    end

    M['obj.width'] = function(name)
        local isComplete, result = pcall(function()
            return (GAME.group.objects[name] and GAME.group.objects[name]._radius)
            and (GAME.group.objects[name].path.radius or 0) or (GAME.group.objects[name] and GAME.group.objects[name].width or 0)
        end) return isComplete and result or 0
    end

    M['obj.height'] = function(name)
        local isComplete, result = pcall(function()
            return (GAME.group.objects[name] and GAME.group.objects[name]._radius)
            and (GAME.group.objects[name].path.radius or 0) or (GAME.group.objects[name] and GAME.group.objects[name].height or 0)
        end) return isComplete and result or 0
    end

    M['obj.rotation'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GAME.group.objects[name].rotation or 0
        end) return isComplete and result or 0
    end

    M['obj.alpha'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GAME.group.objects[name].alpha * 100 or 100
        end) return isComplete and result or 100
    end

    M['obj.distance'] = function(name1, name2)
        local isComplete, result = pcall(function()
            return _G.math.sqrt(((GAME.group.objects[name1].x - GAME.group.objects[name2].x) ^ 2)
            + ((GAME.group.objects[name1].y - GAME.group.objects[name2].y) ^ 2))
        end) return isComplete and result or 0
    end

    M['obj.name_texture'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name] and GAME.group.objects[name]._name or ''
        end) return isComplete and result or ''
    end

    M['obj.velocity_x'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name]._body ~= '' and select(1, GAME.group.objects[name]:getLinearVelocity()) or 0
        end) return isComplete and result or 0
    end

    M['obj.velocity_y'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name]._body ~= '' and 0 - select(2, GAME.group.objects[name]:getLinearVelocity()) or 0
        end) return isComplete and result or 0
    end

    M['obj.angular_velocity'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.objects[name]._body ~= '' and GAME.group.objects[name].angularVelocity or 0
        end) return isComplete and result or 0
    end
end

if 'Текст' then
    M['text.get_text'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name or '0'] and GAME.group.texts[name or '0'].text or ''
        end) return isComplete and result or ''
    end

    M['text.tag'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GAME.group.texts[name]._tag or ''
        end) return isComplete and result or ''
    end

    M['text.pos_x'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GET_X(GAME.group.texts[name].x, GAME.group.texts[name]) or 0
        end) return isComplete and result or 0
    end

    M['text.pos_y'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GET_Y(GAME.group.texts[name].y, GAME.group.texts[name]) or 0
        end) return isComplete and result or 0
    end

    M['text.width'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GAME.group.texts[name].width or 0
        end) return isComplete and result or 0
    end

    M['text.height'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GAME.group.texts[name].height or 0
        end) return isComplete and result or 0
    end

    M['text.rotation'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GAME.group.texts[name].rotation or 0
        end) return isComplete and result or 0
    end

    M['text.alpha'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.texts[name] and GAME.group.texts[name].alpha * 100 or 100
        end) return isComplete and result or 100
    end
end

if 'Группа' then
    M['group.tag'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and GAME.group.groups[name]._tag or ''
        end) return isComplete and result or ''
    end

    M['group.pos_x'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and GAME.group.groups[name].x or 0
        end) return isComplete and result or 0
    end

    M['group.pos_y'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and 0 - GAME.group.groups[name].y or 0
        end) return isComplete and result or 0
    end

    M['group.width'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and GAME.group.groups[name].width or 0
        end) return isComplete and result or 0
    end

    M['group.height'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and GAME.group.groups[name].height or 0
        end) return isComplete and result or 0
    end

    M['group.rotation'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and GAME.group.groups[name].rotation or 0
        end) return isComplete and result or 0
    end

    M['group.alpha'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.groups[name] and GAME.group.groups[name].alpha * 100 or 100
        end) return isComplete and result or 100
    end
end

if 'Виджет' then
    M['widget.tag'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name] and GAME.group.widgets[name]._tag or ''
        end) return isComplete and result or ''
    end

    M['widget.pos_x'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name] and GET_X(GAME.group.widgets[name].x, GAME.group.widgets[name]) or 0
        end) return isComplete and result or 0
    end

    M['widget.pos_y'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name] and GET_Y(GAME.group.widgets[name].y, GAME.group.widgets[name]) or 0
        end) return isComplete and result or 0
    end

    M['widget.value'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name] and (GAME.group.widgets[name].wtype == 'slider' and GAME.group.widgets[name].value or 0) or 50
        end) return isComplete and result or 50
    end

    M['widget.state'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name]
                and (GAME.group.widgets[name].wtype == 'switch' and GAME.group.widgets[name].isOn or false) or false
        end) return isComplete and result
    end

    M['widget.text'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name] and (GAME.group.widgets[name].wtype == 'field' and GAME.group.widgets[name].text or '') or ''
        end) return isComplete and result or ''
    end

    M['widget.link'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.widgets[name] and (GAME.group.widgets[name].wtype == 'webview' and GAME.group.widgets[name].url or '') or ''
        end) return isComplete and result or ''
    end
end

if 'Медиа' then
    M['media.current_time'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.media[name] and GAME.group.media[name].currentTime or 0
        end) return isComplete and result or 0
    end

    M['media.total_time'] = function(name)
        local isComplete, result = pcall(function()
            return GAME.group.media[name] and GAME.group.media[name].totalTime or 0
        end) return isComplete and result or 0
    end

    M['media.sound_volume'] = function(name)
        local isComplete, result = pcall(function()
            return audio.getVolume((GAME.group.media[name] and GAME.group.media[name][2]) and {channel=GAME.group.media[name][2]} or nil)
        end) return isComplete and result or 0
    end

    M['media.sound_total_time'] = function(name)
        local isComplete, result = pcall(function()
            return (GAME.group.media[name] and GAME.group.media[name][1]) and audio.getDuration(GAME.group.media[name][1]) or 0
        end) return isComplete and result or 0
    end

    M['media.sound_pause'] = function(name)
        local isComplete, result = pcall(function()
            return (GAME.group.media[name] and GAME.group.media[name][2]) and audio.isChannelPaused(GAME.group.media[name][2]) or nil
        end) return isComplete and result or nil
    end

    M['media.sound_play'] = function(name)
        local isComplete, result = pcall(function()
            return (GAME.group.media[name] and GAME.group.media[name][2]) and audio.isChannelPlaying(GAME.group.media[name][2]) or nil
        end) return isComplete and result or nil
    end
end

if 'Файлы' then
    M['files.length'] = function(path, isTemp)
        local isComplete, result = pcall(function()
            return GANIN.file('length', DOC_DIR .. '/' .. CURRENT_LINK .. '/' .. (isTemp and 'Temps' or 'Documents') .. '/' .. path)
        end) return isComplete and result or 0
    end

    M['files.is_file'] = function(path, isTemp)
        local isComplete, result = pcall(function()
            return GANIN.file('is_file', DOC_DIR .. '/' .. CURRENT_LINK .. '/' .. (isTemp and 'Temps' or 'Documents') .. '/' .. path)
        end) return isComplete and result or false
    end

    M['files.is_folder'] = function(path, isTemp)
        local isComplete, result = pcall(function()
            return GANIN.file('is_folder', DOC_DIR .. '/' .. CURRENT_LINK .. '/' .. (isTemp and 'Temps' or 'Documents') .. '/' .. path)
        end) return isComplete and result or false
    end

    M['files.length_folder'] = function(path, isTemp)
        local isComplete, result = pcall(function()
            return GANIN.file('length_folder', DOC_DIR .. '/' .. CURRENT_LINK .. '/' .. (isTemp and 'Temps' or 'Documents') .. '/' .. path)
        end) return isComplete and result or 0
    end

    M['files.last_modified'] = function(path, isTemp)
        local isComplete, result = pcall(function()
            return GANIN.file('last_modified', DOC_DIR .. '/' .. CURRENT_LINK .. '/' .. (isTemp and 'Temps' or 'Documents') .. '/' .. path)
        end) return isComplete and result or 0
    end
end

return M
