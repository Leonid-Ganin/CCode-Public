local M = {}

M['get_text'] = function(name)
    local isComplete, result = pcall(function()
        return GAME.group.texts[name or '0'] and GAME.group.texts[name or '0'].text or ''
    end) return isComplete and result or ''
end

M['read_save'] = function(key)
    local isComplete, result = pcall(function()
        return GET_GAME_SAVE(CURRENT_LINK)[tostring(key)]
    end) return isComplete and result or nil
end

M['random_str'] = function(...)
    local args = {...}

    local isComplete, result = pcall(function()
        if #args > 0 then
            return args[math.random(1, #args)]
        else
            return nil
        end
    end) return isComplete and result or ''
end

M['concat'] = function(...)
    local args, str = {...}, ''

    local isComplete, result = pcall(function()
        for i = 1, #args do
            str = str .. args[i]
        end

        return str
    end) return isComplete and result or ''
end

M['tonumber'] = function(str)
    local isComplete, result = pcall(function()
        return tonumber(str) or 0
    end) return isComplete and result or 0
end

M['tostring'] = function(any)
    return tostring(any)
end

M['totable'] = function(str)
    return JSON.decode(str)
end

M['len_table'] = function(t)
    return table.len(t)
end

M['exists_in_table'] = function(t, value)
    local isComplete, result = pcall(function()
        if _G.type(t) == 'table' and #t > 0 then
            return table.indexOf(t, value)
        end
    end) return isComplete and result or nil
end

M['noise'] = function(x, y, seed)
    return NOISE.new(x, y, seed)
end

M['encode'] = function(t, prettify, validate)
    local isComplete, result = pcall(function()
        if type(t) == 'table' and t._ccode_event then
            t = COPY_TABLE(t)
            t._ccode_event = nil
        end

        if validate then
            local t = COPY_TABLE(t)

            for k, v in pairs(t) do
                if type(k) ~= 'string' and type(k) ~= 'number' then
                    t[k], t[tostring(k)] = nil, v
                end
            end

            return JSON[prettify and 'encode' or 'prettify'](t)
        end

        return JSON[prettify and 'encode' or 'prettify'](t)
    end) return isComplete and result or '{}'
end

M['gsub'] = function(str, pattern, replace, n)
    local isComplete, result = pcall(function()
        return UTF8.gsub(str, pattern, replace, n)
    end) return isComplete and result or str
end

M['sub'] = function(str, i, j)
    local isComplete, result = pcall(function()
        return UTF8.sub(str, i, j)
    end) return isComplete and result or str
end

M['len'] = function(str)
    local isComplete, result = pcall(function()
        return UTF8.len(str)
    end) return isComplete and result or 0
end

M['find'] = function(str, pattern, i, plain)
    local isComplete, result = pcall(function()
        return UTF8.find(str, pattern, i, plain)
    end) return isComplete and result or nil
end

M['split'] = function(str, sep)
    local isComplete, result = pcall(function()
        return UTF8.split(str, sep)
    end) return isComplete and result or {}
end

M['match'] = function(str, pattern, i)
    local isComplete, result = pcall(function()
        return UTF8.match(str, pattern, i)
    end) return isComplete and result or nil
end

M['rep'] = function(str, count)
    local isComplete, result = pcall(function()
        return str:rep(count)
    end) return isComplete and result or str
end

M['reverse'] = function(str)
    local isComplete, result = pcall(function()
        return UTF8.reverse(str)
    end) return isComplete and result or str
end

M['upper'] = function(str)
    local isComplete, result = pcall(function()
        return UTF8.upper(str)
    end) return isComplete and result or str
end

M['lower'] = function(str)
    local isComplete, result = pcall(function()
        return UTF8.lower(str)
    end) return isComplete and result or str
end

M['byte'] = function(str, noSum)
    local isComplete, result = pcall(function()
        if noSum then
            return UTF8.trim((function(s) for i = 1, UTF8.len(str) do s = s .. ' ' .. UTF8.byte(UTF8.sub(str, i, i)) end return s end)(''))
        end return math.sum(UTF8.byte(str, 1, UTF8.len(str)))
    end) return isComplete and result or nil
end

M['char'] = function(byte, noSum)
    local isComplete, result = pcall(function()
        if noSum then
            local result = '' while UTF8.find(byte, ' ') do
                result, byte = result .. UTF8.char(UTF8.sub(byte, 1, UTF8.find(byte, ' ') - 1)), UTF8.sub(byte, UTF8.find(byte, ' ') + 1)
            end return result .. UTF8.char(byte)
        end return UTF8.char(byte)
    end) return isComplete and result or nil
end

M['get_ip'] = function(any)
    local isComplete, result = pcall(function()
        return SERVER.getIP()
    end) return isComplete and result or nil
end

M['color_pixel'] = function(x, y)
    local isComplete, result = pcall(function()
        local x = x or 0
        local y = y or 0
        local colors = {0, 0, 0, 0}

        display.colorSample(CENTER_X + x, CENTER_Y - y, function(e)
            colors = {math.round(e.r * 255), math.round(e.g * 255), math.round(e.b * 255), math.round(e.a * 255)}
        end)

        return colors
    end) return isComplete and result or {0, 0, 0, 0}
end

M['unix_time'] = function()
    return os.time()
end

M['parameter'] = function(name, type, parameter)
    local isComplete, result = pcall(function()
        if name == nil and type ~= nil then
            return GAME.group[type]
        elseif name == nil then
            return GAME.group
        elseif parameter == nil then
            return GAME.group[type][name or '0']
        else
            return GAME.group[type][name or '0'] and GAME.group[type][name or '0'][parameter] or nil
        end
    end) return isComplete and result or nil
end

return M
