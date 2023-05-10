return {
    check = function(text, listener)
        local text = UTF8.trim(text)
        local text = tonumber(text)

        if text and text >= -300 and text <= 300 then
            listener({isError = false, text = text}) return
        end

        listener({isError = true, typeError = 'bottom_height'})
    end
}
