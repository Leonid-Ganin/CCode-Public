local EVENTS = require 'Core.Simulation.events'
local CALC = require 'Core.Simulation.calc'
local M = {}

local function setCustom(name, logic)
    if logic then
        EVENTS.BLOCKS[name] = function(params)
            M.lua = M.lua .. ' pcall(function() funsC[\'' .. name .. '\'](' for i = 1, #params do
            M.lua = M.lua .. CALC(params[i]) .. (i == #params and '' or ', ') end M.lua = M.lua .. ') end)'
        end

        EVENTS['_' .. name] = function(nested, params)
            M.lua = M.lua .. ' pcall(function() funsC[\'' .. name .. '\'] = function(...) local args = {...} local isComplete, result ='
            EVENTS.BLOCKS.requestApi({{{logic, 't'}}}) M.lua = M.lua .. ' return isComplete and result or nil end end)'
        end
    else
        EVENTS.BLOCKS[name] = function(params)
            M.lua = M.lua .. ' pcall(function() funsC[\'' .. name .. '\'](' for i = 1, #params do
            M.lua = M.lua .. CALC(params[i]) .. (i == #params and '' or ', ') end M.lua = M.lua .. ') end)'
        end

        EVENTS['_' .. name] = function(nested, params)
            M.lua = M.lua .. ' pcall(function() funsC[\'' .. name .. '\'] = function(...)'
            M.lua = M.lua .. ' local varsE, tablesE, args = {}, {}, {...}' for i = 1, #params do if params[i][1] then
            M.lua = M.lua .. ' varsE[\'' .. params[i][1][1] .. '\'] = args[' .. i .. ']' end end
            EVENTS.requestNestedBlock(nested) M.lua = M.lua .. ' end end)'
        end
    end
end

local function getStartLua(linkBuild)
    local funs1 = ' local fun, device = require \'Core.Functions.fun\', require \'Core.Functions.device\''
    local funs2 = ' local other, select = require \'Core.Functions.other\', require \'Core.Functions.select\''
    local funs3 = ' local math, prop = require \'Core.Functions.math\', require \'Core.Functions.prop\''
    local funs4 = ' local SERVER, CLIENT = require \'Network.server\', require \'Network.client\''
    local code1 = ' GAME.orientation = CURRENT_ORIENTATION display.setDefault(\'background\', 0) transition.ignoreEmptyReference = true'
    local code2 = ' GAME.group = display.newGroup() GAME.group.texts = {} GAME.group.objects = {} GAME.group.media = {} GAME.multi = false'
    local code3 = ' GAME.group.groups = {} GAME.group.masks = {} GAME.group.bitmaps = {} GAME.currentStage = {} GAME.group.stops = {}'
    local code4 = ' GAME.group.animations = {} GAME.group.widgets = {} GAME.group.tags = {TAG = {}} GAME.group.timers = {} GAME.group.ts = {}'
    local code5 = ' GAME.group.const = {touch = false, touch_x = 360, touch_y = 640} GAME.group.displays = {} device.start()'
    local code6 = ' GAME.group.const.touch_fun = function(e) GAME.group.const.touch = e.phase ~= \'ended\' and e.phase ~= \'cancelled\''
    local code7 = ' GAME.group.const.touch_x, GAME.group.const.touch_y = e.x, e.y for i = 1, #GAME.group.displays do GAME.group.displays[i](e)'
    local code8 = ' end return true end Runtime:addEventListener(\'touch\', GAME.group.const.touch_fun) PHYSICS.start() GAME.group.collis = {}'
    local code9 = ' for child = 1, display.currentStage.numChildren do GAME.currentStage[display.currentStage[child]] = true end'
    local cod10 = ' GAME.group.conditions = {} GAME.group.const.enterFrame = function() for i = 1, #GAME.group.conditions do'
    local cod11 = ' GAME.group.conditions[i]() end end Runtime:addEventListener(\'enterFrame\', GAME.group.const.enterFrame)'
    local cod12 = ' GAME.group.backs = {} GAME.group.suspends = {} GAME.group.const.keyBack = function(e) if e.phase == \'up\''
    local cod13 = ' and (e.keyName == \'back\' or e.keyName == \'escape\') then for i = 1, #GAME.group.backs do GAME.group.backs[i]()'
    local cod14 = ' end return true end end Runtime:addEventListener(\'key\', GAME.group.const.keyBack) GAME.group.resumes = {}'
    local cod15 = ' GAME.group.const.system = function(e) if e.type == \'applicationSuspend\' or e.type == \'applicationExit\' then for i = 1,'
    local cod16 = ' #GAME.group.suspends do GAME.group.suspends[i]() end elseif e.type == \'applicationResume\' then for i = 1,'
    local cod17 = ' #GAME.group.resumes do GAME.group.resumes[i]() end end end Runtime:addEventListener(\'system\', GAME.group.const.system)'
    local cod18 = ' GAME.group.textures = {} GAME.group.accelerometers = {} GAME.hash = CRYPTO.digest(CRYPTO.md5, math.random(1, 999999999))'
    local cod19 = ' local hash = GAME.hash GAME.group.networks = {} GAME.group.const.touch_x, GAME.group.const.touch_y = 0, 0'
    local cod20 = ' local tmp = DOC_DIR .. \'/\' .. CURRENT_LINK .. \'/Temps\' OS_REMOVE(tmp, true) LFS.mkdir(tmp)'
    local cod21 = ' GAME.group.snapshots = {} GAME.group.joints = {} GAME_DEVICE_ID = \'' .. tostring(DEVICE_ID) .. '\''
    local cod22 = ' GAME.group.particles = {}'

    if linkBuild then
        return 'pcall(function() local varsP, tablesP, funsP, funsC, a = CLASS(), {}, {}, {}' .. require 'Data.build'
            .. code1 .. code2 .. code3 .. code4 .. code5 .. code6 .. code7 .. code8 .. code9 .. cod10 .. cod11
            .. cod12 .. cod13 .. cod14 .. cod15 .. cod16 .. cod17 .. cod18 .. cod19 .. cod20 .. cod21 .. cod22
    else
        return 'pcall(function() local varsP, tablesP, funsP, funsC, a = CLASS(), {}, {}, {}' .. funs1 .. funs2 .. funs3 .. funs4
            .. code1 .. code2 .. code3 .. code4 .. code5 .. code6 .. code7 .. code8 .. code9 .. cod10 .. cod11
            .. cod12 .. cod13 .. cod14 .. cod15 .. cod16 .. cod17 .. cod18 .. cod19 .. cod20 .. cod21 .. cod22
    end
end

M.remove = function()
    display.setDefault('background', 0.15, 0.15, 0.17) timer.cancelAll()
    transition.cancelAll() native.setProperty('androidSystemUiVisibility', 'default') GAME.hash = ''
    pcall(function() for _, v in ipairs(M.group.networks) do pcall(function() network.cancel(v) v = nil end) end end)
    pcall(function() for _, v in pairs(M.group.timers) do pcall(function() timer.cancel(v) v = nil end) end end)
    pcall(function() for _, v in ipairs(M.group.ts) do pcall(function() timer.cancel(v) v = nil end) end end)
    pcall(function() for _, v in pairs(M.group.widgets) do timer.new(20, 1, function()
    pcall(function() v:removeSelf() v = nil end) end) end end) pcall(function() audio.setVolume(1) end)
    pcall(function() for _, v in pairs(M.group.media) do timer.new(20, 1, function()
    pcall(function() audio.stop(v[2]) v[2] = nil end) pcall(function() audio.dispose(v[1]) v[1] = nil end)
    pcall(function() v:removeSelf() end) pcall(function() v = nil end) end) end end)
    pcall(function() Runtime:removeEventListener('enterFrame', M.group.const.enterFrame) end)
    pcall(function() Runtime:removeEventListener('system', M.group.const.system) end)
    pcall(function() Runtime:removeEventListener('touch', M.group.const.touch_fun) end)
    pcall(function() Runtime:removeEventListener('key', M.group.const.keyBack) end)
    pcall(function() for _, v in ipairs(M.group.accelerometers) do
    pcall(function() Runtime:removeEventListener('accelerometer', v) end) end end) pcall(function() for _, v in ipairs(M.group.collis) do
    pcall(function() Runtime:removeEventListener('collision', v) end) pcall(function() Runtime:removeEventListener('preCollision', v) end)
    pcall(function() Runtime:removeEventListener('postCollision', v) end) end end)
    pcall(function() system.deactivate('multitouch') for _, v in pairs(M.group.objects) do
    pcall(function() v:removeEventListener('collision') end) pcall(function() v:removeEventListener('preCollision') end)
    pcall(function() v:removeEventListener('postCollision') end) pcall(function() PHYSICS.removeBody(v) end) end end)
    pcall(function() if GAME and GAME.camera then GAME.camera:destroy() end end)
    pcall(function() for _, v in pairs(M.group.texts) do pcall(function() PHYSICS.removeBody(v) end) end end)
    pcall(function() for _, v in pairs(M.group.particles) do pcall(function() v:removeSelf() v = nil end) end end)
    pcall(function() for _, v in pairs(M.group.joints) do pcall(function() v:removeSelf() v = nil end) end end)
    pcall(function() for _, v in pairs(M.group.bitmaps) do pcall(function() v:releaseSelf() v = nil end) end end)
    pcall(function() for _, v in pairs(M.group.textures) do pcall(function() v:releaseSelf() v = nil end) end end)
    pcall(function() for _, v in ipairs(M.group.stops) do v() end end) M.isStarted = nil
    pcall(function() PHYSICS.start() PHYSICS.setDrawMode('normal') PHYSICS.setGravity(0, 9.8) PHYSICS.stop() end)
    pcall(function() M.group:removeSelf() M.group = nil end) M.RESOURCES = nil SEED = os.time() math.randomseed(SEED)
    pcall(function() for child = display.currentStage.numChildren, 1, -1 do if display.currentStage[child].wtype
    then timer.new(1, 1, function() pcall(function() display.currentStage[child]:removeSelf() end) end) end
    if not M.currentStage[display.currentStage[child]] then display.currentStage[child]:removeSelf() end end end)
    timer.performWithDelay(1, function() if CURRENT_ORIENTATION ~= M.orientation then setOrientationApp({type = M.orientation, sim = true})
    if (GAME_GROUP_OPEN and GAME_GROUP_OPEN.scroll) then GAME_GROUP_OPEN.scroll:scrollToPosition({y = M.scrollY, time = 0}) end end end)
end

M.new = function(linkBuild, isDebug)
    M.group = display.newGroup()
    M.orientation, EVENTS.CUSTOM = 'portrait', {}
    M.data = GET_GAME_CODE(linkBuild or CURRENT_LINK) M.needBack, M.scripts = true, {}
    M.scrollY = (GAME_GROUP_OPEN and GAME_GROUP_OPEN.scroll) and select(2, GAME_GROUP_OPEN.scroll:getContentPosition()) or 0
    M.lua = getStartLua(linkBuild) .. ' GAME.RESOURCES = JSON.decode(\'' .. UTF8.gsub(JSON.encode(M.data.resources), '\n', '') .. '\')'

    if M.data.settings.orientation == 'portrait' and CURRENT_ORIENTATION ~= 'portrait' then
        M.lua = M.lua .. ' setOrientationApp({type = \'portrait\', sim = true})'
    elseif M.data.settings.orientation == 'landscape' and (linkBuild or CURRENT_ORIENTATION ~= 'landscape') then
        M.lua = M.lua .. ' setOrientationApp({type = \'landscape\', sim = true})'
    end M.lua = M.lua .. ' GAME.camera = CAMERA.createView() GAME.group:insert(GAME.camera)'

    local onStartCount = 0
    local nestedIndex = 0
    local nestedEvent = {}
    local nestedScript = {}
    local dataEvent = {}
    local dataCustom = {}
    local eventComment = false
    local custom = GET_GAME_CUSTOM()

    for index = 1, #M.data.scripts do local i = #M.scripts + 1
        M.scripts[i] = GET_FULL_DATA(GET_GAME_SCRIPT(linkBuild or CURRENT_LINK, index, M.data))

        if M.scripts[i].comment then
            table.remove(M.scripts, i)
        else
            for j = 1, #M.scripts[i].params do
                local name = M.scripts[i].params[j].name
                local index = UTF8.sub(name, 7, UTF8.len(name))
                dataCustom[index] = UTF8.sub(name, 1, 6) == 'custom'

                if not dataCustom[index] then
                    for u = 1, #M.scripts[i].params[j].params do
                        for o = #M.scripts[i].params[j].params[u], 1, -1 do
                            if M.scripts[i].params[j].params[u][o][2] == 'fC' then
                                local name = M.scripts[i].params[j].params[u][o][1]
                                dataCustom[UTF8.sub(name, 7, UTF8.len(name))] = true
                            end
                        end
                    end
                end
            end
        end
    end

    if BLOCKS and BLOCKS.custom then
        local name = 'custom' .. BLOCKS.custom.index

        for i = 1, #M.scripts[1].params do
            if M.scripts[1].params[i].name == '_custom' then
                M.scripts[1].params[i].name = '_custom' .. BLOCKS.custom.index break
            end
        end

        M.scripts = {COPY_TABLE(M.scripts[1])}
        setCustom(name)
    else
        for index, block in pairs(custom) do
            if dataCustom[index] then
                local name = 'custom' .. index
                local logic = custom[index][3]

                if type(logic) == 'string' then
                    local _script = GET_FULL_DATA({
                        title = '', funs = {}, tables = {}, vars = {}, custom = true,
                        params = {{tables = {}, vars = {}, name = '_' .. name, event = true, nested = {}, comment = false, params = {}}}
                    }) table.insert(M.scripts, 1, _script) setCustom(name, logic)
                elseif type(logic) == 'table' then
                    for i = 1, #logic.params do
                        if logic.params[i].name == '_custom' then
                            logic.params[i].name = '_custom' .. index
                        elseif logic.params[i].name == 'onStart' then
                            logic.params[i].comment = true
                        end
                    end

                    local _script = GET_FULL_DATA(logic)
                    table.insert(M.scripts, 1, _script)
                    setCustom(name)
                end
            end
        end
    end

    for i = 1, #M.scripts do
        for j = 1, #M.scripts[i].params do
            if M.scripts[i].params[j].event then
                eventComment = M.scripts[i].params[j].comment
                if not eventComment then
                    nestedIndex = nestedIndex + 1
                    nestedEvent[nestedIndex] = {}
                    dataEvent[nestedIndex] = {
                        script = i,
                        name = M.scripts[i].params[j].name,
                        params = M.scripts[i].params[j].params,
                        comment = M.scripts[i].params[j].comment
                    }
                end
            elseif not M.scripts[i].params[j].comment and not eventComment then
                if not (linkBuild and (name == 'toastShort' or name == 'toastLong')) then
                    table.insert(nestedEvent[nestedIndex], M.scripts[i].params[j])
                end
            end
        end
    end

    for i = 1, #nestedEvent do
        if not nestedScript[dataEvent[i].script] then
            if #nestedScript > 0 then M.lua = M.lua .. ' end end script()' end
            M.lua = M.lua .. ' local function script() local varsS, tablesS, funsS = CLASS(), {}, {}'
            nestedScript[dataEvent[i].script] = true

            for j = i, #nestedEvent do
                local isFunBlock = dataEvent[j].name == 'onFun' or dataEvent[j].name == 'onFunParams'
                or UTF8.sub(dataEvent[j].name, 1, 7) == '_custom' or dataEvent[j].name == 'onTouchBegan'
                or dataEvent[j].name == 'onTouchEnded' or dataEvent[j].name == 'onTouchMoved'
                or dataEvent[j].name == 'onTouchDisplayBegan' or dataEvent[j].name == 'onTouchDisplayEnded'
                or dataEvent[j].name == 'onTouchDisplayMoved' or dataEvent[j].name == 'onSliderMoved'
                or dataEvent[j].name == 'onFieldBegan' or dataEvent[j].name == 'onFieldEditing'
                or dataEvent[j].name == 'onFieldEnded' or dataEvent[j].name == 'onWebViewCallback'
                or dataEvent[j].name == 'onCondition' or dataEvent[j].name == 'onBackPress' or dataEvent[j].name == 'onUpdateVar'
                or dataEvent[j].name == 'onSuspend' or dataEvent[j].name == 'onResume' or dataEvent[j].name == 'onFileDownload'
                or dataEvent[j].name == 'onLocalCollisionBegan' or dataEvent[j].name == 'onLocalCollisionEnded'
                or dataEvent[j].name == 'onLocalPreCollision' or dataEvent[j].name == 'onLocalPostCollision'
                or dataEvent[j].name == 'onGlobalCollisionBegan' or dataEvent[j].name == 'onGlobalCollisionEnded'
                or dataEvent[j].name == 'onGlobalPreCollision' or dataEvent[j].name == 'onGlobalPostCollision'
                or dataEvent[j].name == 'onFirebase' or dataEvent[j].name == 'onSwitchCallback'
                or dataEvent[j].name == 'onConditionNoob' or dataEvent[j].name == 'onFunNoob'
                or dataEvent[j].name == 'onTouchBeganNoob' or dataEvent[j].name == 'onTouchEndedNoob'
                or dataEvent[j].name == 'onTouchMovedNoob' or dataEvent[j].name == 'onLocalCollisionBeganNoob'

                if nestedScript[dataEvent[j].script] and not dataEvent[j].comment and isFunBlock then
                    pcall(function() EVENTS[dataEvent[j].name](nestedEvent[j], dataEvent[j].params) end)
                end
            end

            onStartCount = onStartCount + 1
            M.lua = M.lua .. ' function onStart' .. onStartCount .. '()'
        end

        if not dataEvent[i].comment and dataEvent[i].name ~= 'onFun' and dataEvent[i].name ~= 'onFunParams'
        and UTF8.sub(dataEvent[i].name, 1, 7) ~= '_custom' and dataEvent[i].name ~= 'onTouchBegan'
        and dataEvent[i].name ~= 'onTouchEnded' and dataEvent[i].name ~= 'onTouchMoved'
        and dataEvent[i].name ~= 'onTouchDisplayBegan' and dataEvent[i].name ~= 'onTouchDisplayEnded'
        and dataEvent[i].name ~= 'onTouchDisplayMoved' and dataEvent[i].name ~= 'onSliderMoved'
        and dataEvent[i].name ~= 'onFieldBegan' and dataEvent[i].name ~= 'onFieldEditing'
        and dataEvent[i].name ~= 'onFieldEnded' and dataEvent[i].name ~= 'onWebViewCallback'
        and dataEvent[i].name ~= 'onCondition' and dataEvent[i].name ~= 'onBackPress' and dataEvent[i].name ~= 'onUpdateVar'
        and dataEvent[i].name ~= 'onSuspend' and dataEvent[i].name ~= 'onResume' and dataEvent[i].name ~= 'onFileDownload'
        and dataEvent[i].name ~= 'onLocalCollisionBegan' and dataEvent[i].name ~= 'onLocalCollisionEnded'
        and dataEvent[i].name ~= 'onLocalPreCollision' and dataEvent[i].name ~= 'onLocalPostCollision'
        and dataEvent[i].name ~= 'onGlobalCollisionBegan' and dataEvent[i].name ~= 'onGlobalCollisionEnded'
        and dataEvent[i].name ~= 'onGlobalPreCollision' and dataEvent[i].name ~= 'onGlobalPostCollision'
        and dataEvent[i].name ~= 'onFirebase' and dataEvent[i].name ~= 'onSwitchCallback'
        and dataEvent[i].name ~= 'onConditionNoob' and dataEvent[i].name ~= 'onFunNoob'
        and dataEvent[i].name ~= 'onTouchBeganNoob' and dataEvent[i].name ~= 'onTouchEndedNoob'
        and dataEvent[i].name ~= 'onTouchMovedNoob' and dataEvent[i].name ~= 'onLocalCollisionBeganNoob' then
            pcall(function() EVENTS[dataEvent[i].name](nestedEvent[i], dataEvent[i].params) end)
        end
    end if #nestedEvent > 0 then M.lua = M.lua .. ' end end script()' end

    for i = 1, onStartCount do
        M.lua = M.lua .. ' onStart' .. i .. '()'
    end M.lua = M.lua .. ' end) GAME.isStarted = true'

    if linkBuild or isDebug then
        M.remove() if linkBuild then M.data.settings.build = M.data.settings.build + 1 SET_GAME_CODE(M.data.link, M.data) end
        return M.lua .. (linkBuild and ' end)' or '')
    else
        display.setDefault('background', 0)
        timer.performWithDelay(1, function()
            if not pcall(function() loadstring(M.lua)() end) then
                pcall(function() M.group:removeSelf() M.group, M.isStarted = nil, nil end)

                WINDOW.new(STR['game.isbug'], {STR['button.close']}, function()
                    display.setDefault('background', 0.15, 0.15, 0.17)
                    if (GAME_GROUP_OPEN and GAME_GROUP_OPEN.group) then GAME_GROUP_OPEN.group.isVisible = true end
                end, 5)

                WINDOW.buttons[1].x = WINDOW.bg.x + WINDOW.bg.width / 4 - 5
                WINDOW.buttons[1].text.x = WINDOW.buttons[1].x
            end
        end)
    end
end

for i = 3, 10 do
    pcall(function()
        EVENTS.BLOCKS = table.merge(EVENTS.BLOCKS, require('Core.Simulation.Noob.' .. INFO.listType[i]))
    end)
end

return M
