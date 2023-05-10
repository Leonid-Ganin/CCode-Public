local CALC = require 'Core.Simulation.calc'
local M = {}

M['createServer'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.stops, SERVER.createServer('
    GAME.lua = GAME.lua .. CALC(params[1], '22222') .. ', function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' return ' .. CALC(params[2], 'a', true) .. '(e) end end)) end)'
end

M['connectToServer'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.stops, CLIENT.createClientLoop('
    GAME.lua = GAME.lua .. CALC(params[1], 'nil') .. ', ' .. CALC(params[2], '22222') .. ','
    GAME.lua = GAME.lua .. ' function(e) if GAME.hash == hash then return ' .. CALC(params[3], 'a', true) .. '(e) end end)) end)'
end

M['requestFirebase'] = function(params, method)
    local link, value = CALC(params[1]), (method == 'GET' or method == 'DELETE') and 'nil' or CALC(params[2])
    local key = (method == 'GET' or method == 'DELETE') and CALC(params[2], '\'\'') or CALC(params[3], '\'\'')
    local link = '\'https://\' .. tostring(' .. link .. ') .. \'.firebaseio.com/\' .. tostring(' .. key .. ') .. \'.json\''
    local listener = (method == 'GET' or method == 'DELETE') and CALC(params[3], 'a', true)  or CALC(params[4], 'a', true)

    GAME.lua = GAME.lua .. ' pcall(function() local value = ' .. value
    GAME.lua = GAME.lua .. ' if type(value) == \'number\' or type(value) == \'boolean\' then value = tostring(value)'
    GAME.lua = GAME.lua .. ' elseif type(value) == \'string\' then value = \'"\' .. value .. \'"\''
    GAME.lua = GAME.lua .. ' elseif type(value) == \'table\' then value = JSON.encode(value) end'
    GAME.lua = GAME.lua .. ' table.insert(GAME.group.networks,'
    GAME.lua = GAME.lua .. ' network.request(' .. link .. ', \'' .. method .. '\', function(e) pcall(function() if GAME.hash'
    GAME.lua = GAME.lua .. ' == hash then ' .. listener .. '(e.response) end end) end, {body = value})) end)'
end

M['requestNetwork'] = function(params, method)
    local link, body, timeout = CALC(params[1]), CALC(params[2], '\'{}\''), CALC(params[7], '30')
    local headers, listener = CALC(params[3], '{}'), CALC(params[4], 'a', true)
    local progress = UTF8.match(CALC(params[5]), '%(select%[\'(.+)\'%]') or 'nil'
    local progress = progress == 'progressDownload' and 'download' or progress == 'progressUpload' and 'upload' or 'nil'
    local redirect = UTF8.match(CALC(params[6]), '%(select%[\'(.+)\'%]') or 'nil'
    local redirect = redirect == 'redirectsFalse' and 'false' or 'true'

    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.networks,'
    GAME.lua = GAME.lua .. ' network.request(' .. link .. ', \'' .. method .. '\','
    GAME.lua = GAME.lua .. ' function(e) pcall(function() if GAME.hash == hash then ' .. listener .. '(e) end end) end, {body'
    GAME.lua = GAME.lua .. ' = ' .. body .. ', headers = ' .. headers .. ', progress = ' .. progress .. ','
    GAME.lua = GAME.lua .. ' handleRedirects = ' .. redirect .. ', timeout = ' .. timeout .. '})) end)'
end

M['requestGET'] = function(params) M['requestNetwork'](params, 'GET') end
M['requestPOST'] = function(params) M['requestNetwork'](params, 'POST') end
M['requestPUT'] = function(params) M['requestNetwork'](params, 'PUT') end
M['requestPATCH'] = function(params) M['requestNetwork'](params, 'PATCH') end
M['requestHEAD'] = function(params) M['requestNetwork'](params, 'HEAD') end
M['requestDELETE'] = function(params) M['requestNetwork'](params, 'DELETE') end
M['firebasePUT'] = function(params, method) M['requestFirebase'](params, 'PUT') end
M['firebasePATCH'] = function(params, method) M['requestFirebase'](params, 'PATCH') end
M['firebaseGET'] = function(params, method) M['requestFirebase'](params, 'GET') end
M['firebaseDELETE'] = function(params, method) M['requestFirebase'](params, 'DELETE') end

M['openURL'] = function(params, method)
    GAME.lua = GAME.lua .. ' pcall(function() system.openURL(' .. CALC(params[1]) .. ')  end)'
end

M['initAdsStartApp'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() STARTAPP.init(function(e) if GAME.hash == hash then ' .. CALC(params[2]) .. '(e)'
    GAME.lua = GAME.lua .. ' end end, {appId = ' .. CALC(params[1]) .. '}) end)'
end

M['loadAdsStartApp'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() STARTAPP.load(' .. CALC(params[1]) .. ') end)'
end

M['showAdsStartApp'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() STARTAPP.show(' .. CALC(params[1]) .. ') end)'
end

return M
