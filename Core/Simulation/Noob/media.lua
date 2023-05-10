local CALC = require 'Core.Simulation.calc'
local M = {}

M['playSoundNoob'] = function(params)
    local name = CALC(params[1])
    local loops = CALC(params[2], '1')

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local link = other.getSound(name)'
    GAME.lua = GAME.lua .. ' GAME.group.media[name] = {link and audio.loadSound(link, system.DocumentsDirectory) or nil}'
    GAME.lua = GAME.lua .. ' local loops = ' .. loops .. ' - 1 GAME.group.media[name][2] = audio.play(GAME.group.media[name][1],'
    GAME.lua = GAME.lua .. ' {channel = audio.findFreeChannel(), loops = loops}) end)'
end

M['resumeMediaNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' if GAME.group.media[name][2] then audio.resume(GAME.group.media[name][2])'
    GAME.lua = GAME.lua .. ' else GAME.group.media[name]:play() end end)'
end

M['pauseMediaNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' if GAME.group.media[name][2] then audio.pause(GAME.group.media[name][2])'
    GAME.lua = GAME.lua .. ' else GAME.group.media[name]:pause() end end)'
end

M['seekMediaNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name, duration = ' .. CALC(params[1]) .. ', 1000 * ' .. CALC(params[2], '0')
    GAME.lua = GAME.lua .. ' if GAME.group.media[name][2] then audio.seek(duration, {channel = GAME.group.media[name][2]})'
    GAME.lua = GAME.lua .. ' else GAME.group.media[name]:seek(duration / 1000) end end)'
end

M['setVolumeNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name, volume = ' .. CALC(params[1]) .. ', ' .. CALC(params[2], '1')
    GAME.lua = GAME.lua .. ' audio.setVolume(volume, {channel = GAME.group.media[name][2]}) end)'
end

M['fadeVolumeNoob'] = function(params)
    local name = CALC(params[1])
    local time = CALC(params[2], '1')
    local volume = CALC(params[3], '1')

    GAME.lua = GAME.lua .. ' pcall(function() local name, time, volume = ' .. name .. ', ' .. time .. ', ' .. volume
    GAME.lua = GAME.lua .. ' audio.fade({channel = GAME.group.media[name][2], time = time, volume = volume}) end)'
end

M['stopSoundNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' audio.stop(GAME.group.media[name][2]) audio.dispose(GAME.group.media[name][1]) end)'
end

M['stopTimerSoundNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name, duration = ' .. CALC(params[1]) .. ', ' .. CALC(params[2], '0')
    GAME.lua = GAME.lua .. ' audio.stopWithDelay(duration, {channel = GAME.group.media[name][2]})'
    GAME.lua = GAME.lua .. ' audio.dispose(GAME.group.media[name][1]) end)'
end

return M
