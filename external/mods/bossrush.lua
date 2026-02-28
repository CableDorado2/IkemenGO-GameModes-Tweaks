--[[	   					       BOSS RUSH MODULE
=======================================================================================================
Original Author: K4thos | Edited By: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.02.26)
Description: A special challenge where player fight multiple bosses consecutively.
Beating all bosses clears the mode.

This mode is detectable by GameMode trigger as: bossrush, bossrushcoop and netplaybossrushcoop.
Only characters with select.def "boss = 1" parameter assigned are valid for this mode.
=======================================================================================================
CD2's Tweaks:
- VS Screen Restored
- Enables the "Here Comes a New Challenger" Intermission
- Adds Co-Op and Netplay Variant
- main.t_bossChars renamed to main.t_bossRushChars to allow Single Boss Fight variant like Bonus Games
TODO: Add Single Boss Fight game mode (defeat a boss character selected) detectable by GameMode trigger as boss.
=======================================================================================================
]]

--[[select.def customization:
[Characters]
; - boss
;   IKEMEN feature: Set the paramvalue to 1 to include this character in "Boss Rush" and "Boss Fight" mode.
;   At least 1 character needs this parameter for the mode to be playable.

[Options]
;Maximum number of normal and ratio matches to fight before game ends in Boss Rush mode.
;Leave it empty to fight all boss characters (the "order" parameter is still respected).

bossrush.maxmatches = 6,1,1,0,0,0,0,0,0,0

]]

--[[Example system.def parameters assignments
;-------------------------------------------------------------------------------
[Title Info]
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

menu.itemname.bossrush = "BOSS RUSH" ;Ikemen Feature
menu.itemname.bossrushcoop = "BOSS RUSH CO-OP" ;Ikemen Feature
menu.itemname.server.netplaybossrushcoop = "BOSS RUSH CO-OP" ;Ikemen Feature

menu.itemname.bossfight = "BOSS FIGHT" ;TODO
menu.itemname.bossfight.back = "BACK" ;TODO boss characters menu items are automatically added before bossfight.back

;-------------------------------------------------------------------------------
[Select Info]
title.bossrush.text = "Boss Rush"
title.bossrushcoop.text = "Boss Rush Cooperative"
title.netplaybossrushcoop.text = "Online Boss Rush"

title.boss.text = "Boss Fight" ;TODO

record.bossrush.text = "- BEST RECORD: %n -\n%c: Round %r"
record.bossrushcoop.text = "- BEST RECORD: %n -\n%c: Round %r"

;-------------------------------------------------------------------------------
[Hiscore Info]
;Set per-gamemode ranking criteria: score|time|win. Used to sort hiscores for that mode.

ranking.bossrush = "win"
ranking.bossrushcoop = "win"
ranking.netplaybossrushcoop = "win"

title.bossrush.text = "Ranking Boss Rush"
title.bossrushcoop.text = "Ranking Boss Rush Cooperative"
title.netplaybossrushcoop.text = "Ranking Online Boss Rush"

;-------------------------------------------------------------------------------
[Win Screen]
;Set per-gamemode win/results screen variant to use for that mode.
;Use "Win Screen" (default) or a specific "<X> Results Screen" name.

results.bossrush = "Boss Rush Results Screen"
results.bossrushcoop = "Boss Rush Cooperative Results Screen"
results.netplaybossrushcoop = "Online Boss Rush Results Screen"

;-------------------------------------------------------------------------------
[Boss Rush Results Screen]
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
winstext.text = Bosses defeated: %i
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
[BossRushResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Boss Rush Cooperative Results Screen]
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
winstext.text = Bosses defeated: %i
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
[BossRushCooperativeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Online Boss Rush Results Screen]
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
winstext.text = Bosses defeated: %i
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
[OnlineBossRushResultsBGdef]
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
	main.aiRamp = false
	main.elimination = true
	--main.dropDefeated = true
	main.exitSelect = true
	main.rotationChars = true
	main.makeRoster = true
	--main.quickContinue = true --if by default continuing should skip player selection
	--main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	--main.resetScore = true --if loosing should set score for the next match to lose count
	--main.roundTime = 99
	
	main.motif.versusscreen = true
	--main.motif.versusmatchno = true
	--main.motif.dialogue = true
	main.motif.losescreen = true
	main.motif.winscreen = true
	main.motif.victoryscreen = true
	--main.motif.continuescreen = true
	main.motif.hiscore = true
	
	--main.lifebar.mode = true
	--main.lifebar.match = true
	--main.lifebar.timer = true
	main.lifebar.p1score = true
	--main.lifebar.p1wincount = true
	--main.lifebar.p2aiLevel = true
	
	main.storyboard.gameover = true
	--main.storyboard.credits = true
end

main.t_itemname.bossrush = function()
	remapInput(1, getLastInputController())
	remapInput(getLastInputController(), 1)
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.bossrush)
	setGameMode('bossrush')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.bossrushcoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.bossrushcoop)
	setGameMode('bossrushcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplaybossrushcoop = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplaybossrushcoop)
	setGameMode('netplaybossrushcoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.boss = function() --W.I.P
	remapInput(1, getLastInputController())
	remapInput(getLastInputController(), 1)
	main.selectMenu[2] = true
	main.motif.victoryscreen = true
	
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	
	main.orderSelect[1] = true
	main.orderSelect[2] = true
	
	main.teamMenu[1].single = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[1].turns = true
	main.teamMenu[1].ratio = true
	
	main.teamMenu[2].single = true
	main.forceChar[2] = {main.t_bossChars[item]}
	
	main.motif.challenger = true
	main.f_setCredits()
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.boss)
	setGameMode('boss')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_bossChars = {}
main.t_bossRushChars = {}
for _, v in ipairs(main.t_selChars) do
	if v.boss ~= nil and v.boss == 1 then
		if main.t_bossChars == nil then
			main.t_bossChars = {}
		end
		local order = math.max(1, v.order)
		if main.t_bossRushChars[order] == nil then
			main.t_bossRushChars[order] = {}
		end
		table.insert(main.t_bossChars, v.char_ref)
		table.insert(main.t_bossRushChars[order], v.char_ref)
	end
end

if main.t_selOptions.bossrushmaxmatches == nil or #main.t_selOptions.bossrushmaxmatches == 0 then
	local size = 1
	for k, _ in pairs(main.t_bossRushChars) do
		if k > size then size = k end
	end
	main.t_selOptions.bossrushmaxmatches = {}
	for i = 1, size do
		table.insert(main.t_selOptions.bossrushmaxmatches, 0)
	end	
	for k, v in pairs(main.t_bossRushChars) do
		main.t_selOptions.bossrushmaxmatches[k] = #v
	end
end

--;===========================================================
--; start.lua
--;===========================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]

start.t_makeRoster.bossrush = function()
	return start.f_unifySettings(main.t_selOptions.bossrushmaxmatches, main.t_bossRushChars), main.t_bossRushChars
end
start.t_makeRoster.bossrushcoop = start.t_makeRoster.bossrush
start.t_makeRoster.netplaybossrushcoop = start.t_makeRoster.bossrush
if gameOption('Debug.DumpLuaTables') then
	main.f_printTable(main.t_bossChars, "debug/t_bossChars.txt")
	main.f_printTable(main.t_bossRushChars, "debug/t_bossRushChars.txt")
end