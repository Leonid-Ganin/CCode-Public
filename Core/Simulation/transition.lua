local CALC = require 'Core.Simulation.calc'
local M = {}

if 'Переходы' then
    M['setTransitionListener'] = function(listener)
        return ' function(e) pcall(function() if GAME.hash == hash then ' .. listener .. '(e) end end) end'
    end

    M['setTransitionTo'] = function(params)
        local name, count = CALC(params[1]), CALC(params[4], '1')
        local direction, time, easing = CALC(params[3]), CALC(params[5], '1'), CALC(params[14], 'nil')
        local type, onComplete = CALC(params[2], 'GAME.group.objects'), CALC(params[15], 'a', true)
        local width, height, posX = CALC(params[6], 'nil'), CALC(params[7], 'nil'), CALC(params[8], 'nil')
        local posY, scaleX, scaleY = CALC(params[9], 'nil'), CALC(params[10], 'nil'), CALC(params[11], 'nil')
        local onPause, onResume = CALC(params[16], 'a', true), CALC(params[17], 'a', true)
        local onCancel, onRepeat = CALC(params[18], 'a', true), CALC(params[19], 'a', true)
        local alpha, rotation = CALC(params[12], 'nil'), CALC(params[13], 'nil')

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'
        local posX = posX == 'nil' and 'nil' or 'SET_X(' .. posX .. ', ' .. type .. '[name])'
        local posY = posY == 'nil' and 'nil' or 'SET_Y(' .. posY .. ', ' .. type .. '[name])'
        local scaleX = scaleX == 'nil' and 'nil' or scaleX .. ' / 100'
        local scaleY = scaleY == 'nil' and 'nil' or scaleY .. ' / 100'
        local alpha = alpha == 'nil' and 'nil' or alpha .. ' / 100'

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
        GAME.lua = GAME.lua .. ' transition.' .. direction .. '(obj, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ','
        GAME.lua = GAME.lua .. ' onPause = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ', time = '
        GAME.lua = GAME.lua .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ', x = ' .. posX .. ','
        GAME.lua = GAME.lua .. ' width = ' .. width .. ', height = ' .. height .. ', rotation = ' .. rotation .. ', alpha = ' .. alpha .. ','
        GAME.lua = GAME.lua .. ' xScale = ' .. scaleX .. ', yScale = ' .. scaleY .. ', y = ' .. posY .. '}) end if \'' .. type .. '\' =='
        GAME.lua = GAME.lua .. ' \'GAME.group.tags\' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2]'
        GAME.lua = GAME.lua .. ' == \'tags\' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
        GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
    end

    M['setTransitionPos'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
        local direction, count, time = CALC(params[3]), CALC(params[4], '1'), CALC(params[5], '1')
        local posX, posY, easing = CALC(params[6], 'nil'), CALC(params[7], 'nil'), CALC(params[8], 'nil')
        local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
        local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
        local onRepeat = CALC(params[13], 'a', true)

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'
        local posX = posX == 'nil' and 'nil' or 'SET_X(' .. posX .. ', ' .. type .. '[name])'
        local posY = posY == 'nil' and 'nil' or 'SET_Y(' .. posY .. ', ' .. type .. '[name])'

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
        GAME.lua = GAME.lua .. ' transition.' .. direction .. '(obj, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ','
        GAME.lua = GAME.lua .. ' onPause = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
        GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
        GAME.lua = GAME.lua .. ' x = ' .. posX .. ', y = ' .. posY .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\''
        GAME.lua = GAME.lua .. ' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2]'
        GAME.lua = GAME.lua .. ' == \'tags\' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
        GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
    end

    M['setTransitionSize'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
        local direction, count, time = CALC(params[3]), CALC(params[4], '1'), CALC(params[5], '1')
        local width, height, easing = CALC(params[6], 'nil'), CALC(params[7], 'nil'), CALC(params[8], 'nil')
        local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
        local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
        local onRepeat, size = CALC(params[13], 'a', true), 'nil'

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        if type == 'GAME.group.texts' then
            width, height, size = 'nil', 'nil', width ~= 'nil' and width or height
        end

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
        GAME.lua = GAME.lua .. ' transition.' .. direction .. '(obj, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
        GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ', size = ' .. size .. ','
        GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
        GAME.lua = GAME.lua .. ' width = ' .. width .. ', height = ' .. height .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\''
        GAME.lua = GAME.lua .. ' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2]'
        GAME.lua = GAME.lua .. ' == \'tags\' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
        GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
    end

    M['setTransitionScale'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
        local direction, count, time = CALC(params[3]), CALC(params[4], '1'), CALC(params[5], '1')
        local scaleX, scaleY, easing = CALC(params[6], 'nil'), CALC(params[7], 'nil'), CALC(params[8], 'nil')
        local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
        local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
        local onRepeat = CALC(params[13], 'a', true)

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'
        local scaleX = scaleX == 'nil' and 'nil' or scaleX .. ' / 100'
        local scaleY = scaleY == 'nil' and 'nil' or scaleY .. ' / 100'

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
        GAME.lua = GAME.lua .. ' transition.' .. direction .. '(obj, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ','
        GAME.lua = GAME.lua .. ' onPause = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
        GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
        GAME.lua = GAME.lua .. ' xScale = ' .. scaleX .. ', yScale = ' .. scaleY .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\''
        GAME.lua = GAME.lua .. ' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2]'
        GAME.lua = GAME.lua .. ' == \'tags\' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
        GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
    end

    M['setTransitionRotation'] = function(params)
        local name, type = CALC(params[1]), CALC(params[3], 'GAME.group.objects')
        local direction, count, time = CALC(params[2]), CALC(params[5], '1'), CALC(params[4], '1')
        local rotation, easing = CALC(params[6], 'nil'), CALC(params[7], 'nil')
        local onComplete, onPause = CALC(params[8], 'a', true), CALC(params[9], 'a', true)
        local onResume, onCancel = CALC(params[10], 'a', true), CALC(params[11], 'a', true)
        local onRepeat = CALC(params[12], 'a', true)

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
        GAME.lua = GAME.lua .. ' transition.' .. direction .. '(obj, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ','
        GAME.lua = GAME.lua .. ' onPause = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
        GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
        GAME.lua = GAME.lua .. ' rotation = ' .. rotation .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\''
        GAME.lua = GAME.lua .. ' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2]'
        GAME.lua = GAME.lua .. ' == \'tags\' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
        GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
    end

    M['setTransitionAlpha'] = function(params)
        local name, type = CALC(params[1]), CALC(params[3], 'GAME.group.objects')
        local direction, count, time = CALC(params[2]), CALC(params[5], '1'), CALC(params[4], '1')
        local alpha, easing = CALC(params[6], 'nil'), CALC(params[7], 'nil')
        local onComplete, onPause = CALC(params[8], 'a', true), CALC(params[9], 'a', true)
        local onResume, onCancel = CALC(params[10], 'a', true), CALC(params[11], 'a', true)
        local onRepeat = CALC(params[12], 'a', true)

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'
        local alpha = alpha == 'nil' and 'nil' or alpha .. ' / 100'

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
        GAME.lua = GAME.lua .. ' transition.' .. direction .. '(obj, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ','
        GAME.lua = GAME.lua .. ' onPause = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
        GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
        GAME.lua = GAME.lua .. ' alpha = ' .. alpha .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\''
        GAME.lua = GAME.lua .. ' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2]'
        GAME.lua = GAME.lua .. ' == \'tags\' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
        GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
    end

    M['setTransitionAngles'] = function(params)
        local name, count, angles = CALC(params[1]), CALC(params[5], '1'), CALC(params[6], 'nil')
        local direction, time, easing = CALC(params[2]), CALC(params[4], '1'), CALC(params[7], 'nil')
        local type, onComplete = CALC(params[3], 'GAME.group.objects'), CALC(params[8], 'a', true)
        local onPause, onResume = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
        local onCancel, onRepeat = CALC(params[11], 'a', true), CALC(params[12], 'a', true)

        local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
        local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        local onComplete = M['setTransitionListener'](onComplete)
        local onCancel = M['setTransitionListener'](onCancel)
        local onPause = M['setTransitionListener'](onPause)
        local onResume = M['setTransitionListener'](onResume)
        local onRepeat = M['setTransitionListener'](onRepeat)

        if type == 'GAME.group.tags' or type == 'GAME.group.objects' then
            GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name]'
            GAME.lua = GAME.lua .. ' local p = ' .. angles .. ' if type(p) ~= \'table\' then p = {} end'
            GAME.lua = GAME.lua .. ' local function doTo(obj) transition.' .. direction .. '(obj.path,'
            GAME.lua = GAME.lua .. ' {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause = ' .. onPause .. ','
            GAME.lua = GAME.lua .. ' onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ', x1 = p.x1, y1 = p.y1, x2 = p.x2, y2 = p.y2,'
            GAME.lua = GAME.lua .. ' x3 = p.x3, y3 = p.y3, x4 = p.x4, y4 = p.y4, time = ' .. time .. ' * 1000, iterations = ' .. count .. ','
            GAME.lua = GAME.lua .. ' transition = easing.' .. easing .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\''
            GAME.lua = GAME.lua .. ' then pcall(function() local function doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\''
            GAME.lua = GAME.lua .. ' then doTag(child[1]) else doTo(GAME.group[child[2]][child[1]])'
            GAME.lua = GAME.lua .. ' end end end doTag(name) end) else doTo(obj) end end)'
        end
    end

    M['setTransitionPause'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name]'
        GAME.lua = GAME.lua .. ' if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function()'
        GAME.lua = GAME.lua .. ' local function doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1])'
        GAME.lua = GAME.lua .. ' else transition.pause(child[1]) end end end doTag(name) end) else transition.pause(obj) end end)'
    end

    M['setTransitionResume'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name]'
        GAME.lua = GAME.lua .. ' if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function()'
        GAME.lua = GAME.lua .. ' local function doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1])'
        GAME.lua = GAME.lua .. ' else transition.resume(child[1]) end end end doTag(name) end) else transition.resume(obj) end end)'
    end

    M['setTransitionCancel'] = function(params)
        local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')

        if type == '(select[\'obj\']())' then type = 'GAME.group.objects'
        elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
        elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
        elseif type == '(select[\'widget\']())' then type = 'GAME.group.widgets'
        elseif type == '(select[\'snapshot\']())' then type = 'GAME.group.snapshots'
        elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name]'
        GAME.lua = GAME.lua .. ' if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function()'
        GAME.lua = GAME.lua .. ' local function doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1])'
        GAME.lua = GAME.lua .. ' else transition.cancel(child[1]) end end end doTag(name) end) else transition.cancel(obj) end end)'
    end

    M['setTransitionPauseAll'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() transition.pauseAll() end)'
    end

    M['setTransitionResumeAll'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() transition.resumeAll() end)'
    end

    M['setTransitionCancelAll'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() transition.cancelAll() end)'
    end
end

if 'Частицы' then
    M['newEmitter'] = function(params)
        local name = CALC(params[1])
        local type = UTF8.match(CALC(params[2]), '%(select%[\'(.+)\'%]') or 'air_stars'

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' pcall(function() GAME.group.particles[name]:removeSelf() end)'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name] = PARTICLE.newEmitter(\'Emitter/' .. type .. '.json\', nil, \'Emitter/\')'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].x, GAME.group.particles[name].y = CENTER_X, CENTER_Y'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._height = GAME.group.particles[name].height'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._width = GAME.group.particles[name].width'
        GAME.lua = GAME.lua .. ' GAME.group:insert(GAME.group.particles[name]) end)'
    end

    M['newCustomEmitter'] = function(params)
        local name = CALC(params[1])
        local emitter = CALC(params[2])
        local link = CALC(params[3])

        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' pcall(function() GAME.group.particles[name]:removeSelf() end)'
        GAME.lua = GAME.lua .. ' local params = ' .. emitter .. ' params.textureFileName = other.getImage(' .. link .. ')'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name] = display.newEmitter(params, system.DocumentsDirectory)'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].x, GAME.group.particles[name].y = CENTER_X, CENTER_Y'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._height = GAME.group.particles[name].height'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._width = GAME.group.particles[name].width'
        GAME.lua = GAME.lua .. ' GAME.group:insert(GAME.group.particles[name]) end)'
    end

    M['newLinearEmitter'] = function(params)
        local name, link = CALC(params[1]), CALC(params[2])
        local maxParticles, absolutePosition = CALC(params[3], '500'), CALC(params[4], 'nil')
        local angle, angleVariance = CALC(params[5], '0'), CALC(params[6], '0')
        local speed, speedVariance = CALC(params[7], '0'), CALC(params[8], '0')
        local sourcePositionVariancex, sourcePositionVariancey = CALC(params[9], '0'), CALC(params[10], '0')
        local gravityx, gravityy = CALC(params[11], '0'), CALC(params[12], '0')
        local radialAcceleration, radialAccelVariance = CALC(params[13], 'nil'), CALC(params[14], 'nil')
        local tangentialAcceleration, tangentialAccelVariance = CALC(params[15], 'nil'), CALC(params[16], 'nil')
        local particleLifespan, particleLifespanVariance = CALC(params[17], '2'), CALC(params[18], '0')
        local startParticleSize, startParticleSizeVariance = CALC(params[19], '20'), CALC(params[20], '0')
        local finishParticleSize, finishParticleSizeVariance = CALC(params[21], '5'), CALC(params[22], '0')
        local rotationStart, rotationStartVariance = CALC(params[23], '0'), CALC(params[24], '0')
        local rotationEnd, rotationEndVariance = CALC(params[25], '0'), CALC(params[26], '0')
        local startColor, startColorVariance = CALC(params[27], '{255, 255, 255}'), CALC(params[28], '{0, 0, 0}')
        local finishColor, finishColorVariance = CALC(params[29], '{0, 0, 0}'), CALC(params[30], '{0, 0, 0}')
        local blendFuncSource = UTF8.match(CALC(params[31]), '%(select%[\'GL(.+)\'%]') or '770'
        local blendFuncDestination = UTF8.match(CALC(params[32]), '%(select%[\'GL(.+)\'%]') or '1'

        GAME.lua = GAME.lua .. ' pcall(function() local name, params = ' .. name .. ', {emitterType = 0,'
        GAME.lua = GAME.lua .. ' textureFileName = other.getImage(' .. link .. '), duration = -1,'
        GAME.lua = GAME.lua .. ' absolutePosition = not ' .. absolutePosition .. ', maxParticles = ' .. maxParticles .. ','
        GAME.lua = GAME.lua .. ' angle = ' .. angle .. ', angleVariance = ' .. angleVariance .. ','
        GAME.lua = GAME.lua .. ' speed = ' .. speed .. ', speedVariance = ' .. speedVariance .. ','
        GAME.lua = GAME.lua .. ' sourcePositionVariancex = ' .. sourcePositionVariancex .. ','
        GAME.lua = GAME.lua .. ' sourcePositionVariancey = 0 - ' .. sourcePositionVariancey .. ','
        GAME.lua = GAME.lua .. ' gravityx = ' .. gravityx .. ', gravityy = 0 - ' .. gravityy .. ','
        GAME.lua = GAME.lua .. ' radialAcceleration = ' .. radialAcceleration .. ','
        GAME.lua = GAME.lua .. ' radialAccelVariance = ' .. radialAccelVariance .. ','
        GAME.lua = GAME.lua .. ' tangentialAcceleration = ' .. tangentialAcceleration .. ','
        GAME.lua = GAME.lua .. ' tangentialAccelVariance = ' .. tangentialAccelVariance .. ','
        GAME.lua = GAME.lua .. ' particleLifespan = ' .. particleLifespan .. ','
        GAME.lua = GAME.lua .. ' particleLifespanVariance = ' .. particleLifespanVariance .. ','
        GAME.lua = GAME.lua .. ' startParticleSize = ' .. startParticleSize .. ','
        GAME.lua = GAME.lua .. ' startParticleSizeVariance = ' .. startParticleSizeVariance .. ','
        GAME.lua = GAME.lua .. ' finishParticleSize = ' .. finishParticleSize .. ','
        GAME.lua = GAME.lua .. ' finishParticleSizeVariance = ' .. finishParticleSizeVariance .. ','
        GAME.lua = GAME.lua .. ' rotationStart = ' .. rotationStart .. ', rotationEnd = ' .. rotationEnd .. ','
        GAME.lua = GAME.lua .. ' blendFuncSource = ' .. blendFuncSource .. ', blendFuncDestination = ' .. blendFuncDestination .. '}'
        GAME.lua = GAME.lua .. ' local startColor, startColorVariance = ' .. startColor .. ', ' .. startColorVariance
        GAME.lua = GAME.lua .. ' local finishColor, finishColorVariance = ' .. finishColor .. ', ' .. finishColorVariance
        GAME.lua = GAME.lua .. ' params.startColorRed = startColor and startColor[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorGreen = startColor and startColor[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorBlue = startColor and startColor[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorVarianceRed = startColorVariance and startColorVariance[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorVarianceGreen = startColorVariance and startColorVariance[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorVarianceBlue = startColorVariance and startColorVariance[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorAlpha = 1 params.startColorVarianceAlpha = 0'
        GAME.lua = GAME.lua .. ' params.finishColorRed = finishColor and finishColor[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorGreen = finishColor and finishColor[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorBlue = finishColor and finishColor[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorVarianceRed = finishColorVariance and finishColorVariance[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorVarianceGreen = finishColorVariance and finishColorVariance[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorVarianceBlue = finishColorVariance and finishColorVariance[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorAlpha = 1 params.finishColorVarianceAlpha = 0'
        GAME.lua = GAME.lua .. ' pcall(function() GAME.group.particles[name]:removeSelf() end)'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name] = display.newEmitter(params, system.DocumentsDirectory)'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].x, GAME.group.particles[name].y = CENTER_X, CENTER_Y'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._height = GAME.group.particles[name].height'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._width = GAME.group.particles[name].width'
        GAME.lua = GAME.lua .. ' GAME.group:insert(GAME.group.particles[name]) end)'
    end

    M['newRadialEmitter'] = function(params)
        local name, link = CALC(params[1]), CALC(params[2])
        local maxParticles, absolutePosition = CALC(params[3], '500'), CALC(params[4], 'nil')
        local angle, angleVariance = CALC(params[5], '0'), CALC(params[6], '0')
        local maxRadius, maxRadiusVariance = CALC(params[7], '0'), CALC(params[8], '0')
        local minRadius, minRadiusVariance = CALC(params[9], '0'), CALC(params[10], '0')
        local rotatePerSecond, rotatePerSecondVariance = CALC(params[11], '0'), CALC(params[12], '0')
        local particleLifespan, particleLifespanVariance = CALC(params[13], '2'), CALC(params[14], '0')
        local startParticleSize, startParticleSizeVariance = CALC(params[15], '20'), CALC(params[16], '0')
        local finishParticleSize, finishParticleSizeVariance = CALC(params[17], '5'), CALC(params[18], '0')
        local rotationStart, rotationStartVariance = CALC(params[19], '0'), CALC(params[20], '0')
        local rotationEnd, rotationEndVariance = CALC(params[21], '0'), CALC(params[22], '0')
        local startColor, startColorVariance = CALC(params[23], '{255, 255, 255}'), CALC(params[24], '{0, 0, 0}')
        local finishColor, finishColorVariance = CALC(params[25], '{0, 0, 0}'), CALC(params[26], '{0, 0, 0}')
        local blendFuncSource = UTF8.match(CALC(params[27]), '%(select%[\'GL(.+)\'%]') or '770'
        local blendFuncDestination = UTF8.match(CALC(params[28]), '%(select%[\'GL(.+)\'%]') or '1'

        GAME.lua = GAME.lua .. ' pcall(function() local name, params = ' .. name .. ', {emitterType = 1,'
        GAME.lua = GAME.lua .. ' textureFileName = other.getImage(' .. link .. '), duration = -1,'
        GAME.lua = GAME.lua .. ' absolutePosition = not ' .. absolutePosition .. ', maxParticles = ' .. maxParticles .. ','
        GAME.lua = GAME.lua .. ' angle = ' .. angle .. ', angleVariance = ' .. angleVariance .. ','
        GAME.lua = GAME.lua .. ' maxRadius = ' .. maxRadius .. ', maxRadiusVariance = ' .. maxRadiusVariance .. ','
        GAME.lua = GAME.lua .. ' minRadius = ' .. minRadius .. ', minRadiusVariance = ' .. minRadiusVariance .. ','
        GAME.lua = GAME.lua .. ' rotatePerSecond = ' .. rotatePerSecond .. ','
        GAME.lua = GAME.lua .. ' rotatePerSecondVariance = ' .. rotatePerSecondVariance .. ','
        GAME.lua = GAME.lua .. ' particleLifespan = ' .. particleLifespan .. ','
        GAME.lua = GAME.lua .. ' particleLifespanVariance = ' .. particleLifespanVariance .. ','
        GAME.lua = GAME.lua .. ' startParticleSize = ' .. startParticleSize .. ','
        GAME.lua = GAME.lua .. ' startParticleSizeVariance = ' .. startParticleSizeVariance .. ','
        GAME.lua = GAME.lua .. ' finishParticleSize = ' .. finishParticleSize .. ','
        GAME.lua = GAME.lua .. ' finishParticleSizeVariance = ' .. finishParticleSizeVariance .. ','
        GAME.lua = GAME.lua .. ' rotationStart = ' .. rotationStart .. ', rotationEnd = ' .. rotationEnd .. ','
        GAME.lua = GAME.lua .. ' blendFuncSource = ' .. blendFuncSource .. ', blendFuncDestination = ' .. blendFuncDestination .. '}'
        GAME.lua = GAME.lua .. ' local startColor, startColorVariance = ' .. startColor .. ', ' .. startColorVariance
        GAME.lua = GAME.lua .. ' local finishColor, finishColorVariance = ' .. finishColor .. ', ' .. finishColorVariance
        GAME.lua = GAME.lua .. ' params.startColorRed = startColor and startColor[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorGreen = startColor and startColor[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorBlue = startColor and startColor[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorVarianceRed = startColorVariance and startColorVariance[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorVarianceGreen = startColorVariance and startColorVariance[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorVarianceBlue = startColorVariance and startColorVariance[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.startColorAlpha = 1 params.startColorVarianceAlpha = 0'
        GAME.lua = GAME.lua .. ' params.finishColorRed = finishColor and finishColor[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorGreen = finishColor and finishColor[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorBlue = finishColor and finishColor[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorVarianceRed = finishColorVariance and finishColorVariance[1] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorVarianceGreen = finishColorVariance and finishColorVariance[2] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorVarianceBlue = finishColorVariance and finishColorVariance[3] / 255 or nil'
        GAME.lua = GAME.lua .. ' params.finishColorAlpha = 1 params.finishColorVarianceAlpha = 0'
        GAME.lua = GAME.lua .. ' pcall(function() GAME.group.particles[name]:removeSelf() end)'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name] = display.newEmitter(params, system.DocumentsDirectory)'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].x, GAME.group.particles[name].y = CENTER_X, CENTER_Y'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._height = GAME.group.particles[name].height'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]._width = GAME.group.particles[name].width'
        GAME.lua = GAME.lua .. ' GAME.group:insert(GAME.group.particles[name]) end)'
    end

    M['removeEmitter'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' GAME.group.particles[name]:removeSelf() GAME.group.particles[name] = nil end)'
    end

    M['removeAllEmitter'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() for _, v in pairs(GAME.group.particles) do'
        GAME.lua = GAME.lua .. ' pcall(function() v:removeSelf() v = nil end) end end)'
    end

    M['setEmitterPos'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].x = SET_X(' .. CALC(params[2]) .. ')'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].y = SET_Y(' .. CALC(params[3]) .. ') end)'
    end

    M['setEmitterSize'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name, size = ' .. CALC(params[1]) .. ', ' .. CALC(params[2]) .. ' / 100'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].width = GAME.group.particles[name]._width * size'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].height = GAME.group.particles[name]._height * size end)'
    end

    M['setEmitterSpeed'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name, speed = ' .. CALC(params[1]) .. ', ' .. CALC(params[2])
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].speed = speed end)'
    end

    M['setEmitterRotation'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name, angle = ' .. CALC(params[1]) .. ', ' .. CALC(params[2])
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].angle = angle end)'
    end

    M['setEmitterGravity'] = function(params)
        GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].gravityx = ' .. CALC(params[2])
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].gravityy = 0 - ' .. CALC(params[3]) .. ' end)'
    end

    M['setEmitterStartColor'] = function(params)
        local name = CALC(params[1])
        local colors = CALC(params[2], '{255, 255, 255}')
        local alpha = CALC(params[3], '100')

        GAME.lua = GAME.lua .. ' pcall(function() local name, colors, alpha = ' .. name .. ', ' .. colors .. ', ' .. alpha
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorRed = colors[1] / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorGreen = colors[2] / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorBlue = colors[3] / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorAlpha = alpha / 100 end)'
    end

    M['setEmitterFinishColor'] = function(params)
        local name = CALC(params[1])
        local colors = CALC(params[2], '{255, 255, 255}')
        local alpha = CALC(params[3], '100')

        GAME.lua = GAME.lua .. ' pcall(function() local name, colors, alpha = ' .. name .. ', ' .. colors .. ', ' .. alpha
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorRed = colors[1] / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorGreen = colors[2] / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorBlue = colors[3] / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorAlpha = alpha / 100 end)'
    end

    M['setEmitterStartRGB'] = function(params)
        local name = CALC(params[1])
        local r, g, b = CALC(params[2], '255'), CALC(params[3], '255'), CALC(params[4], '255')
        local alpha = CALC(params[5], '100')

        GAME.lua = GAME.lua .. ' pcall(function() local name, alpha = ' .. name .. ', ' .. alpha
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorRed = ' .. r .. ' / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorGreen = ' .. g .. ' / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorBlue = ' .. b .. ' / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].startColorAlpha = alpha / 100 end)'
    end

    M['setEmitterFinishRGB'] = function(params)
        local name = CALC(params[1])
        local r, g, b = CALC(params[2], '255'), CALC(params[3], '255'), CALC(params[4], '255')
        local alpha = CALC(params[5], '100')

        GAME.lua = GAME.lua .. ' pcall(function() local name, alpha = ' .. name .. ', ' .. alpha
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorRed = ' .. r .. ' / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorGreen = ' .. g .. ' / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorBlue = ' .. b .. ' / 255'
        GAME.lua = GAME.lua .. ' GAME.group.particles[name].finishColorAlpha = alpha / 100 end)'
    end
end

return M
