--[[	   					       SCORE ATTACK MODULE
=======================================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.01.27)
Description: Implements Score Attack game mode (defeat opponents beating previous score record).
Includes a Co-Op and Netplay variant.

This mode is detectable by GameMode trigger as: scoreattack, scoreattackcoop and netplayscoreattackcoop.
=======================================================================================================
]]

--[[select.def customization:

[Options]
;Maximum number of normal and ratio matches to fight before game ends in Score Attack mode.
;Leave it empty to fight all boss characters (the "order" parameter is still respected).

scoreattack.maxmatches = 6,1,1,0,0,0,0,0,0,0

]]

--[[Example system.def parameters assignments:
;-------------------------------------------------------------------------------
[Title Info]
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

menu.itemname.scoreattack = "SCORE ATTACK" ;Ikemen Feature
menu.itemname.scoreattackcoop = "SCORE ATTACK CO-OP" ;Ikemen Feature
menu.itemname.server.netplayscoreattackcoop = "SCORE ATTACK CO-OP" ;Ikemen Feature

;-------------------------------------------------------------------------------
[Select Info]
title.scoreattack.text = "Score Attack"
title.scoreattackcoop.text = "Score Attack Cooperative"
title.netplayscoreattackcoop.text = "Online Score Attack"

;format: %m = minutes, %s = seconds, %x = milliseconds, %p = score, %c = char name, %n = player name, \n = newline
record.scoreattack.text = "- BEST RECORD: %n -\n%c: %p PTS"
record.scoreattackcoop.text = "- BEST RECORD: %n -\n%c: %p PTS"
record.netplayscoreattackcoop.text = "- BEST RECORD: %n -\n%c: %p PTS"

;-------------------------------------------------------------------------------
[Hiscore Info]
;Set per-gamemode ranking criteria: score|time|win. Used to sort hiscores for that mode.

ranking.scoreattack = "score"
ranking.scoreattackcoop = "score"
ranking.netplayscoreattackcoop = "score"

title.scoreattack.text = "Ranking Score Attack"
title.scoreattackcoop.text = "Ranking Score Attack Cooperative"
title.netplayscoreattackcoop.text = "Ranking Online Score Attack"

;-------------------------------------------------------------------------------
[Win Screen]
;Set per-gamemode win/results screen variant to use for that mode.
;Use "Win Screen" (default) or a specific "<X> Results Screen" name.

results.scoreattack = "Score Attack Results Screen"
results.scoreattackcoop = "Score Attack Cooperative Results Screen"
results.netplayscoreattackcoop = "Online Score Attack Results Screen"

;-------------------------------------------------------------------------------
[Score Attack Results Screen]
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
winstext.text = Clear Score: %i
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
[ScoreAttackResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Score Attack Cooperative Results Screen]
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
winstext.text = Clear Score: %i
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
[ScoreAttackCooperativeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Online Score Attack Results Screen]
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
winstext.text = Clear Score: %i
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
[OnlineScoreAttackResultsBGdef]
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
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	
	--main.luaPath = "external/script/default.lua" --path to script executed by start.f_selectMode()
	--main.persistLife = true --if life should be maintained after match
	main.aiRamp = true
	main.elimination = true
	--main.dropDefeated = true
	main.exitSelect = true
	--main.rotationChars = true
	main.makeRoster = true
	main.quickContinue = true --if by default continuing should skip player selection
	--main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	main.resetScore = true --if loosing should set score for the next match to lose count
	--main.roundTime = 99
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
	--main.lifebar.timer = true
	main.lifebar.p1score = true
	--main.lifebar.p1wincount = true
	--main.lifebar.p2aiLevel = true
	
	--main.matchWins.draw = {0, 0}
	--main.matchWins.simul = {1, 1}
	--main.matchWins.single = {1, 1}
	--main.matchWins.tag = {1, 1}
	
	main.storyboard.gameover = true
	--main.storyboard.credits = true
end

main.t_itemname.scoreattack = function()
	remapInput(1, getLastInputController())
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.scoreattack)
	setGameMode('scoreattack')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.scoreattackcoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.scoreattackcoop)
	setGameMode('scoreattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplayscoreattackcoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplayscoreattackcoop)
	setGameMode('netplayscoreattackcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

--;===========================================================
--; start.lua
--;===========================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]
start.t_makeRoster.scoreattack = start.t_makeRoster.arcade
start.t_makeRoster.scoreattackcoop = start.t_makeRoster.arcade
start.t_makeRoster.netplayscoreattackcoop = start.t_makeRoster.arcade

--[[
start.t_aiRampData is a table storing functions returning variable data used
by start.f_aiRamp function, depending on game mode.
]]
start.t_aiRampData.scoreattack = start.t_aiRampData.arcade
start.t_aiRampData.scoreattackcoop = start.t_aiRampData.arcade
start.t_aiRampData.netplayscoreattackcoop = start.t_aiRampData.arcade