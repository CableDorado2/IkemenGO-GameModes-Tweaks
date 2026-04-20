--[[	   					       STAGE VIEWER MODULE
=======================================================================================================
Author: Cable Dorado 2 (CD2) & Yoshin222
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.04.19)
Description: Adds a Stage Viewer Game Mode, based on Yoshin222's Stage Viewer Character.

This mode is detectable by GameMode trigger as: stageviewer
=======================================================================================================
]]
--Set Common Module Files Path
local modulePath = "external/mods/stageviewer/"

--Auto-Load ZSS Module
local zss = gameOption("Common.States")
table.insert(zss, modulePath.."stageviewer.zss")
modifyGameOption("Common.States", zss)

--Set the Stage Viewer Path
local StageViewerPath = modulePath.."STAGE VIEWER.def"

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
	
	main.fightscreen.active = false
	main.fightscreen.bars = false
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.stageviewer or "STAGE VIEWER")
	setGameMode('stageviewer')
	return start.f_selectMode
end