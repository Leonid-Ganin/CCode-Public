LANG, STR = {}, {}

CLASS = require 'Data.class'
CLIENT = require 'Network.client'
SERVER = require 'Network.server'
ANIMATION = require 'plugin.animation'
NOTIFICATIONS = require 'plugin.notifications.v2'
PARTICLE = require 'Emitter.particleDesigner'
NOISE = require 'Core.Modules.noise'
CAMERA = require 'Core.Modules.camera'
RESIZE = require 'Core.Modules.app-resize'
INPUT = require 'Core.Modules.interface-input'
WINDOW = require 'Core.Modules.interface-window'
EXITS = require 'Core.Interfaces.exits'
BITMAP = require 'plugin.memoryBitmap'
FILE = require 'plugin.cnkFileManager'
EXPORT = require 'plugin.exportFile'
PASTEBOARD = require 'plugin.pasteboard'
ORIENTATION = require 'plugin.orientation'
STARTAPP = require 'plugin.startapp'
VIDEO = require 'plugin.videoEditor'
IMPACK = require 'plugin.impack'
SVG = require 'plugin.nanosvg'
UTF8 = require 'plugin.utf8'
ZIP = require 'plugin.zip'
PHYSICS = require 'physics'
JSON = require 'json'
LFS = require 'lfs'
WIDGET = require 'widget'
CRYPTO = require 'crypto'

SIZE = 1.0
BUFFER = {}
LIVE = false
ALERT = true
INDEX_LIST = 0
SEED = os.time()
NOOBMODE = false
MORE_LIST = true
LAST_CHECKBOX = 0
ORIENTATION.init()
BLOCK_CENTER_X = 0
CURRENT_SCRIPT = 0
GAME_GROUP_OPEN = ''
CURRENT_LINK = 'App1'
LAST_CURRENT_SCRIPT = 0
DEVICE_ID = 'qwertyuiop12345'
CURRENT_ORIENTATION = 'portrait'
CENTER_X = display.contentCenterX
CENTER_Y = display.contentCenterY
DISPLAY_WIDTH = display.actualContentWidth
DISPLAY_HEIGHT = display.actualContentHeight
IS_WIN = system.getInfo 'platform' ~= 'android'
IS_SIM = system.getInfo 'environment' == 'simulator'
DOC_DIR = system.pathForFile('', system.DocumentsDirectory)
BUILD = (not IS_SIM and not IS_WIN) and system.getInfo('androidAppVersionCode') or 1264
MY_PATH = '/data/data/' .. tostring(system.getInfo('androidAppPackageName')) .. '/files/ganin'
RES_PATH = '/data/data/' .. tostring(system.getInfo('androidAppPackageName')) .. '/files/coronaResources'
MASK = graphics.newMask('Sprites/mask.png')
SOLAR = _G.B .. _G.D .. _G.A .. _G.C
KEYORDER = {
    'build', 'version', 'package', 'orientation', 'title', 'link', 'resources', 'scripts',
    'settings', 'fonts', 'others', 'videos', 'sounds', 'images', 'funs', 'tables',
    'len', 'vars', 'name', 'custom', 'event', 'nested', 'comment', 'params', 'created', 'folders'
} for i = 10000, 1, -1 do table.insert(KEYORDER, 1, tostring(i)) end

GET_SAFE_AREA = function()
    TOP_HEIGHT, LEFT_HEIGHT, BOTTOM_HEIGHT, RIGHT_HEIGHT = display.getSafeAreaInsets()
    BOTTOM_HEIGHT = (system.getInfo('deviceID') == 'd5e815039ddf2736' and 90 or BOTTOM_HEIGHT) + LOCAL.bottom_height
    ZERO_X = CENTER_X - DISPLAY_WIDTH / 2 + LEFT_HEIGHT
    ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2 + TOP_HEIGHT
    MAX_X = CENTER_X + DISPLAY_WIDTH / 2 - RIGHT_HEIGHT
    MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2 - BOTTOM_HEIGHT
end

if IS_SIM or IS_WIN then
    FILEPICKER = require 'plugin.tinyfiledialogs'

    FILE.pickFile = function(path, listener, file, p1, mime)
        local filter_patterns = mime == 'image/*' and {'*.png', '*.jpg', '*.jpeg', '*.gif'}
        or mime == 'audio/*' and {'*.wav', '*.mp3', '*.ogg'} or mime == 'ccode/*' and {'*.ccode', '*.zip'}
        or mime == 'text/x-lua' and {'*.lua', '*.txt'} or mime == 'video/*' and {'*.mov', '*.mp4', '*.m4v', '*.3gp'} or nil
        local pathToFile, path = path .. '/' .. file, FILEPICKER.openFileDialog({filter_patterns = filter_patterns})
        if path then OS_COPY(path, pathToFile) end listener({done = path and 'ok' or 'error', origFileName = path})
    end

    EXPORT.export = function(config)
        local path, listener, name = config.path, config.listener, config.name
        local pathToFile = FILEPICKER.saveFileDialog({filter_patterns = {'*.ccode'}})
        if path then OS_COPY(path, pathToFile) end listener()
    end
end

if not IS_SIM and not LIVE then
    GANIN = require 'plugin.ganin'
    require('Core.Share.build').reset()
end

GET_NESTED_DATA = function(script, nestedInfo, INFO)
    local script = COPY_TABLE(script)

    for i = #nestedInfo, 1, -1 do
        local current_params = nestedInfo[i]

        if script.params[current_params].event then
            local fixIndex = current_params + 1

            for j = fixIndex, #script.params do
                if script.params[fixIndex].event then break end
                table.insert(script.params[current_params].nested, script.params[fixIndex])
                table.remove(script.params, fixIndex)
            end
        elseif INFO.listNested[script.params[current_params].name] then
            local endIndex = #INFO.listNested[script.params[current_params].name]
            local fixIndex = current_params + 1
            local nestedEndIndex = 1

            for j = fixIndex, #script.params do
                if not script.params[fixIndex].event then
                    local name = script.params[fixIndex].name
                    local notNested = not (script.params[fixIndex].nested
                    and #script.params[fixIndex].nested > 0)
                    table.insert(script.params[current_params].nested, script.params[fixIndex])
                    table.remove(script.params, fixIndex)

                    if name == script.params[current_params].name and notNested then
                        nestedEndIndex = nestedEndIndex + 1
                    elseif name == INFO.listNested[script.params[current_params].name][endIndex] then
                        nestedEndIndex = nestedEndIndex - 1
                        if nestedEndIndex == 0 then break end
                    end
                else
                    fixIndex = fixIndex + 1
                end
            end
        end
    end

    return script
end

GET_FULL_DATA = function(script)
    local script, nestedInfo = COPY_TABLE(script), {}
    local blockIndex = 0

    while blockIndex < #script.params do
        blockIndex = blockIndex + 1

        if script.params[blockIndex].nested and #script.params[blockIndex].nested > 0 then
            table.insert(nestedInfo, blockIndex)

            for j = 1, #script.params[blockIndex].nested do
                local blockIndex, blockData = blockIndex + j, script.params[blockIndex].nested[j]
                table.insert(script.params, blockIndex, blockData)
            end

            script.params[blockIndex].nested = {}
        end
    end

    return script, nestedInfo
end

GIVE_PERMISSION_DATA = function()
    native.showPopup('requestAppPermission', {appPermission = 'Storage', urgency = 'normal'})
end

GET_SCROLL_HEIGHT = function(group)
    if not (group and #group.blocks > 0) then return 0 end

    local b1 = group.blocks[1].y - group.blocks[1].block.height / 2
    local b2 = group.blocks[#group.blocks].y + group.blocks[#group.blocks].block.height / 2

    return math.abs(b1 - b2) + 100
end

READ_FILE = function(path, bin)
    local file, data = io.open(path or '', bin and 'rb' or 'r'), nil

    if file then
        data = file:read('*a')
        io.close(file)
    end

    return data
end

WRITE_FILE = function(path, data, bin)
    local file = io.open(path, bin and 'wb' or 'w')

    if file then
        file:write(tostring(data))
        io.close(file)
    end
end

IS_FOLDER = function(path)
    return LFS.attributes(path, 'mode') == 'directory'
end

IS_IMAGE = function(path, filter)
    display.setDefault('magTextureFilter', filter) display.setDefault('minTextureFilter', filter)
    local image = display.newImage2(path, system.DocumentsDirectory, 10000, 10000)
    local is_image = type(image) == 'table' and image.width > 0 and image.height > 0
    pcall(function() image:removeSelf() image = nil end) return is_image
end

IS_ZERO_TABLE = function(t)
    local result = true

    pcall(function()
        for key, value in pairs(t) do
            result = false
            break
        end
    end)

    return result
end

COPY_TABLE = function(t, isSim)
    local result = {}

    pcall(function() if t then
        for key, value in pairs(t) do
            if type(value) == 'table' and key ~= '_class' and key ~= '_tableListeners' then
                result[key] = COPY_TABLE(value, isSim)
            elseif (not isSim) or (key ~= '_tableListeners' and key ~= '_class') then
                result[key] = value
            end
        end
    end end)

    return result
end

COPY_TABLE_P = function(t, isSim)
    local result = {}

    pcall(function()
        if type(t[1]) == 'table' and #t == 1 then
            result = COPY_TABLE(t[1], isSim)
        else
            result = COPY_TABLE(t, isSim)
        end
    end)

    return result
end

GET_SIZE = function(path, baseDir, width, height, count)
    local onComplete, result = pcall(function()
        local image = display.newImage(path, baseDir)
        local width, height = image.width / count, image.height image:removeSelf()
        return {width, height, count}
    end) if onComplete then return result end return {width, height, count}
end

SET_X = function(x, obj)
    if obj and (obj._isGroup or obj._snapshot) then return x end
    return type(x) == 'number' and ((obj and obj._scroll and GAME.group.widgets[obj._scroll]
    and GAME.group.widgets[obj._scroll].wtype == 'scroll')
    and x + GAME.group.widgets[obj._scroll].width / 2 or CENTER_X + x) or 0
end

SET_Y = function(y, obj)
    if obj and obj._isGroup then return type(y) == 'number' and ((obj and obj._scroll and GAME.group.widgets[obj._scroll]
    and GAME.group.widgets[obj._scroll].wtype == 'scroll') and 0 - y - CENTER_Y or 0 - y ) or 0 end
    return type(y) == 'number' and (((obj and obj._scroll and GAME.group.widgets[obj._scroll]
    and GAME.group.widgets[obj._scroll].wtype == 'scroll') or (obj and obj._snapshot)) and 0 - y or CENTER_Y - y) or 0
end

GET_X = function(x, obj)
    if obj and (obj._isGroup or obj._snapshot) then return x end
    return type(x) == 'number' and ((obj and obj._scroll and GAME.group.widgets[obj._scroll]
    and GAME.group.widgets[obj._scroll].wtype == 'scroll')
    and x - GAME.group.widgets[obj._scroll].width / 2 or x - CENTER_X) or 0
end

GET_Y = SET_Y

NEW_DATA = function()
    WRITE_FILE(system.pathForFile('local.json', system.DocumentsDirectory), JSON.encode(LOCAL))
end

GET_GAME_CODE = function(link)
    return JSON.decode(READ_FILE(DOC_DIR .. '/' .. link .. '/game.json'))
end

SET_GAME_CODE = function(link, data)
    WRITE_FILE(DOC_DIR .. '/' .. link .. '/game.json', JSON.encode3(data, {keyorder = KEYORDER}))
end

GET_INDEX_SCRIPT = function(link)
    local numScript = 1 while true do if READ_FILE(DOC_DIR .. '/' .. link .. '/Scripts/Script' .. numScript)
    then numScript = numScript + 1 else break end end return numScript
end

DEL_GAME_SCRIPT = function(link, index, code)
    OS_REMOVE(DOC_DIR .. '/' .. link .. '/Scripts/Script' .. (code or GET_GAME_CODE(link)).scripts[index])
end

GET_GAME_SCRIPT = function(link, index, code)
    local code = code or GET_GAME_CODE(link)
    return code.scripts[index] and JSON.decode(READ_FILE(DOC_DIR .. '/' .. link .. '/Scripts/Script' .. code.scripts[index])) or nil
end

SET_GAME_SCRIPT = function(link, data, index, code)
    local code = code or GET_GAME_CODE(link) if not code.scripts[index] then
    local numScript = 1 while true do if READ_FILE(DOC_DIR .. '/' .. link .. '/Scripts/Script' .. numScript) then numScript = numScript + 1
    else table.insert(code.scripts, index, numScript) SET_GAME_CODE(link, code) break end end end
    WRITE_FILE(DOC_DIR .. '/' .. link .. '/Scripts/Script' .. code.scripts[index], JSON.encode3(data, {keyorder = KEYORDER}))
end

GET_GAME_CUSTOM = function()
    return JSON.decode(READ_FILE(DOC_DIR .. '/custom.json'))
end

SET_GAME_CUSTOM = function(data)
    WRITE_FILE(DOC_DIR .. '/custom.json', JSON.encode3(data, {keyorder = KEYORDER}))
end

GET_GAME_SAVE = function(link)
    return JSON.decode(READ_FILE(DOC_DIR .. '/' .. link .. '/save.json'))
end

SET_GAME_SAVE = function(link, data)
    WRITE_FILE(DOC_DIR .. '/' .. link .. '/save.json', JSON.encode(data))
end

OS_REMOVE = function(link, recur)
    if IS_SIM or IS_WIN then
        link = UTF8.gsub(link, '/', '\\')
        if recur then os.execute('rd /s /q "' .. link .. '"')
        else os.execute('del /q "' .. link .. '"') end
    else
        os.execute('rm -' .. (recur and 'rf' or 'f') .. ' "' .. link .. '"')
    end
end

OS_MOVE = function(link, link2)
    if IS_SIM or IS_WIN then
        link = UTF8.gsub(link, '/', '\\')
        link2 = UTF8.gsub(link2, '/', '\\')
        os.execute('move /y "' .. link .. '" "' .. link2 .. '"')
    else
        os.execute('mv -f "' .. link .. '" "' .. link2 .. '"')
    end
end

OS_COPY = function(link, link2)
    if IS_SIM or IS_WIN then
        link = UTF8.gsub(link, '/', '\\')
        link2 = UTF8.gsub(link2, '/', '\\')
        os.execute('copy /y "' .. link .. '" "' .. link2 .. '"')
    else
        os.execute('cp -f "' .. link .. '" "' .. link2 .. '"')
    end
end

NEW_APP_CODE = function(title, link, checkbox)
    return {
        build = tostring(BUILD),
        created = tostring(BUILD),
        noobmode = checkbox,
        id = DEVICE_ID,
        title = title,
        link = link,
        tables = {},
        vars = {},
        funs = {},
        settings = {
            build = 1,
            version = '1.0',
            package = 'com.example.app',
            orientation = 'portrait'
        },
        folders = {
            scripts = {{'1', {}, false}},
            images = {{'1', {}, false}},
            sounds = {{'1', {}, false}},
            videos = {{'1', {}, false}},
            others = {{'1', {}, false}},
            fonts = {{'1', {}, false}}
        },
        resources = {
            images = {},
            sounds = {},
            videos = {},
            others = {},
            fonts = {}
        },
        scripts = {}
    }
end

audio.setVolume(1)
PHYSICS.setAverageCollisionPositions(true)
WIDGET.setTheme('widget_theme_android_holo_dark')
display.setDefault('background', 0.15, 0.15, 0.17)
UNPACK = function(t) if #t > 0 then return unpack(t) end return t end
PHYSICS.setReportCollisionsInContentCoordinates(true) math.randomseed(SEED)
DEVELOPERS = {['Ganin'] = true, ['DanilNik'] = true, ['MikhailStudio'] = true}

JSON.encode3 = require('Data.json').encode
JSON.decode2, JSON.decode = JSON.decode, function(str) return type(str) == 'string' and (JSON.decode2(str) or {}) or nil end
math.factorial = function(num) if num == 0 then return 1 else return num * math.factorial(num - 1) end end
math.hex = function(hex) local r, g, b = hex:match('(..)(..)(..)') return {tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)} end
UTF8.split = function(text, sep) local result = {} for s in text:gmatch('[^' .. sep .. ']+') do result[#result + 1] = s end return result end
UTF8.trim = function(s) return UTF8.gsub(UTF8.gsub(s, '^%s+', ''), '%s+$', '') end
UTF8.trimLeft = function(s) return UTF8.gsub(s, '^%s+', '') end
UTF8.trimRight = function(s) return UTF8.gsub(s, '%s+$', '') end
UTF8.trimFull = function(s) return UTF8.trim(UTF8.gsub(s, '%s+', ' ')) end
timer.new = function(sec, rep, lis) return timer.performWithDelay(sec, lis, rep) end
math.sum = function(...) local args, num = {...}, 0 for i = 1, #args do num = num + args[i] end return num end
math.getMaskBits = function(t) local s = 0 for j = 1, #t do s = s + math.getBit(t[j]) end return s end
math.getBit = function(i) return 2 ^ (i-1) end
table.len, math.round, table.merge = function(t)
    return type(t) == 'table' and ((type(#t) == 'number' and #t > 0) and #t
    or (function() local i = 0 for k in pairs(t) do i = i + 1 end return i end)()) or 0
end, function(num, exp)
    if (not exp) or (not tonumber(exp)) then return tonumber(string.match(tostring(num), '(.*)%.')) or num
    else local isMinus, oldNum = tonumber(num) and tonumber(num) < 0, tonumber(num) or 0
    local exps, factor = string.match(tostring(num), '%.(.*)'), tonumber(exp) == 0 and '0.' or '0.0'
    if not exps then return num end for i = 1, tonumber(exp) - 1 do factor = factor .. '0' end factor = factor .. '5' num = tonumber(num)
    and num + factor or 0 exp = string.match(tostring(num), '%.(.*)') and string.match(tostring(num), '%.(.*)'):sub(1, tonumber(exp))
    or '0' num = string.match(tostring(num), '(.*)%.') or tostring(num) num = tonumber(num .. '.' .. exp)
    return isMinus and (oldNum > -0.5 and 0 or num - 1) or num end
end, function(t1, t2)
    for k, v in pairs(t2) do if (type(v) == 'table') and (type(t1[k] or false) == 'table')
    then merge(t1[k], t2[k]) else t1[k] = v end end return t1
end

display.newImage2, display.newImage = display.newImage, function(link, ...)
    local image = display.newImage2(link, ...)

    if image and not (type(image) == 'table' and image.width > 0 and image.height > 0) then
        local args = {...} image = SVG.newImage({
            filename = link, baseDir = args[1],
            x = type(args[1]) == 'userdata' and (args[2] or 0) or (args[1] or 0),
            y = type(args[1]) == 'userdata' and (args[3] or 0) or (args[2] or 0)
        })
    end

    return (type(image) == 'table' and image.width > 0 and image.height > 0) and image or nil
end

LOCAL = require 'Data.local' GET_SAFE_AREA()
LANGS = {'en', 'ru', 'pt', 'es', 'pl', 'ua', 'by', 'cn', 'jp', 'custom'}
LANG.custom = {} LANG.ru = {} LANG.en = {} LANG.pt = {} LANG.es = {}
LANG.pl = {} LANG.ua = {} LANG.by = {} LANG.cn = {} LANG.jp = {}

for i = 1, #LANGS do
    local langData = JSON.decode(READ_FILE(system.pathForFile('Strings/' .. LANGS[i] .. '.json')))
    if langData then for _, langT in pairs(langData) do for key, str in pairs(langT) do LANG[LANGS[i]][key] = str end end end
end

for i = 1, #LANGS do if LANGS[i] == LOCAL.lang then break elseif i == #LANGS then LOCAL.lang = 'en' end end
STR = LANG[LOCAL.lang] for k, v in pairs(LANG.ru) do if not STR[k] then STR[k] = LANG.en[k] or v
elseif type(STR[k]) == 'table' then for k2, v2 in ipairs(LANG.ru[k]) do if not STR[k][k2]
then STR[k][k2] = (LANG.en[k] and LANG.en[k][k2]) and LANG.en[k][k2] or v2 end end end end

if IS_SIM then
    JSON.encode, JSON.encode2, JSON.encode4 = JSON.prettify, JSON.encode, JSON.encode3
    JSON.encode3 = function(s, opt) local opt = opt or {} opt.indent = opt.indent == nil and true or opt.indent return JSON.encode4(s, opt) end
else
    JSON.encode2 = JSON.encode
end

INFO = require('Data.info') require('Core.Modules.custom-block').getBlocks()
if LOCAL.orientation == 'landscape' then setOrientationApp({type = 'landscape'}) end
Runtime:addEventListener('unhandledError', function(event) return GAME and GAME.hash ~= '' end)

GET_GLOBAL_TABLE = function()
    return {
        sendLaunchAnalytics = sendLaunchAnalytics, transition = transition, tostring = tostring, tonumber = tonumber,
        gcinfo = gcinfo, assert = assert, debug = debug, GAME = GAME, collectgarbage = collectgarbage, GANIN = GANIN,
        os = os, display = display, module = module, media = media, OS_REMOVE = OS_REMOVE,
        native = native, coroutine = coroutine, CENTER_X = CENTER_X, CENTER_Y = CENTER_Y, JSON = JSON, ipairs = ipairs,
        TOP_HEIGHT = TOP_HEIGHT, network = network, _network_pathForFile = _network_pathForFile,
        pcall = pcall, BUILD = BUILD, MAX_Y = MAX_Y, MAX_X = MAX_X, string = string, SIZE = SIZE,
        xpcall = xpcall, ZERO_Y = ZERO_Y, ZERO_X = ZERO_X, package = package, OS_MOVE = OS_MOVE,
        table = table, lpeg = lpeg, COPY_TABLE = COPY_TABLE, DISPLAY_HEIGHT = DISPLAY_HEIGHT, OS_COPY = OS_COPY,
        unpack = unpack, setmetatable = setmetatable, next = next, RIGHT_HEIGHT = RIGHT_HEIGHT,
        graphics = graphics, system = system, rawequal = rawequal,  getmetatable = getmetatable, FILE = FILE,
        timer = timer, BOTTOM_HEIGHT = BOTTOM_HEIGHT, newproxy = newproxy, metatable = metatable, NOISE = NOISE,
        al = al, rawset = rawset, easing = easing, coronabaselib = coronabaselib, DOC_DIR = DOC_DIR,
        LEFT_HEIGHT = LEFT_HEIGHT, cloneArray = cloneArray, DISPLAY_WIDTH = DISPLAY_WIDTH, type = type,
        audio = audio, pairs = pairs, select = select, rawget = rawget, Runtime = Runtime, error = error,
        fun = G_fun, math = G_math, other = G_other, device = G_device, prop = G_prop, PASTEBOARD = PASTEBOARD
    }
end
