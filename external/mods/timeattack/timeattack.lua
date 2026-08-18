--[[	   							TIME ATTACK TWEAKS
=======================================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0-rc.3)
Description: Adds personal improvements to make Time Attack more faithful to Commercial Games.

The new Co-op modes are detectable by GameMode trigger as: timeattackcoop and netplaytimeattackcoop
=======================================================================================================
CD2's Tweaks:
- Enables the "Here Comes a New Challenger" Intermission
- Set 1 Round to Win
- Set Infinite Round Time
- Disable Continue Screen
- Adds Co-Op and Netplay Variant
=======================================================================================================
]]

--;===========================================================
--; main.lua
--;===========================================================
--[[
main.t_itemname is a table storing functions with general game mode
configuration (usually ending with start.f_selectMode function call).
]]
local function f_commonCfg()
	main.charparam.ai = true
	main.charparam.music = true
	--main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	--main.charparam.time = true
	
	--main.luaPath = "external/script/default.lua" --path to script executed by start.f_selectMode()
	--main.persistLife = true --if life should be maintained after match
	main.aiRamp = true
	main.elimination = true
	--main.dropDefeated = true
	main.exitSelect = true
	--main.rotationChars = true
	main.makeRoster = true
	--main.quickContinue = true --if by default continuing should skip player selection
	main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	--main.resetScore = true --if loosing should set score for the next match to lose count
	main.roundTime = -1 --Infinite Round Time
	main.stageOrder = true
	
	main.motif.vsscreen = true
	main.motif.vsmatchno = true
	--main.motif.dialogue = true
	--main.motif.losescreen = true
	--main.motif.winscreen = true
	main.motif.victoryscreen = false
	--main.motif.continuescreen = true
	main.motif.hiscore = true
	
	--main.fightscreen.mode = true
	--main.fightscreen.match = true
	main.fightscreen.timer = true
	--main.fightscreen.p1score = true
	--main.fightscreen.p1wincount = true
	--main.fightscreen.p2aiLevel = true
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	
	main.storyboard.gameover = true
	--main.storyboard.credits = true
end

main.t_itemname.timeattack = function()
	remapInput(1, getLastInputController())
	remapInput(getLastInputController(), 1)
	main.motif.challenger = true
	f_commonCfg()
	
	main.orderSelect[1] = true
	main.orderSelect[2] = true

	main.teamMenu[1].single = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[1].turns = true
	main.teamMenu[1].ratio = true
	
	main.teamMenu[2].single = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.teamMenu[2].ratio = true
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.timeattack)
	setGameMode('timeattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.timeattackcoop = function()
	main.coop = true
	main.numSimul = {2, math.min(4, gameOption('Config.Players'))}
	main.numTag = {2, math.min(4, gameOption('Config.Players'))}
	f_commonCfg()
	
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	
	main.teamMenu[2].single = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.teamMenu[2].ratio = true
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.timeattackcoop)
	setGameMode('timeattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplaytimeattackcoop = function()
	main.coop = true
	main.numSimul = {2, 2}
	main.numTag = {2, 2}
	f_commonCfg()
	
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	
	main.teamMenu[2].single = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.teamMenu[2].ratio = true
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplaytimeattackcoop)
	setGameMode('netplaytimeattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;============================================================
--; start.lua
--;============================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]
start.t_makeRoster.timeattackcoop = start.t_makeRoster.arcade
start.t_makeRoster.netplaytimeattackcoop = start.t_makeRoster.arcade

--[[
start.t_aiRampData is a table storing functions returning variable data used
by start.f_aiRamp function, depending on game mode.
]]
start.t_aiRampData.timeattackcoop = start.t_aiRampData.arcade
start.t_aiRampData.netplaytimeattackcoop = start.t_aiRampData.arcade