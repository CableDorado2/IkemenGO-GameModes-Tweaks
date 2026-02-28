--[[	   					       STAGE VIEWER MODULE
=======================================================================================================
Author: Cable Dorado 2 (CD2) & Yoshin222
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.02.26)
Description: Adds a Stage Viewer Game Mode, based on Yoshin222's Stage Viewer Character.

This mode is detectable by GameMode trigger as: stageviewer
=======================================================================================================
]]
--Auto-Load ZSS Module
local zss = gameOption("Common.States")
table.insert(zss, "external/mods/stageviewer/stageviewer.zss")
modifyGameOption("Common.States", zss)

--Set the Stage Viewer Path
local StageViewerPath = "external/mods/stageviewer/STAGE VIEWER.def"

--[[Example system.def parameters assignments:
;-------------------------------------------------------------------------------
[Title Info]
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

menu.itemname.stageviewer = "STAGE VIEWER" ;Ikemen Feature

;-------------------------------------------------------------------------------
[Select Info]
title.stageviewer.text = "Stage Viewer"

;-------------------------------------------------------------------------------
[StageViewer Pause Menu]
menu.itemname.back = "Continue"
menu.itemname.commandlist = 
menu.itemname.menuinput = "Button Config"
menu.itemname.menuinput.keyboard = "Key Config"
menu.itemname.menuinput.gamepad = "Joystick Config"
menu.itemname.menuinput.spacer = "-"
menu.itemname.menuinput.inputdefault = "Default"
menu.itemname.menuinput.back = "Back"
menu.itemname.characterchange = "Stage Change"
menu.itemname.exit = "Exit"

]]

--;===========================================================
--; main.lua
--;===========================================================
--[[
main.t_itemname is a table storing functions with general game mode
configuration (usually ending with start.f_selectMode function call).
]]

main.f_addChar( --Load Character Outside select.def
	StageViewerPath .. ', order = 0, ordersurvival = 0, exclude = 1',
	false, --playable?
	true --loading?
)

main.t_itemname.stageviewer = function()
	remapInput(1, getLastInputController())
	remapInput(getLastInputController(), 1)
	setHomeTeam(1)
	
	main.teamMenu[1].single = true
	main.teamMenu[2].single = true
	
	main.selectMenu[1] = true
	main.selectMenu[2] = true
	
	main.forceChar[1] = {main.t_charDef[StageViewerPath:lower()]}
	main.forceChar[2] = {main.t_charDef[StageViewerPath:lower()]}
	
	main.stageMenu = true
	main.roundTime = -1
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {0, 0}
	main.matchWins.single = {0, 0}
	main.matchWins.tag = {0, 0}
	
	main.lifebar.active = false
	main.lifebar.bars = false
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.stageviewer)
	setGameMode('stageviewer')
	return start.f_selectMode
end