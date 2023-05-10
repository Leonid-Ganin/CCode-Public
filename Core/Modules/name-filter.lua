return {
    check = function(text, listener, blocks, data, type)
        local text = UTF8.trim(text)

        if UTF8.len(text) > 0 then
            for i = 1, #blocks do
                if blocks[i].indexFolder and blocks[i].commentFolder then
                    local indexFolder = blocks[i].getFolderIndex(blocks[i])
                    for j = 1, #data.folders[type][indexFolder][2] do
                        if type == 'scripts' then
                            if GET_GAME_SCRIPT(CURRENT_LINK, data.folders[type][indexFolder][2][j], data).title == text then
                                listener({isError = true, typeError = 'name'}) return
                            end
                        elseif data.folders[type][indexFolder][2][j][1] == text then
                            listener({isError = true, typeError = 'name'}) return
                        end
                    end
                elseif blocks[i].text.text == text then
                    listener({isError = true, typeError = 'name'}) return
                end
            end
        else
            listener({isError = true, typeError = 'filter'}) return
        end

        listener({isError = false, text = text}) return
    end
}
