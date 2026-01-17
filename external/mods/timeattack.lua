--[[	   							TIME ATTACK TWEAKS
=======================================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.01.17)
Description: Adds personal improvements to make Time Attack more faithful to Commercial Games.

This mode is detectable by GameMode trigger as: timeattack, timeattackcoop and netplaytimeattackcoop
=======================================================================================================
CD2's Tweaks:
- Show Best Record in Character Select
- Enables the "Here Comes a New Challenger" Intermission
- Set 1 Round to Win
- Set Infinite Round Time
- Disable Continue Screen
- Disable Victory Screen
- Adds Co-Op and Netplay Variant
=======================================================================================================
]]

--[[Example system.def new parameters assignments
;-------------------------------------------------------------------------------
[Title Info]
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

menu.itemname.timeattackcoop = "TIME ATTACK CO-OP" ;Ikemen Feature
menu.itemname.server.netplaytimeattackcoop = "TIME ATTACK CO-OP" ;Ikemen Feature

;-------------------------------------------------------------------------------
[Select Info]
title.timeattack.text = "Time Attack"
title.timeattackcoop.text = "Time Attack Cooperative"
title.netplaytimeattackcoop.text = "Online Time Attack"

;format: %m = minutes, %s = seconds, %x = milliseconds, %p = score, %c = char name, %n = player name, \n = newline
record.timeattack.text = "- BEST RECORD: %n -\n%c: %m:%s.%x"
record.timeattackcoop.text = "- BEST RECORD: %n -\n%c: %m:%s.%x"
record.netplaytimeattackcoop.text = "- BEST RECORD: %n -\n%c: %m:%s.%x"

;-------------------------------------------------------------------------------
[Hiscore Info]
;Set per-gamemode ranking criteria: score|time|win. Used to sort hiscores for that mode.

ranking.timeattack = "time"
ranking.timeattackcoop = "time"
ranking.netplaytimeattackcoop = "time"

title.timeattack.text = "Ranking Time Attack"
title.timeattackcoop.text = "Ranking Time Attack Cooperative"
title.netplaytimeattackcoop.text = "Ranking Online Time Attack"

;-------------------------------------------------------------------------------
[Win Screen]
;Set per-gamemode win/results screen variant to use for that mode.
;Use "Win Screen" (default) or a specific "<X> Results Screen" name.

results.timeattack = "Time Attack Results Screen"
results.timeattackcoop = "Time Attack Cooperative Results Screen"
results.netplaytimeattackcoop = "Online Time Attack Results Screen"

;-------------------------------------------------------------------------------
[Time Attack Cooperative Results Screen]
enabled = 1
sounds.enabled = 1

fadein.time = 32
fadein.col = 0,0,0
fadein.anim = -1
fadein.snd = -1, 0

fadeout.time = 64
fadeout.col = 0,0,0
fadeout.anim = -1
fadeout.snd = -1, 0

show.time = 300
state.time = 0

winstext.displaytime = 0
winstext.text = Clear Time: %m:%s.%x
winstext.font = enter48.def, 0, 0
winstext.offset = 640,240
winstext.scale = 1.0, 1.0
winstext.xshear = 0
winstext.angle = 0
winstext.layerno = 2
;winstext.window = 0,0, 1280,720
;winstext.localcoord = 

overlay.col = 0,0,0
overlay.alpha = 20,128
;overlay.window = 0,0, 1280,720
;overlay.localcoord = 

cancel.key = a, b, c, x, y, z, s

p1.state = 175, 170
p1.win.state = 180
p1.teammate.state = 
p1.teammate.win.state = 

p2.state = 
p2.win.state = 
p2.teammate.state = 
p2.teammate.win.state = 

;-------------------------------------------------------------------------------
[TimeAttackCooperativeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Online Time Attack Results Screen]
enabled = 1
sounds.enabled = 1

fadein.time = 32
fadein.col = 0,0,0
fadein.anim = -1
fadein.snd = -1, 0

fadeout.time = 64
fadeout.col = 0,0,0
fadeout.anim = -1
fadeout.snd = -1, 0

show.time = 300
state.time = 0

winstext.displaytime = 0
winstext.text = Clear Time: %m:%s.%x
winstext.font = enter48.def, 0, 0
winstext.offset = 640,240
winstext.scale = 1.0, 1.0
winstext.xshear = 0
winstext.angle = 0
winstext.layerno = 2
;winstext.window = 0,0, 1280,720
;winstext.localcoord = 

overlay.col = 0,0,0
overlay.alpha = 20,128
;overlay.window = 0,0, 1280,720
;overlay.localcoord = 

cancel.key = a, b, c, x, y, z, s

p1.state = 175, 170
p1.win.state = 180
p1.teammate.state = 
p1.teammate.win.state = 

p2.state = 
p2.win.state = 
p2.teammate.state = 
p2.teammate.win.state = 

;-------------------------------------------------------------------------------
[OnlineTimeAttackResultsBGdef]
;left blank (character and stage not covered)

]]

--;===========================================================
--; main.lua
--;===========================================================
--[[
main.t_itemname is a table storing functions with general game mode
configuration (usually ending with start.f_selectMode function call).
]]

local function f_commonCfg()
	main.charparam.ai = true
	main.charparam.music = true
	--main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	--main.charparam.time = true
	
	--main.luaPath = "external/script/default.lua" --path to script executed by start.f_selectMode()
	--main.persistLife = true --if life should be maintained after match
	main.aiRamp = true
	main.elimination = true
	--main.dropDefeated = true
	main.exitSelect = true
	--main.rotationChars = true
	main.makeRoster = true
	--main.quickContinue = true --if by default continuing should skip player selection
	main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	--main.resetScore = true --if loosing should set score for the next match to lose count
	main.roundTime = -1 --Infinite Round Time
	main.stageOrder = true
	
	main.motif.versusscreen = true
	main.motif.versusmatchno = true
	--main.motif.dialogue = true
	--main.motif.losescreen = true
	--main.motif.winscreen = true
	main.motif.victoryscreen = false
	--main.motif.continuescreen = true
	main.motif.hiscore = true
	
	--main.lifebar.mode = true
	--main.lifebar.match = true
	main.lifebar.timer = true
	--main.lifebar.p1score = true
	--main.lifebar.p1wincount = true
	--main.lifebar.p2aiLevel = true
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	
	main.storyboard.gameover = true
	--main.storyboard.credits = true
end

main.t_itemname.timeattack = function()
	remapInput(main.playerInput, 1)
	setCommandInputSource(2, 1)
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.timeattack)
	setGameMode('timeattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.timeattackcoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.timeattackcoop)
	setGameMode('timeattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplaytimeattackcoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplaytimeattackcoop)
	setGameMode('netplaytimeattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;============================================================
--; start.lua
--;============================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]
start.t_makeRoster.timeattackcoop = start.t_makeRoster.arcade
start.t_makeRoster.netplaytimeattackcoop = start.t_makeRoster.arcade

--[[
start.t_aiRampData is a table storing functions returning variable data used
by start.f_aiRamp function, depending on game mode.
]]
start.t_aiRampData.timeattackcoop = start.t_aiRampData.arcade
start.t_aiRampData.netplaytimeattackcoop = start.t_aiRampData.arcade