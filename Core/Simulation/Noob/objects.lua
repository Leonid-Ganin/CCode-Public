local EVENTS = require 'Core.Simulation.events'
local CALC = require 'Core.Simulation.calc'
local M = {}

M['newGifNoob'] = function(params)
    local name = CALC(params[1])
    local time = '(' .. CALC(params[2], '0') .. ') * 1000'
    local posX = '(SET_X(' .. CALC(params[3]) .. '))'
    local posY = '(SET_Y(' .. CALC(params[4]) .. '))'

    GAME.lua = GAME.lua .. ' pcall(function() local _link = ' .. name .. ' local name = _link'
    GAME.lua = GAME.lua .. ' local link, filter = other.getImage(_link) local width, height, count ='
    GAME.lua = GAME.lua .. ' GANIN.convert(DOC_DIR .. \'/\' .. link, system.pathForFile(\'gif.png\', system.TemporaryDirectory))'
    GAME.lua = GAME.lua .. ' width, height, count = unpack(GET_SIZE(link, system.TemporaryDirectory, width, height, count))'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[name]:removeSelf() GAME.group.objects[name] = nil end)'
    GAME.lua = GAME.lua .. ' local animations = {name = \'\', start = 1, count = count, time = ' .. time .. '}'
    GAME.lua = GAME.lua .. ' display.setDefault(\'magTextureFilter\', filter ~= \'linear\' and \'nearest\' or \'linear\')'
    GAME.lua = GAME.lua .. ' display.setDefault(\'minTextureFilter\', filter ~= \'linear\' and \'nearest\' or \'linear\')'
    GAME.lua = GAME.lua .. ' local imageSheet = graphics.newImageSheet(\'gif.png\', system.TemporaryDirectory,'
    GAME.lua = GAME.lua .. ' {width = width, height = height, numFrames = count})'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name] = display.newSprite(GAME.group, imageSheet, animations)'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].x, GAME.group.objects[name].y = ' .. posX .. ', ' .. posY
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._width = GAME.group.objects[name].width'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._height = GAME.group.objects[name].height'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._density = 1 GAME.group.objects[name]._bounce = 0'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._friction = 0 GAME.group.objects[name]._gravity = 1'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._body = \'\' GAME.group.objects[name]._hitbox = {}'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._link = link GAME.group.objects[name]._name = _link'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._touch = false GAME.group.objects[name]._tag = \'TAG\''
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._data = {} GAME.group.objects[name]._baseDir = system.TemporaryDirectory'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._listeners = {} GAME.group.objects[name]._gif = true GAME.group.objects[name]:play()'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._size, GAME.group.objects[name].name = 1, name end)'
end

M['setSizeNoob'] = function(params)
    local name = CALC(params[1])
    local size = '((' .. CALC(params[2]) .. ') / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() local name, size = ' .. name .. ', ' .. size .. ' if GAME.group.objects[name]._radius then'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].path.radius = GAME.group.objects[name]._radius * size elseif'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._gif then GAME.group.objects[name].xScale = size GAME.group.objects[name].yScale = size'
    GAME.lua = GAME.lua .. ' else GAME.group.objects[name].width = GAME.group.objects[name]._width * size'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].height = GAME.group.objects[name]._height * size'
    GAME.lua = GAME.lua .. ' end GAME.group.objects[name]._size = size end)'
end

M['updSizeNoob'] = function(params)
    local name = CALC(params[1])
    local size = '((' .. CALC(params[2]) .. ') / 100 + GAME.group.objects[name]._size)'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local size = ' .. size .. ' if GAME.group.objects[name]._radius'
    GAME.lua = GAME.lua .. ' then GAME.group.objects[name].path.radius = GAME.group.objects[name]._radius * size elseif'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._gif then GAME.group.objects[name].xScale = size GAME.group.objects[name].yScale = size'
    GAME.lua = GAME.lua .. ' else GAME.group.objects[name].width = GAME.group.objects[name]._width * size'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].height = GAME.group.objects[name]._height * size'
    GAME.lua = GAME.lua .. ' end GAME.group.objects[name]._size = size end)'
end

M['newObjectNoob'] = EVENTS.BLOCKS['newObject']
M['setPosNoob'] = EVENTS.BLOCKS['setPos']
M['setPosXNoob'] = EVENTS.BLOCKS['setPosX']
M['setPosYNoob'] = EVENTS.BLOCKS['setPosY']
M['setWidthNoob'] = EVENTS.BLOCKS['setWidth']
M['setHeightNoob'] = EVENTS.BLOCKS['setHeight']
M['setRotationNoob'] = EVENTS.BLOCKS['setRotation']
M['setRotationToNoob'] = EVENTS.BLOCKS['setRotationTo']
M['setAlphaNoob'] = EVENTS.BLOCKS['setAlpha']
M['updPosXNoob'] = EVENTS.BLOCKS['updPosX']
M['updPosYNoob'] = EVENTS.BLOCKS['updPosY']
M['updRotationNoob'] = EVENTS.BLOCKS['updRotation']
M['updAlphaNoob'] = EVENTS.BLOCKS['updAlpha']
M['updWidthNoob'] = EVENTS.BLOCKS['updWidth']
M['updHeightNoob'] = EVENTS.BLOCKS['updHeight']

return M
