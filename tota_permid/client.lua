AddEventHandler('onClientMapStart', function()
    TriggerServerEvent('tota:server:displayid', source)
    TriggerServerEvent('tota:server:displaydiscord', source)
end)

local disPlayerNames = 5
local playerDistances = {}
local id = false
local isShown = false

local function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen and isShown then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            if GetPlayerPed(id) then
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(#(vector3(x1,  y1,  z1)-vector3(x2,  y2,  z2)))
				playerDistances[id] = distance
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	Wait(500)
    while true do
        if Config.Marker then
        for _, id in ipairs(GetActivePlayers()) do
				if GetPlayerPed(id) and not IsControlPressed(0, 19) then
                    if playerDistances[id] then
						    if (playerDistances[id] < disPlayerNames) then
						 	    x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
							    if NetworkIsPlayerTalking(id) then
                                DrawMarker(2, x2, y2, z2+0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.2, 0.08, 0, 255, 0, 155, false, false, false, true, false, false, false)
							    end
						    elseif (playerDistances[id] < 25) then
							    x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))						
							    if NetworkIsPlayerTalking(id) then
                                    DrawMarker(2, x2, y2, z2+0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.2, 0.08, 0, 255, 0, 155, false, false, false, true, false, false, false)
							    end
                            end
					end
				end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("tota:client:getId")
AddEventHandler("tota:client:getId", function(playerId, isShown)
    Citizen.Wait(1000)
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            if GetPlayerPed(id) then
                if playerDistances[id] then
                    if (playerDistances[id] < disPlayerNames) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                            if NetworkIsPlayerTalking(id) then
                        DrawText3D(x2, y2, z2+1.2, GetPlayerServerId(id).. " | "..playerId, 119,238,225)
                        if Config.Marker then
                        DrawMarker(2, x2, y2, z2+0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.2, 0.08, 0, 255, 0, 155, false, false, false, true, false, false, false)
                        end
                            else
                        DrawText3D(x2, y2, z2+1, GetPlayerServerId(id).. " | "..playerId, 186,186,186)
                            end
                            elseif (playerDistances[id] < 25) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))						
                            if NetworkIsPlayerTalking(id) then
                                if Config.Marker then
                        DrawMarker(2, x2, y2, z2+0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.2, 0.08, 0, 255, 0, 155, false, false, false, true, false, false, false)
                                end
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("tota:client:notId")
AddEventHandler("tota:client:notId", function()
    if isShown == false then
        isShown = true
    elseif isShown == true then
        isShown = false
    end
end)
