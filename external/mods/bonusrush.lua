--[[	   				   BONUS RUSH MODULE
==========================================================================
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build

Description:
Based on official Boss Rush Module this one implements BONUS RUSH game mode
(defeat all opponents that are consider bonuses).

(Includes a Co-Op Variant)

This mode is detectable by GameMode trigger as bonusrush and bonusrushcoop.
Only characters with select.def "bonus = 1" parameter assigned are valid for
this mode.
=============================================================================
]]

--[[
; select.def customization

[Characters]
 ; - bonus
 ;   IKEMEN feature: Set the paramvalue to 1 to include this character in "Bonus
 ;   Rush" mode. At least 1 character needs this parameter for the mode to show
 ;   up in modes selection menu.

[Options]
 ;IKEMEN feature: Maximum number of normal and ratio matches to fight before
 ;game ends in bonus Rush mode. Can be left empty, if player is meant to fight
 ;against all bonus characters (in such case order parameter is still respected)

bonusrush.maxmatches = 
]]

--[[
; Example system.def parameters assignments

[Title Info]
menu.itemname.bonusrush = "BONUS RUSH"
menu.itemname.bonusrushcoop = "BONUS RUSH CO-OP"

[Bonus Rush Results Screen]
enabled = 1
sounds.enabled = 1

fadein.time = 0
fadein.col = 0, 0, 0
fadein.anim = -1
fadeout.time = 64
fadeout.col = 0, 0, 0
fadeout.anim = -1
show.time = 300

winstext.text = "Congratulations!"
winstext.offset = 159, 70
winstext.font = 3, 0, 0
winstext.scale = 1.0, 1.0
winstext.displaytime = -1
winstext.layerno = 2

;overlay.window = 0, 0, localcoordX, localcoordY
overlay.col = 0, 0, 0
overlay.alpha = 20, 100

p1.state = 180
p2.state = 
p1.teammate.state = 
p2.teammate.state = 

[BonusRushResultsBGdef]
; left blank (character and stage not covered)
]]

--;===========================================================
--; main.lua
--;===========================================================
-- main.t_itemname is a table storing functions with general game mode
-- configuration (usually ending with start.f_selectMode function call).
main.t_itemname.bonusrush = function()
	main.f_playerInput(main.playerInput, 1)
	main.t_pIn[2] = 1
	main.rankDisplay = true
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	main.elimination = true
	main.exitSelect = true
	main.hiscoreScreen = true
	--main.lifebar.p1score = true
	--main.lifebar.p2aiLevel = true
	main.makeRoster = true
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	main.rankingCondition = true
	main.resultsTable = motif.bonus_rush_results_screen
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
	main.txt_mainSelect:update({text = motif.select_info.title_bonusrush_text})
	setGameMode('bonusrush')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.bonusrushcoop = function()
	main.rankDisplay = true
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
	main.lifebar.p1score = true
	main.lifebar.p2aiLevel = true
	main.makeRoster = true
	main.numSimul = {2, math.min(4, config.Players)}
	main.numTag = {2, math.min(4, config.Players)}
	main.rankingCondition = true
	main.resultsTable = motif.bonus_rush_results_screen
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
	main.txt_mainSelect:update({text = motif.select_info.title_bonusrushcoop_text})
	setGameMode('bonusrushcoop')
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
if motif.select_info.title_bonusrush_text == nil then
	motif.select_info.title_bonusrush_text = 'Bonus Rush'
end

if motif.select_info.title_bonusrushcoop_text == nil then
	motif.select_info.title_bonusrushcoop_text = 'Bonus Rush Cooperative'
end

-- [Bonus Rush Results Screen] default parameters. Works similarly to
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
	winstext_text = 'Congratulations!',
	winstext_offset = {159, 70},
	winstext_font = {'f-6x9.def', 0, 0, 255, 255, 255, -1},
	winstext_scale = {1.0, 1.0},
	winstext_displaytime = 0,
	winstext_layerno = 2,
	overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	overlay_col = {0, 0, 0},
	overlay_alpha = {20, 100},
	p1_state = {180},
	p2_state = {},
	p1_teammate_state = {},
	p2_teammate_state = {},
}
if motif.bonus_rush_results_screen == nil then
	motif.bonus_rush_results_screen = {}
end
motif.bonus_rush_results_screen = main.f_tableMerge(t_base, motif.bonus_rush_results_screen)

-- If not defined, [BonusRushResultsBgDef] group defaults to [WinBGdef].
if motif.bonusrushresultsbgdef == nil then
	motif.bonusrushresultsbgdef = motif.winbgdef
end

-- This code creates data out of optional [BonusRushResultsBgDef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.bonusrushresultsbgdef.spr ~= nil and motif.bonusrushresultsbgdef.spr ~= '' then
	motif.bonusrushresultsbgdef.spr = searchFile(motif.bonusrushresultsbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.bonusrushresultsbgdef.spr_data = sffNew(motif.bonusrushresultsbgdef.spr)
else
	motif.bonusrushresultsbgdef.spr = motif.files.spr
	motif.bonusrushresultsbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.bonusrushresultsbgdef.bg = bgNew(motif.bonusrushresultsbgdef.spr_data, motif.def, 'bonusrushresultsbg')

-- fadein/fadeout anim data generation.
if motif.bonus_rush_results_screen.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.bonus_rush_results_screen, {s = 'fadein_'})
end
if motif.bonus_rush_results_screen.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.bonus_rush_results_screen, {s = 'fadeout_'})
end

--;===========================================================
--; start.lua
--;===========================================================
-- start.t_makeRoster is a table storing functions returning table data used
-- by start.f_makeRoster function, depending on game mode.
start.t_makeRoster.bonusrush = function()
	return start.f_unifySettings(main.t_selOptions.bonusrushmaxmatches, main.t_bonusRushChars), main.t_bonusRushChars
end

start.t_makeRoster.bonusrushcoop = start.t_makeRoster.bonusrush

-- start.t_sortRanking is a table storing functions with ranking sorting logic
-- used by start.f_storeStats function, depending on game mode. Here we're
-- reusing logic already declared for survival mode (refer to start.lua)
start.t_sortRanking.bonusrush = start.t_sortRanking.survival
start.t_sortRanking.bonusrushcoop = start.t_sortRanking.survival

-- as above but the functions return if game mode should be considered "cleared"
start.t_clearCondition.bonusrush = function() return winnerteam() == 1 end
start.t_clearCondition.bonusrushcoop = function() return winnerteam() == 1 end

-- start.t_resultData is a table storing functions used for setting variables
-- stored in start.t_result table, returning boolean depending on various
-- factors. It's used by start.f_resultInit function, depending on game mode.
local txt_resultbonusRush = main.f_createTextImg(motif.bonus_rush_results_screen, 'winstext')

start.t_resultData.bonusrush = function()
	if winnerteam() ~= 1 or matchno() < #start.t_roster or motif.bonus_rush_results_screen.enabled == 0 then
		return false
	end
	start.t_result.resultText = main.f_extractText(main.resultsTable[start.t_result.prefix .. '_text'])
	start.t_result.txt = txt_resultbonusRush
	start.t_result.bgdef = 'bonusrushresultsbgdef'
	return true
end

start.t_resultData.bonusrushcoop = start.t_resultData.bonusrush

--;===========================================================
--; main.lua
--;===========================================================
-- Table storing data used by functions related to hiscore rendering and saving.
main.t_hiscoreData.bonusrush = {mode = 'bonusrush', data = 'score', title = motif.select_info.title_bonusrush_text}
main.t_hiscoreData.bonusrushcoop = {mode = 'bonusrushcoop', data = 'score', title = motif.select_info.title_bonusrushcoop_text}

main.t_bonusRushChars = {}

for _, v in ipairs(main.t_selChars) do
	if v.bonus ~= nil and v.bonus == 1 then
		if main.t_bonusRushChars[v.order] == nil then
			main.t_bonusRushChars[v.order] = {}
		end
		table.insert(main.t_bonusRushChars[v.order], v.char_ref)
	end
end

if main.t_selOptions.bonusrushmaxmatches == nil or #main.t_selOptions.bonusrushmaxmatches == 0 then
	local size = 1
	for k, _ in pairs(main.t_bonusRushChars) do if k > size then size = k end end
	main.t_selOptions.bonusrushmaxmatches = {}
	for i = 1, size do
		table.insert(main.t_selOptions.bonusrushmaxmatches, 0)
	end	
	for k, v in pairs(main.t_bonusRushChars) do
		main.t_selOptions.bonusrushmaxmatches[k] = #v
	end
end

if main.debugLog then main.f_printTable(main.t_bonusRushChars, "debug/t_bonusRushChars.txt") end