local server = require 'Network.server'
local socket = require 'socket'
local json = require 'json'
local mime = require 'mime'
local M = {}

M.createClientLoop = function(ip, port, clientListener)
    local clientListener = clientListener or (function() return {} end)
    local sock, clientTable, clientPulse = M.connectToServer(ip, port), {}

    local function cPulse()
        pcall(function()
            if server.getOnline() then
                local data, err = sock:receive()

                if err == 'closed' and clientPulse then
                    sock = M.connectToServer(ip, port, clientTable._sess_hash)
                    local data = sock and sock:receive() or nil
                end

                if data then
                    data = json.decode(data)

                    if data._sess_hash and not clientTable._sess_hash then
                        clientTable._sess_hash = data._sess_hash
                    elseif not data._sess_hash and clientTable._sess_hash then
                        data._sess_hash = clientTable._sess_hash
                    end data._device_id = DEVICE_ID or system.getInfo('deviceID')
                else
                    data = {
                        _device_id = DEVICE_ID or system.getInfo('deviceID')
                    }
                end

                local _data = clientListener(data)

                if type(_data) == 'table' then
                    if clientTable._sess_hash then
                        _data._sess_hash = clientTable._sess_hash
                    end _data._device_id = DEVICE_ID or system.getInfo('deviceID')
                end

                local msg = json.encode2(type(_data) == 'table' and _data or {_device_id = DEVICE_ID or system.getInfo('deviceID')}) .. '\n'

                local data, err = sock:send(msg)
                if err == 'closed' and clientPulse then
                    sock = M.connectToServer(ip, port, clientTable._sess_hash)
                    if sock then sock:send(msg) end
                end
            end
        end)
    end


    clientPulse = timer.performWithDelay(100, cPulse, 0)

    local function stopClient()
        pcall(function()
            timer.cancel(clientPulse) clientPulse = nil sock:close()
            if server.online then server.online:close() end
        end)
    end

    return stopClient
end

M.connectToServer = function(ip, port, sess_hash)
    local sock = socket.connect(ip, port)
    if sock == nil then return false end

    sock:settimeout(0)
    sock:setoption('tcp-nodelay', true)
    sock:send(json.encode2({_sess_hash = sess_hash}) .. '\n')

    return sock
end

return M
