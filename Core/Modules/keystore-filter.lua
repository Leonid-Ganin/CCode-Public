return {
    check = function(text, listener)
        local text = UTF8.trim(text)

        if UTF8.len(text) < 8 then
            listener({isError = true, typeError = 'min8sym'}) return
        elseif UTF8.len(text) > 32 then
            listener({isError = true, typeError = 'max32sym'}) return
        end

        listener({isError = false, text = text}) return
    end
}
