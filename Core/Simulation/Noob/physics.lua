local EVENTS = require 'Core.Simulation.events'
local CALC = require 'Core.Simulation.calc'
local M = {}

M['setBodyNoob'] = EVENTS.BLOCKS['setBody']
M['removeBodyNoob'] = EVENTS.BLOCKS['removeBody']
M['setLinearVelocityXNoob'] = EVENTS.BLOCKS['setLinearVelocityX']
M['setLinearVelocityYNoob'] = EVENTS.BLOCKS['setLinearVelocityY']
M['setSensorNoob'] = EVENTS.BLOCKS['setSensor']
M['removeSensorNoob'] = EVENTS.BLOCKS['removeSensor']
M['setFixedRotationNoob'] = EVENTS.BLOCKS['setFixedRotation']
M['removeFixedRotationNoob'] = EVENTS.BLOCKS['removeFixedRotation']

return M
