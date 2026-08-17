--[[	   				         BONUS MARATHON MODULE
==================================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0-rc.3)
Description: Based on Boss Rush Module.
Bonus Marathon Mode is about defeat all opponents that are consider bonuses.

(Includes Co-Op and Netplay Variant)

This mode is detectable by GameMode trigger as: bonusmarathon, bonusmarathoncoop and netplaybonusmarathoncoop.
Only characters with select.def "bonus = 1" parameter assigned are valid for this mode.
==================================================================================================
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
	
	--main.motif.vsscreen = true
	--main.motif.vsmatchno = true
	--main.motif.dialogue = true
	--main.motif.losescreen = true
	main.motif.winscreen = true
	--main.motif.victoryscreen = true
	--main.motif.continuescreen = true
	main.motif.hiscore = true
	
	--main.fightscreen.mode = true
	--main.fightscreen.match = true
	--main.fightscreen.timer = true
	main.fightscreen.p1score = true
	--main.fightscreen.p1wincount = true
	--main.fightscreen.p2aiLevel = true
	
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
	main.fightscreen.p1score = true
	
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
	if v.bonus == 1 and (v.order or 0) > 0 then
		local order = v.order
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