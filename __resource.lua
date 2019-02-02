------------------------CREDITS------------------------
-------- Script made by Vlad, DevStudios Owner --------
--         Script made for Diamond Romania RP        --
--          Site: https://devstudios.store           --
--        Forum: http://forum.devstudios.store       --
--   Copyright 2019 ©DevStudios. All rights served   --
-------------------------------------------------------
description "vrp_giftbox"
dependency "vrp"

client_scripts {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"client.lua",
	"market.lua",
	"paycheck.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server.lua",
	"cfg/cfg.lua"
}
