local M = {}

M.getBitmapTexture = function(link, name)
    local data, width, height = IMPACK.image.load(link, system.DocumentsDirectory, {req_comp = 3})
    local x, y, size = 1, 1, width * height

    GAME.group.bitmaps[name] = BITMAP.newTexture({width = width, height = height})

    for i = 1, size do
        local args = {data:byte(i * 3 - 2, i * 3)}
        GAME.group.bitmaps[name]:setPixel(x, y, args[1] / 255, args[2] / 255, args[3] / 255, 1)
        x = x == width and 1 or x + 1
        y = x == 1 and y + 1 or y
    end

    GAME.group.bitmaps[name]:invalidate()
end

M.getPhysicsParams = function(friction, bounce, density, hitbox, filter)
    local params = {friction = friction, bounce = bounce, density = density}

    if filter and filter[1] and filter[2] then
        params.filter = {
            categoryBits = math.getBit(filter[1]),
            maskBits = math.getMaskBits(filter[2])
        }
    end

    if hitbox.type == 'box' then
        params.box = {
            halfWidth = hitbox.halfWidth, halfHeight = hitbox.halfHeight,
            x = hitbox.offsetX, y = hitbox.offsetY, angle = hitbox.rotation
        }
    elseif hitbox.type == 'circle' then
        params.radius = hitbox.radius
    elseif hitbox.type == 'mesh' then
        params.outline = hitbox.outline
    elseif hitbox.type == 'polygon' then
        if type(hitbox.shape) == 'table' then
            if type(hitbox.shape[1]) == 'table' then
                local _params = COPY_TABLE(params) params = {}

                for i = 1, #hitbox.shape do
                    params[i] = COPY_TABLE(_params)

                    for j = 1, #hitbox.shape[i] do
                        if j % 2 == 0 then
                            hitbox.shape[i][j] = -hitbox.shape[i][j]
                        end
                    end

                    params[i].shape = hitbox.shape[i]
                end
            else
                for i = 1, #hitbox.shape do
                    if i % 2 == 0 then
                        hitbox.shape[i] = -hitbox.shape[i]
                    end
                end

                params.shape = hitbox.shape
            end
        else
            params.shape = hitbox.shape
        end
    end

    return params
end

M.getPath = function(path, docType, isShort, isFolder)
    if UTF8.find(path, '%.%.') then return nil end
    return (isShort and '' or (DOC_DIR .. '/')) .. CURRENT_LINK .. '/' .. docType .. (isFolder and '' or '/' .. path)
end

M.getResource = function(link)
    for i = 1, #GAME.RESOURCES.others do
        if GAME.RESOURCES.others[i][1] == link then
            return CURRENT_LINK .. '/Resources/' .. GAME.RESOURCES.others[i][2]
        elseif GAME.RESOURCES.others[i][1] == 'Documents:' .. link or GAME.RESOURCES.others[i][1] == 'Temps:' .. link then
            return GAME.RESOURCES.others[i][2]
        end
    end
end

M.getSound = function(link)
    for i = 1, #GAME.RESOURCES.sounds do
        if GAME.RESOURCES.sounds[i][1] == link then
            return CURRENT_LINK .. '/Sounds/' .. GAME.RESOURCES.sounds[i][2]
        elseif GAME.RESOURCES.sounds[i][1] == 'Documents:' .. link or GAME.RESOURCES.sounds[i][1] == 'Temps:' .. link then
            return GAME.RESOURCES.sounds[i][2]
        end
    end
end

M.getVideo = function(link)
    for i = 1, #GAME.RESOURCES.videos do
        if GAME.RESOURCES.videos[i][1] == link then
            return CURRENT_LINK .. '/Videos/' .. GAME.RESOURCES.videos[i][2]
        elseif GAME.RESOURCES.videos[i][1] == 'Documents:' .. link or GAME.RESOURCES.videos[i][1] == 'Temps:' .. link then
            return GAME.RESOURCES.videos[i][2]
        end
    end
end

M.getImage = function(link)
    for i = 1, #GAME.RESOURCES.images do
        if GAME.RESOURCES.images[i][1] == link then
            return CURRENT_LINK .. '/Images/' .. GAME.RESOURCES.images[i][3], GAME.RESOURCES.images[i][2] or 'nearest'
        elseif GAME.RESOURCES.images[i][1] == 'Documents:' .. link or GAME.RESOURCES.images[i][1] == 'Temps:' .. link then
            return GAME.RESOURCES.images[i][3], GAME.RESOURCES.images[i][2] or 'nearest'
        end
    end
end

M.getFont = function(font)
    for i = 1, #GAME.RESOURCES.fonts do
        if GAME.RESOURCES.fonts[i][1] == font then
            if CURRENT_LINK ~= 'App' then
                local new_font = io.open(DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts/' .. GAME.RESOURCES.fonts[i][2], 'rb')
                local main_font = io.open(RES_PATH .. '/' .. CURRENT_LINK .. '_' .. GAME.RESOURCES.fonts[i][2], 'wb')

                if new_font and main_font then
                    main_font:write(new_font:read('*a'))
                    io.close(main_font)
                    io.close(new_font)
                end

                return CURRENT_LINK .. '_' .. GAME.RESOURCES.fonts[i][2]
            end

            return GAME.RESOURCES.fonts[i][2]
        elseif GAME.RESOURCES.fonts[i][1] == 'Documents:' .. font or GAME.RESOURCES.fonts[i][1] == 'Temps:' .. font then
            local rfilename = UTF8.reverse(GAME.RESOURCES.fonts[i][2])
            local filename = UTF8.reverse(UTF8.sub(rfilename, 1, UTF8.find(rfilename, '%/') - 1))
            local new_font = io.open(GAME.RESOURCES.fonts[i][2], 'rb')
            local main_font = io.open(RES_PATH .. '/' .. CURRENT_LINK .. '_' .. filename, 'wb')

            if new_font and main_font then
                main_font:write(new_font:read('*a'))
                io.close(main_font)
                io.close(new_font)
            end

            return CURRENT_LINK .. '_' .. filename
        end
    end

    return font
end

return M
