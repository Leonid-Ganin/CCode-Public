local LOCAL_STR = {
    'program.scripts',
    'program.images',
    'program.levels',
    'program.sounds',
    'program.videos',
    'program.fonts',
    'program.resources',
    'menu.settings',
    'program.export',
    'program.build',
    'program.aab'
}

local BLOCK = require 'Core.Modules.interface-block'
local M = {}

local genBlocks = function()
    for i = 1, #LOCAL_STR do
        BLOCK.new(STR[LOCAL_STR[i]], M.scroll, M.group, 'program', #M.group.blocks + 1)
    end
end

M.create = function(app, noobmode)
    M.group = display.newGroup()
    M.group.isVisible = false
    M.group.data = {}
    M.group.blocks = {}

    if noobmode then
        LOCAL_STR[1] = 'program.scenarios'
        LOCAL_STR[2] = 'program.pictures'

        if LOCAL_STR[5] == 'program.videos' then
            table.remove(LOCAL_STR, 11)
            table.remove(LOCAL_STR, 7)
            table.remove(LOCAL_STR, 5)
        end

        if NEW_BLOCK and not NEW_BLOCK.noobmode then
            pcall(function() NEW_BLOCK.remove() end)
        end
    else
        LOCAL_STR[1] = 'program.scripts'
        LOCAL_STR[2] = 'program.images'

        if LOCAL_STR[5] ~= 'program.videos' then
            table.insert(LOCAL_STR, 5, 'program.videos')
            table.insert(LOCAL_STR, 7, 'program.resources')
            table.insert(LOCAL_STR, 11, 'program.aab')
        end

        if NEW_BLOCK and NEW_BLOCK.noobmode then
            pcall(function() NEW_BLOCK.remove() end)
        end
    end NOOBMODE = noobmode

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = CENTER_X == 641 and DISPLAY_HEIGHT or DISPLAY_WIDTH
        bg.height = CENTER_X == 641 and DISPLAY_WIDTH or DISPLAY_HEIGHT
        bg.rotation = CENTER_X == 641 and 90 or 0
    M.group:insert(bg)

    local title = display.newText(app, ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
        title.button = 'but_title'
        title:addEventListener('touch', require 'Core.Interfaces.program')
    M.group:insert(title)

    local but_play = display.newImage('Sprites/play.png', MAX_X - 190, MAX_Y - 95)
        but_play.alpha = 0.9
        but_play.button = 'but_play'
        but_play:addEventListener('touch', require 'Core.Interfaces.program')
    M.group:insert(but_play)

    M.scroll = WIDGET.newScrollView({
            x = CENTER_X, y = (but_play.y - but_play.height / 2 - 30 + (ZERO_Y + 62) + 72) / 2,
            width = DISPLAY_WIDTH, height = but_play.y - but_play.height / 2 - (ZERO_Y + 62) - 102,
            hideBackground = true, hideScrollBar = true, isBounceEnabled = true, horizontalScrollDisabled = true
        })
    M.group:insert(M.scroll)

    genBlocks()
end

return M
