--[[	   					       	 VS 100 KUMITE MODULE
=======================================================================================================
Original Author: K4thos | Edited By: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.01.27)
Description: Defeat as many opponents as possible across 100 consecutive matches.
Based on Street Fighter Alpha 3 MAX.

This mode is detectable by GameMode trigger as vs100kumite, vs100kumitecoop and netplayvs100kumitecoop
=======================================================================================================
CD2's Tweaks:
- MatchNo now is displayed in VS Screen
- Stage Select Disabled
- Enables the "Here Comes a New Challenger" Intermission
- Adds Co-Op and Netplay Variant
=======================================================================================================
]]

--[[Example system.def parameters assignments
;-------------------------------------------------------------------------------
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

[Title Info]
menu.itemname.vs100kumite = "VS 100 KUMITE" ;Ikemen Feature
menu.itemname.vs100kumitecoop = "VS 100 KUMITE CO-OP" ;Ikemen Feature
menu.itemname.server.netplayvs100kumitecoop = "VS 100 KUMITE CO-OP"

;-------------------------------------------------------------------------------
[Select Info]
title.vs100kumite.text = "VS 100 Kumite"
title.vs100kumitecoop.text = "VS 100 Kumite Cooperative"
title.netplayvs100kumitecoop.text = "Online VS 100 Kumite"

record.vs100kumite.text = "- BEST RECORD: %n -\n%c: Wins %r"
record.vs100kumitecoop.text = "- BEST RECORD: %n -\n%c: Wins %r"
record.netplayvs100kumitecoop.text = "- BEST RECORD: %n -\n%c: Wins %r"

;-------------------------------------------------------------------------------
[Hiscore Info]
;Set per-gamemode ranking criteria: score|time|win. Used to sort hiscores for that mode.

ranking.vs100kumite = "win"
ranking.vs100kumitecoop = "win"
ranking.netplayvs100kumitecoop = "win"

title.vs100kumite.text = "Ranking VS 100 Kumite"
title.vs100kumitecoop.text = "Ranking VS 100 Kumite Cooperative"
title.netplayvs100kumitecoop.text = "Ranking Online VS 100 Kumite"

;-------------------------------------------------------------------------------
[Win Screen]
;Set per-gamemode win/results screen variant to use for that mode.
;Use "Win Screen" (default) or a specific "<X> Results Screen" name.

results.vs100kumite = "VS 100 Kumite Results Screen"
results.vs100kumitecoop = "VS 100 Kumite Cooperative Results Screen"
results.netplayvs100kumitecoop = "Online VS 100 Kumite Results Screen"

;-------------------------------------------------------------------------------
[VS 100 Kumite Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 51

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
winstext.text = Wins: %i\nLoses: %i
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
[VS100KumiteResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[VS 100 Kumite Cooperative Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 51

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
winstext.text = Wins: %i\nLoses: %i
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
[VS100KumiteCooperativeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Online VS 100 Kumite Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 51

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
winstext.text = Wins: %i\nLoses: %i
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
[OnlineVS100KumiteResultsBGdef]
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
	main.aiRamp = false
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	
	main.dropDefeated = false --defeated members are not removed from team
	main.elimination = false --single lose doesn't stop further lua execution
	main.forceRosterSize = true --roster size enforced even if there are not enough characters to fill it
	main.rotationChars = true
	main.exitSelect = true
	--main.stageMenu = true --Enable Stage Select
	main.makeRoster = true
	--main.roundTime = 99
	
	--main.persistLife = true --life maintained after match
	--main.persistMusic = true --don't stop the previous music at the start of the match.
	--main.persistRounds = true --lifebar uses consecutive wins for round numbers
	
	main.motif.versusscreen = true
	main.motif.versusmatchno = true
	main.motif.continuescreen = false --no continue screen after lose the match
	main.motif.hiscore = true
	main.motif.losescreen = false --no lose screen after lose the match
	--main.motif.winscreen = true
	
	--main.lifebar.mode = true
	main.lifebar.match = true
	--main.lifebar.timer = true
	--main.lifebar.p1score = true
	--main.lifebar.p1wincount = true
	--main.lifebar.p2ailevel = true
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
	
	main.storyboard.gameover = true
	--main.storyboard.credits = true
end

main.t_itemname.vs100kumite = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.vs100kumite)
	setGameMode('vs100kumite')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.vs100kumitecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.vs100kumitecoop)
	setGameMode('vs100kumitecoop')
	return start.f_selectMode
end

main.t_itemname.netplayvs100kumitecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplayvs100kumitecoop)
	setGameMode('netplayvs100kumitecoop')
	return start.f_selectMode
end

--;===========================================================
--; start.lua
--;===========================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]
start.t_makeRoster.vs100kumite = function()
	local t = {}
	local t_static = {main.t_randomChars}
	for i = 1, 100 do --generate ratiomatches style table for 100 matches
		table.insert(t, {['rmin'] = start.p[2].numChars, ['rmax'] = start.p[2].numChars, ['order'] = 1})
	end
	return t, t_static
end
start.t_makeRoster.vs100kumitecoop = start.t_makeRoster.vs100kumite
start.t_makeRoster.netplayvs100kumitecoop = start.t_makeRoster.vs100kumite