local PARAMS = require 'Core.Modules.params-listener'
local COLOR = require 'Core.Modules.interface-color'
local LIST = require 'Core.Modules.interface-list'
local BLOCK = require 'Core.Modules.logic-block'
local LOGIC = require 'Core.Modules.logic-input'
local TEXT = require 'Core.Editor.text'
local M = {}

M.find = function(data)
    for i = 1, #data do
        if data[i][2] == '|' then
            return i
        end
    end
end

M.rect = function(target, restart, data)
    local index = target.index
    local type = restart[6] and 'value' or INFO.listName[restart[1]][index + 1][1]

    if type == 'value' and ALERT then
        if TEXT.check(COPY_TABLE(data)) then
            local param = TEXT.number(data, true)
            local data = GET_GAME_CODE(CURRENT_LINK)
            local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)

            if not EDITOR.restart[6] then
                local blockIndex, paramsIndex = restart[2], restart[4]
                local params = script.params[blockIndex].params

                EDITOR.rScrollParams = {}
                params[paramsIndex] = COPY_TABLE(param)
                BLOCKS.group.blocks[blockIndex].data.params = COPY_TABLE(params)
                BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text = BLOCK.getParamsValueText(params, paramsIndex)
                SET_GAME_CODE(CURRENT_LINK, data)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)

                for i = #EDITOR.group[66].buttons, 1, -1 do
                    if EDITOR.group[66].buttons[i].isOpen then
                        table.insert(EDITOR.rScrollParams, 1, i)
                    end
                end

                restart[5], restart[4] = true, index
                restart[3] = COPY_TABLE(script.params[restart[2]].params[restart[4]])
                table.insert(EDITOR.rScrollParams, select(2, EDITOR.group[66]:getContentPosition()))
                EDITOR.scrollY = select(2, EDITOR.group[8]:getContentPosition())
                EDITOR.group:removeSelf() EDITOR.group = nil
                EDITOR.create(unpack(restart))
                EDITOR.group.isVisible = true
            else
                local CUSTOM = require 'Core.Modules.custom-block'
                local params = EDITOR.restart[8]

                EDITOR.rScrollParams = {}
                params[EDITOR.restart[4]] = COPY_TABLE(param)

                for i = #EDITOR.group[66].buttons, 1, -1 do
                    if EDITOR.group[66].buttons[i].isOpen then
                        table.insert(EDITOR.rScrollParams, 1, i)
                    end
                end

                restart[5], restart[4], restart[3] = true, index, COPY_TABLE(params)
                table.insert(EDITOR.rScrollParams, select(2, EDITOR.group[66]:getContentPosition()))
                EDITOR.scrollY = select(2, EDITOR.group[8]:getContentPosition())
                EDITOR.group:removeSelf() EDITOR.group = nil
                EDITOR.create(unpack(restart))
                EDITOR.group.isVisible = true
            end
        else
            EDITOR.group[9]:setIsLocked(true, 'vertical')
            EDITOR.group[66]:setIsLocked(true, 'vertical')

            WINDOW.new(STR['editor.window.error'], {STR['button.close'], STR['editor.button.error']}, function(e)
                EDITOR.group[9]:setIsLocked(false, 'vertical')
                EDITOR.group[66]:setIsLocked(false, 'vertical')
            end, 3)
        end
    elseif type == 'color' and ALERT then
        local data = GET_GAME_CODE(CURRENT_LINK)
        local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)
        local blockIndex, paramsIndex = restart[2], index
        local paramsData = script.params[blockIndex].params[paramsIndex]

        EDITOR.group[9]:setIsLocked(true, 'vertical')
        EDITOR.group[66]:setIsLocked(true, 'vertical')

        COLOR.new(COPY_TABLE((paramsData[1] and paramsData[1][1]) and JSON.decode(paramsData[1][1]) or {255, 255, 255, 255}), function(e)
            EDITOR.rScrollParams = {}

            if e.input then
                script.params[blockIndex].params[paramsIndex][1] = {e.rgb, 'c'}
                BLOCKS.group.blocks[blockIndex].data.params[paramsIndex][1] = {e.rgb, 'c'}
                BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text =
                BLOCK.getParamsValueText(BLOCKS.group.blocks[blockIndex].data.params, paramsIndex)
                SET_GAME_CODE(CURRENT_LINK, data)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
            end

            for i = #EDITOR.group[66].buttons, 1, -1 do
                if EDITOR.group[66].buttons[i].isOpen then
                    table.insert(EDITOR.rScrollParams, 1, i)
                end
            end

            table.insert(EDITOR.rScrollParams, select(2, EDITOR.group[66]:getContentPosition()))
            EDITOR.scrollY = select(2, EDITOR.group[8]:getContentPosition())
            table.remove(restart[3], M.find(restart[3]))
            EDITOR.group:removeSelf() EDITOR.group = nil
            EDITOR.create(unpack(restart))
            EDITOR.group.isVisible = true
        end)
    elseif PARAMS.getListValue(type) and ALERT then
        local data = GET_GAME_CODE(CURRENT_LINK)
        local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)
        local blockIndex, paramsIndex = restart[2], index
        local paramsData = script.params[blockIndex].params[paramsIndex]
        local listX = target.parent.parent.x + target.x + target.width / 2
        local listY = EDITOR.group[1].y + EDITOR.group[1].height + 295

        EDITOR.group[9]:setIsLocked(true, 'vertical')
        EDITOR.group[66]:setIsLocked(true, 'vertical')

        LIST.new(PARAMS.getListButtons(type), listX, listY, 'down', function(e)
            EDITOR.rScrollParams = {}

            if e.index > 0 then
                script.params[blockIndex].params[paramsIndex][1] = {PARAMS.getListValue(type, e.text), 'sl'}
                BLOCKS.group.blocks[blockIndex].data.params[paramsIndex][1] = {PARAMS.getListValue(type, e.text), 'sl'}
                BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text =
                BLOCK.getParamsValueText(BLOCKS.group.blocks[blockIndex].data.params, paramsIndex)
                SET_GAME_CODE(CURRENT_LINK, data)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
            end

            for i = #EDITOR.group[66].buttons, 1, -1 do
                if EDITOR.group[66].buttons[i].isOpen then
                    table.insert(EDITOR.rScrollParams, 1, i)
                end
            end

            table.insert(EDITOR.rScrollParams, select(2, EDITOR.group[66]:getContentPosition()))
            EDITOR.scrollY = select(2, EDITOR.group[8]:getContentPosition())
            table.remove(restart[3], M.find(restart[3]))
            EDITOR.group:removeSelf() EDITOR.group = nil
            EDITOR.create(unpack(restart))
            EDITOR.group.isVisible = true
        end, paramsData[1] and paramsData[1][1] or nil)
    elseif (type == 'var' or type == 'vars' or type == 'table' or type == 'fun' or type == 'localvar' or type == 'localtable') and ALERT then
        local data = GET_GAME_CODE(CURRENT_LINK)
        local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)
        local blockIndex, paramsIndex = restart[2], index
        local paramsData = script.params[blockIndex].params[paramsIndex]
        local paramsType = type == 'localvar' and 'vars' or type == 'localtable' and 'tables' or type .. 's'

        EDITOR.rScrollParams = {}
        EDITOR.group[9]:setIsLocked(true, 'vertical')
        EDITOR.group[66]:setIsLocked(true, 'vertical')

        for i = #EDITOR.group[66].buttons, 1, -1 do
            if EDITOR.group[66].buttons[i].isOpen then
                table.insert(EDITOR.rScrollParams, 1, i)
            end
        end

        table.insert(EDITOR.rScrollParams, select(2, EDITOR.group[66]:getContentPosition()))
        EDITOR.scrollY = select(2, EDITOR.group[8]:getContentPosition())
        table.remove(restart[3], M.find(restart[3]))
        LOGIC.new(paramsType, blockIndex, paramsIndex, COPY_TABLE(paramsData),
            (type == 'localvar' or type == 'localtable'), restart, type == 'vars')
    end
end

M.list = function(target)
    EDITOR.group[9]:setIsLocked(true, 'vertical')
    EDITOR.group[66]:setIsLocked(true, 'vertical')
    LIST.new({STR['button.copy'], STR['button.paste'], STR['button.alldelete']}, MAX_X, target.y - target.height / 2, 'down', function(e)
        EDITOR.group[9]:setIsLocked(false, 'vertical')
        EDITOR.group[66]:setIsLocked(false, 'vertical')

        if e.index ~= 0 then
            if e.index == 3 then
                EDITOR.cursor[2] = 'w'
                EDITOR.cursor[1] = 1
                EDITOR.data = {{'|', '|'}}
                EDITOR.backup = M.backup(EDITOR.backup, 'add', EDITOR.data)
                TEXT.set(TEXT.gen(EDITOR.data, EDITOR.cursor[2]), EDITOR.group[9])
                EDITOR.group[9]:scrollToPosition({y = 0, time = 0})
            elseif e.index == 2 and EDITOR.copy and EDITOR.cursor[2] == 'w' then
                local copy = COPY_TABLE(EDITOR.copy)
                local cursorI = M.find(EDITOR.data)
                local len = #copy[1] - 1

                EDITOR.cursor[1] = EDITOR.cursor[1] + len
                table.remove(copy[1], M.find(copy[1]))

                for i = #copy[1], 1, -1 do
                    table.insert(EDITOR.data, cursorI, copy[1][i])
                end

                EDITOR.backup = M.backup(EDITOR.backup, 'add', EDITOR.data)
                TEXT.set(TEXT.gen(EDITOR.data, EDITOR.cursor[2]), EDITOR.group[9])
            elseif e.index == 1 and #EDITOR.data > 1 then
                EDITOR.copy = {COPY_TABLE(EDITOR.data), COPY_TABLE(EDITOR.cursor)}
            end
        end
    end, nil, nil, 1)
end

M.backup = function(backup, mode, data, cursor)
    if mode == 'add' then
        backup[2] = backup[2] + 1
        backup[1][backup[2]] = COPY_TABLE(data)
        for i = backup[2] + 1, #backup[1] do backup[1][i] = nil end
    elseif mode == 'undo' then
        if backup[2] > 1 then
            backup[2] = backup[2] - 1
            data = COPY_TABLE(backup[1][backup[2]])
            cursor[1], cursor[2] = M.find(data), 'w'
        end
    elseif mode == 'redo' then
        if backup[2] < #backup[1] then
            backup[2] = backup[2] + 1
            data = COPY_TABLE(backup[1][backup[2]])
            cursor[1], cursor[2] = M.find(data), 'w'
        end
    end

    return backup, data, cursor
end

M['<-'] = function(data, cursor, backup)
    if cursor[2] == 'w' then
        if data[cursor[1] - 1] and data[cursor[1] - 1][2] == 't' then
            cursor[2] = 'r'
        elseif cursor[1] > 1 then
            cursor[1] = cursor[1] - 1
            table.remove(data, cursor[1] + 1)
            table.insert(data, cursor[1], {'|', '|'})
        end
    elseif cursor[2] == 'r' then
        if cursor[1] > 1 then
            cursor[2] = 'w'
            cursor[1] = cursor[1] - 1
            table.remove(data, cursor[1] + 1)
            table.insert(data, cursor[1], {'|', '|'})
        end
    end

    return data, cursor, backup
end

M['->'] = function(data, cursor, backup)
    if cursor[2] == 'w' then
        if cursor[1] < #data then
            cursor[1] = cursor[1] + 1
            table.remove(data, cursor[1] - 1)
            table.insert(data, cursor[1], {'|', '|'})
        end
    elseif cursor[2] == 'r' then
        cursor[2] = 'w'
    end

    return data, cursor, backup
end

M['C'] = function(data, cursor, backup)
    if cursor[1] > 1 then
        cursor[2] = 'w'
        cursor[1] = cursor[1] - 1
        table.remove(data, cursor[1])
        backup = M.backup(backup, 'add', data)
    end

    return data, cursor, backup
end

M['Text'] = function(data, cursor, backup)
    EDITOR.group[9]:setIsLocked(true, 'vertical')
    EDITOR.group[66]:setIsLocked(true, 'vertical')

    INPUT.new(STR['blocks.entertext'], function(event) end, function(e)
        EDITOR.group[9]:setIsLocked(false, 'vertical')
        EDITOR.group[66]:setIsLocked(false, 'vertical')

        if e.input then
            if cursor[2] == 'w' then
                cursor[1] = cursor[1] + 1
                table.insert(data, cursor[1] - 1, {e.text, 't'})
                backup = M.backup(backup, 'add', data)
            elseif cursor[2] == 'r' then
                data[cursor[1] - 1][1] = e.text
                backup = M.backup(backup, 'add', data)
            end

            TEXT.set(TEXT.gen(data, cursor[2]), EDITOR.group[9])
        end
    end, cursor[2] == 'r' and data[cursor[1] - 1][1] or '', nil, true) native.setKeyboardFocus(INPUT.box)

    return data, cursor, backup
end

M['Local'] = function(data, cursor, backup)
    if cursor[2] == 'w' then
        cursor[1] = cursor[1] + 1
        table.insert(data, cursor[1] - 1, {'{ }', 'u'})
        backup = M.backup(backup, 'add', data)
    end

    TEXT.set(TEXT.gen(data, cursor[2]), EDITOR.group[9])
    return data, cursor, backup
end

M['Hide'] = function(data, cursor, backup)
    local list, buttons = require 'Core.Editor.list'
    EDITOR.group[66]:scrollToPosition({y = 0, time = 0})

    for i = 1, 9 do
        if EDITOR.group[66].buttons[i].isOpen then
            if NOOBMODE then
                buttons = i < 3 and {STR['editor.list.project']} or i == 4 and {
                    STR['editor.list.prop.obj.noob'], STR['editor.list.prop.text'], STR['editor.list.prop.group'],STR['editor.list.prop.media']
                } or i == 3 and {STR['editor.list.project']} or i == 5 and EDITOR.fun
                or i == 6 and EDITOR.math or i == 7 and EDITOR.log or i == 8 and EDITOR.device or {
                    STR['editor.list.resource.images'], STR['editor.list.resource.sounds'], STR['editor.list.resource.videos'],
                    STR['editor.list.resource.fonts'], STR['editor.list.resource.others']
                }
            elseif BLOCKS.custom then
                buttons = i < 3 and {STR['editor.list.event'], STR['editor.list.script']} or i == 4 and {
                    STR['editor.list.prop.obj'], STR['editor.list.prop.text'], STR['editor.list.prop.group'],
                    STR['editor.list.prop.widget'], STR['editor.list.prop.media'], STR['editor.list.prop.files']
                } or i == 3 and {STR['editor.list.custom'], STR['editor.list.script']} or i == 5 and EDITOR.fun
                or i == 6 and EDITOR.math or i == 7 and EDITOR.log or i == 8 and EDITOR.device or {}
            else
                buttons = i < 3 and {STR['editor.list.event'], STR['editor.list.script'], STR['editor.list.project']} or i == 4 and {
                    STR['editor.list.prop.obj'], STR['editor.list.prop.text'], STR['editor.list.prop.group'],
                    STR['editor.list.prop.widget'], STR['editor.list.prop.media'], STR['editor.list.prop.files']
                } or i == 3 and {STR['editor.list.custom'], STR['editor.list.script'], STR['editor.list.project']} or i == 5 and EDITOR.fun
                or i == 6 and EDITOR.math or i == 7 and EDITOR.log or i == 8 and EDITOR.device or {
                    STR['editor.list.resource.images'], STR['editor.list.resource.sounds'], STR['editor.list.resource.videos'],
                    STR['editor.list.resource.fonts'], STR['editor.list.resource.others']
                }
            end

            list.set(EDITOR.group[66].buttons[i], buttons, i < 5, i > 4)
        end
    end

    return data, cursor, backup
end

M['Ok'] = function(data, cursor, backup)
    if TEXT.check(COPY_TABLE(data)) then
        local param = TEXT.number(data, true)
        local data = GET_GAME_CODE(CURRENT_LINK)
        local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)

        if not EDITOR.restart[6] then
            local blockIndex, paramsIndex = EDITOR.restart[2], EDITOR.restart[4]
            local params = script.params[blockIndex].params

            params[paramsIndex] = COPY_TABLE(param)
            BLOCKS.group.blocks[blockIndex].data.params = COPY_TABLE(params)
            BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text = BLOCK.getParamsValueText(params, paramsIndex)
            SET_GAME_CODE(CURRENT_LINK, data)
            SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)

            EDITOR.group:removeSelf()
            EDITOR.group = nil
            BLOCKS.group.isVisible = true
        else
            local CUSTOM = require 'Core.Modules.custom-block'
            local params = EDITOR.restart[8]

            params[EDITOR.restart[4]] = COPY_TABLE(param)
            EDITOR.group:removeSelf()
            EDITOR.group = nil

            ALERT = false CUSTOM.alert = true
            CUSTOM.scroll:setIsLocked(false, 'vertical')
            CUSTOM.scroll:remove(M.block) CUSTOM.block:removeSelf()
            CUSTOM.genBlock(COPY_TABLE(params), EDITOR.restart[7])

            for i = 2, 12 do
                CUSTOM.group[i].isVisible = true
            end

            EXITS.add(CUSTOM.removeOverlay, EDITOR.restart[7])
        end
    else
        EDITOR.group[9]:setIsLocked(true, 'vertical')
        EDITOR.group[66]:setIsLocked(true, 'vertical')
        WINDOW.new(STR['editor.window.error'], {STR['button.close'], STR['editor.button.error']}, function(e)
            EDITOR.group[9]:setIsLocked(false, 'vertical')
            EDITOR.group[66]:setIsLocked(false, 'vertical')
        end, 3) return data, cursor, backup
    end
end

local syms = {'+', '-', '*', '/', '.', ',', '(', ')', '[', ']', '=='}

for i = 1, #syms do
    M[syms[i]] = function(data, cursor, backup)
        if cursor[2] == 'w' then
            cursor[1] = cursor[1] + 1
            table.insert(data, cursor[1] - 1, {syms[i], i == 5 and 'n' or i == 11 and 'l' or 's'})
            backup = M.backup(backup, 'add', data)
        end

        return data, cursor, backup
    end
end

for i = 0, 9 do
    M[tostring(i)] = function(data, cursor, backup)
        if cursor[2] == 'w' then
            cursor[1] = cursor[1] + 1
            table.insert(data, cursor[1] - 1, {tostring(i), 'n'})
            backup = M.backup(backup, 'add', data)
        end

        return data, cursor, backup
    end
end

return M
