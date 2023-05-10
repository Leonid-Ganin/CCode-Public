local CALC = require 'Core.Simulation.calc'
local M = {}

M['newText'] = function(params)
    local name, text = CALC(params[1]), CALC(params[2])
    local font, size = CALC(params[3], '\'ubuntu\''), CALC(params[4], '36')
    local colors, alpha = CALC(params[5], '{255, 255, 255}'), CALC(params[6], '100')
    local posX = '(SET_X(' .. CALC(params[7]) .. '))'
    local posY = '(SET_Y(' .. CALC(params[8]) .. '))'

    GAME.lua = GAME.lua .. ' pcall(function() local name, colors, font = ' .. name .. ', ' .. colors .. ', other.getFont(' .. font .. ')'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[name]:removeSelf() end) GAME.group.texts[name] ='
    GAME.lua = GAME.lua .. ' display.newText(GAME.group, tostring(' .. text .. '), ' .. posX .. ', ' .. posY .. ', font, ' .. size .. ')'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[name]:setFillColor(colors[1]/255, colors[2]/255, colors[3]/255) end)'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[name].alpha = ' ..  alpha .. ' / 100 end)'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._density = 1 GAME.group.texts[name]._bounce = 0'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._friction = 0 GAME.group.texts[name]._gravity = 1'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._body = \'\' GAME.group.texts[name]._hitbox = {}'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._touch = \'\' GAME.group.texts[name]._tag = \'TAG\''
    GAME.lua = GAME.lua .. ' GAME.group:insert(GAME.group.texts[name]) GAME.group.texts[name].name = name end)'
end

M['newText2'] = function(params)
    local name, text = CALC(params[1]), CALC(params[2])
    local font, size = CALC(params[3], '\'ubuntu\''), CALC(params[4], '36')
    local colors, align = CALC(params[5], '{255, 255, 255}'), CALC(params[6], '\'center\'')
    local width, height = CALC(params[7]), CALC(params[8])
    local posX = '(SET_X(' .. CALC(params[9]) .. '))'
    local posY = '(SET_Y(' .. CALC(params[10]) .. '))'

    GAME.lua = GAME.lua .. ' pcall(function() local name, colors, font = ' .. name .. ', ' .. colors .. ', other.getFont(' .. font .. ')'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[name]:removeSelf() end)'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name] = display.newText({parent = GAME.group, text = tostring(' .. text .. '),'
    GAME.lua = GAME.lua .. ' x = ' .. posX .. ', y = ' .. posY .. ', width = ' .. width .. ', height = ' .. height .. ','
    GAME.lua = GAME.lua .. ' align = ' .. align .. ', font = font, fontSize = ' .. size .. '}) GAME.group:insert(GAME.group.texts[name])'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[name]:setFillColor(colors[1]/255, colors[2]/255, colors[3]/255) end)'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._density = 1 GAME.group.texts[name]._bounce = 0'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._friction = 0 GAME.group.texts[name]._gravity = 1'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._body = \'\' GAME.group.texts[name]._hitbox = {}'
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]._touch = \'\' GAME.group.texts[name]._tag = \'TAG\''
    GAME.lua = GAME.lua .. ' GAME.group.texts[name].name = name end)'
end

M['setVar'] = function(params)
    local var = CALC(params[1], 'a', true)
    local value = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() ' .. var .. ' = ' .. value .. ' end)'
end

M['updVar'] = function(params)
    local var = CALC(params[1], 'a', true)
    local value = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() ' .. var .. ' = ' .. var .. ' + ' .. value .. ' end)'
end

M['setObjVar'] = function(params)
    local key = CALC(params[1], '\'KEY\'', true)
    local obj, value = 'GAME.group.objects[' .. CALC(params[2]) .. ']._data', CALC(params[3])
    local key = UTF8.sub(key, 1, 2) ~= 't[' and '[' .. key .. ']' or UTF8.sub(key, 2)

    GAME.lua = GAME.lua .. ' pcall(function() ' .. obj .. key .. ' = ' .. value .. ' end)'
end

M['addTable'] = function(params)
    local key = CALC(params[1], '\'KEY\'', true)
    local table, value = CALC(params[2], 'a', true), CALC(params[3])
    local key = UTF8.sub(key, 1, 2) ~= 't[' and '[' .. key .. ']' or UTF8.sub(key, 2)

    GAME.lua = GAME.lua .. ' pcall(function() if ' .. table .. ' then ' .. table .. key .. ' = ' .. value
    GAME.lua = GAME.lua .. ' else ' .. table .. ' = {} ' .. table .. key .. ' = ' .. value .. ' end end)'
end

M['insertTable'] = function(params)
    local key = CALC(params[1], '\'KEY\'', true)
    local table, value = CALC(params[2], 'a', true), CALC(params[3])
    local key = UTF8.sub(key, 1, 2) ~= 't[' and '[' .. key .. ']' or UTF8.sub(key, 2)
    local temp_key, nestedI, countI, keys = key, 0, 0, {}

    while true do
        local sym = UTF8.sub(key, 1, 1) key, countI = UTF8.sub(key, 2), countI + 1
        if sym == '[' then nestedI = nestedI + 1 elseif sym == ']' then nestedI = nestedI - 1 end
        if nestedI == 0 then _G.table.insert(keys, UTF8.sub(temp_key, 2, countI - 1) or '')
        temp_key = UTF8.sub(temp_key, countI + 1) key, countI = temp_key, 0 end if key == '' then break end
    end

    for i = 1, #keys - 1 do
        table = table .. '[' .. keys[i] .. ']'
    end key = keys[#keys]

    GAME.lua = GAME.lua .. ' pcall(function() if ' .. table .. ' then table.insert(' .. table .. ', ' .. key .. ', ' .. value .. ')'
    GAME.lua = GAME.lua .. ' else ' .. table .. ' = {} table.insert(' .. table .. ', ' .. key .. ', ' .. value .. ') end end)'
end

M['removeTable'] = function(params)
    local key = CALC(params[2], '\'KEY\'', true)
    local table = CALC(params[1], 'a', true)
    local key = UTF8.sub(key, 1, 2) ~= 't[' and '[' .. key .. ']' or UTF8.sub(key, 2)
    local temp_key, nestedI, countI, keys = key, 0, 0, {}

    while true do
        local sym = UTF8.sub(key, 1, 1) key, countI = UTF8.sub(key, 2), countI + 1
        if sym == '[' then nestedI = nestedI + 1 elseif sym == ']' then nestedI = nestedI - 1 end
        if nestedI == 0 then _G.table.insert(keys, UTF8.sub(temp_key, 2, countI - 1) or '')
        temp_key = UTF8.sub(temp_key, countI + 1) key, countI = temp_key, 0 end if key == '' then break end
    end

    for i = 1, #keys - 1 do
        table = table .. '[' .. keys[i] .. ']'
    end key = keys[#keys]

    GAME.lua = GAME.lua .. ' pcall(function() table.remove(' .. table .. ', ' .. key .. ') end)'
end

M['resetTable'] = function(params)
    local table = CALC(params[1], 'a', true)
    local value = CALC(params[2], '\'{}\'')

    GAME.lua = GAME.lua .. ' pcall(function() ' .. table .. ' = JSON.decode(' .. value .. ') end)'
end

M['saveValue'] = function(params)
    local key = CALC(params[1])
    local value = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() local data = GET_GAME_SAVE(CURRENT_LINK)'
    GAME.lua = GAME.lua .. ' data[tostring(' .. key .. ')] = ' .. value .. ' SET_GAME_SAVE(CURRENT_LINK, data) end)'
end

M['setRandomSeed'] = function(params)
    local seed = CALC(params[1])

    GAME.lua = GAME.lua .. ' pcall(function() local seed = ' .. seed .. ' SEED = math.sum(UTF8.byte(tostring(seed), 1,'
    GAME.lua = GAME.lua .. ' UTF8.len(tostring(seed)))) math.randomseed(SEED) end)'
end

M['setText'] = function(params)
    local name = CALC(params[1])
    local text = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].text = tostring(' .. text .. ') end)'
end

M['setTextSize'] = function(params)
    local name = CALC(params[1])
    local size = CALC(params[2], '36')

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].size = ' .. size .. ' end)'
end

M['setTextPos'] = function(params)
    local name = CALC(params[1])
    local posX = '(SET_X(' .. CALC(params[2]) .. ', GAME.group.texts[name]))'
    local posY = '(SET_Y(' .. CALC(params[3]) .. ', GAME.group.texts[name]))'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].x = ' .. posX
    GAME.lua = GAME.lua .. ' GAME.group.texts[name].y = ' .. posY .. ' end)'
end

M['setTextPosX'] = function(params)
    local name = CALC(params[1])
    local posX = '(SET_X(' .. CALC(params[2]) .. ', GAME.group.texts[name]))'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].x = ' .. posX .. ' end)'
end

M['setTextPosY'] = function(params)
    local name = CALC(params[1])
    local posY = '(SET_Y(' .. CALC(params[2]) .. ', GAME.group.texts[name]))'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].y = ' .. posY .. ' end)'
end

M['setTextRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].rotation = ' .. rotation .. ' end)'
end

M['setTextAnchor'] = function(params)
    local name = CALC(params[1])
    local anchorX = CALC(params[2], '50') .. '/ 100'
    local anchorY = CALC(params[3], '50') .. '/ 100'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].anchorX = ' .. anchorX
    GAME.lua = GAME.lua .. ' GAME.group.texts[name].anchorY = ' .. anchorY .. ' end)'
end

M['setTextAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '(' .. CALC(params[2]) .. ' / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].alpha = ' .. alpha .. ' end)'
end

M['setTextColor'] = function(params)
    local name = CALC(params[1])
    local colors = CALC(params[2], '{255, 255, 255}')

    GAME.lua = GAME.lua .. ' pcall(function() local colors = ' .. colors
    GAME.lua = GAME.lua .. ' GAME.group.texts[' .. name .. ']:setFillColor(colors[1]/255, colors[2]/255, colors[3]/255) end)'
end

M['setTextRGB'] = function(params)
    local name = CALC(params[1])
    local r, g, b = CALC(params[2], '255'), CALC(params[3], '255'), CALC(params[4], '255')

    GAME.lua = GAME.lua .. ' pcall(function() local r, g, b = ' .. r .. '/255, ' .. g .. '/255, ' .. b .. '/255'
    GAME.lua = GAME.lua .. ' GAME.group.texts[' .. name .. ']:setFillColor(r, g, b) end)'
end

M['setTextHEX'] = function(params)
    local name = CALC(params[1])
    local hex = CALC(params[2], '\'FFFFFF\'')

    GAME.lua = GAME.lua .. ' pcall(function() local hex = UTF8.trim(tostring(' .. hex .. '))'
    GAME.lua = GAME.lua .. ' if UTF8.sub(hex, 1, 1) == \'#\' then hex = UTF8.sub(hex, 2, 7) end'
    GAME.lua = GAME.lua .. ' if UTF8.len(hex) ~= 6 then hex = \'FFFFFF\' end local errorHex = false'
    GAME.lua = GAME.lua .. ' local filterHex = {\'0\', \'1\', \'2\', \'3\', \'4\', \'5\', \'6\','
    GAME.lua = GAME.lua .. ' \'7\', \'8\', \'9\', \'A\', \'B\', \'C\', \'D\', \'E\', \'F\'}'
    GAME.lua = GAME.lua .. ' for indexHex = 1, 6 do local symHex = UTF8.upper(UTF8.sub(hex, indexHex, indexHex))'
    GAME.lua = GAME.lua .. ' for i = 1, #filterHex do if symHex == filterHex[i] then break elseif i == #filterHex then errorHex = true end end'
    GAME.lua = GAME.lua .. ' end if errorHex then hex = \'FFFFFF\' end local r, g, b = unpack(math.hex(hex))'
    GAME.lua = GAME.lua .. ' GAME.group.texts[' .. name .. ']:setFillColor(r/255, g/255, b/255) end)'
end

M['updTextPosX'] = function(params)
    local name = CALC(params[1])
    local posX = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].x'
    GAME.lua = GAME.lua .. ' = GAME.group.texts[name].x + ' .. posX .. ' end)'
end

M['updTextPosY'] = function(params)
    local name = CALC(params[1])
    local posY = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].y'
    GAME.lua = GAME.lua .. ' = GAME.group.texts[name].y - ' .. posY .. ' end)'
end

M['updTextRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = '(' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].rotation'
    GAME.lua = GAME.lua .. ' = GAME.group.texts[name].rotation + ' .. rotation .. ' end)'
end

M['updTextAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '((' .. CALC(params[2]) .. ') / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name .. ' GAME.group.texts[name].alpha'
    GAME.lua = GAME.lua .. ' = GAME.group.texts[name].alpha + ' .. alpha .. ' end)'
end

M['hideText'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. CALC(params[1]) .. '].isVisible = false end)'
end

M['showText'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. CALC(params[1]) .. '].isVisible = true end)'
end

M['removeText'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.texts[name]:removeSelf() GAME.group.texts[name] = nil end)'
end

M['frontText'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. CALC(params[1]) .. ']:toFront() end)'
end

M['backText'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. CALC(params[1]) .. ']:toBack() end)'
end

M['saveValueNoob'] = function(params)
    local key = CALC(params[1], 'a', true)
    local value, key = CALC(params[1]), UTF8.sub(key, 7, UTF8.len(key) - 1)

    GAME.lua = GAME.lua .. ' pcall(function() local data = GET_GAME_SAVE(CURRENT_LINK)'
    GAME.lua = GAME.lua .. ' data[' .. key .. '] = ' .. value .. ' SET_GAME_SAVE(CURRENT_LINK, data) end)'
end

M['readValueNoob'] = function(params)
    local key = CALC(params[1], 'a', true)
    local var, key = key, UTF8.sub(key, 7, UTF8.len(key) - 1)

    GAME.lua = GAME.lua .. ' pcall(function() local data = GET_GAME_SAVE(CURRENT_LINK) ' .. var
    GAME.lua = GAME.lua .. ' = data[' .. key .. '] or ' .. var .. ' end)'
end

M['setVarNoob'] = M['setVar']
M['updVarNoob'] = M['updVar']

return M
