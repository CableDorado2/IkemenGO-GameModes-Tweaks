--[[	   SCORE ATTACK MODULE
=================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build

Description:
This module implements SCORE ATTACK game mode with a Co-Op variant
(defeat opponents beating previous score record).

This mode is detectable by GameMode trigger as scoreattack and scoreattackcoop.
=================================================================================
]]

--[[
; select.def customization

[Options]
 ;IKEMEN feature: Maximum number of normal and ratio matches to fight before
 ;game ends in Score Attack mode. Can be left empty, if player is meant to fight
 ;against all characters (in such case order parameter is still respected)

scoreattack.maxmatches = 
]]

--[[
; Example system.def parameters assignments

[Title Info]
menu.itemname.scoreattack = "SCORE ATTACK"
menu.itemname.scoreattackcoop = "SCORE ATTACK CO-OP"

[Select Info]
; Displaying game mode record directly in select screen
record.offset = 159,39
record.font = 3,0,0
record.scale = 1.0, 1.0
; format: %m = minutes, %s = seconds, %x = milliseconds, %p = score, %c = char name, %n = player name, \n = newline
record.scoreattack.text = "- BEST RECORD -\n%c %p PTS: %n"
record.scoreattackcoop.text = "- BEST RECORD -\n%c %p PTS: %n"

[Score Attack Results Screen]
enabled = 1
sounds.enabled = 1

fadein.time = 32
fadein.col = 0,0,0
fadein.anim = -1
fadeout.time = 64
fadeout.col = 0, 0, 0
fadeout.anim = -1
show.time = 300

winstext.text = "Clear Score: %i"
winstext.offset = 159,70
winstext.font = 3,0,0
winstext.scale = 1.0,1.0
winstext.displaytime = -1
winstext.layerno = 2

;overlay.window = 0,0,320,240
overlay.col = 0,0,0
overlay.alpha = 20,100

p1.state = 175,170
p1.win.state = 180
p2.state = 
p2.win.state = 
p1.teammate.state = 
p1.teammate.win.state = 
p2.teammate.state = 
p2.teammate.win.state = 

[ScoreAttackResultsBGdef]
; left blank (character and stage not covered)
]]

--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.scoreattack = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.aiRamp = true
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.exitSelect = true
	main.elimination = true
	main.hiscoreScreen = true
	main.lifebar.p1score = true
	main.lifebar.p2aiLevel = true
	main.makeRoster = true
	main.quickContinue = true
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.rankDisplay = true
	main.resultsTable = motif.score_attack_results_screen
	main.stageOrder = true
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
	main.versusScreen = true
	main.storyboard.gameover = true
	--main.storyboard.credits = true
	--main.stageMenu = true
	--main.rankingCondition = true
	--main.resetScore = true
	--main.continueScreen = true
	main.txt_mainSelect:update({text = motif.select_info.title_scoreattack_text})
	setGameMode('scoreattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.scoreattackcoop = function()
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.elimination = true
	main.exitSelect = true
	main.hiscoreScreen = true
	main.quickContinue = true
	main.coop = true
	main.lifebar.p1score = true
	main.lifebar.p2aiLevel = true
	main.rankDisplay = true
	main.makeRoster = true
	main.numSimul = {2, math.min(4, config.Players)}
	main.numTag = {2, math.min(4, config.Players)}
	main.resultsTable = motif.score_attack_results_screen
	main.stageOrder = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[2].single = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.teamMenu[2].ratio = true
	main.versusScreen = true
	main.storyboard.gameover = true
	--main.storyboard.credits = true
	--main.stageMenu = true
	--main.continueScreen = true
	--main.resetScore = true
	--main.rankingCondition = true
	main.txt_mainSelect:update({text = motif.select_info.title_scoreattackcoop_text})
	setGameMode('scoreattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;===========================================================
--; motif.lua
--;===========================================================
-- Here we're expanding motif table with default values that will be used if
-- these parameters are not overridden by system.def parameter assignment.
-- (dots should not be used in variable names, so they have been changed to _)

-- [Select Info] default parameters. Displayed in select screen.
if motif.select_info.title_scoreattack_text == nil then
	motif.select_info.title_scoreattack_text = 'Score Attack'
end

if motif.select_info.title_scoreattackcoop_text == nil then
	motif.select_info.title_scoreattackcoop_text = 'Score Attack Cooperative'
end

if motif.select_info.record_scoreattack_text == nil then
	motif.select_info.record_scoreattack_text = '- BEST RECORD -\n%c %p PTS: %n'
end

if motif.select_info.record_scoreattackcoop_text == nil then
	motif.select_info.record_scoreattackcoop_text = '- BEST RECORD -\n%c %p PTS: %n'
end

-- [Score Attack Results Screen] default parameters. Works similarly to
-- [Win Screen] (used for rendering mode results screen after last match)
local t_base = {
	enabled = 1,
	sounds_enabled = 1,
	fadein_time = 0,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	fadeout_time = 64,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	show_time = 300,
	winstext_text = 'Score: %i',
	winstext_offset = {159, 70},
	winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	winstext_scale = {1.0, 1.0},
	winstext_displaytime = 0,
	winstext_layerno = 2,
	overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	overlay_col = {0, 0, 0},
	overlay_alpha = {0, 128},
	p1_state = {175, 170},
	p1_win_state = {180},
	p2_state = {},
	p2_win_state = {},
	p1_teammate_state = {},
	p1_teammate_win_state = {},
	p2_teammate_state = {},
	p2_teammate_win_state = {},
}
if motif.score_attack_results_screen == nil then
	motif.score_attack_results_screen = {}
end
motif.score_attack_results_screen = main.f_tableMerge(t_base, motif.score_attack_results_screen)

-- If not defined, [ScoreAttackResultsBGdef] group defaults to [WinBGdef].
if motif.scoreattackresultsbgdef == nil then
	motif.scoreattackresultsbgdef = motif.winbgdef
end

-- This code creates data out of optional [ScoreAttackResultsBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.scoreattackresultsbgdef.spr ~= nil and motif.scoreattackresultsbgdef.spr ~= '' then
	motif.scoreattackresultsbgdef.spr = searchFile(motif.scoreattackresultsbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.scoreattackresultsbgdef.spr_data = sffNew(motif.scoreattackresultsbgdef.spr)
else
	motif.scoreattackresultsbgdef.spr = motif.files.spr
	motif.scoreattackresultsbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.scoreattackresultsbgdef.bg = bgNew(motif.scoreattackresultsbgdef.spr_data, motif.def, 'scoreattackresultsbg')

-- fadein/fadeout anim data generation.
if motif.score_attack_results_screen.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.score_attack_results_screen, {s = 'fadein_'})
end
if motif.score_attack_results_screen.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.score_attack_results_screen, {s = 'fadeout_'})
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_makeRoster is a table storing functions returning table data used
-- by start.f_makeRoster function, depending on game mode.
start.t_makeRoster.scoreattack = start.t_makeRoster.arcade
start.t_makeRoster.scoreattackcoop = start.t_makeRoster.arcade

-- start.t_aiRampData is a table storing functions returning variable data used
-- by start.f_aiRamp function, depending on game mode.
start.t_aiRampData.scoreattack = start.t_aiRampData.arcade
start.t_aiRampData.scoreattackcoop = start.t_aiRampData.arcade

-- start.t_sortRanking is a table storing functions with ranking sorting logic
-- used by start.f_storeStats function, depending on game mode.
start.t_sortRanking.scoreattack = function(t, a, b) return t[b].score < t[a].score end
start.t_sortRanking.scoreattackcoop = start.t_sortRanking.scoreattack --Reuse above data

-- as above but the functions return if game mode should be considered "cleared"
start.t_clearCondition.scoreattack = function() return winnerteam() == 1 end
start.t_clearCondition.scoreattackcoop = function() return winnerteam() == 1 end

-- start.t_resultData is a table storing functions used for setting variables
-- stored in start.t_result table, returning boolean depending on various
-- factors. It's used by start.f_resultInit function, depending on game mode.
local txt_resultScoreAttack = main.f_createTextImg(motif.score_attack_results_screen, 'winstext')

start.t_resultData.scoreattack = function()
	if winnerteam() ~= 1 or matchno() < #start.t_roster or motif.score_attack_results_screen.enabled == 0 then
		return false
	end
	start.t_result.resultText = main.f_extractText(main.resultsTable[start.t_result.prefix .. '_text'], scoretotal())
	start.t_result.txt = txt_resultScoreAttack
	start.t_result.bgdef = 'scoreattackresultsbgdef'
	if scoretotal() <= start.f_lowestRankingData('score') then
		start.t_result.stateType = '_lose'
		start.t_result.winBgm = false
	else
		start.t_result.stateType = '_win'
	end
	return true
end

start.t_resultData.scoreattackcoop = start.t_resultData.scoreattack --Reuse above data

--;===========================================================
--; main.lua
--;===========================================================
-- Table storing data used by functions related to hiscore rendering and saving.
main.t_hiscoreData.scoreattack = {mode = 'scoreattack', data = 'score', title = motif.select_info.title_scoreattack_text}
main.t_hiscoreData.scoreattackcoop = {mode = 'scoreattackcoop', data = 'score', title = 'Score Attack Co-Op'}

if main.t_selOptions.scoreattackmaxmatches == nil then main.t_selOptions.scoreattackmaxmatches = {6, 1, 1, 0, 0, 0, 0, 0, 0, 0} end