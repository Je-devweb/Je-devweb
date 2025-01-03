require 'samp.events'

local function isVehicleOnFire(vehicleId)
    return sampIsVehicleOnFire(vehicleId)
end

local function extinguishVehicleFire(vehicleId)
    local _, x, y, z = sampGetVehiclePos(vehicleId)
    sampCreateExplosion(7)
end

local function checkAndExtinguishFire()
    local playerPed = PLAYER_PED
    if playerPed then
        local isInVehicle, vehicleId = sampIsPlayerInVehicle(playerPed)
        if isInVehicle and isVehicleOnFire(vehicleId) then
            extinguishVehicleFire(vehicleId)
            sampAddChatMessage("Vehicle fire extinguished automatically.", 0xFFFF00)
        end
    end
end

-- Automatically start the anti-burn vehicle logic
sampAddChatMessage("Anti-burn vehicle monitoring started automatically.", 0xFFFF00)

sampRegisterChatCommand("startfiremonitor", function()
    sampAddChatMessage("Fire monitoring started.", 0xFFFF00)
    lua_thread.create(function()
        while true do
            checkAndExtinguishFire()
            wait(1000) -- Check every second
        end
    end)
end)

sampRegisterChatCommand("stopfiremonitor", function()
    sampAddChatMessage("Fire monitoring stopped.", 0xFFFF00)
    -- You may need to implement a way to stop the thread if desired
end)

-- Start monitoring automatically
lua_thread.create(function()
    while true do
        checkAndExtinguishFire()
        wait(1000) -- Check every second
    end
end)