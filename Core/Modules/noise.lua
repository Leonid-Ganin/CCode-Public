local rseed = math.randomseed
local rand = math.random
local floor = math.floor
local max = math.max

local MT = {
	__index = function(t, i)
		return t[i - 256]
	end
}

local Perms = setmetatable({
	151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
	140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
	247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
	57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68,	175,
	74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111,	229, 122,
	60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
	65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
	200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
	52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
	207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
	119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
	129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
	218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
	81,	51, 145, 235, 249, 14, 239,	107, 49, 192, 214, 31, 181, 199, 106, 157,
	184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
	222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}, MT)

local Perms12 = setmetatable({}, MT)

for i = 1, 256 do
	Perms12[i] = Perms[i] % 12 + 1
	Perms[i] = Perms[i] + 1
end

local Grads3 = {
	{ 1, 1, 0 }, { -1, 1, 0 }, { 1, -1, 0 }, { -1, -1, 0 },
	{ 1, 0, 1 }, { -1, 0, 1 }, { 1, 0, -1 }, { -1, 0, -1 },
	{ 0, 1, 1 }, { 0, -1, 1 }, { 0, 1, -1 }, { 0, -1, -1 }
}

local function GetN(ix, iy, x, y)
    local t = 0.5 - x ^ 2 - y ^ 2
    local index = Perms12[ix + Perms[iy + 1]]
    local grad = Grads3[index]

    return max(0, t ^ 4) * (grad[1] * x + grad[2] * y)
end

local F = (math.sqrt(3) - 1) / 2
local G = (3 - math.sqrt(3)) / 6
local G2 = 2 * G - 1

local function SampleNoise(x, y, seed)
	local rdm = 0
    local x = x or 0
    local y = y or 0

    if seed then
        rseed(seed)
		rdm = rand(seed, seed * 2)
        x = x + 100000 + rdm
        y = y + 100000 + rdm
    end

    local s = (x + y) * F
    local ix, iy = floor(x + s), floor(y + s)

    local t = (ix + iy) * G
    local x0 = x + t - ix
    local y0 = y + t - iy

    ix, iy = ix % 256, iy % 256

    local n0 = GetN(ix, iy, x0, y0)
    local n2 = GetN(ix + 1, iy + 1, x0 + G2, y0 + G2)
    local xi = x0 > y0 and 1 or 0
    local n1 = GetN(ix + xi, iy + (1 - xi), x0 + G - xi, y0 + G - (1 - xi))

	rseed(SEED)

    return 70.1480580019 * (n0 + n1 + n2)
end

return {new = SampleNoise}
