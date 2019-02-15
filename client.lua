------------------------CREDITS------------------------
-------- Script made by Vlad, DevStudios Owner  -------
--         Script made for Diamond Romania RP        --
--          Site: https://devstudios.store           --
--        Forum: http://forum.devstudios.store       --
--   Copyright 2019 ©DevStudios. All rights served   --
-------------------------------------------------------
incircle = false 
giftBox = {x = -530.02941894532, y = -229.9102935791, z = 36.702156066894}

function giftbox_DisplayText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawTxt(x,y,z,textInput,fontId,scaleX,scaleY)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(0, 255, 0, 255)
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
   end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
		local px,py,pz = playerPos.x, playerPos.y, playerPos.z

		if GetDistanceBetweenCoords(giftBox.x,giftBox.y,giftBox.z,px,py,pz,true) <= 150 then
			DrawTxt(giftBox.x,giftBox.y,giftBox.z +0.10,"Open GiftBox", 10, 0.1, 0.1) 
			DrawMarker(32,giftBox.x,giftBox.y,giftBox.z+0.5,0,0,0,0,0,0,1.7,4.5,1.7,0,255,0,130,0,0,0,true)
		end
		if(Vdist(giftBox.x,giftBox.y,giftBox.z,px,py,pz) < 2)then
			if (incircle == false) then
				giftbox_DisplayText("Press ~INPUT_CONTEXT~ to open a ~g~Giftbox!")
			end
			incircle = true
			if(IsControlJustReleased(1, 51))then
				TriggerServerEvent('vRP:giftboxopen')
			end
		elseif(Vdist(giftBox.x,giftBox.y,giftBox.z,px,py,pz) > 2)then
			incircle = false
		end
	end
end)
