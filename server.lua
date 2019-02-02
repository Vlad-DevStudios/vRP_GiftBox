------------------------CREDITS------------------------
-------- Script made by Vlad, DevStudios Owner --------
--         Script made for Diamond Romania RP        --
--          Site: https://devstudios.store           --
--        Forum: http://forum.devstudios.store       --
--   Copyright 2019 ©DevStudios. All rights served   --
-------------------------------------------------------
MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

vRPgb = {}
Tunnel.bindInterface("vRP_giftbox",vRPgb)
Proxy.addInterface("vRP_giftbox",vRPgb)

vRPclient = Tunnel.getInterface("vRP","vRP_giftbox")

MySQL.createCommand("vRP/giftbox_init_user","INSERT IGNORE INTO vrp_giftbox(user_id,giftbox) VALUES(@user_id,@giftbox)")
MySQL.createCommand("vRP/get_giftbox","SELECT * FROM vrp_giftbox WHERE user_id = @user_id")
MySQL.createCommand("vRP/set_giftbox","UPDATE vrp_giftbox SET giftbox = @giftbox WHERE user_id = @user_id")
MySQL.createCommand("vRP/add_custom_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,vehicle_plate,veh_type) VALUES(@user_id,@vehicle,@vehicle_plate,@veh_type)")

tmpgiftbox = {}

function displayBox(value)
	return "<span class=\"symbol\">GiftBoxes:</span> "..value
end

function vRPgb.getgiftbox(user_id)
	local giftbox = tonumber(tmpgiftbox[user_id])
	if giftbox ~= nil then
		return tonumber(tmpgiftbox[user_id])
	else
		return 0
	end
end

function vRPgb.setgiftbox(user_id,value)
	local giftbox = tonumber(tmpgiftbox[user_id])
	if giftbox ~= nil then
		tmpgiftbox[user_id] = tonumber(value)
	end

	local source = vRP.getUserSource({user_id})
	if source ~= nil then
		vRPclient.setDivContent(source,{"giftbox",displayBox(value)})
	end
end

function vRPgb.givegiftbox(user_id,amount)
	local giftbox = vRPgb.getgiftbox(user_id)
	local giftboxs = giftbox + amount
	vRPgb.setgiftbox(user_id,giftboxs)
end

function vRPgb.takegiftbox(user_id,amount)
	local giftbox = vRPgb.getgiftbox(user_id)
	local giftboxs = giftbox - amount
	vRPgb.setgiftbox(user_id,giftboxs)
end

function vRPgb.tryBoxPayment(user_id,amount)
	local giftbox = vRPgb.getgiftbox(user_id)
	if giftbox >= amount then
		vRPgb.setgiftbox(user_id,giftbox-amount)
		return true
	else
		return false
	end
end

AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
	local cfg = getConfig()
	MySQL.execute("vRP/giftbox_init_user", {user_id = user_id, giftbox = cfg.open_giftbox}, function(affected)
		MySQL.query("vRP/get_giftbox", {user_id = user_id}, function(rows, affected)
			if #rows > 0 then
				tmpgiftbox[user_id] = tonumber(rows[1].giftbox)
			end
		end)
	end)
end)

AddEventHandler("vRP:playerLeave",function(user_id,source)
	local giftbox = tmpgiftbox[user_id]
	if giftbox and giftbox ~= nil then
		MySQL.execute("vRP/set_giftbox", {user_id = user_id, giftbox = giftbox})
	end
end)

AddEventHandler("vRP:save", function()
	for i, v in pairs(tmpgiftbox) do
		if v ~= nil then
			MySQL.execute("vRP/set_giftbox", {user_id = i, giftbox = v})
		end
	end
end)

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		local cfg = getConfig()
		local mygiftbox = vRPgb.getgiftbox(user_id)
		vRPclient.setDiv(source, {"giftbox", cfg.display_css, displayBox(mygiftbox)})
	end
end)

local function givePlayergiftbox(player,choice)
	local cfg = getConfig()
	vRP.prompt({player, "User ID: ", "", function(player, user_id)
		user_id = tonumber(user_id)
		local target = vRP.getUserSource({user_id})
		if target ~= nil then
			vRP.prompt({player, "GiftBoxes: ", "", function(player, giftbox)
				giftbox = giftbox
				if(tonumber(giftbox))then
					giftbox = tonumber(giftbox)
					vRPgb.givegiftbox(user_id,giftbox)
					vRPclient.notify(player, {"~w~[~g~GiftBox~w~] You gave ~g~"..GetPlayerName(target).."~w~, ~g~"..giftbox.." ~g~Giftboxes~w~!"})
					vRPclient.notify(target, {"~w~[~g~GiftBox~w~] ~g~"..GetPlayerName(player).."~w~ gave you ~g~"..giftbox.." Giftboxes~w~!"})
					TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^0[^2GiftBox^0] ^2'.. GetPlayerName(player) ..' ^0gave ^2'.. GetPlayerName(target) ..'^0, ^2'.. giftbox ..' GiftBoxes ^0!')
				else
					vRP.notify(player, {cfg.message.invalid_number})
				end
			end})
		else
			vRPclient.notify(player, {cfg.message.offline})
		end
	end})
end

local function takePlayergiftbox(player,choice)
	local cfg = getConfig()
	vRP.prompt({player, "User ID: ", "", function(player, user_id)
		user_id = tonumber(user_id)
		local target = vRP.getUserSource({user_id})
		if target ~= nil then
			vRP.prompt({player, "GiftBoxes: ", "", function(player, giftbox)
				giftbox = giftbox
				local tgiftbox = tonumber(vRPgb.getgiftbox(user_id))
				if(tonumber(giftbox))then
					giftbox = tonumber(giftbox)
					if(tgiftbox >= giftbox)then
						vRPgb.takegiftbox(user_id,giftbox)
						vRPclient.notify(player, {"~w~[~g~GiftBox~w~] You took from ~g~"..GetPlayerName(target).."~w~, ~g~"..giftbox.." ~g~Giftboxes~w~!"})
						vRPclient.notify(target, {"~w~[~g~GiftBox~w~] ~g~"..GetPlayerName(player).."~w~ took ~g~"..giftbox.." Giftboxes~w~ from you!"})
						TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^0[^2GiftBox^0] ^2'.. GetPlayerName(player) ..' ^0took from ^2'.. GetPlayerName(target) ..'^0, ^2'.. giftbox ..' GiftBoxes ^0!')
					else
						vRPclient.notify(player, {"~w~[~g~GiftBox~w~] Player only has ~g~"..tgiftbox.." Giftboxes~w~!",})
					end
				else
					vRPclient.notify(player, {cfg.message.invalid_number})
				end
			end})
		else
			vRPclient.notify(player, {cfg.message.offline})
		end
	end})
end

RegisterServerEvent('vRP:giftboxopen')
AddEventHandler('vRP:giftboxopen', function ()
	local cfg = getConfig()
	local chance = math.random(1,3)
	local money = math.random(1000,30000)
	local giftbox = math.random(1,1)
	if chance ~= 1 then
		if vRPgb.tryBoxPayment(source,1) then
		vRPclient.addBlip(source,{-545.720703125,-227.97738647461,37.649803161621,500,69,"GiftBox Market"})
		vRP.giveMoney({source,money})
		vRPclient.notify(source,{"~w~[~g~GiftBox~w~] You got ~g~".. money .."$~w~!"})
		TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^0[^2GiftBox^0] ^2'.. GetPlayerName(source) ..'^0 opened a ^2GiftBox ^0and he got ^2'.. money ..'$^0!')
	else
		vRPclient.notify(source,{cfg.message.not_enough_gb})
	end
	if chance ~= 2 then 
		if vRPgb.tryBoxPayment(source,1) then
		vRPgb.givegiftbox(source,giftbox)
		vRPclient.notify(source,{"~w~[~g~GiftBox~w~] You got a ~g~".. giftbox .. " GiftBox ~w~!"})
		TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^0[^2GiftBox^0] ^2'.. GetPlayerName(source) ..'^0 opened a ^2GiftBox ^0and he got ^2'.. giftbox ..' GiftBox^0!')
	else
		vRPclient.notify(source,{cfg.message.not_enough_gb})
	end 
		if chance ~= 3 then
			if vRPgb.tryBoxPayment(user_id,1) then
				vRPclient.notify(source,{"~w~[~g~GiftBox~w~] You didn't got any thing!"})
				TriggerClientEvent('chatmessage', -1, '', { 255, 255, 255}, '^0[^2GiftBox^0] ^2'.. GetPlayerName(source) ..'^0 opened a ^2GiftBox ^0and he got ^2Nothing^0!')
			else
				vRPclient.notify(source,{cfg.message.not_enough_gb})
			end
		end
	end
end
end)

RegisterServerEvent('vRP:moneygift')
AddEventHandler('vRP:moneygift', function ()
	local cfg = getConfig()
	if vRP.tryPayment({source,1000000}) then
		vRPclient.addBlip(source,{-530.02941894532,-229.9102935791,36.702156066894,66,69,"GiftBox"})
		vRPgb.givegiftbox(source,1)
		vRPclient.notify(source, {cfg.message.tr_succes})
	else
		vRPclient.notify(source, {cfg.message.not_enough_m})
	end
end)

RegisterServerEvent('vRP:gbpaycheck')
AddEventHandler('vRP:gbpaycheck', function()
	local cfg = getConfig()
  	local user_id = vRP.getUserId({source})
	  vRPgb.givegiftbox(user_id,cfg.paycheck.amount)
	  vRPclient.notifyPicture(source,{cfg.paycheck.picture,1,cfg.paycheck.title,false,cfg.paycheck.msg})
end)

vRP.registerMenuBuilder({"admin", function(add, data)
	local cfg = getConfig()
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		if(vRP.hasPermission({user_id, cfg.menu.permission}))then
			choices["Give GiftBox"] = {givePlayergiftbox, cfg.menu.give_desc}
		end
		if(vRP.hasPermission({user_id, "giftbox.admin"}))then
			choices["Take GiftBox"] = {takePlayergiftbox, cfg.menu.take_desc}
		end
		add(choices)
	end
end})

