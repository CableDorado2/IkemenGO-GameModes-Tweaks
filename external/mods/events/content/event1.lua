--[[EVENT EXAMPLE
For all paramvalues available, check the Engine Wiki:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Lua#launchfight
]]

if gameMode() ~= nil and gameMode() ~= "" then --To avoid execute this script as module when boot the engine
	if matchNo() == 1 then
		if not launchFight{
			p1char = {"kfm_zaxis"},
			p2char = {"kfm_zaxis"},
			p1numchars = 1,
			p2numchars = 1,
			p1teammode = "single",
			p2teammode = "single",
			p1rounds = 1,
			p2rounds = 1,
			time = -1,
			stage = "stages/stageZ.def",
		} then return end
	end
	setMatchNo(-1)
end