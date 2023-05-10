local CALC = require 'Core.Simulation.calc'
local M = {}

M['requestApi'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local args = type(args) == \'table\' and JSON.encode(args) or \'{}\''
    GAME.lua = GAME.lua .. ' args = args:gsub(\'\\n\', \'\\\\n\'):gsub(\'\\r\', \'\'):gsub(\'\\\'\', \'\\\\\\\'\')'
    GAME.lua = GAME.lua .. ' local p1 = ' .. CALC(params[1], nil, nil, true)
    GAME.lua = GAME.lua .. ' p1 = UTF8.gsub(p1, \'setFocus\', \'display.getCurrentStage():setFocus\')'
    GAME.lua = GAME.lua .. ' p1 = UTF8.gsub(p1, \'setfenv\', \'print\') p1 = UTF8.gsub(p1, \'loadstring\', \'print\')'
    GAME.lua = GAME.lua .. ' p1 = UTF8.gsub(p1, \'currentStage\', \'fps\') p1 = UTF8.gsub(p1, \'getCurrentStage\', \'getDefault\')'
    GAME.lua = GAME.lua .. ' G_fun, G_device, G_other, G_math, G_prop = fun, device, other, math, prop'
    GAME.lua = GAME.lua .. ' return loadstring(\'local G = {} G.args = JSON.decode(\\\'\' .. args .. \'\\\') for key, value in'
    GAME.lua = GAME.lua .. ' pairs(GET_GLOBAL_TABLE()) do G[key] = value end setfenv(1, G) require = function(path)'
    GAME.lua = GAME.lua .. ' return (path:find(\\\'%.\\\') or path:find(\\\'io\\\') or path:find(\\\'os\\\') or path:find(\\\'lfs\\\')'
    GAME.lua = GAME.lua .. ' or path:find(\\\'starter\\\')) and {} or print5(path) end \' .. p1)() end)'
end

M['requestApiRes'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local link = other.getResource(' .. CALC(params[1]) .. ')'
    GAME.lua = GAME.lua .. ' local args = type(args) == \'table\' and JSON.encode(args) or \'{}\''
    GAME.lua = GAME.lua .. ' args = args:gsub(\'\\n\', \'\\\\n\'):gsub(\'\\r\', \'\'):gsub(\'\\\'\', \'\\\\\\\'\') local p1 ='
    GAME.lua = GAME.lua .. ' READ_FILE(DOC_DIR .. \'/\' .. link) p1 = UTF8.gsub(p1, \'setFocus\', \'display.getCurrentStage():setFocus\')'
    GAME.lua = GAME.lua .. ' p1 = UTF8.gsub(p1, \'setfenv\', \'print\') p1 = UTF8.gsub(p1, \'loadstring\', \'print\')'
    GAME.lua = GAME.lua .. ' p1 = UTF8.gsub(p1, \'currentStage\', \'fps\') p1 = UTF8.gsub(p1, \'getCurrentStage\', \'getDefault\')'
    GAME.lua = GAME.lua .. ' G_fun, G_device, G_other, G_math, G_prop = fun, device, other, math, prop'
    GAME.lua = GAME.lua .. ' return loadstring(\'local G = {} G.args = JSON.decode(\\\'\' .. args .. \'\\\') for key, value in'
    GAME.lua = GAME.lua .. ' pairs(GET_GLOBAL_TABLE()) do G[key] = value end setfenv(1, G) require = function(path)'
    GAME.lua = GAME.lua .. ' return (path:find(\\\'%.\\\') or path:find(\\\'io\\\') or path:find(\\\'os\\\') or path:find(\\\'lfs\\\')'
    GAME.lua = GAME.lua .. ' or path:find(\\\'starter\\\')) and {} or print5(path) end \' .. p1)() end)'
end

M['requestFun'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. '() end)'
end

M['requestFunNoob'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. '() end)'
end

M['requestFunParams'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. '(' .. CALC(params[2]) .. ') end)'
end

M['setFocus'] = function(params)
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(GAME.group.objects[' .. CALC(params[1], 'nil') .. '])'
end

M['setFocusMultitouch'] = function(params)
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(GAME.group.objects['
    GAME.lua = GAME.lua .. CALC(params[1], 'nil') .. '], ' .. CALC(params[2], 'nil') .. ')'
end

M['activateMultitouch'] = function(params)
    GAME.lua = GAME.lua .. ' GAME.multi = true system.activate(\'multitouch\')'
end

M['deactivateMultitouch'] = function(params)
    GAME.lua = GAME.lua .. ' GAME.multi = false system.deactivate(\'multitouch\')'
end

M['toastShort'] = function(params)
    GAME.lua = GAME.lua .. ' GANIN.toast(' .. CALC(params[1], '\'\'') .. ', 0)'
end

M['toastLong'] = function(params)
    GAME.lua = GAME.lua .. ' GANIN.toast(' .. CALC(params[1], '\'\'') .. ', 1)'
end

M['returnValue'] = function(params)
    GAME.lua = GAME.lua .. ' return ' .. CALC(params[1])
end

M['requestExit'] = function(params)
    if CURRENT_LINK ~= 'App' then
        GAME.lua = GAME.lua .. ' pcall(function() if GAME.isStarted then EXITS.game() end end)'
    else
        GAME.lua = GAME.lua .. ' pcall(function() native.requestExit() end)'
    end
end

M['setListener'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' table.insert(GAME.group.objects[name]._listeners, ' .. CALC(params[2], 'a', true) .. ')'
    GAME.lua = GAME.lua .. ' if not GAME.group.objects[name].hasListener then GAME.group.objects[name].hasListener = true'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]:addEventListener(\'touch\','
    GAME.lua = GAME.lua .. ' function(e) local isComplete, result = pcall(function() if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' e.isTouch = e.target._touch GAME.group.const.touch_x, GAME.group.const.touch_y = e.x, e.y'
    GAME.lua = GAME.lua .. ' if e.phase == \'began\' then e.target._touch, GAME.group.const.touch = true, true'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, e.id)'
    GAME.lua = GAME.lua .. ' else display.getCurrentStage():setFocus(e.target) end'
    GAME.lua = GAME.lua .. ' elseif e.phase == \'ended\' or e.phase == \'cancelled\' then'
    GAME.lua = GAME.lua .. ' e.target._touch, GAME.group.const.touch = false, false'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, nil) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(nil) for name, object in pairs(GAME.group.objects) do'
    GAME.lua = GAME.lua .. ' if object._touch then GAME.group.objects[name]._touch = false end end end end'
    GAME.lua = GAME.lua .. ' e = {_ccode_event = e, name = e.target.name, x = GET_X(e.x, e.target), y = GET_Y(e.y, e.target),'
    GAME.lua = GAME.lua .. ' xStart = GET_X(e.xStart, e.target), yStart = GET_Y(e.yStart, e.target),'
    GAME.lua = GAME.lua .. ' id = e.id, xDelta = e.xDelta, yDelta = e.yDelta, phase = e.phase}'
    GAME.lua = GAME.lua .. ' local responses = {} for i = 1, #GAME.group.objects[name]._listeners do'
    GAME.lua = GAME.lua .. ' local response = GAME.group.objects[name]._listeners[i](e) if response ~= nil then'
    GAME.lua = GAME.lua .. ' table.insert(responses, response) end end return responses[#responses]'
    GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then return result end return true end) end end)'
end

M['setListener3'] = function(params)
    M['setListener']({params[1], params[2]})
    M['setListener']({params[1], params[3]})
    M['setListener']({params[1], params[4]})
end

M['setLocalCollision'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].collision = function(s, e) if GAME.hash == hash then local isComplete, result ='
    GAME.lua = GAME.lua .. ' pcall(function() return ' .. CALC(params[2], 'a', true) .. '(e) end) return isComplete'
    GAME.lua = GAME.lua .. ' and result or false end end GAME.group.objects[name]:addEventListener(\'collision\') end)'
end

M['setLocalPreCollision'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].preCollision = function(s, e) if GAME.hash == hash then e.phase = \'pre\' local'
    GAME.lua = GAME.lua .. ' isComplete, result = pcall(function() return ' .. CALC(params[2], 'a', true) .. '(e) end) return isComplete'
    GAME.lua = GAME.lua .. ' and result or false end end GAME.group.objects[name]:addEventListener(\'preCollision\') end)'
end

M['setLocalPostCollision'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].postCollision = function(s, e) if GAME.hash == hash then e.phase = \'post\' local'
    GAME.lua = GAME.lua .. ' isComplete, result = pcall(function() return ' .. CALC(params[2], 'a', true) .. '(e) end) return isComplete'
    GAME.lua = GAME.lua .. ' and result or false end end GAME.group.objects[name]:addEventListener(\'postCollision\') end)'
end

M['setGlobalCollision'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.collis, function(e) if GAME.hash == hash then local isCompl, result ='
    GAME.lua = GAME.lua .. ' pcall(function() return ' .. CALC(params[1], 'a', true) .. '(e) end) return isCompl and result or false'
    GAME.lua = GAME.lua .. ' end end) Runtime:addEventListener(\'collision\', GAME.group.collis[#GAME.group.collis]) end)'
end

M['setGlobalPreCollision'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.collis, function(e) if GAME.hash == hash then e.phase = \'pre\' local'
    GAME.lua = GAME.lua .. ' isCompl, result = pcall(function() return ' .. CALC(params[1], 'a', true) .. '(e) end) return isCompl and'
    GAME.lua = GAME.lua .. ' result or false end end) Runtime:addEventListener(\'preCollision\', GAME.group.collis[#GAME.group.collis]) end)'
end

M['setGlobalPostCollision'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.collis, function(e) if GAME.hash == hash then e.phase = \'post\' local'
    GAME.lua = GAME.lua .. ' isCompl, result = pcall(function() return ' .. CALC(params[1], 'a', true) .. '(e) end) return isCompl and'
    GAME.lua = GAME.lua .. ' result or false end end) Runtime:addEventListener(\'postCollision\', GAME.group.collis[#GAME.group.collis]) end)'
end

M['timer'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.ts, timer.new(' .. CALC(params[1], '0.001')
    GAME.lua = GAME.lua .. ' * 1000, ' .. CALC(params[2], '1') .. ', function(e) pcall(function() if GAME.hash == hash then'
end

M['timerName'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.timers[' .. CALC(params[1]) .. '] = timer.new(' .. CALC(params[2], '0.001')
    GAME.lua = GAME.lua .. ' * 1000, ' .. CALC(params[3], '1') .. ', function(e) pcall(function() if GAME.hash == hash then'
end

M['timerEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) end)) end)'
end

M['timerNameEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) end) end)'
end

M['if'] = function(params)
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() if ' .. CALC(params[1]) .. ' then'
end

M['ifElse'] = function(params)
    GAME.lua = GAME.lua .. ' elseif ' .. CALC(params[1]) .. ' then'
end

M['ifEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then if result == \'_ccode_break\' then return end return result end'
end

M['forever'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() timer.new(1, 0, function(e) pcall(function() if GAME.hash == hash then'
end

M['foreverEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) end) end)'
end

M['for'] = function(params)
    local from, to = CALC(params[1]), CALC(params[2])
    local var, step = CALC(params[3], 'a', true), CALC(params[4], '1')

    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function()'
    GAME.lua = GAME.lua .. ' for i = ' .. from .. ', ' .. to .. ', ' .. step .. ' do ' .. var .. ' = i'
end

M['forEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then return result end'
end

M['foreach'] = function(params)
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() for key, value in pairs(' .. CALC(params[1], 'a', true) .. ')'
    GAME.lua = GAME.lua .. ' do ' .. CALC(params[2], 'a', true) .. ' = value ' .. CALC(params[3], 'a', true) .. ' = key'
end

M['foreachEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then return result end'
end

M['while'] = function(params)
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() while ' .. CALC(params[1]) .. ' do'
end

M['whileEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then return result end'
end

M['repeat'] = function(params)
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() for i = 1, ' .. CALC(params[1]) .. ' do'
end

M['repeatEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end) if isComplete and result ~= nil then return result end'
end

M['break'] = function(params)
    GAME.lua = GAME.lua .. ' return \'_ccode_break\''
end

M['timerPause'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() timer.pause(GAME.group.timers[' .. CALC(params[1]) .. ']) end)'
end

M['timerResume'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() timer.resume(GAME.group.timers[' .. CALC(params[1]) .. ']) end)'
end

M['timerCancel'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() timer.cancel(GAME.group.timers[' .. CALC(params[1]) .. ']) end)'
end

M['timerPauseAll'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() for _, v in pairs(GAME.group.timers) do pcall(function() timer.pause(v) end) end end)'
    GAME.lua = GAME.lua .. ' pcall(function() for _, v in ipairs(GAME.group.ts) do pcall(function() timer.pause(v) end) end end)'
end

M['timerResumeAll'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() for _, v in pairs(GAME.group.timers) do pcall(function() timer.resume(v) end) end end)'
    GAME.lua = GAME.lua .. ' pcall(function() for _, v in ipairs(GAME.group.ts) do pcall(function() timer.resume(v) end) end end)'
end

M['timerCancelAll'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() for _, v in pairs(GAME.group.timers) do pcall(function() timer.cancel(v) end) end end)'
    GAME.lua = GAME.lua .. ' pcall(function() for _, v in ipairs(GAME.group.ts) do pcall(function() timer.cancel(v) end) end end)'
end

M['setBackgroundColor'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local colors = ' .. CALC(params[1], '{0}')
    GAME.lua = GAME.lua .. ' display.setDefault(\'background\', colors[1]/255, colors[2]/255, colors[3]/255) end)'
end

M['setBackgroundRGB'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() display.setDefault(\'background\','
    GAME.lua = GAME.lua .. CALC(params[1]) .. '/255, ' .. CALC(params[2]) .. '/255, ' .. CALC(params[3]) .. '/255) end)'
end

M['setBackgroundHEX'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local hex = UTF8.trim(tostring(' .. CALC(params[1], '\'000000\'') .. '))'
    GAME.lua = GAME.lua .. ' if UTF8.sub(hex, 1, 1) == \'#\' then hex = UTF8.sub(hex, 2, 7) end'
    GAME.lua = GAME.lua .. ' if UTF8.len(hex) ~= 6 then hex = \'FFFFFF\' end local errorHex = false'
    GAME.lua = GAME.lua .. ' local filterHex = {\'0\', \'1\', \'2\', \'3\', \'4\', \'5\', \'6\','
    GAME.lua = GAME.lua .. ' \'7\', \'8\', \'9\', \'A\', \'B\', \'C\', \'D\', \'E\', \'F\'}'
    GAME.lua = GAME.lua .. ' for indexHex = 1, 6 do local symHex = UTF8.upper(UTF8.sub(hex, indexHex, indexHex))'
    GAME.lua = GAME.lua .. ' for i = 1, #filterHex do if symHex == filterHex[i] then break elseif i == #filterHex then errorHex = true end end'
    GAME.lua = GAME.lua .. ' end if errorHex then hex = \'FFFFFF\' end local r, g, b = unpack(math.hex(hex))'
    GAME.lua = GAME.lua .. ' display.setDefault(\'background\', r/255, g/255, b/255) end)'
end

M['setPortraitOrientation'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() setOrientationApp({type = \'portrait\', lis = ' .. CALC(params[1], 'a', true) .. '}) end)'
end

M['setLandscapeOrientation'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() setOrientationApp({type = \'landscape\', lis = ' .. CALC(params[1], 'a', true) .. '}) end)'
end

M['newAlert'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() native.showAlert(' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. ', '
    GAME.lua = GAME.lua .. CALC(params[3]) .. ', function(e) pcall(function() if GAME.hash == hash then '
    GAME.lua = GAME.lua .. CALC(params[4], 'a', true) .. '(e) end end) end) end)'
end

M['scheduleNotification'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() NOTIFICATIONS.scheduleNotification(' .. CALC(params[2]) .. ','
    GAME.lua = GAME.lua .. ' {alert = ' .. CALC(params[1]) .. '}) end)'
end

M['cancelNotification'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() NOTIFICATIONS.cancelNotification() end)'
end

M['turnOnAccelerometer'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.accelerometers, function(e) pcall(function()'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then ' .. CALC(params[1], 'a', true) .. '(e) end end) end)'
    GAME.lua = GAME.lua .. ' Runtime:addEventListener(\'accelerometer\', GAME.group.accelerometers[#GAME.group.accelerometers]) end)'
end

M['setAccelerometerFrequency'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() system.setAccelerometerInterval(' .. CALC(params[1], '10') .. ') end)'
end

M['readFileRes'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local link = other.getResource(' .. CALC(params[1]) .. ') ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = READ_FILE(DOC_DIR .. \'/\' .. link, ' .. CALC(params[3]) .. ') end)'
end

M['pasteboardCopy'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() PASTEBOARD.copy(\'string\', tostring(' .. CALC(params[1]) .. ')) end)'
end

M['pasteboardPaste'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() PASTEBOARD.paste(function(e) ' .. CALC(params[1], 'a', true)
    GAME.lua = GAME.lua .. ' = e.string or e.url or ' .. CALC(params[1], 'a', true) .. ' end) end)'
end

M['pasteboardClear'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() PASTEBOARD.clear() end)'
end

return M
