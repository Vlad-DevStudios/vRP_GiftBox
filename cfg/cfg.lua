------------------------CREDITS------------------------
-------- Script made by Vlad, DevStudios Owner --------
--         Script made for Diamond Romania RP        --
--          Site: https://devstudios.store           --
--        Forum: http://forum.devstudios.store       --
--   Copyright 2019 ©DevStudios. All rights served   --
-------------------------------------------------------
local cfg = {}

cfg.message = {
	offline = "~w~[~g~GiftBox~w~] Player is not online!",
	invalid_number = "~w~[~g~GiftBox~w~] Number has to be a number!",
	not_enough_gb = "~w~[~g~GiftBox~w~] You don't have enough ~g~GiftBoxes~w~!",
	tr_succes = "~w~[~g~GiftBox~w~] The ~g~Transaction ~w~was made successfully~w~!",
	not_enough_m = "~w~[~g~GiftBox~w~] You don't have enough ~g~Money~w~!",
}

cfg.paycheck = {
	picture = "CHAR_BANK_BOL",
	title = "GiftBox",
	msg = "~w~[~g~GiftBox~w~] You got ~g~1 GiftBox~w~!",
	amount = 5
}

cfg.menu = {
	permission = "giftbox.admin",
	take_desc = "Take giftboxes from a player",
	give_desc = "Give giftboxes to a player",
}

cfg.open_giftbox = 1

cfg.display_css = [[
	.div_giftbox {
		position: absolute;
		top: 149px;
		right: 10px;
		font-size: 30px;
		font-family: Pricedown;
		color: #FFFFFF;
		text-shadow: rgb(0, 0, 0) 1px 0px 0px, rgb(0, 0, 0) 0.533333px 0.833333px 0px, rgb(0, 0, 0) -0.416667px 0.916667px 0px, rgb(0, 0, 0) -0.983333px 0.133333px 0px, rgb(0, 0, 0) -0.65px -0.75px 0px, rgb(0, 0, 0) 0.283333px -0.966667px 0px, rgb(0, 0, 0) 0.966667px -0.283333px 0px;
	}
	.div_giftbox .symbol{
        content: url(https://discordapp.com/assets/739c1934cfb00cde067e3d45d49c5a45.svg);
		display: inline-flex;
		width: 23px;
		height: 23px;
	}
]]

function getConfig()
	return cfg
end
