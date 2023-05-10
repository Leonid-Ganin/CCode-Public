local LISTENER = require 'Core.Interfaces.settings'
local M = {}

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = CENTER_X == 641 and DISPLAY_HEIGHT or DISPLAY_WIDTH
        bg.height = CENTER_X == 641 and DISPLAY_WIDTH or DISPLAY_HEIGHT
        bg.rotation = CENTER_X == 641 and 90 or 0
    M.group:insert(bg)

    -- local lineH = display.newRect(MAX_X - 250, CENTER_Y, 10, DISPLAY_HEIGHT)
    -- M.group:insert(lineH)

    local lMaxWidth = MAX_X - ZERO_X - 250
    local rCenterX = ZERO_X + (lMaxWidth + MAX_X + 20) / 2
    local rMaxWidth = 200

    local title = display.newText(STR['menu.settings'], ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local lang_text = display.newText({
            text = STR['settings.applang'], x = ZERO_X + 20, y = title.y + 120,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) lang_text.anchorX = 0
    M.group:insert(lang_text)

    local lang_button = display.newRect(rCenterX, lang_text.y, rMaxWidth, 60)
        lang_button:setFillColor(0, 0, 0, 0.005)
        lang_button.text = display.newText(STR['lang.' .. LOCAL.lang], lang_button.x, lang_button.y, 'ubuntu', 30)
    M.group:insert(lang_button)
    M.group:insert(lang_button.text)

    local dog_text = display.newText({
            text = STR['settings.old_dog'], x = ZERO_X + 20, y = lang_text.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) dog_text.anchorX = 0
    M.group:insert(dog_text)

    local dog_button = display.newRect(rCenterX, dog_text.y, rMaxWidth, 60)
        dog_button:setFillColor(0, 0, 0, 0.005)
        dog_button.text = display.newText('', dog_button.x, dog_button.y, 'ubuntu', 30)
        dog_button.text.text = LOCAL.old_dog and STR['button.yes'] or STR['button.no']
    M.group:insert(dog_button)
    M.group:insert(dog_button.text)

    local confirm_text = display.newText({
            text = STR['settings.confirmdelete'], x = ZERO_X + 20, y = dog_text.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) confirm_text.anchorX = 0
    M.group:insert(confirm_text)

    local confirm_button = display.newRect(rCenterX, confirm_text.y, rMaxWidth, 60)
        confirm_button:setFillColor(0, 0, 0, 0.005)
        confirm_button.text = display.newText('', confirm_button.x, confirm_button.y, 'ubuntu', 30)
        confirm_button.text.text = LOCAL.confirm and STR['button.yes'] or STR['button.no']
    M.group:insert(confirm_button)
    M.group:insert(confirm_button.text)

    local autoplace_text = display.newText({
            text = STR['settings.autoplace'], x = ZERO_X + 20, y = confirm_text.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) autoplace_text.anchorX = 0
    M.group:insert(autoplace_text)

    local autoplace_button = display.newRect(rCenterX, autoplace_text.y, rMaxWidth, 60)
        autoplace_button:setFillColor(0, 0, 0, 0.005)
        autoplace_button.text = display.newText('', autoplace_button.x, autoplace_button.y, 'ubuntu', 30)
        autoplace_button.text.text = LOCAL.autoplace and STR['button.yes'] or STR['button.no']
    M.group:insert(autoplace_button)
    M.group:insert(autoplace_button.text)

    local keystore_text = display.newText({
            text = STR['settings.keystore'], x = ZERO_X + 20, y = autoplace_text.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) keystore_text.anchorX = 0
    M.group:insert(keystore_text)

    local keystore_button = display.newRect(rCenterX, keystore_text.y, rMaxWidth, 60)
        keystore_button:setFillColor(0, 0, 0, 0.005)
        keystore_button.text = display.newText('', keystore_button.x, keystore_button.y, 'ubuntu', 30)
        keystore_button.text.text = LOCAL.keystore[1] == 'testkey' and STR['settings.keystore.testkey'] or STR['settings.keystore.custom']
    M.group:insert(keystore_button)
    M.group:insert(keystore_button.text)

    local bottom_height_text = display.newText({
            text = STR['settings.bottom_height'], x = ZERO_X + 20, y = keystore_text.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) bottom_height_text.anchorX = 0
    M.group:insert(bottom_height_text)

    local bottom_height_button = display.newRect(rCenterX, bottom_height_text.y, rMaxWidth, 60)
        bottom_height_button:setFillColor(0, 0, 0, 0.005)
        bottom_height_button.text = display.newText('', bottom_height_button.x, bottom_height_button.y, 'ubuntu', 30)
        bottom_height_button.text.text = LOCAL.bottom_height or 0
    M.group:insert(bottom_height_button)
    M.group:insert(bottom_height_button.text)

    local show_ads_text = display.newText({
            text = STR['settings.showads'], x = ZERO_X + 20, y = confirm_button.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) show_ads_text.anchorX = 0
    M.group:insert(show_ads_text)

    local show_ads_button = display.newRect(rCenterX, show_ads_text.y, rMaxWidth, 60)
        show_ads_button:setFillColor(0, 0, 0, 0.005)
        show_ads_button.text = display.newText('', show_ads_button.x, show_ads_button.y, 'ubuntu', 30)
        show_ads_button.text.text = LOCAL.show_ads and STR['button.yes'] or STR['button.no']
    M.group:insert(show_ads_button)
    M.group:insert(show_ads_button.text)

    local pos_top_ads_text = display.newText({
            text = STR['settings.posads'], x = ZERO_X + 20, y = show_ads_button.y + 70,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) pos_top_ads_text.anchorX = 0
    M.group:insert(pos_top_ads_text)

    local pos_top_ads_button = display.newRect(rCenterX, pos_top_ads_text.y, rMaxWidth, 60)
        pos_top_ads_button:setFillColor(0, 0, 0, 0.005)
        pos_top_ads_button.text = display.newText('', pos_top_ads_button.x, pos_top_ads_button.y, 'ubuntu', 30)
        pos_top_ads_button.text.text = LOCAL.pos_top_ads and STR['settings.topads'] or STR['settings.bottomads']
    M.group:insert(pos_top_ads_button)
    M.group:insert(pos_top_ads_button.text)

    local orientation_text = display.newText({
            text = STR['settings.orientation'], x = ZERO_X + 20, y = pos_top_ads_button.y + 120,
            font = 'ubuntu', fontSize = 30, width = lMaxWidth, height = 36
        }) orientation_text.anchorX = 0
    M.group:insert(orientation_text)

    local orientation_group = display.newGroup()
        orientation_group.x = rCenterX
        orientation_group.y = orientation_text.y
        orientation_group.rotation = LOCAL.orientation == 'portrait' and 90 or 0
    M.group:insert(orientation_group)

    local orientation_icon = display.newRoundedRect(0, 0, 58, 100, 6)
        orientation_icon:setFillColor(0.15, 0.15, 0.17)
        orientation_icon:setStrokeColor(1)
        orientation_icon.strokeWidth = 3
        orientation_icon.rotation = 90
    orientation_group:insert(orientation_icon)

    local orientation_icon_left = display.newRect(0, 15 - orientation_icon.height / 2, 30, 1.6)
        orientation_icon_left:setFillColor(1)
    orientation_group:insert(orientation_icon_left)

    local orientation_icon_right = display.newRect(0, orientation_icon.height / 2 - 15, 30, 1.6)
        orientation_icon_right:setFillColor(1)
    orientation_group:insert(orientation_icon_right)

    if CENTER_X == 360 then
        local splash = display.newImage('Sprites/splash.png', ZERO_X + 10, MAX_Y - 10)
            splash.width = splash.width / 4
            splash.height = splash.height / 4
            splash.anchorX, splash.anchorY = 0, 1
        M.group:insert(splash)
    end

    show_ads_button.text.isVisible = false
    show_ads_button.isVisible = false
    show_ads_text.isVisible = false
    pos_top_ads_button.text.isVisible = false
    pos_top_ads_button.isVisible = false
    pos_top_ads_text.isVisible = false
    orientation_group.isVisible = false
    orientation_text.isVisible = false
    -- orientation_text.y = confirm_button.y + 120
    -- orientation_group.y = orientation_text.y

    title:addEventListener('touch', function(e) LISTENER(e, 'title') end)
    dog_button:addEventListener('touch', function(e) LISTENER(e, 'dog') end)
    lang_button:addEventListener('touch', function(e) LISTENER(e, 'lang') end)
    confirm_button:addEventListener('touch', function(e) LISTENER(e, 'confirm') end)
    keystore_button:addEventListener('touch', function(e) LISTENER(e, 'keystore') end)
    autoplace_button:addEventListener('touch', function(e) LISTENER(e, 'autoplace') end)
    bottom_height_button:addEventListener('touch', function(e) LISTENER(e, 'bottom_height') end)
    -- show_ads_button:addEventListener('touch', function(e) LISTENER(e, 'show') end)
    -- pos_top_ads_button:addEventListener('touch', function(e) LISTENER(e, 'pos') end)
    -- orientation_group:addEventListener('touch', function(e) LISTENER(e, 'orientation') end)
end

return M
