------------------------CREDITS------------------------
-------- Script made by Vlad, DevStudios Owner --------
--         Script made for Diamond Romania RP        --
--          Site: https://devstudios.store           --
--        Forum: http://forum.devstudios.store       --
--   Copyright 2019 ©DevStudios. All rights served   --
-------------------------------------------------------
function giftbox_DisplayText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawTxt(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.7*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
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
	while true do
		Citizen.Wait(0)

		local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
		local px,py,pz = playerPos.x, playerPos.y, playerPos.z
		
		if GetDistanceBetweenCoords(-545.720703125,-227.97738647461,37.649803161621,px,py,pz,true) <= 150 then
		    DrawTxt(-545.720703125,-227.97738647461,37.649803161621 +2.40, tostring("~w~[~g~GiftBox~w~]\n~g~Market\n~w~Buy ~g~GiftBoxes ~w~with ~g~money\n ~g~1.000.000 $"))
			DrawMarker(29,-545.720703125,-227.97738647461,37.649803161621+0.5,0, 0, 0, 0, 0, 0, 1.5,1.5,1.5, 0,255,0,130,0,0,0,true)
			DrawMarker(6,-545.720703125,-227.97738647461,37.649803161621+0.5,0, 0, 0, 0, 0, 0, 2.0,2.0,2.0, 255,255,255,130,0,0,0,true)
		end
		if(Vdist(-545.720703125,-227.97738647461,37.649803161621,px,py,pz) < 2)then
			if (incircle == false) then
				giftbox_DisplayText("Press ~INPUT_CONTEXT~ to make the ~g~Transaction~w~!")
			end
			incircle = true
			if(IsControlJustReleased(1, 51))then
				TriggerServerEvent('vRP:moneygift')
			end
		elseif(Vdist(-545.720703125,-227.97738647461,37.649803161621,px,py,pz) > 2)then
			incircle = false
		end
	end
end)