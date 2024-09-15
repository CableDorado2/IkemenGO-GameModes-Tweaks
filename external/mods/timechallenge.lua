--[[Tested on Ikemen GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build

This external module implements TIME CHALLENGE game mode (defeat selected
opponent beating previous time record). Up to release 0.97 this mode was part
of the default scripts distributed with engine, now it's used as a showcase
how to implement full fledged mode with Ikemen GO external modules feature,
without conflicting with default scripts. More info:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Lua#external-modules
This mode is detectable by GameMode trigger as timechallenge, timechallengecoop and netplaytimechallengecoop

CD2's Tweaks:
- Team Mode Enabled
- Adds Co-Op and Netplay Variant
]]

--[[
; Example system.def parameters assignments

[Title Info]
menu.itemname.timechallenge = "TIME CHALLENGE"
menu.itemname.timechallengecoop = "TIME CHALLENGE CO-OP"

menu.itemname.server.netplaytimechallengecoop = "TIME CHALLENGE CO-OP"

[Select Info]
title.timechallenge.text = "Time Challenge"
title.timechallengecoop.text = "Time Challenge Cooperative"
title.netplaytimechallengecoop.text = "Online Time Challenge"

; Displaying game mode record directly in select screen
record.offset = 159,39
record.font = 3,0,0
record.scale = 1.0, 1.0
; format: %m = minutes, %s = seconds, %x = milliseconds, %p = score, %c = char name, %n = player name, \n = newline
record.timechallenge.text = "- BEST RECORD -\n%c %m:%s.%x: %n"
record.timechallengecoop.text = "- BEST RECORD -\n%c %m:%s.%x: %n"
record.netplaytimechallengecoop.text = "- BEST RECORD -\n%c %m:%s.%x: %n"

[Time Challenge Results Screen]
enabled = 1
sounds.enabled = 1

fadein.time = 32
fadein.col = 0,0,0
fadein.anim = -1
fadeout.time = 64
fadeout.col = 0,0,0
fadeout.anim = -1
show.time = 300

winstext.text = "Clear Time: %m:%s.%x"
winstext.offset = 159,70
winstext.font = 3,0,0
winstext.scale = 1.0,1.0
winstext.displaytime = -1
winstext.layerno = 2

;overlay.window = 0,0,320,240
overlay.col = 0,0,0
overlay.alpha = 20,100

p1.state = 175, 170
p1.win.state = 180
p2.state = 
p2.win.state = 
p1.teammate.state = 
p1.teammate.win.state = 
p2.teammate.state = 
p2.teammate.win.state = 

[TimeChallengeResultsBGdef]
; left blank (character and stage not covered)
]]

--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.timechallenge = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.hiscoreScreen = true
	--main.lifebar.p2aiLevel = true
	--main.lifebar.timer = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.rankDisplay = true
	main.rankingCondition = true
	main.resultsTable = motif.time_challenge_results_screen
	if main.roundTime == -1 then
		main.roundTime = 99
	end
	main.selectMenu[2] = true
	main.stageMenu = true
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
	main.txt_mainSelect:update({text = motif.select_info.title_timechallenge_text})
	setGameMode('timechallenge')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.timechallengecoop = function()
	main.hiscoreScreen = true
	main.coop = true
	main.lifebar.p2aiLevel = true
	main.lifebar.timer = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.numSimul = {2, math.min(4, config.Players)}
	main.numTag = {2, math.min(4, config.Players)}
	main.rankDisplay = true
	main.rankingCondition = true
	main.resultsTable = motif.time_challenge_results_screen
	if main.roundTime == -1 then
		main.roundTime = 99
	end
	main.selectMenu[2] = true
	main.stageMenu = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[2].single = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.teamMenu[2].ratio = true
	main.versusScreen = true
	main.txt_mainSelect:update({text = motif.select_info.title_timechallengecoop_text})
	setGameMode('timechallengecoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplaytimechallengecoop = function()
	main.coop = true
	main.lifebar.p2aiLevel = true
	main.lifebar.timer = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.numSimul = {2, 2}
	main.numTag = {2, 2}
	main.rankDisplay = true
	main.rankingCondition = true
	main.resultsTable = motif.time_challenge_results_screen
	if main.roundTime == -1 then
		main.roundTime = 99
	end
	main.selectMenu[2] = true
	main.stageMenu = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[2].single = true
	main.teamMenu[2].simul = true
	main.teamMenu[2].tag = true
	main.teamMenu[2].turns = true
	main.teamMenu[2].ratio = true
	main.versusScreen = true
	main.txt_mainSelect:update({text = motif.select_info.title_netplaytimechallengecoop_text})
	setGameMode('netplaytimechallengecoop')
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
if motif.select_info.title_timechallenge_text == nil then
	motif.select_info.title_timechallenge_text = 'Time Challenge'
end

if motif.select_info.title_timechallengecoop_text == nil then
	motif.select_info.title_timechallengecoop_text = 'Time Challenge Cooperative'
end

if motif.select_info.title_netplaytimechallengecoop_text == nil then
	motif.select_info.title_netplaytimechallengecoop_text = 'Online Time Challenge'
end

if motif.select_info.record_timechallenge_text == nil then
	motif.select_info.record_timechallenge_text = '- BEST RECORD -\n%c %m:%s.%x: %n'
end

if motif.select_info.record_timechallengecoop_text == nil then
	motif.select_info.record_timechallengecoop_text = '- BEST RECORD -\n%c %m:%s.%x: %n'
end

if motif.select_info.record_netplaytimechallengecoop_text == nil then
	motif.select_info.record_netplaytimechallengecoop_text = '- BEST RECORD -\n%c %m:%s.%x: %n'
end

-- [Time Challenge Results Screen] default parameters. Works similarly to
-- [Win Screen] (used for rendering mode results screen after last match)
local t_base = {
	enabled = 1,
	sounds_enabled = 1,
	fadein_time = 32,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	fadeout_time = 64,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	show_time = 300,
	winstext_text = 'Clear Time: %m:%s.%x',
	winstext_offset = {159, 70},
	winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	winstext_scale = {1.0, 1.0},
	winstext_displaytime = 0,
	winstext_layerno = 2,
	overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	overlay_col = {0, 0, 0},
	overlay_alpha = {20, 100},
	p1_state = {175, 170},
	p1_win_state = {180},
	p2_state = {},
	p2_win_state = {},
	p1_teammate_state = {},
	p1_teammate_win_state = {},
	p2_teammate_state = {},
	p2_teammate_win_state = {},
}
if motif.time_challenge_results_screen == nil then
	motif.time_challenge_results_screen = {}
end
motif.time_challenge_results_screen = main.f_tableMerge(t_base, motif.time_challenge_results_screen)

-- If not defined, [TimeChallengeBGdef] group defaults to [WinBGdef].
if motif.timechallengeresultsbgdef == nil then
	motif.timechallengeresultsbgdef = motif.winbgdef
end

-- This code creates data out of optional [TimeChallengeBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.timechallengeresultsbgdef.spr ~= nil and motif.timechallengeresultsbgdef.spr ~= '' then
	motif.timechallengeresultsbgdef.spr = searchFile(motif.timechallengeresultsbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.timechallengeresultsbgdef.spr_data = sffNew(motif.timechallengeresultsbgdef.spr)
else
	motif.timechallengeresultsbgdef.spr = motif.files.spr
	motif.timechallengeresultsbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.timechallengeresultsbgdef.bg = bgNew(motif.timechallengeresultsbgdef.spr_data, motif.def, 'timechallengeresultsbg')

-- fadein/fadeout anim data generation.
if motif.time_challenge_results_screen.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.time_challenge_results_screen, {s = 'fadein_'})
end
if motif.time_challenge_results_screen.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.time_challenge_results_screen, {s = 'fadeout_'})
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_sortRanking is a table storing functions with ranking sorting logic
-- used by start.f_storeStats function, depending on game mode. Here we're
-- reusing logic already declared for timeattack mode (refer to start.lua)
start.t_sortRanking.timechallenge = start.t_sortRanking.timeattack
start.t_sortRanking.timechallengecoop = start.t_sortRanking.timeattack
start.t_sortRanking.netplaytimechallengecoop = start.t_sortRanking.timeattack

-- as above but the functions return if game mode should be considered "cleared"
start.t_clearCondition.timechallenge = function() return winnerteam() == 1 end
start.t_clearCondition.timechallengecoop = function() return winnerteam() == 1 end
start.t_clearCondition.netplaytimechallengecoop = function() return winnerteam() == 1 end

-- start.t_resultData is a table storing functions used for setting variables
-- stored in start.t_result table, returning boolean depending on various
-- factors. It's used by start.f_resultInit function, depending on game mode.
local txt_resultTimeChallenge = main.f_createTextImg(motif.time_challenge_results_screen, 'winstext')
start.t_resultData.timechallenge = function()
	if winnerteam() ~= 1 or motif.time_challenge_results_screen.enabled == 0 then
		return false
	end
	start.t_result.resultText = main.f_extractText(start.f_clearTimeText(main.resultsTable[start.t_result.prefix .. '_text'], timetotal() / 60))
	start.t_result.txt = txt_resultTimeChallenge
	start.t_result.bgdef = 'timechallengeresultsbgdef'
	if matchtime() / 60 >= start.f_lowestRankingData('time') then
		start.t_result.stateType = '_lose'
		start.t_result.winBgm = false
	else
		start.t_result.stateType = '_win'
	end
	return true
end

start.t_resultData.timechallengecoop = start.t_resultData.timechallenge
start.t_resultData.netplaytimechallengecoop = start.t_resultData.timechallenge

--;===========================================================
--; main.lua
--;===========================================================
-- Table storing data used by functions related to hiscore rendering and saving.
main.t_hiscoreData.timechallenge = {mode = 'timechallenge', data = 'time', title = motif.select_info.title_timechallenge_text}
main.t_hiscoreData.timechallengecoop = {mode = 'timechallengecoop', data = 'time', title = 'Time Challenge CO-OP'}