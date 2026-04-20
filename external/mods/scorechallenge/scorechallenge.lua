--[[	   					       SCORE CHALLENGE MODULE
=======================================================================================================
Original Author: K4thos | Edited By: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.04.20)
Description: A special challenge where player fight a selected opponent and tries to beat their previous best score.
Based on Super Street Fighter II: The New Challengers (Sega Mega Drive).

This mode is detectable by GameMode trigger as: scorechallenge, scorechallengecoop and netplayscorechallengecoop
=======================================================================================================
CD2's Tweaks:
- Enables the "Here Comes a New Challenger" Intermission
- Set 1 Round to Win
- Set 50 Seconds to Round Time
- Score Record now is Saved in Ranking only if player wins (MISSING)
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
	main.selectMenu[2] = true
	main.stageMenu = true
	main.roundTime = 50
	main.elimination = true --if single lose should stop further lua execution
	main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	
	main.motif.hiscore = true
	main.motif.vsscreen = true
	main.motif.victoryscreen = true
	main.motif.winscreen = true
	main.motif.losescreen = true
	
	--main.fightscreen.mode = true
	main.fightscreen.p1score = true
	--main.fightscreen.p2ailevel = true
end

main.t_itemname.scorechallenge = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.scorechallenge)
	setGameMode('scorechallenge')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.scorechallengecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.scorechallengecoop)
	setGameMode('scorechallengecoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplayscorechallengecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplayscorechallengecoop)
	setGameMode('netplayscorechallengecoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end