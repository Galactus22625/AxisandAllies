--right bound 473

--top left corner, draws the Ipcs of countries
function drawIPC()
    love.graphics.setColor(0/255, 0/255, 0/255)
    love.graphics.setFont(IPCFont)
    love.graphics.print('IPC Count', 473/2 - 60, 20)
    local seperationIPC = IPCFontP + 10
    love.graphics.print('Russian IPC: ' .. tostring(IPC.Russian.value), 473/4 - 90, 20+ seperationIPC)
    love.graphics.print('German IPC: ' .. tostring(IPC.German.value), 473/4 - 90, 20+ 2* seperationIPC)
    love.graphics.print('British IPC: ' .. tostring(IPC.Britain.value), 473/4 - 90, 20+ 3*seperationIPC)
    love.graphics.print('Japanese IPC: ' .. tostring(IPC.Japan.value), 473/4 - 90, 20+ 4* seperationIPC)
    love.graphics.print('American IPC: ' .. tostring(IPC.American.value), 473/4 - 90, 20+ 5*seperationIPC)

    love.graphics.print('IPC/Turn: ' .. tostring(IPC.Russian.rate), 3*473/4 - 90, 20+ seperationIPC)
    love.graphics.print('IPC/Turn: ' .. tostring(IPC.German.rate), 3*473/4 - 90, 20+ 2* seperationIPC)
    love.graphics.print('IPC/Turn: ' .. tostring(IPC.Britain.rate), 3*473/4 - 90, 20+ 3*seperationIPC)
    love.graphics.print('IPC/Turn: ' .. tostring(IPC.Japan.rate), 3*473/4 - 90, 20+ 4* seperationIPC)
    love.graphics.print('IPC/Turn: ' .. tostring(IPC.American.rate), 3*473/4 - 90, 20+ 5*seperationIPC)
end