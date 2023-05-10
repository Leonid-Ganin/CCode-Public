local EVENTS = require 'Core.Simulation.events'
local CALC = require 'Core.Simulation.calc'
local M = {}

M['setTransitionPosNoob'] = function(params)
    local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
    local time, posX, posY = CALC(params[3], '1'), CALC(params[4], 'nil'), CALC(params[5], 'nil')

    if type == '(select[\'pic\']())' then type = 'GAME.group.objects'
    elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
    elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
    elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

    local posX = posX == 'nil' and 'nil' or type == 'GAME.group.groups' and posX or 'SET_X(' .. posX .. ')'
    local posY = posY == 'nil' and 'nil' or type == 'GAME.group.groups' and '0 - (' .. posY .. ')' or 'SET_Y(' .. posY .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
    GAME.lua = GAME.lua .. ' transition.to(obj, {time = ' .. time .. ' * 1000, x = ' .. posX .. ', y = ' .. posY .. '}) end if'
    GAME.lua = GAME.lua .. ' \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function() local function doTag(tag) for _, child'
    GAME.lua = GAME.lua .. ' in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1]) else'
    GAME.lua = GAME.lua .. ' doTo(child[1]) end end end doTag(name) end) else doTo(obj) end end)'
end

M['setTransitionSizeNoob'] = function(params)
    local name, type, size = CALC(params[1]), CALC(params[2], 'GAME.group.objects'), 'nil'
    local time, width, height = CALC(params[3], '1'), CALC(params[4], 'nil'), CALC(params[5], 'nil')

    if type == '(select[\'pic\']())' then type = 'GAME.group.objects'
    elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
    elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
    elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

    if type == 'GAME.group.texts' then
        width, height, size = 'nil', 'nil', width ~= 'nil' and width or height
    end

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
    GAME.lua = GAME.lua .. ' transition.to(obj, {time = ' .. time .. ' * 1000, width = ' .. width .. ', height = ' .. height .. ','
    GAME.lua = GAME.lua .. ' size = ' .. size .. '}) end if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function() local function'
    GAME.lua = GAME.lua .. ' doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1]) else'
    GAME.lua = GAME.lua .. ' doTo(child[1]) end end end doTag(name) end) else doTo(obj) end end)'
end

M['setTransitionScaleNoob'] = function(params)
    local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
    local time, scaleX, scaleY = CALC(params[3], '1'), CALC(params[4], 'nil'), CALC(params[5], 'nil')

    if type == '(select[\'pic\']())' then type = 'GAME.group.objects'
    elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
    elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
    elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

    local scaleX = scaleX == 'nil' and 'nil' or scaleX .. ' / 100'
    local scaleY = scaleY == 'nil' and 'nil' or scaleY .. ' / 100'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
    GAME.lua = GAME.lua .. ' transition.to(obj, {time = ' .. time .. ' * 1000, xScale = ' .. scaleX .. ', yScale = ' .. scaleY .. '}) end'
    GAME.lua = GAME.lua .. ' if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function() local function doTag(tag) for _, child'
    GAME.lua = GAME.lua .. ' in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1]) else'
    GAME.lua = GAME.lua .. ' doTo(child[1]) end end end doTag(name) end) else doTo(obj) end end)'
end

M['setTransitionRotationNoob'] = function(params)
    local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
    local time, rotation = CALC(params[3], '1'), CALC(params[4], 'nil')

    if type == '(select[\'pic\']())' then type = 'GAME.group.objects'
    elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
    elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
    elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
    GAME.lua = GAME.lua .. ' transition.to(obj, {time = ' .. time .. ' * 1000, rotation = ' .. rotation .. '})'
    GAME.lua = GAME.lua .. ' end if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function() local function'
    GAME.lua = GAME.lua .. ' doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1]) else'
    GAME.lua = GAME.lua .. ' doTo(child[1]) end end end doTag(name) end) else doTo(obj) end end)'
end

M['setTransitionAlphaNoob'] = function(params)
    local name, type = CALC(params[1]), CALC(params[2], 'GAME.group.objects')
    local time, alpha = CALC(params[3], '1'), CALC(params[4], 'nil')
    local alpha = alpha == 'nil' and 'nil' or alpha .. ' / 100'

    if type == '(select[\'pic\']())' then type = 'GAME.group.objects'
    elseif type == '(select[\'text\']())' then type = 'GAME.group.texts'
    elseif type == '(select[\'group\']())' then type = 'GAME.group.groups'
    elseif type == '(select[\'tag\']())' then type = 'GAME.group.tags' end

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local obj = ' .. type .. '[name] local function doTo(obj)'
    GAME.lua = GAME.lua .. ' transition.to(obj, {time = ' .. time .. ' * 1000, alpha = ' .. alpha .. '})'
    GAME.lua = GAME.lua .. ' end if \'' .. type .. '\' == \'GAME.group.tags\' then pcall(function() local function'
    GAME.lua = GAME.lua .. ' doTag(tag) for _, child in ipairs(obj) do if child[2] == \'tags\' then doTag(child[1]) else'
    GAME.lua = GAME.lua .. ' doTo(child[1]) end end end doTag(name) end) else doTo(obj) end end)'
end

return M
