display.setStatusBar(display.HiddenStatusBar)
display.setStatusBar(display.TranslucentStatusBar)
display.setStatusBar(display.HiddenStatusBar)

timer.performWithDelay(system.getInfo 'environment' == 'simulator' and 0 or 100, function()
    display.setStatusBar(display.HiddenStatusBar)
    display.setStatusBar(display.TranslucentStatusBar)
    display.setStatusBar(display.HiddenStatusBar)

    GLOBAL = require 'Data.global'
    MENU = require 'Interfaces.menu'
    ROBODOG = require 'Interfaces.robodog'
    MENU.create() MENU.group.isVisible = true
end)
