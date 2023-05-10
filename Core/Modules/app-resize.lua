local function appResize(type, listener)
    if CURRENT_ORIENTATION ~= type then
        CENTER_X, CENTER_Y = CENTER_Y, CENTER_X
        DISPLAY_WIDTH, DISPLAY_HEIGHT = DISPLAY_HEIGHT, DISPLAY_WIDTH
        TOP_HEIGHT, LEFT_HEIGHT = LEFT_HEIGHT, TOP_HEIGHT
        BOTTOM_HEIGHT, RIGHT_HEIGHT = RIGHT_HEIGHT, BOTTOM_HEIGHT

        ZERO_X = CENTER_X - DISPLAY_WIDTH / 2 + LEFT_HEIGHT
        ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2 + TOP_HEIGHT
        MAX_X = CENTER_X + DISPLAY_WIDTH / 2 - RIGHT_HEIGHT
        MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2 - BOTTOM_HEIGHT
    end

    CURRENT_ORIENTATION = type
    ORIENTATION.lock(CURRENT_ORIENTATION)
    if listener then listener({orientation = type}) end
end

function setOrientationApp(event)
    local vis = appResize(event.type, event.lis)

    -- if MENU and MENU.group then
    --     vis = MENU.group.isVisible
    --     MENU.group:removeSelf()
    --     MENU.group = nil
    --     MENU.create()
    --     MENU.group.isVisible = vis
    -- end
    --
    -- if PROGRAMS and PROGRAMS.group then
    --     vis = PROGRAMS.group.isVisible
    --     PROGRAMS.group:removeSelf()
    --     PROGRAMS.group = nil
    --     PROGRAMS.create()
    --     PROGRAMS.group.isVisible = vis
    -- end
    --
    -- if PROGRAM and PROGRAM.group then
    --     vis = PROGRAM.group.isVisible
    --     PROGRAM.group:removeSelf()
    --     PROGRAM.group = nil
    --     PROGRAM.create(LOCAL.last)
    --     PROGRAM.group.isVisible = vis
    -- end
    --
    -- if SCRIPTS and SCRIPTS.group then
    --     vis = SCRIPTS.group.isVisible
    --     SCRIPTS.group:removeSelf()
    --     SCRIPTS.group = nil
    --     SCRIPTS.create()
    --     SCRIPTS.group.isVisible = vis
    -- end
    --
    -- if IMAGES and IMAGES.group then
    --     vis = IMAGES.group.isVisible
    --     IMAGES.group:removeSelf()
    --     IMAGES.group = nil
    --     IMAGES.create()
    --     IMAGES.group.isVisible = vis
    -- end
    --
    -- if SOUNDS and SOUNDS.group then
    --     vis = SOUNDS.group.isVisible
    --     SOUNDS.group:removeSelf()
    --     SOUNDS.group = nil
    --     SOUNDS.create()
    --     SOUNDS.group.isVisible = vis
    -- end
    --
    -- if VIDEOS and VIDEOS.group then
    --     vis = VIDEOS.group.isVisible
    --     VIDEOS.group:removeSelf()
    --     VIDEOS.group = nil
    --     VIDEOS.create()
    --     VIDEOS.group.isVisible = vis
    -- end
    --
    -- if FONTS and FONTS.group then
    --     vis = FONTS.group.isVisible
    --     FONTS.group:removeSelf()
    --     FONTS.group = nil
    --     FONTS.create()
    --     FONTS.group.isVisible = vis
    -- end
    --
    -- if SETTINGS and SETTINGS.group then
    --     vis = SETTINGS.group.isVisible
    --     SETTINGS.group:removeSelf()
    --     SETTINGS.group = nil
    --     SETTINGS.create()
    --     SETTINGS.group.isVisible = vis
    -- end
    --
    -- if BLOCKS and BLOCKS.group then
    --     vis = BLOCKS.group.isVisible
    --     BLOCKS.group:removeSelf()
    --     BLOCKS.group = nil
    --     BLOCKS.create()
    --     BLOCKS.group.isVisible = vis
    -- end
    --
    -- if NEW_BLOCK and NEW_BLOCK.group then
    --     vis = NEW_BLOCK.group.isVisible
    --     NEW_BLOCK.group:removeSelf()
    --     NEW_BLOCK.group = nil
    --     NEW_BLOCK.create()
    --     NEW_BLOCK.group.isVisible = vis
    -- end
    --
    -- if EDITOR and EDITOR.group then
    --     vis = EDITOR.group.isVisible
    --     restart = COPY_TABLE(EDITOR.restart)
    --     restart[5] = true
    --     EDITOR.group:removeSelf()
    --     EDITOR.group = nil
    --     EDITOR.create(unpack(restart))
    --     EDITOR.group.isVisible = vis
    -- end
end
