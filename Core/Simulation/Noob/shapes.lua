local EVENTS = require 'Core.Simulation.events'
local CALC = require 'Core.Simulation.calc'
local M = {}

M['setSpriteNoob'] = EVENTS.BLOCKS['setSprite']
M['newCircleNoob'] = EVENTS.BLOCKS['newCircle']
M['newRectNoob'] = EVENTS.BLOCKS['newRect']
M['newRoundedRectNoob'] = EVENTS.BLOCKS['newRoundedRect']
M['setColorNoob'] = EVENTS.BLOCKS['setColor']
M['hideObjectNoob'] = EVENTS.BLOCKS['hideObject']
M['showObjectNoob'] = EVENTS.BLOCKS['showObject']
M['removeObjectNoob'] = EVENTS.BLOCKS['removeObject']
M['frontObjectNoob'] = EVENTS.BLOCKS['frontObject']
M['backObjectNoob'] = EVENTS.BLOCKS['backObject']

return M
