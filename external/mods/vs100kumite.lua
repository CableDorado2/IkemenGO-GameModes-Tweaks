--[[
Last tested on Ikemen GO v0.98
This external module implements VS 100 KUMITE game mode known from Street
Fighter Alpha 3 MAX (defeat as many opponents as you can in 100 successive
matches). Up to release 0.97 this mode was part of the default scripts
distributed with engine, now it's used as a showcase how to implement full
fledged mode with Ikemen GO external modules feature, without conflicting
with default scripts. More info:
https://github.com/K4thos/Ikemen_GO/wiki/Miscellaneous-Info#lua_modules
This mode is detectable by GameMode trigger as vs100kumite

CD2's Tweaks:
- Adds a Co-Op Variant
]]

--[[
; Example system.def parameters assignments

[Title Info]
menu.itemname.vs100kumite = "VS 100 KUMITE"

[VS100 Kumite Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 51

fadein.time = 0
fadein.col = 0, 0, 0
fadein.anim = -1
fadeout.time = 64
fadeout.col = 0, 0, 0
fadeout.anim = -1
show.time = 300

winstext.text = "Wins: %i\nLoses: %i"
winstext.offset = 159, 70
winstext.font = 3, 0, 0
winstext.scale = 1.0, 1.0
winstext.displaytime = 0
winstext.layerno = 2

;overlay.window = 0, 0, localcoordX, localcoordY
overlay.col = 0, 0, 0
overlay.alpha = 20, 100

p1.state = 175, 170
p1.win.state = 180
p2.state = 
p2.win.state = 
p1.teammate.state = 
p1.teammate.win.state = 
p2.teammate.state = 
p2.teammate.win.state = 

[VS100KumiteResultsBGdef]
; left blank (character and stage not covered)
]]

--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.vs100kumite = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.exitSelect = true
	main.forceRosterSize = true
	main.hiscoreScreen = true
	--main.lifebar.match = true
	--main.lifebar.p2aiLevel = true
	main.makeRoster = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.rankDisplay = true
	main.resultsTable = motif.vs100_kumite_results_screen
	main.rotationChars = true
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
	main.txt_mainSelect:update({text = motif.select_info.title_vs100kumite_text})
	setGameMode('vs100kumite')
	return start.f_selectMode
end

main.t_itemname.vs100kumitecoop = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.exitSelect = true
	main.forceRosterSize = true
	main.hiscoreScreen = true
	--main.lifebar.match = true
	--main.lifebar.p2aiLevel = true
	main.makeRoster = true
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.rankDisplay = true
	main.resultsTable = motif.vs100_kumite_results_screen
	main.rotationChars = true
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
	main.txt_mainSelect:update({text = motif.select_info.title_vs100kumite_text})
	setGameMode('vs100kumite')
	return start.f_selectMode
end

--;===========================================================
--; motif.lua
--;===========================================================
-- Here we're expanding motif table with default values that will be used if
-- these parameters are not overridden by system.def parameter assignment.
-- (dots should not be used in variable names, so they have been changed to _)

-- [Select Info] default parameters. Displayed in select screen.
if motif.select_info.title_vs100kumite_text == nil then
	motif.select_info.title_vs100kumite_text = 'VS 100 Kumite'
end

-- [VS100 Kumite Results Screen] default parameters. Works similarly to
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
	winstext_text = 'Wins: %i\nLoses: %i',
	winstext_offset = {159, 70},
	winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	winstext_scale = {1.0, 1.0},
	winstext_displaytime = 0,
	winstext_layerno = 2,
	roundstowin = 51,
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
if motif.vs100_kumite_results_screen == nil then
	motif.vs100_kumite_results_screen = {}
end
motif.vs100_kumite_results_screen = main.f_tableMerge(t_base, motif.vs100_kumite_results_screen)

-- If not defined, [VS100KumiteResultsBGdef] group defaults to [WinBGdef].
if motif.vs100kumiteresultsbgdef == nil then
	motif.vs100kumiteresultsbgdef = motif.winbgdef
end

-- This code creates data out of optional [VS100KumiteResultsBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.vs100kumiteresultsbgdef.spr ~= nil and motif.vs100kumiteresultsbgdef.spr ~= '' then
	motif.vs100kumiteresultsbgdef.spr = searchFile(motif.vs100kumiteresultsbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.vs100kumiteresultsbgdef.spr_data = sffNew(motif.vs100kumiteresultsbgdef.spr)
else
	motif.vs100kumiteresultsbgdef.spr = motif.files.spr
	motif.vs100kumiteresultsbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.vs100kumiteresultsbgdef.bg = bgNew(motif.vs100kumiteresultsbgdef.spr_data, motif.def, 'vs100kumiteresultsbg')

-- fadein/fadeout anim data generation.
if motif.vs100_kumite_results_screen.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.vs100_kumite_results_screen, {s = 'fadein_'})
end
if motif.vs100_kumite_results_screen.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.vs100_kumite_results_screen, {s = 'fadeout_'})
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_makeRoster is a table storing functions returning table data used
-- by start.f_makeRoster function, depending on game mode.
start.t_makeRoster.vs100kumite = function()
	local t = {}
	local t_static = {main.t_randomChars}
	for i = 1, 100 do --generate ratiomatches style table for 100 matches
		table.insert(t, {['rmin'] = start.p[2].numChars, ['rmax'] = start.p[2].numChars, ['order'] = 1})
	end
	return t, t_static
end

-- start.t_sortRanking is a table storing functions with ranking sorting logic
-- used by start.f_storeStats function, depending on game mode. Here we're
-- reusing logic already declared for survival mode (refer to start.lua)
start.t_sortRanking.vs100kumite = start.t_sortRanking.survival

-- as above but the functions return if game mode should be considered "cleared"
start.t_clearCondition.vs100kumite = function() return true end

-- start.t_resultData is a table storing functions used for setting variables
-- stored in start.t_result table, returning boolean depending on various
-- factors. It's used by start.f_resultInit function, depending on game mode.
local txt_resultVS100 = main.f_createTextImg(motif.vs100_kumite_results_screen, 'winstext')
start.t_resultData.vs100kumite = function()
	if matchno() < #start.t_roster or motif.vs100_kumite_results_screen.enabled == 0 then
		return false
	end
	start.t_result.resultText = main.f_extractText(main.resultsTable[start.t_result.prefix .. '_text'], start.winCnt, start.loseCnt)
	start.t_result.txt = txt_resultVS100
	start.t_result.bgdef = 'vs100kumiteresultsbgdef'
	if start.winCnt < main.resultsTable.roundstowin then
		start.t_result.stateType = '_lose'
		start.t_result.winBgm = false
	else
		start.t_result.stateType = '_win'
	end
	return true
end

--;===========================================================
--; main.lua
--;===========================================================
-- Table storing data used by functions related to hiscore rendering and saving.
main.t_hiscoreData.vs100kumite = {mode = 'vs100kumite', data = 'win', title = motif.select_info.title_vs100kumite_text}
