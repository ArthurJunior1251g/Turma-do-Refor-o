------------------------------------------------------------------------------------
-- Variaveis
------------------------------------------------------------------------------------
local ped = PlayerPedId() 
local player = PlayerId()
local ativado = false
------------------------------------------------------------------------------------
-- Notificar
------------------------------------------------------------------------------------
function notificar (text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(true, true)
end
------------------------------------------------------------------------------------
-- TPCDS
------------------------------------------------------------------------------------
RegisterCommand('tpcds', function(source, args, rawCommand) -- Source inutil no client | Args são os argumentos passados | rawCommand é o comando inteiro
    local x,y,z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if x and y and z then
        SetEntityCoords(ped, x, y, z)
        notificar('~g~Teleportado !')
    else
        notificar('~r~Cordenada Invalida')
    end
end)
------------------------------------------------------------------------------------
-- CAR
------------------------------------------------------------------------------------
RegisterCommand('car', function(source, args) 
    local cds = GetEntityCoords(ped)
    local model = GetHashKey(args[1])
    RequestModel(model)
    repeat 
        Citizen.Wait(100)
    until HasModelLoaded(model) == 1
    local veiculo = CreateVehicle(model, cds, 175.31811523438, true, true)
    SetPedIntoVehicle(ped, veiculo, -1)
    notificar('~g~O veiculo ' .. args[1] .. ' foi spawnado')
end)
------------------------------------------------------------------------------------
-- MORRER
------------------------------------------------------------------------------------
RegisterCommand('morrer', function()
    SetEntityHealth(ped, 1)
    notificar('~g~Morreu !')
end)
------------------------------------------------------------------------------------
-- FIX
------------------------------------------------------------------------------------
RegisterCommand('fix', function()
    local v = GetVehiclePedIsUsing(ped)
    SetVehicleFixed(v)
    notificar('~g~O veiculo foi consertado')
end)
------------------------------------------------------------------------------------
-- ARMA
------------------------------------------------------------------------------------
RegisterCommand('arma', function(source, args)
    local arma = GetHashKey(args[1])
    GiveWeaponToPed(ped, arma, 1000, false, true)
end)
------------------------------------------------------------------------------------
-- DV
------------------------------------------------------------------------------------
RegisterCommand('dv', function()
    local vehicle = GetVehiclePedIsIn(ped, true)
    if vehicle then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end)
------------------------------------------------------------------------------------
-- SUJAR
------------------------------------------------------------------------------------
-- RegisterCommand('sujar', function()
--     local vehicle = GetVehiclePedIsIn(ped, true)
--     if vehicle then
--         SetVehicleDirtLevel(vehicle, 15.0)
--     end
-- end)
------------------------------------------------------------------------------------
-- BEBER
------------------------------------------------------------------------------------
local bottle_cds = vec3(-1025.9295654297, 4837.8237304688, 255.43692016602)
local bottle_dict = 'amb@world_human_drinking@beer@male@idle_a'
local bottle_anim = 'idle_a'
local bottle_time = 10 -- (em segundos)
local cds = GetEntityCoords(ped)
ClearAreaOfObjects(cds.x, cds.y, cds.z, 100.0)
------------------------------------------------------------------------------------
-- CTRL
------------------------------------------------------------------------------------
local is_crouched = false

RequestAnimSet("move_ped_crouched")
RequestAnimSet("move_ped_crouched_strafing")
CreateThread(function()
    repeat
        Wait(0)
        DisableControlAction(0, 36, true)
        if IsDisabledControlJustPressed(0, 36) then
            if not is_crouched then
                is_crouched = true
                SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                SetPedMovementClipset(ped,"move_ped_crouched",0.1)
            else
                is_crouched = false
                ResetPedStrafeClipset(ped)
                ResetPedMovementClipset(ped,0.1)
            end
        end
    until false
end)

------------------------------------------------------------------------------------
-- X
------------------------------------------------------------------------------------
local hands_up_dict = "random@mugging3"
local hands_up_anim = "handsup_standing_base"
local is_hands_up = false

CreateThread(function()
    repeat
        Wait(0)
        if IsControlJustPressed(0, 73) then
            if not is_hands_up then
                RequestAnim(hands_up_dict)
                TaskPlayAnim(ped, hands_up_dict, hands_up_anim, 4.0, 4.0, -1, 48, 0.0)
                is_hands_up = true
            else
                ClearPedTasks(ped)
                is_hands_up = false
            end
        end
    until false
end)