local CALC = require 'Core.Simulation.calc'
local M = {}

if 'Медиа' then
    M['newVideo'] = function(params)
        local name, link, fun = CALC(params[1]), CALC(params[2]), CALC(params[3], 'a', true)
        local posX = '(SET_X(' .. CALC(params[4]) .. '))'
        local posY = '(SET_Y(' .. CALC(params[5]) .. '))'
        local width, height = CALC(params[6]), CALC(params[7])

        GAME.lua = GAME.lua .. ' pcall(function() local link, name = other.getVideo(' .. link .. '), ' .. name .. ' GAME.group.media[name]'
        GAME.lua = GAME.lua .. ' = native.newVideo(' .. posX .. ', ' .. posY .. ', ' .. width .. ', ' .. height .. ')'
        GAME.lua = GAME.lua .. ' GAME.group.media[name]:load(link, system.DocumentsDirectory) GAME.group.media[name]:play()'
        GAME.lua = GAME.lua .. ' GAME.group.media[name]:addEventListener(\'video\', function(e) if GAME.hash == hash'
        GAME.lua = GAME.lua .. ' then pcall(function() e.name = name ' .. fun .. '(e)'
        GAME.lua = GAME.lua .. ' end) end end) GAME.group.media[name]:setNativeProperty(\'IgnoreErrors\', true) end)'
    end

    M['newRemoteVideo'] = function(params)
        local name, link, fun = CALC(params[1]), CALC(params[2]), CALC(params[3], 'a', true)
        local posX = '(SET_X(' .. CALC(params[4]) .. '))'
        local posY = '(SET_Y(' .. CALC(params[5]) .. '))'
        local width, height = CALC(params[6]), CALC(params[7])

        GAME.lua = GAME.lua .. ' pcall(function() local link, name = ' .. link .. ', ' .. name .. ' GAME.group.media[name]'
        GAME.lua = GAME.lua .. ' = native.newVideo(' .. posX .. ', ' .. posY .. ', ' .. width .. ', ' .. height .. ')'
        GAME.lua = GAME.lua .. ' GAME.group.media[name]:load(link, media.RemoteSource) GAME.group.media[name]:play()'
        GAME.lua = GAME.lua .. ' GAME.group.media[name]:addEventListener(\'video\', function(e) if GAME.hash == hash'
        GAME.lua = GAME.lua .. ' then pcall(function() e.name = name ' .. fun .. '(e)'
        GAME.lua = GAME.lua .. ' end) end end) GAME.group.media[name]:setNativeProperty(\'IgnoreErrors\', true) end)'
    end

    M['loadSound'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local link, name = other.getSound(' .. CALC(params[2]) .. '), ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' GAME.group.media[name] = {link and audio.loadSound(link, system.DocumentsDirectory) or nil} end)'
    end

    M['loadStream'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local link, name = other.getSound(' .. CALC(params[2]) .. '), ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' GAME.group.media[name] = {link and audio.loadStream(link, system.DocumentsDirectory) or nil} end)'
    end

    M['playSound'] = function(params)
        local name = CALC(params[1])
        local loops = CALC(params[2], '1')
        local fun = CALC(params[3], 'a', true)
        local duration = CALC(params[4], 'nil')
        local fadein = CALC(params[5], 'nil')

        GAME.lua = GAME.lua .. ' pcall(function() local name, loops = ' .. name .. ', ' .. loops .. ' - 1'
        GAME.lua = GAME.lua .. ' local fadein, duration = ' .. fadein .. ', ' .. duration .. ' GAME.group.media[name][2]'
        GAME.lua = GAME.lua .. ' = audio.play(GAME.group.media[name][1], {channel = audio.findFreeChannel(), loops'
        GAME.lua = GAME.lua .. ' = loops, duration = duration and duration * 1000 or nil, fadein = fadein and fadein * 1000 or nil,'
        GAME.lua = GAME.lua .. ' onComplete = function(e) pcall(function() e.name = name ' .. fun .. '(e) end) end}) end)'
    end

    M['resumeMedia'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' if GAME.group.media[name][2] then audio.resume(GAME.group.media[name][2])'
        GAME.lua = GAME.lua .. ' else GAME.group.media[name]:play() end end)'
    end

    M['pauseMedia'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' if GAME.group.media[name][2] then audio.pause(GAME.group.media[name][2])'
        GAME.lua = GAME.lua .. ' else GAME.group.media[name]:pause() end end)'
    end

    M['seekMedia'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name, duration = ' .. CALC(params[1]) .. ', 1000 * ' .. CALC(params[2], '0')
        GAME.lua = GAME.lua .. ' if GAME.group.media[name][2] then audio.seek(duration, {channel = GAME.group.media[name][2]})'
        GAME.lua = GAME.lua .. ' else GAME.group.media[name]:seek(duration / 1000) end end)'
    end

    M['setVolume'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name, volume = ' .. CALC(params[1]) .. ', ' .. CALC(params[2], '100')
        GAME.lua = GAME.lua .. ' audio.setVolume(volume / 100, {channel = GAME.group.media[name][2]}) end)'
    end

    M['fadeVolume'] = function(params)
        local name = CALC(params[1])
        local time = CALC(params[2], '1')
        local volume = CALC(params[3], '100')

        GAME.lua = GAME.lua .. ' pcall(function() local name, time, volume = ' .. name .. ', ' .. time .. ', ' .. volume
        GAME.lua = GAME.lua .. ' audio.fade({channel = GAME.group.media[name][2], time = time, volume = volume / 100}) end)'
    end

    M['stopSound'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() audio.stop(GAME.group.media[' .. CALC(params[1]) .. '][2]) end)'
    end

    M['stopTimerSound'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name, duration = ' .. CALC(params[1]) .. ', ' .. CALC(params[2], '0')
        GAME.lua = GAME.lua .. ' audio.stopWithDelay(duration, {channel = GAME.group.media[name][2]}) end)'
    end

    M['disposeSound'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() audio.dispose(GAME.group.media[' .. CALC(params[1]) .. '][1]) end)'
    end

    M['removeVideo'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() GAME.group.media[' .. CALC(params[1]) .. ']:removeSelf() end)'
    end
end

if 'Файлы' then
    M['newFolder'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() LFS.mkdir(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. ')) end)'
    end

    M['moveFolder'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() OS_MOVE(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '),'
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[3]) .. ', ' .. CALC(params[4]) .. ')) end)'
    end

    M['copyFolder'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() OS_COPY(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '),'
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[3]) .. ', ' .. CALC(params[4]) .. ')) end)'
    end

    M['removeFolder'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() OS_REMOVE(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '), true) end)'
    end

    M['newCapturePNG'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
        local path, docType = CALC(params[3]), CALC(params[4])

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups' end

        GAME.lua = GAME.lua .. ' pcall(function() display.save(' .. type .. '[' .. name .. '], {filename ='
        GAME.lua = GAME.lua .. ' other.getPath(' .. path .. ', ' .. docType .. ', true),'
        GAME.lua = GAME.lua .. ' baseDir = system.DocumentsDirectory, captureOffscreenArea = true}) end)'
    end

    M['newCaptureJPEG'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
        local path, docType, quality = CALC(params[3]), CALC(params[4]), CALC(params[6])
        local colors = CALC(params[5], '{255, 255, 255}')

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups' end

        GAME.lua = GAME.lua .. ' pcall(function() local colors = ' .. colors .. ' display.save(' .. type .. '[' .. name .. '],'
        GAME.lua = GAME.lua .. ' {filename = other.getPath(' .. path .. ', ' .. docType .. ', true),'
        GAME.lua = GAME.lua .. ' jpegQuality = ' .. quality .. '/100, backgroundColor = {colors[1]/255, colors[2]/255, colors[3]/255},'
        GAME.lua = GAME.lua .. ' baseDir=system.DocumentsDirectory, captureOffscreenArea=true}) end)'
    end

    M['newFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() WRITE_FILE(other.getPath(' .. CALC(params[1]) .. ', '
        GAME.lua = GAME.lua .. CALC(params[4]) .. '), ' .. CALC(params[2]) .. ', ' .. CALC(params[3]) .. ') end)'
    end

    M['readFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[2], 'a', true) .. ' = READ_FILE(other.getPath('
        GAME.lua = GAME.lua .. CALC(params[1]) .. ', ' .. CALC(params[4]) .. '), ' .. CALC(params[3]) .. ') end)'
    end

    M['moveFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() OS_MOVE(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '),'
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[3]) .. ', ' .. CALC(params[4]) .. ')) end)'
    end

    M['copyFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() OS_COPY(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '),'
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[3]) .. ', ' .. CALC(params[4]) .. ')) end)'
    end

    M['removeFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() OS_REMOVE(other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. ')) end)'
    end

    M['convertFileToSprite'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local docType, spriteType = ' .. CALC(params[2]) .. ', ' .. CALC(params[4])
        GAME.lua = GAME.lua .. ' table.insert(GAME.RESOURCES.images, 1, {docType .. \':\' .. ' .. CALC(params[3]) .. ', spriteType,'
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[1]) .. ', docType, true)}) end)'
    end

    M['convertFileToVideo'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local docType = ' .. CALC(params[3]) .. ' table.insert(GAME.RESOURCES.videos, 1, {docType'
        GAME.lua = GAME.lua .. ' .. \':\' .. ' .. CALC(params[1]) .. ', other.getPath(' .. CALC(params[2]) .. ', docType, true)}) end)'
    end

    M['convertFileToSound'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local docType = ' .. CALC(params[3]) .. ' table.insert(GAME.RESOURCES.sounds, 1, {docType'
        GAME.lua = GAME.lua .. ' .. \':\' .. ' .. CALC(params[1]) .. ', other.getPath(' .. CALC(params[2]) .. ', docType, true)}) end)'
    end

    M['convertFileToFont'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local docType = ' .. CALC(params[3]) .. ' table.insert(GAME.RESOURCES.fonts, 1, {docType'
        GAME.lua = GAME.lua .. ' .. \':\' .. ' .. CALC(params[1]) .. ', other.getPath(' .. CALC(params[2]) .. ', docType, true)}) end)'
    end

    M['convertFileToRes'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local docType = ' .. CALC(params[3]) .. ' table.insert(GAME.RESOURCES.others, 1, {docType'
        GAME.lua = GAME.lua .. ' .. \':\' .. ' .. CALC(params[1]) .. ', other.getPath(' .. CALC(params[2]) .. ', docType, true)}) end)'
    end

    M['foreachFolder'] = function(params)
        GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() local path ='
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[2]) .. ', ' .. CALC(params[3]) .. ') for file in LFS.dir(path)'
        GAME.lua = GAME.lua .. ' do ' .. CALC(params[1], 'a', true) .. ' = {name = file, isFolder = IS_FOLDER(path .. \'/\' .. file)}'
    end

    M['foreachFolderEnd'] = function(params)
        GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then return result end'
    end

    M['compressZipFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() GANIN.zip(\'compress\', \'file\', other.getPath('
        GAME.lua = GAME.lua .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '), other.getPath(' .. CALC(params[3]) .. ', '
        GAME.lua = GAME.lua .. CALC(params[4]) .. '), ' .. CALC(params[5]) .. ', ' .. CALC(params[6]) .. ') end)'
    end

    M['compressZipFolder'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() GANIN.zip(\'compress\', \'folder\', other.getPath('
        GAME.lua = GAME.lua .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '), other.getPath(' .. CALC(params[3]) .. ', '
        GAME.lua = GAME.lua .. CALC(params[4]) .. '), ' .. CALC(params[5]) .. ', ' .. CALC(params[6]) .. ') end)'
    end

    M['uncompressZip'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local path = other.getPath(' .. CALC(params[4]) .. ', ' .. CALC(params[5]) .. ')'
        GAME.lua = GAME.lua .. ' LFS.mkdir(path) GANIN.zip(\'uncompress\', other.getPath(' .. CALC(params[2]) .. ', '
        GAME.lua = GAME.lua .. CALC(params[3]) .. '), path, ' .. CALC(params[1]) .. ') end)'
    end

    M['importFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() GIVE_PERMISSION_DATA() FILE.pickFile(other.getPath(\'\', ' .. CALC(params[2]) .. ','
        GAME.lua = GAME.lua .. ' nil, true), function(import) ' .. CALC(params[4], 'a', true) .. '(import)'
        GAME.lua = GAME.lua .. ' end, ' .. CALC(params[1]) .. ', \'\', ' .. CALC(params[3]) .. ') end)'
    end

    M['exportFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() GIVE_PERMISSION_DATA() EXPORT.export({path ='
        GAME.lua = GAME.lua .. ' other.getPath(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. '), name = ' .. CALC(params[3]) .. ','
        GAME.lua = GAME.lua .. ' listener = function(e) ' .. CALC(params[4], 'a', true) .. '(e) end}) end)'
    end

    M['downloadFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.networks, network.download(' .. CALC(params[1]) .. ','
        GAME.lua = GAME.lua .. ' \'GET\', function(e) pcall(function() if GAME.hash == hash'
        GAME.lua = GAME.lua .. ' then ' .. CALC(params[3], 'a', true) .. '({phase = e.phase,'
        GAME.lua = GAME.lua .. ' status = e.status, isError = e.isError, url = e.url, responseType = e.responseType,'
        GAME.lua = GAME.lua .. ' bytesEstimated = e.bytesEstimated, bytesTransferred = e.bytesTransferred})'
        GAME.lua = GAME.lua .. ' end end) end, {progress = true, bodyType = (' .. CALC(params[4]) .. ')'
        GAME.lua = GAME.lua .. ' and \'binary\' or \'text\'}, other.getPath(' .. CALC(params[2]) .. ', '
        GAME.lua = GAME.lua .. CALC(params[5]) .. ', true), system.DocumentsDirectory)) end)'
    end

    M['uploadFile'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.networks, network.upload(' .. CALC(params[1]) .. ','
        GAME.lua = GAME.lua .. ' \'POST\', function(e) pcall(function() if GAME.hash == hash'
        GAME.lua = GAME.lua .. ' then ' .. CALC(params[4], 'a', true) .. '({phase = e.phase,'
        GAME.lua = GAME.lua .. ' status = e.status, isError = e.isError, url = e.url, responseType = e.responseType,'
        GAME.lua = GAME.lua .. ' bytesEstimated = e.bytesEstimated, bytesTransferred = e.bytesTransferred})'
        GAME.lua = GAME.lua .. ' end end) end, {progress = true, bodyType = (' .. CALC(params[5]) .. ')'
        GAME.lua = GAME.lua .. ' and \'binary\' or \'text\'}, other.getPath(' .. CALC(params[3]) .. ', ' .. CALC(params[6]) .. ', true),'
        GAME.lua = GAME.lua .. ' system.DocumentsDirectory, ' .. CALC(params[2], 'multipart/aplication') .. ')) end)'
    end

    M['installApk'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() GIVE_PERMISSION_DATA() OS_COPY(other.getPath(' .. CALC(params[1]) .. ', '
        GAME.lua = GAME.lua .. CALC(params[2]) .. '), MY_PATH .. \'/game.apk\') GANIN.update(MY_PATH .. \'/game.apk\') end)'
    end
end

return M
