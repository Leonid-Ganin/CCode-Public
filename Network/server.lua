local crypto = require 'crypto'
local socket = require 'socket'
local json = require 'json'
local mime = require 'mime'
local M = {}

M.getOnline = function()
    local isNetworkAvailable = false
    if not M.online then M.online = socket.tcp() M.online:settimeout(0) end
    local con, err = M.online:connect('www.google.com', 80)
    isNetworkAvailable = con ~= nil or err == 'already connected'
    return isNetworkAvailable
end

M.getIP = function()
    local s = socket.udp()
    s:setpeername('74.125.115.104', 80)
    return select(1, s:getsockname())
end

M.createServer = function(port, serverListener)
    if not M.serverIsCreated then
        local serverListener = serverListener or (function() return {} end)
        local tcp, err = socket.bind(M.getIP(), port) tcp:settimeout(0)
        local clientList, clientBuffer = {}, {} M.serverIsCreated = true

        local function sPulse()
            pcall(function()
                local newClientList = {}

                repeat
                    local client = tcp:accept()
                    if client then
                        client:settimeout(0)
                        newClientList[#newClientList + 1] = client
                    end
                until not client

                local ready, writeReady, err = socket.select(clientList, clientList, 0)
                if err == nil then
                    for i = 1, #ready do
                        local client, sess_hash = ready[i]
                        local data, err = client:receive()

                        if data then
                            data = json.decode(data)

                            if data._sess_hash and clientBuffer[data._sess_hash] then
                                sess_hash = data._sess_hash
                            end
                        else
                            for key, buffer in pairs(clientBuffer) do
                                if buffer[2] == client then
                                    sess_hash = key
                                    break
                                end
                            end data = {}
                        end

                        local _data = serverListener(data)

                        if sess_hash then
                            clientBuffer[sess_hash][1] = json.encode2(type(_data) == 'table' and _data or {})
                            clientBuffer[sess_hash][3] = _data
                        end
                    end

                    for _, buffer in pairs(clientBuffer) do
                        buffer[2]:send(buffer[1] .. '\n')
                        buffer[1] = '{}\n'
                    end
                end

                if #newClientList > 0 then
                    local _ready, _writeReady, _err = socket.select(newClientList, newClientList, 0)
                    if _err == nil then
                        for i = 1, #_ready do
                            local client = _ready[i]
                            local data, err = client:receive()

                            if data then
                                local _data = json.decode(data)

                                if _data._sess_hash then
                                    if clientBuffer[_data._sess_hash] then
                                        local index = table.indexOf(clientList, clientBuffer[_data._sess_hash][2])
                                        if index then table.remove(clientList, index) end

                                        clientList[#clientList + 1] = client
                                        clientBuffer[_data._sess_hash][2] = client
                                    end
                                else
                                    local ip = client:getpeername()
                                    local encodedData = crypto.hmac(crypto.md5, ip .. ':' .. math.random(111111, 999999), '?.сс_ode')

                                    clientList[#clientList + 1] = client
                                    clientBuffer[encodedData] = {json.encode2({_sess_hash = encodedData}) .. '\n', client, {}}
                                end
                            else
                                local ip = client:getpeername()
                                local encodedData = crypto.hmac(crypto.md5, ip .. ':' .. math.random(111111, 999999), '?.сс_ode')

                                clientList[#clientList + 1] = client
                                clientBuffer[encodedData] = {json.encode2({_sess_hash = encodedData}), client, {}}
                            end
                        end

                        for _, buffer in pairs(clientBuffer) do
                            buffer[2]:send(buffer[1] .. '\n')
                            buffer[1] = '{}\n'
                        end
                    end
                end
            end)
        end

        local serverPulse = timer.performWithDelay(100, sPulse, 0)

        local function stopServer()
            timer.cancel(serverPulse)
            tcp:close() M.serverIsCreated = nil
            if M.online then M.online:close() end
            for i, v in pairs(clientList) do
                v:close()
            end
        end

        return stopServer
    end
end

return M
