local LISTENER = require 'Core.Interfaces.robodog'
local M = {}

M.getPath = function(type, id)
    local ids = {'Face', 'Eyes', 'Ears', 'Mouth', 'Accessories'}
    if not id then id = LOCAL.dog[ids[type]:lower()] end
    return 'Sprites/' .. ids[type] .. '/cdog' .. ids[type] .. id .. '.png'
end

M.getDog = function(x, y, width, height, num)
    local dog, a = display.newGroup()

    if LOCAL.old_dog then
        a = display.newImage(dog, 'Sprites/ccdog' .. num .. '.png', x, y)
        pcall(function() a.width, a.height = width, height end)
    else
        a = display.newImage(dog, M.getPath(1), x, y)
        pcall(function() a.width, a.height = width, height end)
        a = display.newImage(dog, M.getPath(2), x, y)
        pcall(function() a.width, a.height = width, height end)
        a = display.newImage(dog, M.getPath(3), x, y)
        pcall(function() a.width, a.height = width, height end)
        a = display.newImage(dog, M.getPath(4), x, y)
        pcall(function() a.width, a.height = width, height end)
        a = display.newImage(dog, M.getPath(5), x, y)
        pcall(function() a.width, a.height = width, height end)
    end

    return dog
end

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false
    M.group.isOpen = false

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = CENTER_X == 641 and DISPLAY_HEIGHT or DISPLAY_WIDTH
        bg.height = CENTER_X == 641 and DISPLAY_WIDTH or DISPLAY_HEIGHT
        bg.rotation = CENTER_X == 641 and 90 or 0
    M.group:insert(bg)

    local width = DISPLAY_WIDTH - RIGHT_HEIGHT - 60
    local width3 = (DISPLAY_WIDTH - RIGHT_HEIGHT - 60) / 2

    local buttonDogs = display.newRect(CENTER_X - width / 2 + width3 / 2, ZERO_Y + 50, width3, 56)
        buttonDogs.isOn = true
        buttonDogs.alpha = 0.3
        buttonDogs.tag = 'dogs'
        buttonDogs:addEventListener('touch', function(e) LISTENER(e, 'toolbar') end)
    M.group:insert(buttonDogs)

    local buttonDogsText = display.newText(STR['menu.dogs'], buttonDogs.x, buttonDogs.y, 'ubuntu', 28)
    M.group:insert(buttonDogsText)

    local buttonAch = display.newRect(buttonDogs.x + width3, ZERO_Y + 50, width3, 56)
        buttonAch.isOn = false
        buttonAch.alpha = 0.1
        buttonAch.tag = 'ach'
        buttonAch:addEventListener('touch', function(e) LISTENER(e, 'toolbar') end)
    M.group:insert(buttonAch)

    local buttonAchText = display.newText(STR['robodog.achievements'], buttonAch.x, buttonAch.y, 'ubuntu', 28)
    M.group:insert(buttonAchText)

    local buttonShop = display.newRect(CENTER_X - width / 2 + width3 / 2, ZERO_Y + 106, width3, 56)
        buttonShop.isOn = false
        buttonShop.alpha = 0.1
        buttonShop.tag = 'shop'
        buttonShop:addEventListener('touch', function(e) LISTENER(e, 'toolbar') end)
    M.group:insert(buttonShop)

    local buttonShopText = display.newText(STR['robodog.shop'], buttonShop.x, buttonShop.y, 'ubuntu', 28)
    M.group:insert(buttonShopText)

    local buttonLearn = display.newRect(buttonShop.x + width3, ZERO_Y + 106, width3, 56)
        buttonLearn.isOn = false
        buttonLearn.alpha = 0.1
        buttonLearn.tag = 'learn'
        buttonLearn:addEventListener('touch', function(e) LISTENER(e, 'toolbar') end)
    M.group:insert(buttonLearn)

    local buttonLearnText = display.newText(STR['robodog.learning'], buttonLearn.x, buttonLearn.y, 'ubuntu', 28)
    M.group:insert(buttonLearnText)

    local buttonLine1 = display.newRect(CENTER_X, ZERO_Y + 78, 3, 112)
        buttonLine1:setFillColor(0.6)
    M.group:insert(buttonLine1)

    local buttonLine2 = display.newRect(CENTER_X, ZERO_Y + 78, width3 * 2, 3)
        buttonLine2:setFillColor(0.6)
    M.group:insert(buttonLine2)

    M.dog = {LOCAL.dog.face, LOCAL.dog.eyes, LOCAL.dog.ears, LOCAL.dog.mouth, LOCAL.dog.accessories}
    M.face = display.newImage(M.getPath(1), CENTER_X - 18, buttonShop.y + 300)
    M.eyes = display.newImage(M.getPath(2), CENTER_X - 18, buttonShop.y + 300)
    M.ears = display.newImage(M.getPath(3), CENTER_X - 18, buttonShop.y + 300)
    M.mouth = display.newImage(M.getPath(4), CENTER_X - 18, buttonShop.y + 300)
    M.accessories = display.newImage(M.getPath(5), CENTER_X - 18, buttonShop.y + 300)

    if M.face then M.group:insert(M.face) end
    if M.eyes then M.group:insert(M.eyes) end
    if M.ears then M.group:insert(M.ears) end
    if M.mouth then M.group:insert(M.mouth) end
    if M.accessories then M.group:insert(M.accessories) end

    M.frames = {}
    local x_frame = DISPLAY_WIDTH / 6
    local y_frame = M.face.y + M.face.height / 2 + 50

    for i = 1, 5 do
        M.frames[i] = display.newImage('Sprites/ccdogBg.png', x_frame, y_frame)
            M.frames[i].width = 100
            M.frames[i].height = 100
        M.group:insert(M.frames[i])

        M.frames[i].content = display.newImage(M.getPath(i), x_frame - 3, y_frame - 3)
            if M.frames[i].content then M.frames[i].content.width = 100 end
            if M.frames[i].content then M.frames[i].content.height = 100 end
        if M.frames[i].content then M.group:insert(M.frames[i].content) end

        x_frame = x_frame + DISPLAY_WIDTH / 6
        M.frames[i]:addEventListener('touch', function(e) e.i = i LISTENER(e, 'frame') end)

        M['frames' .. i] = {}
        local _x_frame = DISPLAY_WIDTH / 7
        local _y_frame = MAX_Y + DISPLAY_HEIGHT / 2

        for j = 1, (i == 1 and 25 or i == 2 and 38 or i == 3 and 35 or i == 4 and 34 or 11) do
            M['frames' .. i][j] = display.newImage('Sprites/ccdogBg.png', _x_frame, _y_frame)
                M['frames' .. i][j].width = 100
                M['frames' .. i][j].height = 100
            M.group:insert(M['frames' .. i][j])

            M['frames' .. i][j].content = display.newImage(M.getPath(i, j), _x_frame - 3, _y_frame - 3)
                if M['frames' .. i][j].content then M['frames' .. i][j].content.width = 100 end
                if M['frames' .. i][j].content then M['frames' .. i][j].content.height = 100 end
            if M['frames' .. i][j].content then M.group:insert(M['frames' .. i][j].content) end

            _x_frame = j % 6 == 0 and DISPLAY_WIDTH / 7 or _x_frame + DISPLAY_WIDTH / 7
            _y_frame = j % 6 == 0 and _y_frame + DISPLAY_WIDTH / 7 or _y_frame
            M['frames' .. i][j]:addEventListener('touch', function(e) e.j, e.i = j, i LISTENER(e, 'frames') end)
        end
    end

    M.face:addEventListener('touch', function(e) LISTENER(e, 'face') end)
end

return M
