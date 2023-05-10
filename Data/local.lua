local data, custom = {}, {}
local file = io.open(system.pathForFile('local.json', system.DocumentsDirectory), 'r')

if file then
    data = JSON.decode(file:read('*a')) io.close(file)
    if data.autoplace == nil then data.autoplace = true end
    if data.bottom_height == nil then data.bottom_height = 0 end
    if data.old_dog == nil then data.old_dog = false end
    if data.old_update == nil then data.old_update = false end
    if data.keystore == nil then data.keystore = {'testkey'} end data.back = 'System'
    if data.dog == nil then
        data.dog = {face = 1, ears = 1, eyes = 1, mouth =  1, accessories = 1}
        data.dogs = {face = {true}, ears = {true}, eyes = {true}, mouth = {true}, accessories = {}}
    end WRITE_FILE(system.pathForFile('local.json', system.DocumentsDirectory), JSON.encode(data))
else
    data, custom = {
        lang = system.getPreference('locale', 'language'),
        last = '',
        last_link = '',
        orientation = 'portrait',
        back = 'System',
        keystore = {'testkey'},
        bottom_height = 0,
        autoplace = true,
        show_ads = true,
        pos_top_ads = true,
        confirm = true,
        first = true,
        ui = true,
        apps = {},
        repository = {},
        name_tester = '',
        old_update = false,
        old_dog = false,
        dog = {face = 1, ears = 1, eyes = 1, mouth =  1, accessories = 1},
        dogs = {face = {true}, ears = {true}, eyes = {true}, mouth = {true}, accessories = {}}
    }, {len = 0}

    SET_GAME_CUSTOM(custom)
    WRITE_FILE(system.pathForFile('local.json', system.DocumentsDirectory), JSON.encode(data))
end

return data
