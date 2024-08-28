--[[	   TIME ATTACK TWEAKS
=========================================
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build

Description: Adds personal improvements to make Time Attack
more faithful to what is seen in Commercial Games.

CD2's Tweaks:
- Set 1 Round to Win
- Infinite Continues
- Ranking record will now be displayed when you complete the game mode
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
	main.rankDisplay = true
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.continueScreen = true
	main.exitSelect = true
	main.hiscoreScreen = true
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
	main.rankingCondition = true
	main.resultsTable = motif.time_attack_results_screen
	main.stageOrder = true
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
	main.storyboard.gameover = true
	--main.storyboard.credits = true
	--main.stageMenu = true
	main.txt_mainSelect:update({text = motif.select_info.title_timeattack_text})
	setGameMode('timeattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.timeattackcoop = function()
	main.aiRamp = true
	main.rankDisplay = true
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.exitSelect = true
	main.hiscoreScreen = true
	main.coop = true
	main.continueScreen = true
	main.lifebar.timer = true
	main.lifebar.p2aiLevel = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.makeRoster = true
	main.quickContinue = true
	main.numSimul = {2, math.min(4, config.Players)}
	main.numTag = {2, math.min(4, config.Players)}
	main.resetScore = true
	if main.roundTime == -1 then
		main.roundTime = 99
	end
	main.rankingCondition = true
	main.resultsTable = motif.time_attack_results_screen
	main.stageOrder = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[2].ratio = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].single = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.versusScreen = true
	main.versusMatchNo = true
	main.storyboard.gameover = true
	--main.storyboard.credits = true
	--main.stageMenu = true
	main.txt_mainSelect:update({text = motif.select_info.title_timeattackcoop_text})
	setGameMode('timeattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;===========================================================
--; motif.lua
--;===========================================================
if motif.select_info.title_timeattackcoop_text == nil then
	motif.select_info.title_timeattackcoop_text = 'Time Attack Cooperative'
end

--;===========================================================
--; start.lua
--;======================================================
start.t_makeRoster.timeattackcoop = start.t_makeRoster.arcade

start.t_aiRampData.timeattackcoop = start.t_aiRampData.arcade

start.t_sortRanking.timeattackcoop = start.t_sortRanking.timeattack

start.t_clearCondition.timeattackcoop = function() return winnerteam() == 1 end

start.t_resultData.timeattackcoop = start.t_resultData.timeattack

--;===========================================================
--; main.lua
--;===========================================================
main.t_hiscoreData.timeattackcoop = {mode = 'timeattackcoop', data = 'time', title = motif.select_info.title_timeattackcoop_text}