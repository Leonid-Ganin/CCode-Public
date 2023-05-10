local M = {}

M.create = function()
    local data = GET_GAME_CODE(CURRENT_LINK)

    M.group = display.newGroup()
    M.group.isVisible = false
    M.group.data = {}
    M.group.blocks = {}

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = CENTER_X == 641 and DISPLAY_HEIGHT or DISPLAY_WIDTH
        bg.height = CENTER_X == 641 and DISPLAY_WIDTH or DISPLAY_HEIGHT
        bg.rotation = CENTER_X == 641 and 90 or 0
    M.group:insert(bg)

    local title = display.newText(STR['program.psettings'], ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local build_text = display.newText(STR['psettings.build'], ZERO_X + 20, title.y + 150, 'ubuntu', 30)
        build_text.anchorX = 0
    M.group:insert(build_text)

    local build_value = display.newText({
            text = '\'' .. data.settings.build .. '\'', align = 'left',
            x = MAX_X - 50, y = build_text.y, height = build_text.height - 4,
            width = MAX_X - 100 - build_text.x - build_text.width, fontSize = 26, font = 'ubuntu'
        }) build_value.anchorX = 1
    M.group:insert(build_value)

    local build_button = display.newRect(build_value.x, build_value.y, build_value.width + 10, build_value.height + 14)
        build_button.anchorX = 1
        build_button:setFillColor(0, 0.2)
        build_button.value = build_value
    M.group:insert(build_button)
        build_value:toFront()

    local version_text = display.newText(STR['psettings.version'], ZERO_X + 20, build_text.y + 100, 'ubuntu', 30)
        version_text.anchorX = 0
    M.group:insert(version_text)

    local version_value = display.newText({
            text = '\'' .. data.settings.version .. '\'', align = 'left',
            x = MAX_X - 50, y = version_text.y, height = version_text.height - 4,
            width = MAX_X - 100 - version_text.x - version_text.width, fontSize = 26, font = 'ubuntu'
        }) version_value.anchorX = 1
    M.group:insert(version_value)

    local version_button = display.newRect(version_value.x, version_value.y, version_value.width + 10, version_value.height + 14)
        version_button.anchorX = 1
        version_button:setFillColor(0, 0.2)
        version_button.value = version_value
    M.group:insert(version_button)
        version_value:toFront()

    local package_text = display.newText(STR['psettings.package'], ZERO_X + 20, version_text.y + 100, 'ubuntu', 30)
        package_text.anchorX = 0
    M.group:insert(package_text)

    local package_value = display.newText({
            text = '\'' .. data.settings.package .. '\'', align = 'left',
            x = MAX_X - 50, y = package_text.y, height = package_text.height - 4,
            width = MAX_X - 100 - package_text.x - package_text.width, fontSize = 26, font = 'ubuntu'
        }) package_value.anchorX = 1
    M.group:insert(package_value)

    local package_button = display.newRect(package_value.x, package_value.y, package_value.width + 10, package_value.height + 14)
        package_button.anchorX = 1
        package_button:setFillColor(0, 0.2)
        package_button.value = package_value
    M.group:insert(package_button)
        package_value:toFront()

    local icon_text = display.newText(STR['psettings.icon'], ZERO_X + 20, package_text.y + 150, 'ubuntu', 30)
        icon_text.anchorX = 0
    M.group:insert(icon_text)

    local orientation_text = display.newText(STR['psettings.orientation'], ZERO_X + 20, icon_text.y + 150, 'ubuntu', 30)
        orientation_text.anchorX = 0
    M.group:insert(orientation_text)

    local orientation_group = display.newGroup()
        orientation_group.x = MAX_X - 150
        orientation_group.y = orientation_text.y
        orientation_group.rotation = data.settings.orientation == 'portrait' and 90 or 0
    M.group:insert(orientation_group)

    local orientation_icon = display.newRoundedRect(0, 0, 58, 100, 6)
        orientation_icon:setFillColor(0.15, 0.15, 0.17)
        orientation_icon:setStrokeColor(1)
        orientation_icon.strokeWidth = 3
        orientation_icon.rotation = 90
    orientation_group:insert(orientation_icon)

    local orientation_icon_left = display.newRect(0, 15 - orientation_icon.height / 2, 30, 1.5)
        orientation_icon_left:setFillColor(1)
    orientation_group:insert(orientation_icon_left)

    local orientation_icon_right = display.newRect(0, orientation_icon.height / 2 - 15, 30, 1.5)
        orientation_icon_right:setFillColor(1)
    orientation_group:insert(orientation_icon_right)

    local path, icon, isIcon = DOC_DIR .. '/' .. CURRENT_LINK .. '/icon.png'
    local file = io.open(path, 'r') if file then isIcon = true io.close(file) end

    local container = display.newContainer(100, 100)
        container:translate(MAX_X - 150, icon_text.y)
    M.group:insert(container)

    if isIcon then
        icon = display.newImage(CURRENT_LINK .. '/icon.png', system.DocumentsDirectory)
            local diffSize = icon.height / icon.width
            if icon.height > icon.width then
                icon.height = 90
                icon.width = 90 / diffSize
            else
                icon.width = 90
                icon.height = 90 * diffSize
            end
        container:insert(icon, true)
    else
        icon = display.newRoundedRect(0, 0, 100, 100, 25)
            icon:setFillColor(0.1, 0.1, 0.12)
        container:insert(icon, true)
    end

    title.id = 'title'
    title:addEventListener('touch', require 'Core.Interfaces.program-settings')

    icon.id = 'icon'
    icon:addEventListener('touch', require 'Core.Interfaces.program-settings')

    version_button.id = 'version_button'
    version_button:addEventListener('touch', require 'Core.Interfaces.program-settings')

    package_button.id = 'package_button'
    package_button:addEventListener('touch', require 'Core.Interfaces.program-settings')

    orientation_group.id, orientation_group.data = 'orientation_icon', data
    orientation_group:addEventListener('touch', require 'Core.Interfaces.program-settings')
end

return M
