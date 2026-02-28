--[[	   				         BONUS MARATHON MODULE
==================================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.02.26)
Description: Based on Boss Rush Module.
Bonus Marathon Mode is about defeat all opponents that are consider bonuses.

(Includes Co-Op and Netplay Variant)

This mode is detectable by GameMode trigger as: bonusmarathon, bonusmarathoncoop and netplaybonusmarathoncoop.
Only characters with select.def "bonus = 1" parameter assigned are valid for this mode.
==================================================================================================
]]

--[[select.def customization:
[Characters]
; - bonus
;   IKEMEN feature: Set the paramvalue to 1 to include this character in Bonus Marathon mode.
;	At least 1 character needs this parameter for the mode to be playable.

[Options]
;Maximum number of normal and ratio matches to fight before game ends in Bonus Marathon mode.
;Leave it empty to fight all bonus characters (the "order" parameter is still respected).

bonusmarathon.maxmatches = 6,1,1,0,0,0,0,0,0,0

]]

--[[Example system.def parameters assignments:
;-------------------------------------------------------------------------------
[Title Info]
;You need to add itemname to the main system.def so menu items keep the expected order. Grouping rules:
;https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus

menu.itemname.bonusmarathon = "BONUS MARATHON" ;Ikemen Feature
menu.itemname.bonusmarathoncoop = "BONUS MARATHON CO-OP" ;Ikemen Feature
menu.itemname.server.netplaybonusmarathoncoop = "BONUS MARATHON CO-OP" ;Ikemen Feature

;-------------------------------------------------------------------------------
[Select Info]
title.bonusmarathon.text = "Bonus Marathon"
title.bonusmarathoncoop.text = "Bonus Marathon Cooperative"
title.netplaybonusmarathoncoop.text = "Online Bonus Marathon"

record.bonusmarathon.text = "- BEST RECORD: %n -\n%c: %p PTS"
record.bonusmarathoncoop.text = "- BEST RECORD: %n -\n%c: %p PTS"
record.netplaybonusmarathoncoop.text = "- BEST RECORD: %n -\n%c: %p PTS"

;-------------------------------------------------------------------------------
[Hiscore Info]
;Set per-gamemode ranking criteria: score|time|win. Used to sort hiscores for that mode.

ranking.bonusmarathon = "score"
ranking.bonusmarathoncoop = "score"
ranking.netplaybonusmarathoncoop = "score"

title.bonusmarathon.text = "Ranking Bonus Marathon"
title.bonusmarathoncoop.text = "Ranking Bonus Marathon Cooperative"
title.netplaybonusmarathoncoop.text = "Ranking Online Bonus Marathon"

;-------------------------------------------------------------------------------
[Win Screen]
;Set per-gamemode win/results screen variant to use for that mode.
;Use "Win Screen" (default) or a specific "<X> Results Screen" name.

results.bonusmarathon = "Bonus Marathon Results Screen"
results.bonusmarathoncoop = "Bonus Marathon Cooperative Results Screen"
results.netplaybonusmarathoncoop = "Online Bonus Marathon Results Screen"

;-------------------------------------------------------------------------------
[Bonus Marathon Results Screen]
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
winstext.text = Total Score: %i
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

[BonusMarathonResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Bonus Marathon Cooperative Results Screen]
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
winstext.text = Total Score: %i
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

[BonusMarathonCooperativeResultsBGdef]
;left blank (character and stage not covered)

;-------------------------------------------------------------------------------
[Online Bonus Marathon Results Screen]
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
winstext.text = Total Score: %i
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

[OnlineBonusMarathonResultsBGdef]
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
	main.rankingCondition = true --if winning (clearing) whole mode is needed for rankings to be saved
	--main.resetScore = true --if loosing should set score for the next match to lose count
	--main.roundTime = 99
	
	--main.motif.versusscreen = true
	--main.motif.versusmatchno = true
	--main.motif.dialogue = true
	--main.motif.losescreen = true
	main.motif.winscreen = true
	--main.motif.victoryscreen = true
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

main.t_itemname.bonusmarathon = function()
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
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.bonusmarathon)
	setGameMode('bonusmarathon')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.bonusmarathoncoop = function()
	main.coop = true
	main.numSimul = {2, math.min(4, gameOption('Config.Players'))}
	main.numTag = {2, math.min(4, gameOption('Config.Players'))}
	f_commonCfg()
	
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	
	main.teamMenu[2].single = true
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.bonusmarathoncoop)
	setGameMode('bonusmarathoncoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.netplaybonusmarathoncoop = function()
	main.coop = true
	main.numSimul = {2, 2}
	main.numTag = {2, 2}
	f_commonCfg()
	
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	
	main.teamMenu[2].single = true
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.netplaybonusmarathoncoop)
	setGameMode('netplaybonusmarathoncoop')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_itemname.bonus = function(t, item)
	remapInput(1, getLastInputController())
	remapInput(getLastInputController(), 1)
	
	main.charparam.ai = true
	main.charparam.music = true
	main.charparam.rounds = true
	main.charparam.single = true
	main.charparam.stage = true
	main.charparam.time = true
	
	main.forceChar[2] = {main.t_bonusChars[item]}
	main.selectMenu[2] = true
	main.lifebar.p1score = true
	
	main.teamMenu[1].single = true
	main.teamMenu[1].simul = true
	main.teamMenu[1].tag = true
	main.teamMenu[1].turns = true
	main.teamMenu[1].ratio = true
	
	main.teamMenu[2].single = true
	
	main.motif.challenger = true
	main.f_setCredits()
	
	textImgSetText(motif.select_info.title.TextSpriteData, motif.select_info.title.text.bonus)
	setGameMode('bonus')
	hook.run("main.t_itemname")
	return start.f_selectMode
end

main.t_bonusmarathonChars = {}
for _, v in ipairs(main.t_selChars) do
	if v.bonus ~= nil and v.bonus == 1 then
		local order = math.max(1, v.order)
		if main.t_bonusmarathonChars[order] == nil then
			main.t_bonusmarathonChars[order] = {}
		end
		table.insert(main.t_bonusmarathonChars[order], v.char_ref)
	end
end

if main.t_selOptions.bonusmarathonmaxmatches == nil or #main.t_selOptions.bonusmarathonmaxmatches == 0 then
	local size = 1
	for k, _ in pairs(main.t_bonusmarathonChars) do
		if k > size then size = k end
	end
	main.t_selOptions.bonusmarathonmaxmatches = {}
	for i = 1, size do
		table.insert(main.t_selOptions.bonusmarathonmaxmatches, 0)
	end	
	for k, v in pairs(main.t_bonusmarathonChars) do
		main.t_selOptions.bonusmarathonmaxmatches[k] = #v
	end
end

--;===========================================================
--; start.lua
--;===========================================================
--[[
start.t_makeRoster is a table storing functions returning table data used
by start.f_makeRoster function, depending on game mode.
]]

start.t_makeRoster.bonusmarathon = function()
	return start.f_unifySettings(main.t_selOptions.bonusmarathonmaxmatches, main.t_bonusmarathonChars), main.t_bonusmarathonChars
end
start.t_makeRoster.bonusmarathoncoop = start.t_makeRoster.bonusmarathon
start.t_makeRoster.netplaybonusmarathoncoop = start.t_makeRoster.bonusmarathon

if gameOption('Debug.DumpLuaTables') then main.f_printTable(main.t_bonusmarathonChars, "debug/t_bonusmarathonChars.txt") end