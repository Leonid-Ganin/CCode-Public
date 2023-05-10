local CALC = require 'Core.Simulation.calc'
local M = {}

M['newObject'] = function(params)
    local name = CALC(params[1])
    local link = #params == 3 and name or CALC(params[2])
    local posX = '(SET_X(' .. CALC(#params == 3 and params[2] or params[3]) .. '))'
    local posY = '(SET_Y(' .. CALC(#params == 3 and params[3] or params[4]) .. '))'

    GAME.lua = GAME.lua .. ' pcall(function() local _link = ' .. link .. ' local name = ' .. (#params == 3 and '_link' or name)
    GAME.lua = GAME.lua .. ' local link, filter = other.getImage(_link) pcall(function()'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]:removeSelf() GAME.group.objects[name] = nil end)'
    GAME.lua = GAME.lua .. ' display.setDefault(\'magTextureFilter\', filter ~= \'linear\' and \'nearest\' or \'linear\')'
    GAME.lua = GAME.lua .. ' display.setDefault(\'minTextureFilter\', filter ~= \'linear\' and \'nearest\' or \'linear\')'
    GAME.lua = GAME.lua .. ' local image, sheetParams = display.newImage(link, system.DocumentsDirectory), {link, system.DocumentsDirectory}'
    GAME.lua = GAME.lua .. ' if filter == \'vector\' then local index = #GAME.group.textures + 1'
    GAME.lua = GAME.lua .. ' GAME.group.textures[index] = SVG.newTexture({filename = link, baseDir = system.DocumentsDirectory})'
    GAME.lua = GAME.lua .. ' sheetParams = {GAME.group.textures[index].filename, GAME.group.textures[index].baseDir} end'
    GAME.lua = GAME.lua .. ' local imageSheet = graphics.newImageSheet(sheetParams[1], sheetParams[2],'
    GAME.lua = GAME.lua .. ' {width = image.width, height = image.height, numFrames = 1}) image:removeSelf() image = nil'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name] = display.newSprite(GAME.group, imageSheet, {name = \'\', frames = {1}})'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].x, GAME.group.objects[name].y = ' .. posX .. ', ' .. posY
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._width = GAME.group.objects[name].width'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._height = GAME.group.objects[name].height'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._density = 1 GAME.group.objects[name]._bounce = 0'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._friction = 0 GAME.group.objects[name]._gravity = 1'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._body = \'\' GAME.group.objects[name]._hitbox = {}'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._link = link GAME.group.objects[name]._name = _link'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._touch = false GAME.group.objects[name]._tag = \'TAG\''
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._data = {} GAME.group.objects[name]._baseDir = system.DocumentsDirectory'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._listeners = {}'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._size, GAME.group.objects[name].name = 1, name end)'
end

M['newSprite'] = function(params)
    local name, link = CALC(params[1]), CALC(params[2])
    local width, height = CALC(params[3]), CALC(params[4])
    local count, animations = CALC(params[5]), CALC(params[6], '{}')
    local posX = '(SET_X(' .. CALC(params[7]) .. '))'
    local posY = '(SET_Y(' .. CALC(params[8]) .. '))'

    GAME.lua = GAME.lua .. ' pcall(function() local _link, name, count = ' .. link .. ', ' .. name .. ', ' .. count
    GAME.lua = GAME.lua .. ' local link, filter = other.getImage(_link) local animations = {}'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[name]:removeSelf() GAME.group.objects[name] = nil end)'
    GAME.lua = GAME.lua .. ' pcall(function() local anims = ' .. animations
    GAME.lua = GAME.lua .. ' if type(anims) ~= \'table\' then animations = GAME.group.animations[anims]'
    GAME.lua = GAME.lua .. ' elseif #anims == 0 then animations = {name = \'\', start = 1, count = count}'
    GAME.lua = GAME.lua .. ' elseif #anims == 1 then animations = GAME.group.animations[anims[1]]'
    GAME.lua = GAME.lua .. ' else for _, v in ipairs(anims) do table.insert(animations, GAME.group.animations[v]) end end'
    GAME.lua = GAME.lua .. ' if not animations or IS_ZERO_TABLE(animations) then animations = {name = \'\', start = 1, count = count} end end)'
    GAME.lua = GAME.lua .. ' display.setDefault(\'magTextureFilter\', filter ~= \'linear\' and \'nearest\' or \'linear\')'
    GAME.lua = GAME.lua .. ' display.setDefault(\'minTextureFilter\', filter ~= \'linear\' and \'nearest\' or \'linear\')'
    GAME.lua = GAME.lua .. ' local sheetParams = {link, system.DocumentsDirectory}'
    GAME.lua = GAME.lua .. ' if filter == \'vector\' then local index = #GAME.group.textures + 1'
    GAME.lua = GAME.lua .. ' GAME.group.textures[index] = SVG.newTexture({filename = link, baseDir = system.DocumentsDirectory})'
    GAME.lua = GAME.lua .. ' sheetParams = {GAME.group.textures[index].filename, GAME.group.textures[index].baseDir} end'
    GAME.lua = GAME.lua .. ' local imageSheet = graphics.newImageSheet(sheetParams[1], sheetParams[2],'
    GAME.lua = GAME.lua .. ' {width = ' .. width .. ', height = ' .. height .. ', numFrames = count})'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name] = display.newSprite(GAME.group, imageSheet, animations)'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].x, GAME.group.objects[name].y = ' .. posX .. ', ' .. posY
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._width = GAME.group.objects[name].width'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._height = GAME.group.objects[name].height'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._density = 1 GAME.group.objects[name]._bounce = 0'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._friction = 0 GAME.group.objects[name]._gravity = 1'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._body = \'\' GAME.group.objects[name]._hitbox = {}'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._link = link GAME.group.objects[name]._name = _link'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._touch = false GAME.group.objects[name]._tag = \'TAG\''
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._data = {} GAME.group.objects[name]._baseDir = system.DocumentsDirectory'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._listeners = {}'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._size, GAME.group.objects[name].name = 1, name end)'
end

M['newGif'] = function(params)
    local name = CALC(params[1])
    local link = CALC(params[2])
    local posX = '(SET_X(' .. CALC(params[3]) .. '))'
    local posY = '(SET_Y(' .. CALC(params[4]) .. '))'

    GAME.lua = GAME.lua .. ' pcall(function() local _link = ' .. link .. ' local name = ' .. name
    GAME.lua = GAME.lua .. ' local link, filter = other.getImage(_link) local width, height, count ='
    GAME.lua = GAME.lua .. ' GANIN.convert(DOC_DIR .. \'/\' .. link, system.pathForFile(\'gif.png\', system.TemporaryDirectory))'
    GAME.lua = GAME.lua .. ' width, height, count = unpack(GET_SIZE(link, system.TemporaryDirectory, width, height, count))'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[name]:removeSelf() GAME.group.objects[name] = nil end)'
    GAME.lua = GAME.lua .. ' local animations = {name = \'\', start = 1, count = count}'
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
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._listeners = {}'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._size, GAME.group.objects[name].name = 1, name end)'
end

M['setPos'] = function(params)
    local name = CALC(params[1])
    local posX = '(SET_X(' .. CALC(params[2]) .. ', GAME.group.objects[name]))'
    local posY = '(SET_Y(' .. CALC(params[3]) .. ', GAME.group.objects[name]))'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].x = ' .. posX
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].y = ' .. posY .. ' end)'
end

M['setPosX'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1]) .. ' GAME.group.objects[name].x ='
    GAME.lua = GAME.lua .. ' SET_X(' .. CALC(params[2]) .. ', GAME.group.objects[name]) end)'
end

M['setPosY'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1]) .. ' GAME.group.objects[name].y ='
    GAME.lua = GAME.lua .. ' SET_Y(' .. CALC(params[2]) .. ', GAME.group.objects[name]) end)'
end

M['setWidth'] = function(params)
    local name = CALC(params[1])
    local width = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' if GAME.group.objects[name]._radius then'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].path.radius = ' .. width .. ' else'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].width = ' .. width .. ' end end)'
end

M['setHeight'] = function(params)
    local name = CALC(params[1])
    local height = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' if GAME.group.objects[name]._radius then'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].path.radius = ' .. height .. ' else'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].height = ' .. height .. ' end end)'
end

M['setSize'] = function(params)
    local name = CALC(params[1])
    local size = '((' .. CALC(params[2]) .. ') / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() local name, size = ' .. name .. ', ' .. size .. ' if GAME.group.objects[name]._radius then'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].path.radius = GAME.group.objects[name]._radius * size'
    GAME.lua = GAME.lua .. ' else GAME.group.objects[name].width = GAME.group.objects[name]._width * size'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].height = GAME.group.objects[name]._height * size'
    GAME.lua = GAME.lua .. ' end GAME.group.objects[name]._size = size end)'
end

M['setRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].rotation = ' .. rotation .. ' end)'
end

M['setRotationTo'] = function(params)
    local name1 = CALC(params[1])
    local name2 = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() local obj1, obj2 = GAME.group.objects[' .. name1 .. '], GAME.group.objects[' .. name2 .. ']'
    GAME.lua = GAME.lua .. ' obj1.rotation = math.atan2(obj2.y - obj1.y, obj2.x - obj1.x) end)'
end

M['setAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '((' .. CALC(params[2]) .. ') / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].alpha = ' .. alpha .. ' end)'
end

M['setAnchor'] = function(params)
    local name = CALC(params[1])
    local anchorX = CALC(params[2], '50') .. '/ 100'
    local anchorY = CALC(params[3], '50') .. '/ 100'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].anchorX = ' .. anchorX
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].anchorY = ' .. anchorY .. ' end)'
end

M['updPosX'] = function(params)
    local name = CALC(params[1])
    local posX = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].x ='
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].x + ' .. posX .. ' end)'
end

M['updPosY'] = function(params)
    local name = CALC(params[1])
    local posY = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].y ='
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].y - ' .. posY .. ' end)'
end

M['updSize'] = function(params)
    local name = CALC(params[1])
    local size = '((' .. CALC(params[2]) .. ') / 100 + GAME.group.objects[name]._size)'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' local size = ' .. size .. ' if GAME.group.objects[name]._radius'
    GAME.lua = GAME.lua .. ' then GAME.group.objects[name].path.radius = GAME.group.objects[name]._radius * size'
    GAME.lua = GAME.lua .. ' else GAME.group.objects[name].width = GAME.group.objects[name]._width * size'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].height = GAME.group.objects[name]._height * size'
    GAME.lua = GAME.lua .. ' end GAME.group.objects[name]._size = size end)'
end

M['updRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].rotation ='
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].rotation + ' .. rotation .. ' end)'
end

M['updAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '((' .. CALC(params[2]) .. ') / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].alpha ='
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].alpha + ' .. alpha .. ' end)'
end

M['updWidth'] = function(params)
    local name = CALC(params[1])
    local width = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].width ='
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].width + ' .. width .. ' end)'
end

M['updHeight'] = function(params)
    local name = CALC(params[1])
    local height = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.objects[name].height ='
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].height + ' .. height .. ' end)'
end

M['hideObject'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. CALC(params[1]) .. '].isVisible = false end)'
end

M['showObject'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. CALC(params[1]) .. '].isVisible = true end)'
end

M['removeObject'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]:removeSelf() GAME.group.objects[name] = nil end)'
end

M['frontObject'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. CALC(params[1]) .. ']:toFront() end)'
end

M['backObject'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. CALC(params[1]) .. ']:toBack() end)'
end

return M
