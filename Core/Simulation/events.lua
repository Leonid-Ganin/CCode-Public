local CALC = require 'Core.Simulation.calc'
local M, LIST_TYPES  = {BLOCKS = {}}, {'filters'}

for i = 3, 14 do
    M.BLOCKS = table.merge(M.BLOCKS, require('Core.Simulation.' .. INFO.listType[i]))
end

for i = 1, #LIST_TYPES do
    M.BLOCKS = table.merge(M.BLOCKS, require('Core.Simulation.' .. LIST_TYPES[i]))
end

M.requestNestedBlock = function(nested)
    for i = 1, #nested do
        local name = nested[i].name
        local params = nested[i].params
        pcall(function() M.BLOCKS[name](params) end)
    end
end

M['onStart'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() local function event() local varsE, tablesE = {}, {}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end event() end)'
end

M['onFun'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function()'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then local varsE, tablesE = {}, {}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onFunParams'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(...) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = COPY_TABLE_P({...}, true)'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onCondition'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.conditions, function() if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} if ' .. CALC(params[1]) .. ' then'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end) end)'
end

M['onUpdateVar'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true, nil, true) .. ' = function()'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then local varsE, tablesE = {}, {}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onTouchBegan'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(e) if e.phase == \'began\' then if GAME.hash'
    GAME.lua = GAME.lua .. ' == hash then local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = COPY_TABLE(e, true)'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onTouchEnded'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' if (e.phase == \'ended\' or e.phase == \'cancelled\') and e._ccode_event.isTouch then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = COPY_TABLE(e, true)'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onTouchMoved'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' if e.phase == \'moved\' and e._ccode_event.isTouch then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = COPY_TABLE(e, true)'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onTouchDisplayBegan'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.displays, function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' if e.phase == \'began\' then local varsE, tablesE = {}, {} ' .. CALC(params[1], 'a', true)
    GAME.lua = GAME.lua .. ' = {_ccode_event = e, name = \'_ccode_display\', x = GET_X(e.x), y = GET_Y(e.y), xStart = GET_X(e.xStart),'
    GAME.lua = GAME.lua .. ' yStart = GET_Y(e.yStart), id = e.id, xDelta = e.xDelta, yDelta = e.yDelta}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end) end)'
end

M['onTouchDisplayEnded'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.displays, function(e) if GAME.hash == hash then if e.phase == \'ended\''
    GAME.lua = GAME.lua .. ' or e.phase == \'cancelled\' then local varsE, tablesE = {}, {} ' .. CALC(params[1], 'a', true)
    GAME.lua = GAME.lua .. ' = {_ccode_event = e, name = \'_ccode_display\', x = GET_X(e.x), y = GET_Y(e.y), xStart = GET_X(e.xStart),'
    GAME.lua = GAME.lua .. ' yStart = GET_Y(e.yStart), id = e.id, xDelta = e.xDelta, yDelta = e.yDelta}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end) end)'
end

M['onTouchDisplayMoved'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.displays, function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' if e.phase == \'moved\' then local varsE, tablesE = {}, {} ' .. CALC(params[1], 'a', true)
    GAME.lua = GAME.lua .. ' = {_ccode_event = e, name = \'_ccode_display\', x = GET_X(e.x), y = GET_Y(e.y), xStart = GET_X(e.xStart),'
    GAME.lua = GAME.lua .. ' yStart = GET_Y(e.yStart), id = e.id, xDelta = e.xDelta, yDelta = e.yDelta}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end) end)'
end

M['onFirebase'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(response) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = response'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onFileDownload'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' if e.phase == \'ended\' then local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = e'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onSliderMoved'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(value) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = value'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onSwitchCallback'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(e) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE = {}, {} ' .. CALC(params[2], 'a', true) .. ' = e.target.isOn'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onWebViewCallback'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p, n) if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {name = n, type = p.type, url = p.url, errorCode = p.errorCode, errorMessage = p.errorMessage}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end)'
end

M['onFieldBegan'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p, n)'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then if p.phase == \'began\' then local varsE, tablesE,'
    GAME.lua = GAME.lua .. ' p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true) .. ' = {name = n}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onFieldEditing'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p, n) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'editing\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {numDeleted = p.numDeleted, startPosition = p.startPosition, name = n,'
    GAME.lua = GAME.lua .. ' text = p.text, oldText = p.oldText, newCharacters = p.newCharacters}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onFieldEnded'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p, n) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'ended\' or p.phase == \'submitted\' then local varsE, tablesE, p = {}, {},'
    GAME.lua = GAME.lua .. ' COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true) .. ' = {name = n, text = GAME.group.widgets[n].text}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onBackPress'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.needBack = false table.insert(GAME.group.backs, function() pcall(function()'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then local varsE, tablesE = {}, {}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end) end) end)'
end

M['onSuspend'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.suspends, function() pcall(function()'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then local varsE, tablesE = {}, {}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end) end) end)'
end

M['onResume'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() table.insert(GAME.group.resumes, function() pcall(function()'
    GAME.lua = GAME.lua .. ' if GAME.hash == hash then local varsE, tablesE = {}, {}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end) end) end)'
end

M['onLocalCollisionBegan'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'began\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, selfElement = p.selfElement, otherElement = p.otherElement, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction, tangentSpeed'
    GAME.lua = GAME.lua .. ' = p.contact.tangentSpeed}, name = p.target.name, other = p.other.name,'
    GAME.lua = GAME.lua .. ' x = GET_X(p.x, p.target), y = GET_Y(p.y, p.target)}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onLocalCollisionEnded'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'ended\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, selfElement = p.selfElement, otherElement = p.otherElement, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction, tangentSpeed'
    GAME.lua = GAME.lua .. ' = p.contact.tangentSpeed}, name = p.target.name, other = p.other.name, x = 0, y = 0}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onLocalPreCollision'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'pre\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, selfElement = p.selfElement, otherElement = p.otherElement, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction},'
    GAME.lua = GAME.lua .. ' name = p.target.name, other = p.other.name, x = GET_X(p.x, p.target), y = GET_Y(p.y, p.target)}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onLocalPostCollision'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'post\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, selfElement = p.selfElement, otherElement = p.otherElement, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction}, name'
    GAME.lua = GAME.lua .. ' = p.target.name, other = p.other.name, x = GET_X(p.x, p.target),'
    GAME.lua = GAME.lua .. ' y = GET_Y(p.y, p.target), force = p.force, friction = p.friction}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onGlobalCollisionBegan'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'began\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, element1 = p.element1, element2 = p.element2, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction, tangentSpeed'
    GAME.lua = GAME.lua .. ' = p.contact.tangentSpeed}, name1 = p.object1.name, name2 = p.object2.name,'
    GAME.lua = GAME.lua .. ' x = GET_X(p.x, p.target), y = GET_Y(p.y, p.target)}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onGlobalCollisionEnded'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'ended\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, element1 = p.element1, element2 = p.element2, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction, tangentSpeed'
    GAME.lua = GAME.lua .. ' = p.contact.tangentSpeed}, name1 = p.object1.name, name2 = p.object2.name, x = 0, y = 0}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onGlobalPreCollision'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'pre\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, element1 = p.element1, element2 = p.element2, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction},'
    GAME.lua = GAME.lua .. ' name1 = p.object1.name, name2 = p.object2.name,'
    GAME.lua = GAME.lua .. ' x = GET_X(p.x, p.target), y = GET_Y(p.y, p.target)}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onGlobalPostCollision'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[1], 'a', true) .. ' = function(p) if GAME.hash == hash then if'
    GAME.lua = GAME.lua .. ' p.phase == \'post\' then local varsE, tablesE, p = {}, {}, COPY_TABLE(p, true) ' .. CALC(params[2], 'a', true)
    GAME.lua = GAME.lua .. ' = {contact = p.contact, element1 = p.element1, element2 = p.element2, _contact ='
    GAME.lua = GAME.lua .. ' {isTouching = p.contact.isTouching, bounce = p.contact.bounce, friction = p.contact.friction}, name1'
    GAME.lua = GAME.lua .. ' = p.object1.name, name2 = p.object2.name, x = GET_X(p.x, p.target),'
    GAME.lua = GAME.lua .. ' y = GET_Y(p.y, p.target), force = p.force, friction = p.friction}'
    M.requestNestedBlock(nested) GAME.lua = GAME.lua .. ' end end end end)'
end

M['onTouchBeganNoob'] = function(nested, params)
    GAME.lua = GAME.lua .. ' timer.new(1, 1, function() pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]:addEventListener(\'touch\', function(e)'
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' e.target._touch = e.phase ~= \'ended\' and e.phase ~= \'cancelled\' GAME.group.const.touch'
    GAME.lua = GAME.lua .. ' = e.target._touch GAME.group.const.touch_x, GAME.group.const.touch_y = e.x, e.y if e.target._touch then'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, e.id) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(e.target) end else'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, nil) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(nil) for name, object in pairs(GAME.group.objects) do'
    GAME.lua = GAME.lua .. ' if object._touch and object ~= e.target then GAME.group.objects[name]._touch = false end end end end'
    GAME.lua = GAME.lua .. ' return (not ((function(p) if p.phase == \'began\' then' M.requestNestedBlock(nested)
    GAME.lua = GAME.lua .. ' end end)(e) == false)) end end) if isComplete then return result end return true end) end) end)'
end

M['onTouchMovedNoob'] = function(nested, params)
    GAME.lua = GAME.lua .. ' timer.new(1, 1, function() pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]:addEventListener(\'touch\', function(e)'
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' e.target._touch = e.phase ~= \'ended\' and e.phase ~= \'cancelled\' GAME.group.const.touch'
    GAME.lua = GAME.lua .. ' = e.target._touch GAME.group.const.touch_x, GAME.group.const.touch_y = e.x, e.y if e.target._touch then'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, e.id) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(e.target) end else'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, nil) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(nil) for name, object in pairs(GAME.group.objects) do'
    GAME.lua = GAME.lua .. ' if object._touch and object ~= e.target then GAME.group.objects[name]._touch = false end end end end'
    GAME.lua = GAME.lua .. ' return (not ((function(p) if p.phase == \'moved\' then' M.requestNestedBlock(nested)
    GAME.lua = GAME.lua .. ' end end)(e) == false)) end end) if isComplete then return result end return true end) end) end)'
end

M['onTouchEndedNoob'] = function(nested, params)
    GAME.lua = GAME.lua .. ' timer.new(1, 1, function() pcall(function() local name = ' .. CALC(params[1])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]:addEventListener(\'touch\', function(e)'
    GAME.lua = GAME.lua .. ' local isComplete, result = pcall(function() if GAME.hash == hash then'
    GAME.lua = GAME.lua .. ' e.target._touch = e.phase ~= \'ended\' and e.phase ~= \'cancelled\' GAME.group.const.touch'
    GAME.lua = GAME.lua .. ' = e.target._touch GAME.group.const.touch_x, GAME.group.const.touch_y = e.x, e.y if e.target._touch then'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, e.id) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(e.target) end else'
    GAME.lua = GAME.lua .. ' if GAME.multi then display.getCurrentStage():setFocus(e.target, nil) else'
    GAME.lua = GAME.lua .. ' display.getCurrentStage():setFocus(nil) for name, object in pairs(GAME.group.objects) do'
    GAME.lua = GAME.lua .. ' if object._touch and object ~= e.target then GAME.group.objects[name]._touch = false end end end end'
    GAME.lua = GAME.lua .. ' return (not ((function(p) if p.phase == \'ended\' or p.phase == \'cancelled\' then' M.requestNestedBlock(nested)
    GAME.lua = GAME.lua .. ' end end)(e) == false)) end end) if isComplete then return result end return true end) end) end)'
end

M['onLocalCollisionBeganNoob'] = function(nested, params)
    GAME.lua = GAME.lua .. ' timer.new(1, 1, function() pcall(function() local name, name2 = ' .. CALC(params[1]) .. ', ' .. CALC(params[2])
    GAME.lua = GAME.lua .. ' GAME.group.objects[name].collision = function(s, e) if GAME.hash == hash then local isComplete, result ='
    GAME.lua = GAME.lua .. ' pcall(function() return (function(p) if GAME.hash == hash then if p.phase == \'began\' then'
    GAME.lua = GAME.lua .. ' if p.other.name == name2 then' M.requestNestedBlock(nested)
    GAME.lua = GAME.lua .. ' end end end end)(e) end) return isComplete and result or false'
    GAME.lua = GAME.lua .. ' end end GAME.group.objects[name]:addEventListener(\'collision\') end) end)'
end

M['onFunNoob'] = M['onFun']
M['onConditionNoob'] = M['onCondition']
M['onTouchDisplayBeganNoob'] = M['onTouchDisplayBegan']
M['onTouchDisplayEndedNoob'] = M['onTouchDisplayEnded']
M['onTouchDisplayMovedNoob'] = M['onTouchDisplayMoved']

return M
