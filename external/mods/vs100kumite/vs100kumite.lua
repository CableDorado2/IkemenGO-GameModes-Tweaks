--[[	   					       	 VS 100 KUMITE MODULE
=======================================================================================================
Original Author: K4thos | Edited By: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0-rc.5)
Description: Defeat as many opponents as possible across 100 consecutive matches.
Based on Street Fighter Alpha 3.

This mode is detectable by GameMode trigger as vs100kumite, vs100kumitecoop and netplayvs100kumitecoop
=======================================================================================================
CD2's Tweaks:
- VS Screen Restored
- Stage Select Disabled
- Enables the "Here Comes a New Challenger" Intermission
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
	main.aiRamp = false
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	
	main.dropDefeated = false --defeated members are not removed from team
	main.elimination = false --single lose doesn't stop further lua execution
	main.forceRosterSize = true --roster size enforced even if there are not enough characters to fill it
	main.rotationChars = true
	main.exitSelect = true
	--main.stageMenu = true --Enable Stage Select
	main.makeRoster = true
	--main.roundTime = 99
	
	--main.persistLife = true --life maintained after match
	--main.persistMusic = true --don't stop the previous music at the start of the match.
	--main.persistRounds = true --lifebar uses consecutive wins for round numbers
	
	main.motif.vsscreen = true
	main.motif.vsmatchno = true
	main.motif.continuescreen = false --no continue screen after lose the match
	main.motif.hiscore = true
	main.motif.losescreen = false --no lose screen after lose the match
	--main.motif.winscreen = true
	
	--main.fightscreen.mode = true
	main.fightscreen.match = true
	--main.fightscreen.timer = true
	--main.fightscreen.p1score = true
	--main.fightscreen.p1wincount = true
	--main.fightscreen.p2ailevel = true
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	
	main.storyboard.gameover = true
	--main.storyboard.credits = true
end

main.t_itemname.vs100kumite = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.vs100kumite)
	setGameMode('vs100kumite')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.vs100kumitecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.vs100kumitecoop)
	setGameMode('vs100kumitecoop')
	return start.f_selectMode
end

main.t_itemname.netplayvs100kumitecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplayvs100kumitecoop)
	setGameMode('netplayvs100kumitecoop')
	return start.f_selectMode
end

--;===========================================================
--; start.lua
--;===========================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]
start.t_makeRoster.vs100kumite = function()
	local t = {}
	local t_static = {main.t_randomChars}
	for i = 1, 100 do --generate ratiomatches style table for 100 matches
		table.insert(t, {['rmin'] = start.p[2].numChars, ['rmax'] = start.p[2].numChars, ['order'] = 1})
	end
	return t, t_static
end
start.t_makeRoster.vs100kumitecoop = start.t_makeRoster.vs100kumite
start.t_makeRoster.netplayvs100kumitecoop = start.t_makeRoster.vs100kumite