return function(params, default, withoutBrackets, isApi, isSetter)
    if not params then return default or '0' end
    local result, index = #params == 0 and ' 0' or ''

    for i = 1, #params do
        if params[i - 1] and params[i - 1][2] == 's' and params[i - 1][1] == '[' then
            index = UTF8.len(result)
        end

        if params[i][2] ~= 's' and (params[i][2] ~= 't' or not isApi) then
            params[i][1] = params[i][1]:gsub('\\\'', '\\\\\''):gsub('\n', '\\n'):gsub('\r', ''):gsub('\'', '\\\'')

            local len = UTF8.len(params[i][1])
            if UTF8.sub(params[i][1], len) == '\\' then
                local factor = 0

                for j = len - 1, 1, -1 do
                    if UTF8.sub(params[i][1], j, j) == '\\' then
                        factor = factor + 1
                    else
                        break
                    end
                end

                if factor % 2 == 0 then
                    params[i][1] = UTF8.sub(params[i][1], 1, len - 1)
                end
            end
        end

        if params[i][2] == 'n' then
            result = result .. ' ' .. params[i][1]
        elseif params[i][2] == 'c' then
            result = result .. ' JSON.decode(\'' .. params[i][1] .. '\')'
        elseif params[i][2] == 'u' then
            return '{}'
        elseif params[i][2] == 'l' then
            result = result .. ' ' .. params[i][1]
        elseif params[i][2] == 'f' then
            result = result .. ' fun[\'' .. params[i][1] .. '\']'
            if params[i][1] == 'unix_time' then result = result .. '()' end
        elseif params[i][2] == 'd' then
            result = result .. ' device[\'' .. params[i][1] .. '\']()'
        elseif params[i][2] == 'sl' then
            result = result .. ' select[\'' .. params[i][1] .. '\']()'
        elseif params[i][2] == 'm' then
            result = result .. ' math[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'p' then
            result = result .. ' prop[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 's' then
            if params[i][1] == '+' and ((params[i - 1] and params[i - 1][2] == 't') or (params[i + 1] and params[i + 1][2] == 't')) then
                result = result .. ' ..'
            else
                if params[i][1] == '[' or params[i][1] == ']' then
                    result = result .. params[i][1]
                else
                    result = result .. ' ' .. params[i][1]
                end
            end
        elseif params[i][2] == 't' then
            if isApi then params[i][1] = params[i][1]:gsub('\n', '\\n'):gsub('\r', ''):gsub('\'', '\\\'') end
            result = result .. ' \'' .. params[i][1] .. '\''
        elseif params[i][2] == 'tE' then
            result = result .. ' tablesE[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'tS' then
            result = result .. ' tablesS[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'tP' then
            result = result .. ' tablesP[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'vE' then
            result = result .. ' varsE[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'vS' then
            result = result .. ' varsS[\'' .. params[i][1] .. (isSetter and '__set\']' or '\']')
        elseif params[i][2] == 'vP' then
            result = result .. ' varsP[\'' .. params[i][1] .. (isSetter and '__set\']' or '\']')
        elseif params[i][2] == 'fS' then
            result = result .. ' funsS[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'fP' then
            result = result .. ' funsP[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'fC' then
            result = result .. ' funsC[\'' .. params[i][1] .. '\']'
        end

        if index then
            result, index = UTF8.sub(result, 1, index) .. UTF8.sub(result, index + 2, UTF8.len(result)), nil
        end
    end

    return (#params == 0 and default) and default or UTF8.sub(result, 1, 1) == ' '
    and (withoutBrackets and UTF8.sub(result, 2, UTF8.len(result)) or '(' .. UTF8.sub(result, 2, UTF8.len(result)) .. ')')
    or (withoutBrackets and 't' .. result .. '' or '(t' .. result .. ')')
end
