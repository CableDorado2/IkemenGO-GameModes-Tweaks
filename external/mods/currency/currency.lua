--[[					 		   CURRENCY MODULE
===========================================================================================
Version: 1.0.1
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0)
Description: Adds In-Game Currency System (Player Currency will increase after win a match).
===========================================================================================
]]
local currencyMotifPath = "external/mods/currency/rewardScreen.def" --Set the Motif/Screenpack Definition File Path
local currencySavePath = "save/currencyDat.json" --Set the Currency Save Data File Path
--===================================================================================
--								 COMMON FUNCTIONS
--===================================================================================
--calculate menu.tween and boxcursor.tween (copy from external/script/main.lua)
local function f_tweenStep(val, target, factor)
	if not factor or factor <= 0 then
		return target
	end
	local newVal = val + (target - val) * math.min(factor, 1)
	if math.abs(newVal - target) < 1 then
		return target
	end
	return newVal
end

--function for navigating into subtables
local function f_readSubtable(tDat, subt)
	if not subt or subt == "" then return tDat end
	local t = tDat
	for part in subt:gmatch("[^%.]+") do
		t = t and t[part]
		if not t then return nil end
	end
	return t
end

--Set thousand format to a number value
local function f_setThousandsFormat(num)
	local txt = tostring(num)
	txt = txt:reverse():gsub("(...)", "%1."):reverse()
	if txt:sub(1, 1) == "." then
		txt = txt:sub(2)
	end
	return txt
end

--shortcut for updating text
local function f_updateTextImg(t, sect, textData)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	textImgSetFont(textData, motifCurrency.fontData[section.font[1]] or -1)
	textImgSetBank(textData, section.font[2] or 0)
	textImgSetAlign(textData, section.font[3] or 0)
	textImgSetColor(textData, section.font[4] or 255, section.font[5] or 255, section.font[6] or 255, section.font[7] or 255)
	if section.localcoord ~= nil then --Need to be ALWAYS BEFORE textImgSetPos() to draw the text
		textImgSetLocalcoord(textData, section.localcoord[1], section.localcoord[2])
	else
		textImgSetLocalcoord(textData, motifCurrency.info.localcoord[1], motifCurrency.info.localcoord[2])
	end
	if section.offset ~= nil then textImgSetPos(textData, section.offset[1] or 0, section.offset[2] or 0) end
	if section.scale ~= nil then textImgSetScale(textData, section.scale[1] or 1.0, section.scale[2] or 1.0) end
	textImgSetXShear(textData, section.xshear or 0)
	textImgSetAngle(textData, section.angle or 0)
	textImgSetXAngle(textData, section.xangle or 0)
	textImgSetYAngle(textData, section.yangle or 0)
	textImgSetProjection(textData, section.projection or "orthographic")
	textImgSetFocalLength(textData, section.focallength or 2048)
	textImgSetText(textData, section.text or "")
	textImgSetLayerno(textData, section.layerno or 0)
	if section.window ~= nil then
		textImgSetWindow(textData, section.window[1], section.window[2], section.window[3], section.window[4])
	else
		textImgSetWindow(textData, 0, 0, motifCurrency.info.localcoord[1], motifCurrency.info.localcoord[2])
	end
	--textImgSetTextDelay(textData, section.delay or 0)
	--if section.spacing ~= nil then textImgSetTextSpacing(textData, section.spacing[1] or 0, section.spacing[2] or 0) end
	--if section.textwrap ~= nil then textImgSetTextWrap(textData, true) end
	return textData
end

--shortcut for creating new text
local function f_createTextImg(t, sect)
	local textData = textImgNew()
	f_updateTextImg(t, sect, textData)
	return textData
end

--[[Wrap a long string. Source: http://lua-users.org/wiki/StringRecipes
str: string to wrap
limit: maximum line length
indent: regular indentation
indent1: indentation of first line
]]
local function f_wrap(str, limit, indent, indent1)
	indent = indent or ''
	indent1 = indent1 or indent
	limit = limit or 72
	local here = 1 - #indent1
	return indent1 .. str:gsub("(%s+)()(%S+)()",
	function(sp, st, word, fi)
		if fi - here > limit then
			here = st - #indent
			return '\n' .. indent .. word
		end
	end)
end

--[[Draw string letter by letter + wrap lines:
textData: text data
str: string (text to draw)
counter: external counter (values should be increased each frame by 1 starting from 1)
x: first line X position
y: first line Y position
scaleX: scale X axis
scaleY: scale Y axis
spacing: spacing between lines (rendering Y position increasement for each line)
delay (optional): ticks (frames) delay between each letter is rendered, defaults to 0 (all text rendered immediately)
limit (optional): maximum line length (string wraps when reached), if omitted line wraps only if string contains '\n'
maxLimit (optional): maximum number of lines allowed before truncating
]]
local function f_textRender(textData, str, counter, x, y, scaleX, scaleY, spacing, delay, limit, maxlimit)
	local delay = delay or 0
	local limit = limit or -1
	local maxLimit = maxlimit or 0 --0= No Max Limits
	str = tostring(str)
--Process line breaks and wrapping if necessary
	if limit == -1 then
		str = str:gsub('\\n', '\n')
	else
		str = str:gsub('%s*\\n%s*', ' ')
		if math.floor(#str / limit) + 1 > 1 then
			str = f_wrap(str, limit, indent, indent1)
		end
	end
--Determine how much text to display
	local subEnd = math.floor(#str - (#str - counter / delay))
	local t = {}
	for line in str:gmatch('([^\r\n]*)[\r\n]?') do
		t[#t + 1] = line
	end
	t[#t] = nil --get rid of the last blank line
--If maxLimit > 0 and we have exceeded that limit, replace the last line with "..."
	if maxLimit > 0 and #t > maxLimit then
		for i=1, maxLimit - 1 do
		--draw the first lines normally
			local line = t[i]
			if subEnd < #str then
				local length = #line
				local totalLength = 0
				for j=1, i-1 do
					totalLength = totalLength + #t[j] + 1
				end
				if subEnd < totalLength + length then
					line = line:sub(1, subEnd - totalLength)
				end
			end
			textImgSetText(textData, line)
			textImgSetPos(textData, x, y + spacing * (i - 1))
			textImgSetScale(textData, scaleX, scaleY)
			textImgDraw(textData)
		end
	--replace the last allowed line with "..."
		textImgSetText(textData, "...")
		textImgSetPos(textData, x, y + spacing * (maxLimit - 1))
		textImgSetScale(textData, scaleX, scaleY)
		textImgDraw(textData)
		--return lengthCnt
	else
		local lengthCnt = 0
		for i=1, #t do
			if subEnd < #str then
				local length = #t[i]
				if i > 1 and i <= #t then
					length = length + 1
				end
				lengthCnt = lengthCnt + length
				if subEnd < lengthCnt then
					t[i] = t[i]:sub(0, subEnd - lengthCnt)
				end
			end
			textImgSetText(textData, t[i])
			textImgSetPos(textData, x, y + spacing * (i - 1))
			textImgSetScale(textData, scaleX, scaleY)
			textImgDraw(textData)
		end
		return lengthCnt
	end
end

--shortcut for updating animation/sprite
local function f_updateAnim(section, animData)
	animSetLocalcoord(animData, motifCurrency.info.localcoord[1], motifCurrency.info.localcoord[2]) --Need to be ALWAYS BEFORE animSetPos() to draw the animation/sprite
	if section.scale ~= nil then animSetScale(animData, section.scale[1] or 1.0, section.scale[2] or 1.0) end
	animSetFacing(animData, section.facing or 0)
	animSetAngle(animData, section.angle or 0)
	animSetXAngle(animData, section.xangle or 0)
	animSetYAngle(animData, section.yangle or 0)
	animSetFocalLength(animData, section.focallength or 2048)
	animSetProjection(animData, section.projection or "orthographic")
	animSetLayerno(animData, section.layerno or 0)
	if section.window then
		animSetWindow(animData, section.window[1], section.window[2], section.window[3], section.window[4])
	else
		animSetWindow(animData, 0, 0, motifCurrency.info.localcoord[1], motifCurrency.info.localcoord[2])
	end
	return animData
end

--shortcut for creating new animation/sprite
local function f_createAnim(t, sect, moduleSff, moduleActions)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	local sffDat = nil
	local airDat = nil
	local actionData = "-1,0, 0,0, -1" --create dummy data
--Use [Files] "spr = " data from system.def
	if not moduleSff then
		sffDat = motif.Sff
--Use "spr" data from module currencyMotifPath, instead system.def file
	else
		sffDat = motifCurrency.sprData
	end
--Use Animations/Actions data from system.def file
	if (moduleActions and motifCurrency.airData == nil) or not moduleActions then
		airDat = motif.AnimTable
--Use "air" data from module currencyMotifPath, instead system.def file
	else
		airDat = motifCurrency.airData
	end
--Load Animation Data logic by jay_ts & m14
	if section.anim then
		local actionNo = tonumber(section.anim)
		if actionNo then
			if airDat[actionNo] then
				actionNo = airDat[actionNo]
				actionData = actionNo or actionData
			end
		end
--Load Sprite Data logic by jay_ts & m14
	elseif section.spr then
		local group, item = section.spr[1], section.spr[2]
		group = group or -1
		item = item or 0
		actionData = string.format("%s,%s, 0,0, -1", group, item)
	end
--Create Data
	local animData = animNew(sffDat, actionData)
	f_updateAnim(section, animData)
	return animData
end
--===================================================================================
--								CURRENCY DATA GENERATION
--===================================================================================
currency = {} --To access from other modules

motifCurrency = loadIni(currencyMotifPath) --Load Motif/Screenpack Data
if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifCurrency, "debug/currencyMenuMotif.txt") end

local file = io.open(currencySavePath, "r") --Check that file exists
if not file then
	file = io.open(currencySavePath, "w") --Create file
	file:write("{}")
	file:close() --Close file in writting mode
else
	file:close() --Close file in reading mode
end
--Data loading from currencySavePath
currencyDat = jsonDecode(currencySavePath)

--Data saving to currencySavePath
local function f_saveCurrency()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(currencyDat, 'debug/t_currencyDat.txt') end --Print Debug Info
	jsonEncode(currencyDat, currencySavePath) --Write in currencySavePath file
end

if currencyDat.money == nil then currencyDat.money = 0 end --Create space to save money
currencyDat.moneyOLD = currencyDat.money --Save player currency backup to do calculations
f_saveCurrency()

--Returns the amount of money that player has
function currency.getMoney()
	return currencyDat.money
end

--Set a new player money amount
function currency.setMoney(val)
	if val ~= nil then
		if currencyDat.moneyOLD == -1 then currencyDat.moneyOLD = currencyDat.money end
		currencyDat.money = currencyDat.money + val
		f_saveCurrency()
	end
end

local function f_loadCurrency() --Load def file which contains currency items data
--Set Default Data
	local currencyItemsDef = nil
	motifCurrency.sprData = sffNew() --Create blank sprite data
	motifCurrency.sndData = motif.Snd --Use default system.def sound data
--If events files section is detected, replace Default Data with Custom Data
	if motifCurrency.files ~= nil then
	--Load .def file with Currency Items
		if motifCurrency.files.def ~= nil and main.f_fileExists(motifCurrency.files.def) then
			currencyItemsDef = motifCurrency.files.def
		end
	--Load .sff file with Currency Preview Items
		if motifCurrency.files.sff ~= nil and main.f_fileExists(motifCurrency.files.sff) then
			motifCurrency.sprData = sffNew(motifCurrency.files.sff)
		end
	--Load .air file with Currency Menu Animations
		if motifCurrency.files.air ~= nil and main.f_fileExists(motifCurrency.files.air) then
			motifCurrency.airData = loadAnimTable(motifCurrency.files.air, motifCurrency.sprData)
		end
	--Load .snd file with Currency Menu Sounds
		if motifCurrency.files.snd ~= nil and main.f_fileExists(motifCurrency.files.snd) then
			motifCurrency.sndData = sndNew(motifCurrency.files.snd)
		end
	end
	motifCurrency.fontData = motif.Fnt --Use default system.def font data
--If currency fonts section is detected, replace Default Data with Custom Data
	if motifCurrency.fonts ~= nil then
		local i = 1
		while motifCurrency.fonts["font"..i] ~= nil do
			motifCurrency.fontData[i] = fontNew(motifCurrency.fonts["font"..i])
			i = i + 1
		end
	end
end
f_loadCurrency()
--===================================================================================
--								REWARD SCREEN ASSETS GENERATION
--===================================================================================
--[[Background data
Refer to official Elecbyte docs for information how to define backgrounds:
http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements

I.K.E.M.E.N. Features:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Background-features
]]
local sffBGDat = nil
if motifCurrency.rewardbgdef.spr ~= nil and main.f_fileExists(motifCurrency.rewardbgdef.spr) then
	sffBGDat = sffNew(motifCurrency.rewardbgdef.spr) --Load a dedicate sprite .sff file
else
	sffBGDat = motif.Sff --Load default system.sff data
end

local modelBGDat = nil
if motifCurrency.rewardbgdef.model ~= nil and main.f_fileExists(motifCurrency.rewardbgdef.model) then
	modelBGDat = modelNew(motifCurrency.rewardbgdef.model) --Load a dedicate 3D Model object
end

motifCurrency.rewardbgdef.BGDef = bgNew(sffBGDat, currencyMotifPath, 'rewardbg', modelBGDat)

--Fade Data
if motifCurrency.reward_info.fadein.anim ~= -1 then
	motifCurrency.reward_info.fadein.AnimData = f_createAnim(motifCurrency.reward_info, 'fadein', false, false)
end
motifCurrency.reward_info.fadein.FadeData = fadeNew(motifCurrency.reward_info.fadein)

if motifCurrency.reward_info.fadeout.anim ~= -1 then
	motifCurrency.reward_info.fadeout.AnimData = f_createAnim(motifCurrency.reward_info, 'fadeout', false, false)
end
motifCurrency.reward_info.fadeout.FadeData = fadeNew(motifCurrency.reward_info.fadeout)

--Text Data
local txt_currency = f_createTextImg(motifCurrency.currency_info, 'currency')
local txt_reward = f_createTextImg(motifCurrency.reward_info, 'reward')
local txt_rewardAccept = f_createTextImg(motifCurrency.reward_info, 'accept')

--Draw Current Currency Text
function currency.display()
	textImgSetText(txt_currency, currency.getMoney()..motifCurrency.currency_info.currency.suffix)
	textImgSetPos(
		txt_currency,
		motifCurrency.currency_info.currency.offset[1],
		motifCurrency.currency_info.currency.offset[2]
	)
	textImgDraw(txt_currency)
end
if gameOption('Debug.DumpLuaTables') then main.f_printTable(currency, 'debug/t_currency.txt') end --Print Debug Info
--;===========================================================================================
--; 							    REWARD SCREEN
--;===========================================================================================
local function f_setReward()
	if getWinnerTeam() == 0 or getWinnerTeam() == 1 then
		local reward = motifCurrency.reward_info.victory.reward
		if firstAttack() then reward = reward + motifCurrency.reward_info.firstattack.reward end
		if winSpecial() then reward = reward + motifCurrency.reward_info.specialko.reward end
		if winHyper() then reward = reward + motifCurrency.reward_info.superko.reward end
		if winPerfect() then reward = reward + motifCurrency.reward_info.perfectko.reward end
		if matchNo() > 1 then reward = reward * matchNo() end
		if getConsecutiveWins(1) then reward = reward * getConsecutiveWins(1) end
		currency.setMoney(reward)
	end
end

local function f_rewardScreen()
	if netPlay() or (currency.getMoney() == currencyDat.moneyOLD or currencyDat.moneyOLD == -1) then return end --Skip this screen
	local rewardTextData = (currency.getMoney() - currencyDat.moneyOLD)..motifCurrency.currency_info.currency.suffix..' '..motifCurrency.reward_info.reward.text
	local rewardClaimed = false
	currencyDat.moneyOLD = -1 --Reset Var
	f_saveCurrency()
	bgReset(motifCurrency.rewardbgdef.BGDef)
	fadeInInit(motifCurrency.reward_info.fadein.FadeData)
	sndPlay(motifCurrency.sndData, motifCurrency.reward_info.reward.snd[1], motifCurrency.reward_info.reward.snd[2]) --Play Reward SFX
	playBgm({
		bgm = motifCurrency.music.menu.bgm,
		loop = tonumber(motifCurrency.music.menu.loop),
		volume = tonumber(motifCurrency.music.menu.volume),
		loopstart = tonumber(motifCurrency.music.menu.loopstart),
		loopend = tonumber(motifCurrency.music.menu.loopend),
		startposition = tonumber(motifCurrency.music.menu.startposition),
		freqmul = tonumber(motifCurrency.music.menu.freqmul),
		loopcount = tonumber(motifCurrency.music.menu.loopcount),
		interrupt = true
	})
	while true do
		clearColor(motifCurrency.rewardbgdef.bgclearcolor[1], motifCurrency.rewardbgdef.bgclearcolor[2], motifCurrency.rewardbgdef.bgclearcolor[3])
	--Layerno = 0 backgrounds
		bgDraw(motifCurrency.rewardbgdef.BGDef, 0)
	--Draw Reward Text
		textImgSetText(txt_reward, rewardTextData)
		textImgSetPos(
			txt_reward,
			motifCurrency.reward_info.menu.pos[1] + motifCurrency.reward_info.reward.offset[1],
			motifCurrency.reward_info.menu.pos[2] + motifCurrency.reward_info.reward.offset[2]
		)
		textImgDraw(txt_reward)
	--Draw Accept Text
		textImgSetPos(
			txt_rewardAccept,
			motifCurrency.reward_info.menu.pos[1] + motifCurrency.reward_info.accept.offset[1],
			motifCurrency.reward_info.menu.pos[2] + motifCurrency.reward_info.accept.offset[2]
		)
		textImgDraw(txt_rewardAccept)
	--Attract Credits/Coins
		if motif.attract_mode.enabled and getCredits() ~= -1 then
			textImgReset(motif.attract_mode.credits.TextSpriteData)
			textImgSetText(motif.attract_mode.credits.TextSpriteData, string.format(motif.attract_mode.credits.text, getCredits()))
			textImgDraw(motif.attract_mode.credits.TextSpriteData)
		end
	--Layerno = 1 backgrounds
		bgDraw(motifCurrency.rewardbgdef.BGDef, 1)
	--Close Menu
		if rewardClaimed and not fadeActive() then
			bgReset(motifCurrency.rewardbgdef.BGDef)
			fadeInInit(motifCurrency.reward_info.fadein.FadeData)
			main.f_unlock(true) --Check Menu Unlocks
			break
		elseif getInput(-1, motifCurrency.reward_info.menu.done.key) and not fadeActive() then
			sndPlay(motifCurrency.sndData, motifCurrency.reward_info.accept.snd[1], motifCurrency.reward_info.accept.snd[2])
			fadeOutInit(motifCurrency.reward_info.fadeout.FadeData)
			rewardClaimed = true
		end
		refresh()
	end
end

--;===========================================================
--; MODES LOOP (copied from external/script/start.lua)
--;===========================================================
function start.f_selectMode()
	start.f_selectReset(true)
	while true do
		--select screen
		if gameOption('Config.BootLoadingMode') == 1 then
			main.f_waitForPreloads()
		end
		if not start.f_selectScreen() then
--;---------------------------------------------------------------------------------------------------------------------
			f_rewardScreen() --Display Currency Reward Screen before back to main menu
--;---------------------------------------------------------------------------------------------------------------------
			bgReset(motif[main.background].BGDef)
			fadeInInit(motif[main.group].fadein.FadeData)
			if not eventModeActive then
				playBgm({source = "motif.title", interrupt = true})
			else
				eventCharSelectBack = true
			end
			return
		end
		-- lua file with custom arcade path detection
		local path = main.luaPath
		if main.charparam.arcadepath then
			if start.f_getCharData(start.p[1].t_selected[1].ref).arcadepath ~= '' then
				path = start.f_getCharData(start.p[1].t_selected[1].ref).arcadepath
			end
			path = hook.runFirst("start.f_selectMode.luaPath", path) or path
			if path ~= '' and path ~= main.defaultLuaPath then
				if not main.f_fileExists(path) then
					local label = "arcadepath"
					if path ~= main.luaPath then
						label = start.f_getCharData(start.p[1].t_selected[1].ref).name .. " arcadepath"
					end
					panicError("\n" .. label .. " doesn't exist: " .. path .. "\n")
				end
			end
		end
		local customArcadePath = main.charparam.arcadepath and path ~= main.defaultLuaPath
		--first match
		if start.reset then
			-- Save current remap state. main.f_restoreInput() should restore to this.
			main.f_saveBaseRemapInput()
			if customArcadePath then
				main.t_availableChars = main.f_tableCopy(main.t_orderChars.default)
			else
				main.t_availableChars = main.f_tableCopy(start.f_getOrderChars())
			end
			--generate default roster
			if main.makeRoster and not customArcadePath then
				start.t_roster = start.f_makeRoster()
			else
				start.t_roster = {}
			end
			--generate AI ramping table
			if main.aiRamp then
				start.f_aiRamp(1)
			end
			start.reset = false
		end
		--external script execution
		local oldCustomArcadePath = start.customArcadePath
		start.customArcadePath = customArcadePath
		assert(loadFile(path))()
		start.customArcadePath = oldCustomArcadePath
		--infinite matches flag detected
		if main.makeRoster and start.t_roster[matchNo()] ~= nil and start.t_roster[matchNo()][1] == -1 then
			table.remove(start.t_roster, matchNo())
			start.t_roster = start.f_makeRoster(start.t_roster)
			if main.aiRamp then
				start.f_aiRamp(matchNo())
			end
		--otherwise
		else
			if matchNo() == -1 then --no more matches left
				-- hiscore & stats handled in Go; returns (cleared, place)
				local cleared, place = computeRanking(gameMode())
				if main.motif.hiscore and place > 0 then
					main.f_hiscore(gameMode(), place)
				end
				--credits
				if cleared and main.storyboard.credits and motif.end_credits.enabled and main.f_fileExists(motif.end_credits.storyboard) then
					main.f_storyboard(motif.end_credits.storyboard)
				end
				--game over
				if main.storyboard.gameover and motif.game_over_screen.enabled and main.f_fileExists(motif.game_over_screen.storyboard) then
					if cleared or not main.motif.continuescreen or (not continued() and motif.continue_screen.gameover.enabled) then
						main.f_storyboard(motif.game_over_screen.storyboard)
					end
				end
--;---------------------------------------------------------------------------------------------------------------------
			--EVENTS MODE RESULTS
				if eventModeActive then f_eventResults() end
				f_setReward() --Reward Evaluation
--;---------------------------------------------------------------------------------------------------------------------
				--exit to main menu
				if main.exitSelect then
					if motif.files.intro.storyboard ~= '' and not motif.attract_mode.enabled then
						main.f_storyboard(motif.files.intro.storyboard)
					end
				end
				start.exit = start.exit or main.exitSelect or not main.selectMenu[1]
			end
			if start.exit then
--;---------------------------------------------------------------------------------------------------------------------
				f_rewardScreen() --Display Currency Reward Screen before back to main menu
--;---------------------------------------------------------------------------------------------------------------------
				bgReset(motif[main.background].BGDef)
				fadeInInit(motif[main.group].fadein.FadeData)
				playBgm({source = "motif.title", interrupt = true})
				start.exit = false
				return
			end
			if not continued() or esc() then
				start.f_selectReset(false)
			else
				t_reservedChars = {{}, {}}
			end
		end
	end
end