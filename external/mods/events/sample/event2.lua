
if gameMode() ~= nil and gameMode() ~= "" then --To avoid execute this script as module when boot the engine
	if matchNo() == 1 then
		if not launchFight{
			p2char = {"kfm720"},
			p2numchars = 1,
			p2teammode = "single",
			p2rounds = 1,
			time = 30,
			stage = "stages/stage3d.def",
		} then return end
	end
	setMatchNo(-1)
end