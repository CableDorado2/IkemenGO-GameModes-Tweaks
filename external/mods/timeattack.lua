--[[	   TIME ATTACK TWEAKS
=========================================
Author: CD2
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build

Description: Adds personal improvements to make Time Attack
more faithful to what is seen in Commercial Games.

CD2's Tweaks:
- Set 1 Round to Win
- Ranking record now shows when you complete the game mode
- Adds a Co-Op Variant
=========================================
]]

--;===========================================================
--; main.lua
--;===========================================================
main.t_itemname.timeattack = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.aiRamp = true
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.continueScreen = true
	main.exitSelect = true
	main.hiscoreScreen = true
	--main.lifebar.timer = true
	--main.lifebar.p2aiLevel = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.makeRoster = true
	main.quickContinue = true
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.resetScore = true
	if main.roundTime == -1 then
		main.roundTime = 99
	end
	main.rankDisplay = true
	main.rankingCondition = true
	main.resultsTable = motif.time_attack_results_screen
	main.stageOrder = true
	main.storyboard.credits = true
	main.storyboard.gameover = true
	main.teamMenu[1].ratio = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].single = true
	main.teamMenu[1].tag = true
	main.teamMenu[1].turns = true
	main.teamMenu[2].ratio = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].single = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.versusScreen = true
	main.versusMatchNo = true
	main.f_setCredits()
	main.txt_mainSelect:update({text = motif.select_info.title_timeattack_text})
	setGameMode('timeattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--[[ TODO
main.t_itemname.timeattackcoop = function()
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.elimination = true
	main.exitSelect = true
	main.hiscoreScreen = true
	main.coop = true
	--main.lifebar.timer = true
	--main.lifebar.p2aiLevel = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {2, 2}
	main.matchWins.single = {2, 2}
	main.matchWins.tag = {2, 2}
	main.rankDisplay = true
	main.makeRoster = true
	main.numSimul = {2, math.min(4, config.Players)}
	main.numTag = {2, math.min(4, config.Players)}
	main.rankingCondition = true
	main.resultsTable = motif.time_attack_results_screen
	main.stageMenu = true
	main.storyboard.credits = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[2].ratio = true
	main.teamMenu[2].simul = false
	main.teamMenu[2].single = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.versusScreen = true
	main.versusMatchNo = true
	main.txt_mainSelect:update({text = motif.select_info.title_timeattack_text})
	setGameMode('timeattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end
]]