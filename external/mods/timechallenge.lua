--[[	   					       TIME CHALLENGE MODULE
=======================================================================================================
Original Author: K4thos | Edited By: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.01.17)
Description: A special challenge where player fight a selected opponent and tries to beat their previous best time.
Based on Super Street Fighter II: The New Challengers (Sega Mega Drive).

This mode is detectable by GameMode trigger as: timechallenge, timechallengecoop and netplaytimechallengecoop
=======================================================================================================
CD2's Tweaks:
- Enables the "Here Comes a New Challenger" Intermission
- Set 1 Round to Win
- Set Infinite Round Time
- Time Record now is Saved in Ranking if player wins
- Adds Co-Op and Netplay Variant
=======================================================================================================
]]

--[[Example system.def parameters assignments
;-------------------------------------------------------------------------------
[Title Info]
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

menu.itemname.timechallenge = "TIME CHALLENGE" ;Ikemen Feature
menu.itemname.timechallengecoop = "TIME CHALLENGE CO-OP" ;Ikemen Feature
menu.itemname.server.netplaytimechallengecoop = "TIME CHALLENGE CO-OP" ;Ikemen Feature

;-------------------------------------------------------------------------------
[Select Info]
title.timechallenge.text = "Time Challenge"
title.timechallengecoop.text = "Time Challenge Cooperative"
title.netplaytimechallengecoop.text = "Online Time Challenge"

;format: %m = minutes, %s = seconds, %x = milliseconds, %p = score, %c = char name, %n = player name, \n = newline
record.timechallenge.text = "- BEST RECORD: %n -\n%c: %m:%s.%x"
record.timechallengecoop.text = "- BEST RECORD: %n -\n%c: %m:%s.%x"
record.netplaytimechallengecoop.text = "- BEST RECORD: %n -\n%c: %m:%s.%x"

;-------------------------------------------------------------------------------
[Hiscore Info]
;Set per-gamemode ranking criteria: score|time|win. Used to sort hiscores for that mode.

ranking.timechallenge = "time"
ranking.timechallengecoop = "time"
ranking.netplaytimechallengecoop = "time"

title.timechallenge.text = "Ranking Time Challenge"
title.timechallengecoop.text = "Ranking Time Challenge Cooperative"
title.netplaytimechallengecoop.text = "Ranking Online Time Challenge"

;-------------------------------------------------------------------------------
[Win Screen]
;Set per-gamemode win/results screen variant to use for that mode.
;Use "Win Screen" (default) or a specific "<X> Results Screen" name.

results.timechallenge = "Time Challenge Results Screen"
results.timechallengecoop = "Time Challenge Cooperative Results Screen"
results.netplaytimechallengecoop = "Online Time Challenge Results Screen"

;-------------------------------------------------------------------------------
[Time Challenge Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 1

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
[TimeChallengeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Time Challenge Cooperative Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 1

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
[TimeChallengeCooperativeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Online Time Challenge Results Screen]
enabled = 1
sounds.enabled = 1
roundstowin = 1

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
[OnlineTimeChallengeResultsBGdef]
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
	main.selectMenu[2] = true
	main.stageMenu = true
	main.roundTime = -1 --Infinite Round Time
	main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	
	main.motif.hiscore = true
	main.motif.losescreen = true
	main.motif.versusscreen = true
	main.motif.victoryscreen = true
	main.motif.winscreen = true
	
	--main.lifebar.mode = true
	main.lifebar.timer = true
	--main.lifebar.p2ailevel = true
	
	main.matchWins.draw = {0, 0}
	main.matchWins.simul = {1, 1}
	main.matchWins.single = {1, 1}
	main.matchWins.tag = {1, 1}
end

main.t_itemname.timechallenge = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.timechallenge)
	setGameMode('timechallenge')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.timechallengecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.timechallengecoop)
	setGameMode('timechallengecoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplaytimechallengecoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplaytimechallengecoop)
	setGameMode('netplaytimechallengecoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end