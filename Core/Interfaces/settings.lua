local LIST = require 'Core.Modules.interface-list'
local listeners = {}

listeners.title = function()
    EXITS.settings()
end

listeners.orientation = function(e)
    LOCAL.orientation = LOCAL.orientation == 'portrait' and 'landscape' or 'portrait'
    e.target.rotation = e.target.rotation + 90 NEW_DATA() native.requestExit()
end

listeners.bottom_height = function(e)
    local FILTER = require 'Core.Modules.height-filter'

    INPUT.new(STR['settings.bottom_height.enterheight'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            FILTER.check(event.target.text, function(ev)
                if ev.isError then
                    INPUT.remove(false)
                    WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']})
                else
                    INPUT.remove(true, ev.text)
                end
            end)
        end
    end, function(e)
        if e.input then
            LOCAL.bottom_height = e.text
            GET_SAFE_AREA()

            MENU.group:removeSelf()
            MENU.group = nil
            MENU.create()

            pcall(function()
                NEW_BLOCK.remove()
            end)

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end
    end, LOCAL.bottom_height)
end

listeners.keystore = function(e)
    local FILTER = require 'Core.Modules.keystore-filter'
    local list = LOCAL.keystore[1] == 'testkey'
    and {STR['settings.keystore.testkey'], STR['settings.keystore.custom']}
    or {STR['settings.keystore.custom'], STR['settings.keystore.testkey']}

    local function inputValue(index, mode, alias)
        timer.new(1, 1, function()
            INPUT.new(STR['settings.keystore.enter' .. mode], function(event)
                if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                    FILTER.check(event.target.text, function(ev)
                        if ev.isError then
                            INPUT.remove(false)
                            WINDOW.new(STR['errors.' .. ev.typeError], {STR['button.close'], STR['button.okay']})
                        else
                            INPUT.remove(true, ev.text)
                        end
                    end)
                end
            end, function(e)
                if e.input then
                    if not alias then
                        inputValue(index, 'pass', e.text)
                    else
                        LOCAL.keystore = {'custom', alias, e.text}

                        SETTINGS.group:removeSelf()
                        SETTINGS.group = nil
                        SETTINGS.create()
                        SETTINGS.group.isVisible = true

                        NEW_DATA()

                        timer.new(1, 1, function()
                            if index == 1 then
                                timer.new(1, 1, function()
                                    local info = STR['settings.keystore.import.successfully'] .. '\n'
                                    local info = info .. STR['settings.keystore.alias'] .. ': ' .. alias .. '\n'
                                    local info = info .. STR['settings.keystore.pass'] .. ': ' .. e.text

                                    WINDOW.new(info, {STR['button.close']}, function(e) end, 2)
                                    WINDOW.buttons[1].x = WINDOW.bg.x + WINDOW.bg.width / 4 - 5
                                    WINDOW.buttons[1].text.x = WINDOW.buttons[1].x
                                end)
                            elseif index == 2 then
                                pcall(function() GANIN.keystore(DOC_DIR, alias, e.text) end)

                                timer.new(1, 1, function()
                                    local info = STR['settings.keystore.create.successfully'] .. '\n'
                                    local info = info .. STR['settings.keystore.alias'] .. ': ' .. alias .. '\n'
                                    local info = info .. STR['settings.keystore.pass'] .. ': ' .. e.text

                                    WINDOW.new(info, {STR['button.close']}, function(e)
                                        GIVE_PERMISSION_DATA()
                                        EXPORT.export({
                                            path = DOC_DIR .. '/cbuilder.jks', name = alias .. '.jks',
                                            listener = function(event) end
                                        })
                                    end, 2)

                                    WINDOW.buttons[1].x = WINDOW.bg.x + WINDOW.bg.width / 4 - 5
                                    WINDOW.buttons[1].text.x = WINDOW.buttons[1].x
                                end)
                            end
                        end)
                    end
                end
            end)
        end)
    end

    LIST.new(list, e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        if e.index > 0 then
            if e.text == STR['settings.keystore.custom'] then
                WINDOW.new(STR['scripts.sandbox.exit'], {STR['settings.keystore.import'], STR['settings.keystore.create']}, function(e)
                    if e.index == 1 then
                        GIVE_PERMISSION_DATA()
                        FILE.pickFile(DOC_DIR, function(import)
                            if type(import) == 'table' and import.done and import.done == 'ok' then
                                inputValue(1, 'alias')
                            end
                        end, 'cbuilder.jks', '', '*/*', nil, nil, nil)
                    elseif e.index == 2 then
                        inputValue(2, 'alias')
                    end
                end, 3)
            elseif e.text == STR['settings.keystore.testkey'] then
                LOCAL.keystore = {'testkey'}

                SETTINGS.group:removeSelf()
                SETTINGS.group = nil
                SETTINGS.create()
                SETTINGS.group.isVisible = true

                NEW_DATA()
            end
        end
    end, nil, nil, 0.5)
end

listeners.pos = function(e)
    local list = LOCAL.pos_top_ads
    and {STR['settings.topads'], STR['settings.bottomads']}
    or {STR['settings.bottomads'], STR['settings.topads']}

    LIST.new(list, e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        if e.index > 0 then
            LOCAL.pos_top_ads = e.text == STR['settings.topads']

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end
    end, nil, nil, 0.5)
end

listeners.show = function(e)
    local list = LOCAL.show_ads and {STR['button.yes'], STR['button.no']} or {STR['button.no'], STR['button.yes']}

    LIST.new(list, e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        if e.index > 0 then
            LOCAL.show_ads = e.text == STR['button.yes']

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end
    end, nil, nil, 0.5)
end

listeners.dog = function(e)
    local list = LOCAL.old_dog and {STR['button.yes'], STR['button.no']} or {STR['button.no'], STR['button.yes']}

    LIST.new(list, e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        if e.index > 0 then
            LOCAL.old_dog = e.text == STR['button.yes']

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end
    end, nil, nil, 0.5)
end

listeners.confirm = function(e)
    local list = LOCAL.confirm and {STR['button.yes'], STR['button.no']} or {STR['button.no'], STR['button.yes']}

    LIST.new(list, e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        if e.index > 0 then
            LOCAL.confirm = e.text == STR['button.yes']

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end
    end, nil, nil, 0.5)
end

listeners.autoplace = function(e)
    local list = LOCAL.autoplace and {STR['button.yes'], STR['button.no']} or {STR['button.no'], STR['button.yes']}

    LIST.new(list, e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        if e.index > 0 then
            LOCAL.autoplace = e.text == STR['button.yes']

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end
    end, nil, nil, 0.5)
end

listeners.lang = function(e)
    local list = {{STR['lang.' .. LOCAL.lang]}, {LOCAL.lang}}

    for i = 1, #LANGS do
        if LOCAL.lang ~= LANGS[i] then
            list[1][#list[1] + 1] = STR['lang.' .. LANGS[i]]
            list[2][#list[2] + 1] = LANGS[i]
        end
    end

    LIST.new(list[1], e.target.x, e.target.y - e.target.height / 2, 'down', function(e)
        local function changeLang()
            LOCAL.lang = list[2][e.index]
            STR = LANG[LOCAL.lang]

            for k, v in pairs(LANG.ru) do
                if not STR[k] then
                    STR[k] = LANG.en[k] or v
                elseif type(STR[k]) == 'table' then
                    for k2, v2 in ipairs(LANG.ru[k]) do
                        if not STR[k][k2] then
                            STR[k][k2] = (LANG.en[k] and LANG.en[k][k2]) and LANG.en[k][k2] or v2
                        end
                    end
                end
            end

            MENU.group:removeSelf()
            MENU.group = nil
            MENU.create()

            pcall(function()
                NEW_BLOCK.remove()
            end)

            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = true

            NEW_DATA()
        end

        if e.text == STR['lang.custom'] then
            local completeImportLanguage = function(import)
                if import.done and import.done == 'ok' then
                    local langData = JSON.decode(READ_FILE(DOC_DIR .. '/lang.json'))

                    if langData then
                        for _, langT in pairs(langData) do
                            for key, str in pairs(langT) do
                                LANG['custom'][key] = str
                            end
                        end
                    end

                    OS_REMOVE(DOC_DIR .. '/lang.json') changeLang()
                end
            end

            GIVE_PERMISSION_DATA()
            FILE.pickFile(DOC_DIR, completeImportLanguage, 'lang.json', '', '*/*', nil, nil, nil)
        elseif e.index > 0 then
            changeLang()
        end
    end, nil, nil, 0.5)
end

return function(e, type)
    if ALERT then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            if type == 'title' then e.target.alpha = 0.6
            elseif type ~= 'orientation' then e.target:setFillColor(0.22, 0.22, 0.24) end
            e.target.click = true
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            display.getCurrentStage():setFocus(nil)
            if type == 'title' then e.target.alpha = 1
            elseif type ~= 'orientation' then e.target:setFillColor(0, 0, 0, 0.005) end
            e.target.click = false
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if type == 'title' then e.target.alpha = 1
            elseif type ~= 'orientation' then e.target:setFillColor(0, 0, 0, 0.005) end
            if e.target.click then
                e.target.click = false
                listeners[type](e)
            end
        end
    end

    return true
end
