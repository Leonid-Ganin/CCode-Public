local M = {}

local sin = math.sin
local cos = math.cos
local tan = math.tan
local asin = math.asin
local acos = math.acos
local atan = math.atan
local atan2 = math.atan2
local random = math.random
local factorial = math.factorial
local radical = math.sqrt
local log10 = math.log10
local log0 = math.log
local getMaskBits = math.getMaskBits
local getBit = math.getBit
local round = math.round

M.randomseed = math.randomseed
M.sum = math.sum
M.pi = math.pi

M.module = math.abs
M.power = math.pow
M.hex = math.hex
M.exp = math.exp
M.max = math.max
M.min = math.min

M['round'] = function(num, exp)
    local isComplete, result = pcall(function()
        return round(num, exp)
    end) return isComplete and result or 0
end

M['getMaskBits'] = function(t)
    local isComplete, result = pcall(function()
        return getMaskBits(t)
    end) return isComplete and result or 0
end

M['getBit'] = function(num)
    local isComplete, result = pcall(function()
        return getBit(num)
    end) return isComplete and result or 0
end

M['log10'] = function(num)
    local isComplete, result = pcall(function()
        return log10(num)
    end) return isComplete and result or 0
end

M['log0'] = function(num)
    local isComplete, result = pcall(function()
        return log0(num)
    end) return isComplete and result or 0
end

M['radical'] = function(num)
    local isComplete, result = pcall(function()
        return radical(num)
    end) return isComplete and result or 0
end

M['factorial'] = function(num)
    local isComplete, result = pcall(function()
        return factorial(num)
    end) return isComplete and result or 0
end

M['random'] = function(num1, num2)
    local isComplete, result = pcall(function()
        return random(num1, num2)
    end) return isComplete and result or 0
end

M['remainder'] = function(num, count)
    local isComplete, result = pcall(function()
        return num % count
    end) return isComplete and result or 0
end

M['raycast'] = function(x1, y1, x2, y2, behavior)
    local isComplete, result = pcall(function()
        local rayT = PHYSICS.rayCast(CENTER_X + x1, CENTER_Y - y1, CENTER_X + x2, CENTER_Y - y2, behavior or 'closest')
        local returnRayT = {}

        for i = 1, #rayT do
            returnRayT[i] = {
                x = rayT[i].position.x, y = rayT[i].position.y, name = rayT[i].object.name,
                normalX = rayT[i].normal.x, normalY = rayT[i].normal.y, fraction = rayT[i].fraction
            }
        end

        if #returnRayT == 1 then
            returnRayT = returnRayT[1]
        end

        return returnRayT
    end) return isComplete and result or {}
end

M['asin'] = function(num)
    local isComplete, result = pcall(function()
        return asin(num) * 180 / M.pi
    end) return isComplete and result or 0
end

M['acos'] = function(num)
    local isComplete, result = pcall(function()
        return acos(num) * 180 / M.pi
    end) return isComplete and result or 0
end

M['atan'] = function(num)
    local isComplete, result = pcall(function()
        return atan(num) * 180 / M.pi
    end) return isComplete and result or 0
end

M['atan2'] = function(y, x)
    local isComplete, result = pcall(function()
        return atan2(y, x) * 180 / M.pi
    end) return isComplete and result or 0
end

M['sin'] = function(num)
    local isComplete, result = pcall(function()
        return tonumber(string.format('%.4f', sin(num * M.pi / 180)))
    end) return isComplete and result or 0
end

M['cos'] = function(num)
    local isComplete, result = pcall(function()
        return tonumber(string.format('%.4f', cos(num * M.pi / 180)))
    end) return isComplete and result or 0
end

M['tan'] = function(num)
    local isComplete, result = pcall(function()
        return tonumber(string.format('%.4f', tan(num * M.pi / 180)))
    end) return isComplete and result or 0
end

M['ctan'] = function(num)
    local isComplete, result = pcall(function()
        return tonumber(string.format('%.4f', 1 / tan(num * M.pi / 180)))
    end) return isComplete and result or 0
end

return M
