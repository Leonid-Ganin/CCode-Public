local LISTENER = require 'Core.Editor.listener'
local DATA = require 'Core.Editor.data'
local TEXT = require 'Core.Editor.text'
local listeners = {}

listeners.listener = function(e)
    if e.phase == 'began' and ALERT then
        display.getCurrentStage():setFocus(e.target)
        e.target.click = true
    elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) and ALERT then
        EDITOR.group[66]:takeFocus(e)
        e.target.click = false
    elseif (e.phase == 'ended' or e.phase == 'cancelled') and ALERT then
        display.getCurrentStage():setFocus(nil)
        if e.target.click then
            e.target.click = false
            if listeners[e.target.text.id] then
                listeners[e.target.text.id](e.target)
            else
                if EDITOR.cursor[2] == 'w' then
                    local thisData = UTF8.sub(e.target.text.id, 1, 1) == '/'
                    local type = e.target.text.ID == 'fun' and 'f' or
                    e.target.text.ID == 'math' and 'm' or
                    e.target.text.ID == 'log' and 'l' or
                    e.target.text.ID == 'device' and 'd' or
                    e.target.text.id == '/fscript' and 'fS' or
                    e.target.text.id == '/fproject' and 'fP' or
                    e.target.text.id == '/fcustom' and 'fC' or
                    e.target.text.id == '/event' and 'vE' or
                    e.target.text.id == '/script' and 'vS' or
                    e.target.text.id == '/project' and 'vP' or
                    e.target.text.id == '/tevent' and 'tE' or
                    e.target.text.id == '/tscript' and 'tS' or
                    e.target.text.id == '/tproject' and 'tP' or
                    e.target.text.id == '/pobj' and 'p' or
                    e.target.text.id == '/ptext' and 'p' or
                    e.target.text.id == '/pmedia' and 'p' or
                    e.target.text.id == '/pfiles' and 'p' or
                    e.target.text.id == '/pgroup' and 'p' or
                    e.target.text.id == '/pwidget' and 'p' or 't'

                    EDITOR.cursor[1] = EDITOR.cursor[1] + 1
                    table.insert(EDITOR.data, EDITOR.cursor[1] - 1, {
                        thisData and ((type == 'p' or type == 'fC') and e.target.text.ID or e.target.text.text) or e.target.text.id, type
                    }) DATA.set(type, type == 'p' and e.target.text.ID or e.target.text.id)
                    EDITOR.backup = LISTENER.backup(EDITOR.backup, 'add', EDITOR.data)

                    TEXT.set(TEXT.gen(EDITOR.data, EDITOR.cursor[2]), EDITOR.group[9])
                end
            end
        end
    end

    return true
end

local function moveListButtons(buttons, index, height)
    for i = index, #buttons do
        buttons[i].y = buttons[i].y + height
        buttons[i].text.y = buttons[i].text.y + height
        if buttons[i].polygon then buttons[i].polygon.y = buttons[i].polygon.y + height end
    end
end

local function getId(y)
    return (y - 35) / 70 + 1
end

local getFontSize getFontSize = function(width, text, size, isData)
    local checkText = display.newText(text, 0, 5000, 'ubuntu', size)

    if isData then
        return 26
    elseif checkText.width > width - 30 then
        checkText:removeSelf()
        return getFontSize(width, text, size - 1)
    else
        checkText:removeSelf()
        return size
    end
end

listeners.set = function(target, buttons, isData, isList, buttonId)
    if buttons and (buttons.names and #buttons.names > 0 or #buttons > 0) then
        target.isOpen = not target.isOpen
        target.polygon.yScale = target.isOpen and -1 or 1
        buttons = buttons.names and buttons or {names = COPY_TABLE(buttons)}

        if target.isOpen then
            local listScroll = EDITOR.group[66]
            local listButtonsX = listScroll.width / 2
            local listButtonsY = target.y + 70

            for i = 1, #buttons.names do
                local j, i, text = i, i + getId(target.y), buttons.names[i]
                table.insert(listScroll.buttons, i, {})

                listScroll.buttons[i] = display.newRect(listButtonsX, listButtonsY, listScroll.width, 70)
                    if isData then
                        listScroll.buttons[i].isOpen = false
                        listScroll.buttons[i]:setFillColor(0.14, 0.14, 0.16)
                    elseif target.text.id == 'event' or target.text.id == 'script' or target.text.id == 'project'
                    or target.text.id == 'tevent' or target.text.id == 'tscript' or target.text.id == 'tproject'
                    or target.text.id == 'pobj' or target.text.id == 'ptext' or target.text.id == 'pgroup'
                    or target.text.id == 'pwidget' or target.text.id == 'pmedia' or target.text.id == 'fcustom'
                    or target.text.id == 'fscript' or target.text.id == 'fproject' or target.text.id == 'pfiles'
                    or target.text.id == 'rimages' or target.text.id == 'rsounds' or target.text.id == 'rvideos'
                    or target.text.id == 'rfonts' or target.text.id == 'rothers' then
                        listScroll.buttons[i]:setFillColor(0.17, 0.17, 0.19)
                    else
                        listScroll.buttons[i]:setFillColor(0.14, 0.14, 0.16)
                    end listScroll.buttons[i].count = 0
                listScroll:insert(listScroll.buttons[i])

                listScroll.buttons[i].text = display.newText(text, 20, listButtonsY, 'ubuntu', getFontSize(listScroll.width, text, 24, isData))
                    if isData then local id = buttonId or getId(target.y)
                        if NOOBMODE then
                            listScroll.buttons[i].text.id = id == 1 and 'project' or id == 2 and 'tproject' or id == 3 and 'fproject'
                            or id == 4 and (j == 1 and 'pobj' or j == 2 and 'ptext' or j == 3 and 'pgroup' or 'pmedia')
                            or (j == 1 and 'rimages' or j == 2 and 'rsounds' or 'rfonts')
                        elseif BLOCKS.custom then
                            listScroll.buttons[i].text.id = id == 1 and (j == 1 and 'event' or 'script')
                            or (id == 2 and (j == 1 and 'tevent' or 'tscript') or (id == 3 and (j == 1 and 'fcustom' or 'fscript')
                            or (j == 1 and 'pobj' or j == 2 and 'ptext' or j == 3 and 'pgroup'
                            or j == 4 and 'pwidget' or j == 5 and 'pmedia' or 'pfiles')))
                        else
                            listScroll.buttons[i].text.id = id == 1 and (j == 1 and 'event' or j == 2 and 'script' or 'project')
                            or (id == 2 and (j == 1 and 'tevent' or j == 2 and 'tscript' or 'tproject')
                            or (id == 3 and (j == 1 and 'fcustom' or j == 2 and 'fscript' or 'fproject')
                            or (id == 4 and (j == 1 and 'pobj' or j == 2 and 'ptext' or j == 3 and 'pgroup'
                            or j == 4 and 'pwidget' or j == 5 and 'pmedia' or 'pfiles')
                            or (j == 1 and 'rimages' or j == 2 and 'rsounds' or j == 3 and 'rvideos'
                            or j == 4 and 'rfonts' or 'rothers'))))
                        end
                    elseif isList then
                        listScroll.buttons[i].text.id = buttons.keys[j]
                        listScroll.buttons[i].text.ID = target.text.id
                    else
                        listScroll.buttons[i].text.id = '/' .. target.text.id
                        listScroll.buttons[i].text.ID = target.text.id == 'pobj' and 'obj.' .. buttons.keys[j]
                        or target.text.id == 'fcustom' and EDITOR.funs._custom[j]
                        or target.text.id == 'ptext' and 'text.' .. buttons.keys[j]
                        or target.text.id == 'pgroup' and 'group.' .. buttons.keys[j]
                        or target.text.id == 'pmedia' and 'media.' .. buttons.keys[j]
                        or target.text.id == 'pwidget' and 'widget.' .. buttons.keys[j]
                        or target.text.id == 'pfiles' and 'files.' .. buttons.keys[j] or nil
                    end
                    listScroll.buttons[i].text.anchorX = 0
                listScroll:insert(listScroll.buttons[i].text)

                if isData then
                    listScroll.buttons[i].polygon = display.newPolygon(listScroll.width - 30, listButtonsY, {0, 0, 10, 10, -10, 10})
                    listScroll:insert(listScroll.buttons[i].polygon)
                end

                listButtonsY = listButtonsY + 70
                listScroll.scrollHeight = listScroll.scrollHeight + 70
                listScroll.buttons[i]:addEventListener('touch', listeners.listener)
            end

            target.count = #buttons.names
            moveListButtons(listScroll.buttons, #buttons.names + getId(target.y) + 1, #buttons.names * 70)
            listScroll:setScrollHeight(listScroll.scrollHeight)
        else
            local listScroll = EDITOR.group[66]
            local moveY = 0

            for i = getId(target.y) + 1, getId(target.y) + #buttons.names do
                local index = getId(target.y) + 1

                if listScroll.buttons[index].polygon then
                    listScroll.buttons[index].polygon:removeSelf() listScroll.buttons[index].polygon = nil

                    for j = index + 1, index + listScroll.buttons[index].count do
                        moveY = moveY - 70 listScroll.scrollHeight = listScroll.scrollHeight - 70
                        listScroll.buttons[index + 1].text:removeSelf() listScroll.buttons[index + 1].text = nil
                        listScroll.buttons[index + 1]:removeSelf() table.remove(listScroll.buttons, index + 1)
                    end
                end

                moveY = moveY - 70 listScroll.scrollHeight = listScroll.scrollHeight - 70
                listScroll.buttons[index].text:removeSelf() listScroll.buttons[index].text = nil
                listScroll.buttons[index]:removeSelf() table.remove(listScroll.buttons, index)
            end

            target.count = 0
            moveListButtons(listScroll.buttons, getId(target.y) + 1, moveY)
            listScroll:setScrollHeight(listScroll.scrollHeight)
        end
    end
end

listeners.fcustom = function(target)
    if BLOCKS.custom then
        EDITOR.funs._custom = {BLOCKS.custom.index}
        EDITOR.funs.custom = {BLOCKS.custom.name}
    end listeners.set(target, EDITOR.funs.custom)
end

listeners.pobj = function(target)
    listeners.set(target, EDITOR.prop.obj)
end

listeners.ptext = function(target)
    listeners.set(target, EDITOR.prop.text)
end

listeners.pgroup = function(target)
    listeners.set(target, EDITOR.prop.group)
end

listeners.pmedia = function(target)
    listeners.set(target, EDITOR.prop.media)
end

listeners.pfiles = function(target)
    listeners.set(target, EDITOR.prop.files)
end

listeners.pwidget = function(target)
    listeners.set(target, EDITOR.prop.widget)
end

listeners.fproject = function(target)
    listeners.set(target, EDITOR.funs.project)
end

listeners.fscript = function(target)
    listeners.set(target, EDITOR.funs.script)
end

listeners.tproject = function(target)
    listeners.set(target, EDITOR.tables.project)
end

listeners.tscript = function(target)
    listeners.set(target, EDITOR.tables.script)
end

listeners.tevent = function(target)
    listeners.set(target, EDITOR.tables.event)
end

listeners.project = function(target)
    listeners.set(target, EDITOR.vars.project)
end

listeners.script = function(target)
    listeners.set(target, EDITOR.vars.script)
end

listeners.event = function(target)
    listeners.set(target, EDITOR.vars.event)
end

listeners.rimages = function(target)
    listeners.set(target, EDITOR.resources.images)
end

listeners.rsounds = function(target)
    listeners.set(target, EDITOR.resources.sounds)
end

listeners.rvideos = function(target)
    listeners.set(target, EDITOR.resources.videos)
end

listeners.rfonts = function(target)
    listeners.set(target, EDITOR.resources.fonts)
end

listeners.rothers = function(target)
    listeners.set(target, EDITOR.resources.others)
end

listeners.device = function(target)
    listeners.set(target, EDITOR.device, nil, true)
end

listeners.log = function(target)
    listeners.set(target, EDITOR.log, nil, true)
end

listeners.math = function(target)
    listeners.set(target, EDITOR.math, nil, true)
end

listeners.fun = function(target)
    listeners.set(target, EDITOR.fun, nil, true)
end

listeners.var = function(target)
    if NOOBMODE then
        listeners.set(target, {STR['editor.list.project']}, true, nil, 1)
    elseif BLOCKS.custom then
        listeners.set(target, {STR['editor.list.event'], STR['editor.list.script']}, true, nil, 1)
    else
        listeners.set(target, {STR['editor.list.event'], STR['editor.list.script'], STR['editor.list.project']}, true, nil, 1)
    end
end

listeners.table = function(target)
    if NOOBMODE then
        listeners.set(target, {STR['editor.list.project']}, true, nil, 2)
    elseif BLOCKS.custom then
        listeners.set(target, {STR['editor.list.event'], STR['editor.list.script']}, true, nil, 2)
    else
        listeners.set(target, {STR['editor.list.event'], STR['editor.list.script'], STR['editor.list.project']}, true, nil, 2)
    end
end

listeners.funs = function(target)
    if NOOBMODE then
        listeners.set(target, {STR['editor.list.project']}, true, nil, 3)
    elseif BLOCKS.custom then
        listeners.set(target, {STR['editor.list.custom'], STR['editor.list.script']}, true, nil, 3)
    else
        listeners.set(target, {STR['editor.list.custom'], STR['editor.list.script'], STR['editor.list.project']}, true, nil, 3)
    end
end

listeners.prop = function(target)
    if NOOBMODE then
        listeners.set(target, {
            STR['editor.list.prop.obj.noob'], STR['editor.list.prop.text'],
            STR['editor.list.prop.group'], STR['editor.list.prop.media.noob']
        }, true, nil, 4)
    else
        listeners.set(target, {
            STR['editor.list.prop.obj'], STR['editor.list.prop.text'], STR['editor.list.prop.group'],
            STR['editor.list.prop.widget'], STR['editor.list.prop.media'], STR['editor.list.prop.files']
        }, true, nil, 4)
    end
end

listeners.resource = function(target)
    if NOOBMODE then
        listeners.set(target, {
            STR['editor.list.resource.images.noob'], STR['editor.list.resource.sounds'], STR['editor.list.resource.fonts']
        }, true, nil, 9)
    elseif not BLOCKS.custom then
        listeners.set(target, {
            STR['editor.list.resource.images'], STR['editor.list.resource.sounds'], STR['editor.list.resource.videos'],
            STR['editor.list.resource.fonts'], STR['editor.list.resource.others']
        }, true, nil, 9)
    end
end

return listeners
