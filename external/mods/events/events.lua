--[[	   				  EVENTS MODULE
======================================================================
Version: 1.5.0
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (Nightly Build - 2026.04.17)
Description: Adds a Custom Game Mode entry (Events) to the Main Menu.

TODO:
- Add "background params" for menu.
- Custom Fonts support in [Files] .def module section.
======================================================================
]]
local eventMotifPath = "external/mods/events/eventsMenu.def" --Set the Motif/Screenpack Definition File Path
local eventSavePath = "save/eventsDat.json" --Set the Events Save Data File Path
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

--Set Time format to a tick value
local function f_setTimeFormat(ticks)
	local gameTick = 60 --1 Second = 60 ticks
	local num = tonumber(ticks) / gameTick
	local secondsTotal = math.floor(num) --Entire part of the seconds
	local tm = math.floor(secondsTotal / 60) % 1000 --Minute
	local ts = secondsTotal % 60 --Second
	local tms = math.floor((num - secondsTotal) * 100 + 0.5) % 1000 --Millisecond
	return string.format("%02d:%02d.%02d", tm, ts, tms)
end

--shortcut for updating text
local function f_updateTextImg(t, sect, textData)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	textImgSetFont(textData, motif.Fnt[section.font[1]] or -1)
	textImgSetBank(textData, section.font[2] or 0)
	textImgSetAlign(textData, section.font[3] or 0)
	textImgSetColor(textData, section.font[4] or 255, section.font[5] or 255, section.font[6] or 255, section.font[7] or 255)
	if section.localcoord ~= nil then --Need to be ALWAYS BEFORE textImgSetPos() to draw the text
		textImgSetLocalcoord(textData, section.localcoord[1], section.localcoord[2])
	else
		textImgSetLocalcoord(textData, motifEvent.info.localcoord[1], motifEvent.info.localcoord[2])
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
		textImgSetWindow(textData, 0, 0, motifEvent.info.localcoord[1], motifEvent.info.localcoord[2])
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
	animSetLocalcoord(animData, motifEvent.info.localcoord[1], motifEvent.info.localcoord[2]) --Need to be ALWAYS BEFORE animSetPos() to draw the animation/sprite
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
		animSetWindow(animData, 0, 0, motifEvent.info.localcoord[1], motifEvent.info.localcoord[2])
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
--Use "events.spr" data from module eventMotifPath, instead system.def file
	else
		sffDat = motifEvent.sprData
	end
--Use Animations/Actions data from system.def file
	if (moduleActions and motifEvent.airData == nil) or not moduleActions then
		airDat = motif.AnimTable
--Use "events.air" data from module eventMotifPath, instead system.def file
	else
		airDat = motifEvent.airData
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

--shortcut for updating rectangle
local function f_updateRect(t, sect, rectData)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	if section.localcoord ~= nil then
		rectSetLocalcoord(rectData, section.localcoord[1], section.localcoord[2])
	else
		rectSetLocalcoord(rectData, motifEvent.info.localcoord[1], motifEvent.info.localcoord[2])
	end
	rectSetColor(rectData, section.col[1] or 0, section.col[2] or 0, section.col[3] or 0)
	if section.alpha ~= nil then
		rectSetAlpha(rectData, section.alpha[1] or 0, section.alpha[2] or 128)
	end
	if section.pulse ~= nil then
		rectSetAlphaPulse(rectData, section.pulse[1] or 30, section.pulse[2] or 20, section.pulse[3] or 30)
	end
	if section.coords ~= nil then
		rectSetWindow(rectData, section.coords[1], section.coords[2], section.coords[3], section.coords[4])
	end
	rectSetLayerno(rectData, section.layerno or 0)
	return rectData
end

--shortcut for creating new rectangle
local function f_createRect(t, sect)
	local rectData = rectNew()
	f_updateRect(t, sect, rectData)
	return rectData
end
--===================================================================================
--								EVENTS DATA GENERATION
--===================================================================================
motifEvent = loadIni(eventMotifPath) --Load Motif/Screenpack Data
if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifEvent, "debug/eventsMenuMotif.txt") end

local file = io.open(eventSavePath, "r") --Check that file exists
if not file then
	file = io.open(eventSavePath, "w") --Create file
	file:write("{}")
	file:close() --Close file in writting mode
else
	file:close() --Close file in reading mode
end
--Data loading from eventSavePath
eventsDat = jsonDecode(eventSavePath)

--Data saving to eventSavePath
local function f_saveEventData()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(eventsDat, 'debug/t_eventsDat.txt') end --Print Debug Info
	jsonEncode(eventsDat, eventSavePath) --Write in eventSavePath file
end

local function f_eventResults()
	local t_stats = start.f_accStats()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(t_stats, "debug/t_EventResults.txt") end
--Save Event Data only if player complete event
	if getWinnerTeam() == 1 then
	--Update Hiscore only if is greater than the previous one
		if t_stats.score.total[1] > eventsDat[gameMode()].score then
			eventsDat[gameMode()].score = t_stats.score.total[1]
		end
	--Update Best Record Time only if is minor than the previous one
		if t_stats.time.total < eventsDat[gameMode()].recordtime then
			eventsDat[gameMode()].recordtime = t_stats.time.total
		end
	--Update Consecutive Wins Hiscore only if is greater than the previous one
		if getConsecutiveWins(1) > eventsDat[gameMode()].wins then
			eventsDat[gameMode()].wins = getConsecutiveWins(1)
		end
	end
	eventsDat[gameMode()].playtime = eventsDat[gameMode()].playtime + t_stats.time.total
	f_saveEventData()
end

--Refresh t_unlockLua table
local function f_refreshUnlockDat()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
end

local t_selEventMode = {}
local function f_loadEvents()
	t_selEventMode = {}
--Set Default Data
	local eventsDef = motif.files.select
	motifEvent.sprData = sffNew()
--If events files section is detected, replace Default Data with Custom Data
	if motifEvent.files ~= nil then
	--Load .def file with Events Items
		if motifEvent.files.def ~= nil and main.f_fileExists(motifEvent.files.def) then
			eventsDef = motifEvent.files.def
		end
	--Load .sff file with Events Preview Items
		if motifEvent.files.sff ~= nil and main.f_fileExists(motifEvent.files.sff) then
			motifEvent.sprData = sffNew(motifEvent.files.sff)
		end
	--Load .air file with Events Menu Animations
		if motifEvent.files.air ~= nil and main.f_fileExists(motifEvent.files.air) then
			motifEvent.airData = loadAnimTable(motifEvent.files.air, motifEvent.sprData)
		end
	end
	local section = 0
	local row = 0
	local content = main.f_fileRead(eventsDef)
	content = content:gsub('([^\r\n;]*)%s*;[^\r\n]*', '%1')
	content = content:gsub('\n%s*\n', '\n')
	for line in content:gmatch('[^\r\n]+') do
		local lineCase = line:lower()
		if lineCase:match('^%s*%[%s*eventsmode%s*%]') then
			row = 0
			section = 1
		elseif lineCase:match('^%s*%[%w+%]$') then
			section = -1
		elseif section == 1 then --[EventsMode]
			local param, value = line:match('^%s*(.-)%s*=%s*(.-)%s*$')
			if param ~= nil and value ~= nil and param ~= '' and value ~= '' then
				if param:match('^id$') then --Generate Table to manage each event
					table.insert(t_selEventMode,
					--Default Values for each Event Added
						{
							id = value,
							spr = {},
							name = '',
							description = '',
							path = '',
							unlock = 'true',
						--character select vars
							characterselect = false,
							stageselect = false,
							vsscreen = false,
							orderselect = false,
							victoryscreen = true,
							continuescreen = true,
							quickcontinue = false,
							singlemode = false,
							simulmode = false,
							tagmode = false,
							turnsmode = false,
							ratiomode = false,
						--match lifebars vars
							lifebar = true,
							lifebarmatchno = false,
							lifebartimer = false,
							lifebarwincntp1 = false,
							lifebarwincntp2 = false,
							lifebarscorep1 = false,
							lifebarscorep2 = false,
							lifebarailevelp1 = false,
							lifebarailevelp2 = false
						}
					)
			--Update optional comma separated number values to table
				elseif param:match('^spr$') then
					local tbl = {}
					for num in value:gmatch('([^,]+)') do
						table.insert(tbl, tonumber(num))
					end
					t_selEventMode[#t_selEventMode][param] = tbl
			--Update optional paramvalues with custom ones
				else--if t_selEventMode[#t_selEventMode][param] ~= nil then
					t_selEventMode[#t_selEventMode][param] = value
				end
			end
		end
	end
	for i=1, #t_selEventMode do --Convert String stored to Boolean
		local settrue = "true"
		local setfalse = "false"
		if t_selEventMode[i].characterselect == settrue then t_selEventMode[i].characterselect = true end
		if t_selEventMode[i].stageselect == settrue then t_selEventMode[i].stageselect = true end
		if t_selEventMode[i].vsscreen == settrue then t_selEventMode[i].vsscreen = true end
		if t_selEventMode[i].orderselect == settrue then t_selEventMode[i].orderselect = true end
		if t_selEventMode[i].victoryscreen == setfalse then t_selEventMode[i].victoryscreen = false end
		if t_selEventMode[i].continuescreen == setfalse then t_selEventMode[i].continuescreen = false end
		if t_selEventMode[i].quickcontinue == settrue then t_selEventMode[i].quickcontinue = true end
		
		if t_selEventMode[i].singlemode == settrue then t_selEventMode[i].singlemode = true end
		if t_selEventMode[i].simulmode == settrue then t_selEventMode[i].simulmode = true end
		if t_selEventMode[i].tagmode == settrue then t_selEventMode[i].tagmode = true end
		if t_selEventMode[i].turnsmode == settrue then t_selEventMode[i].turnsmode = true end
		if t_selEventMode[i].ratiomode == settrue then t_selEventMode[i].ratiomode = true end
		
		if t_selEventMode[i].lifebar == setfalse then t_selEventMode[i].lifebar = false end
		if t_selEventMode[i].lifebarmatchno == settrue then t_selEventMode[i].lifebarmatchno = true end
		if t_selEventMode[i].lifebartimer == settrue then t_selEventMode[i].lifebartimer = true end
		if t_selEventMode[i].lifebarwincntp1 == settrue then t_selEventMode[i].lifebarwincntp1 = true end
		if t_selEventMode[i].lifebarwincntp2 == settrue then t_selEventMode[i].lifebarwincntp2 = true end
		if t_selEventMode[i].lifebarscorep1 == settrue then t_selEventMode[i].lifebarscorep1 = true end
		if t_selEventMode[i].lifebarscorep2 == settrue then t_selEventMode[i].lifebarscorep2 = true end
		if t_selEventMode[i].lifebarailevelp1 == settrue then t_selEventMode[i].lifebarailevelp1 = true end
		if t_selEventMode[i].lifebarailevelp2 == settrue then t_selEventMode[i].lifebarailevelp2 = true end
	end
	for k, v in ipairs(t_selEventMode) do
		main.t_unlockLua.modes[v.id] = v.unlock --Set Events Unlock Condition
	end
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(t_selEventMode, 'debug/t_selEventMode.txt') end
end
f_loadEvents() --Load events data (events.def & events.sff files) when engine starts
--===================================================================================
--								EVENTS ASSETS GENERATION
--===================================================================================
--[[Background data
Refer to official Elecbyte docs for information how to define backgrounds:
http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements

I.K.E.M.E.N. Features:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Background-features
]]
local sffBGDat = nil
if motifEvent.eventbgdef.spr ~= nil and main.f_fileExists(motifEvent.eventbgdef.spr) then
	sffBGDat = sffNew(motifEvent.eventbgdef.spr) --Load a dedicate sprite .sff file
else
	sffBGDat = motif.Sff --Load default system.sff data
end

local modelBGDat = nil
if motifEvent.eventbgdef.model ~= nil and main.f_fileExists(motifEvent.eventbgdef.model) then
	modelBGDat = modelNew(motifEvent.eventbgdef.model) --Load a dedicate 3D Model object
end

motifEvent.eventbgdef.BGDef = bgNew(sffBGDat, eventMotifPath, 'eventbg', modelBGDat)

--Rectangle Data
local rect_boxcursor = f_createRect(motifEvent.event_info, 'menu.boxcursor')
local rect_boxbg = f_createRect(motifEvent.event_info, 'menu.boxbg')
local t_menuWindowEvent = main.f_menuWindow(motifEvent.event_info.menu)

--Text Data
local txt_titleEvent = f_createTextImg(motifEvent.event_info, 'title')
local txt_hiscoreEvent = f_createTextImg(motifEvent.event_info, 'hiscore')
local txt_recordTimeEvent = f_createTextImg(motifEvent.event_info, 'recordtime')
local txt_infoEvent = f_createTextImg(motifEvent.event_info, 'info')

local infoTextCnt = 0
local infoTextActive = 1
local function f_resetEventInfoTxt()
	infoTextCnt = 0
	infoTextActive = 1
end

if motifEvent.event_info.menu.item then motifEvent.event_info.menu.item.TextSpriteData = f_createTextImg(motifEvent.event_info, 'menu.item') end
if motifEvent.event_info.menu.item.active then motifEvent.event_info.menu.item.active.TextSpriteData = f_createTextImg(motifEvent.event_info, 'menu.item.active') end
if motifEvent.event_info.menu.item.value then motifEvent.event_info.menu.item.value.TextSpriteData = f_createTextImg(motifEvent.event_info, 'menu.item.value') end
if motifEvent.event_info.menu.item.value.active then motifEvent.event_info.menu.item.value.active.TextSpriteData = f_createTextImg(motifEvent.event_info, 'menu.item.value.active') end

--Sprite Data
local spr_previewUnknow = f_createAnim(motifEvent.event_info, 'preview.unknown', true, true)
motifEvent.event_info.menu.arrow.up.AnimData = f_createAnim(motifEvent.event_info, 'menu.arrow.up', false, false)
motifEvent.event_info.menu.arrow.down.AnimData = f_createAnim(motifEvent.event_info, 'menu.arrow.down', false, false)

local function f_drawCustomPreview(group, index, x, y, scaleX, scaleY, x1, y1, x2, y2, angle, xangle, yangle, focallength, projection, layerno)
	local anim = group..','..index..', 0,0, -1' --local anim = group..','..index..','..x..','..y..','..'-1'
	anim = animNew(motifEvent.sprData, anim)
	animSetLocalcoord(anim, motifEvent.info.localcoord[1], motifEvent.info.localcoord[2])
	animSetPos(anim, x, y)
	animSetScale(anim, scaleX, scaleY)
	animSetWindow(anim, x1, y1, x2, y2)
	animSetAngle(anim, angle or 0)
	animSetXAngle(anim, xangle or 0)
	animSetYAngle(anim, yangle or 0)
	animSetFocalLength(anim, focallength or 2048)
	animSetProjection(anim, projection or "orthographic")
	animSetLayerno(anim, layerno or 0)
	animUpdate(anim)
	animDraw(anim)
end

local function f_playEventBGM()
	playBgm({
		bgm = motifEvent.music.menu.bgm,
		loop = tonumber(motifEvent.music.menu.loop),
		volume = tonumber(motifEvent.music.menu.volume),
		loopstart = tonumber(motifEvent.music.menu.loopstart),
		loopend = tonumber(motifEvent.music.menu.loopend),
		startposition = tonumber(motifEvent.music.menu.startposition),
		freqmul = tonumber(motifEvent.music.menu.freqmul),
		loopcount = tonumber(motifEvent.music.menu.loopcount),
		interrupt = true
	})
end
if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifEvent, "debug/eventsMenuMotif.txt") end
--===================================================================================
--								 EVENTS MENU
--===================================================================================
eventModeActive = false
local function f_events()
	eventModeActive = true
	main.f_default()
	sndPlay(motif.Snd, motif[main.group].cursor.done.snd.default[1], motif[main.group].cursor.done.snd.default[2])
	local cursorPosY = 1
	local moveTxt = 0
	local item = 1
	local t = {}
	local currentCursor = item
	local unlockItem = false
	local cdText = ""
	local defaultRecord = 359999.4
	f_resetEventInfoTxt()
--[[
	local w = main.f_menuWindow(motifEvent.event_info.menu)
	for _, v in pairs(motifEvent.event_info.menu.item.bg) do
		animSetWindow(v.AnimData, w[1], w[2], w[3], w[4])
	end
	for _, v in pairs(motifEvent.event_info.menu.item.active.bg) do
		animSetWindow(v.AnimData, w[1], w[2], w[3], w[4])
	end
--]]
	if motifEvent.event_info.reload.enabled == 1 then f_loadEvents() end --Reload select.def events data each time that events menu is initialized
	for k, v in ipairs(t_selEventMode) do
		table.insert(t,
			{
				itemname = v.id,
				itemspr = v.spr,
				displayname = v.name,
				displaynameunlocked = v.name,
				vardisplay = "",
				info = v.description,
				path = v.path,
				unlock = v.unlock,
				
				charsel = v.characterselect,
				stgsel = v.stageselect,
				vsscreen = v.vsscreen,
				ordersel = v.orderselect,
				winscreen = v.victoryscreen,
				continue = v.continuescreen,
				quickcontinue = v.quickcontinue,
				
				single = v.singlemode,
				simul = v.simulmode,
				tag = v.tagmode,
				turns = v.turnsmode,
				ratio = v.ratiomode,
				
				lfbar = v.lifebar,
				lfbarmatchno = v.lifebarmatchno,
				lfbartimer = v.lifebartimer,
				lfbarwinp1 = v.lifebarwincntp1,
				lfbarwinp2 = v.lifebarwincntp2,
				lfbarscorep1 = v.lifebarscorep1,
				lfbarscorep2 = v.lifebarscorep2,
				lfbaraip1 = v.lifebarailevelp1,
				lfbaraip2 = v.lifebarailevelp2
			}
		)
	end
--No Event Data Found
	if #t_selEventMode == 0 then
		table.insert(t,
			{
				itemname = 'back',
				itemspr = {},
				displayname = motifEvent.event_info.menu.itemname.back,
				displaynameunlocked = motifEvent.event_info.menu.itemname.back,
				info = ""
			}
		)
--Event Data Found
	else
	--Create and Save Event Data (if does not exist)
		for i=1, #t do
			if eventsDat[t[i].itemname] == nil then
				eventsDat[t[i].itemname] = {playtime = 0, recordtime = defaultRecord, score = 0, wins = 0}
			end
		end
		f_saveEventData()
	--Check Events Unlocks
		main.f_unlock(false)
		f_refreshUnlockDat()
	end
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(t, 'debug/t_eventsMenu.txt') end
	bgReset(motifEvent.eventbgdef.BGDef)
	main.f_fadeReset('fadein', motifEvent.event_info)
	if motifEvent.music.menu.bgm ~= "" then f_playEventBGM() end --Play Event Menu BGM
	main.close = false
	while true do
		local selectedEvent = t[item].itemname
		local offx = 0
		local offy = 0
	--effective visible-items: treat 0 or 'unlimitedItems' as "all"
		local visible = (motifEvent.event_info.menu.window and motifEvent.event_info.menu.window.visibleitems) or #t
		if not visible or visible <= 0 then
			visible = #t
		end
		clearColor(motifEvent.eventbgdef.bgclearcolor[1], motifEvent.eventbgdef.bgclearcolor[2], motifEvent.eventbgdef.bgclearcolor[3])
	--draw layerno = 0 backgrounds
		bgDraw(motifEvent.eventbgdef.BGDef, 0)
	--draw menu box
		if motifEvent.event_info.menu.boxbg.visible == 1 then
			local x1 = offx + motifEvent.event_info.menu.pos[1] + motifEvent.event_info.menu.boxcursor.coords[1]
			local y1 = offy + motifEvent.event_info.menu.pos[2] + motifEvent.event_info.menu.boxcursor.coords[2]
			local w = motifEvent.event_info.menu.boxcursor.coords[3] - motifEvent.event_info.menu.boxcursor.coords[1] + 1
			local h = motifEvent.event_info.menu.boxcursor.coords[4] - motifEvent.event_info.menu.boxcursor.coords[2] + 1 + (math.min(#t, visible) - 1) * motifEvent.event_info.menu.item.spacing[2]
			rectSetColor(
				rect_boxbg,
				motifEvent.event_info.menu.boxbg.col[1],
				motifEvent.event_info.menu.boxbg.col[2],
				motifEvent.event_info.menu.boxbg.col[3]
			)
			rectSetAlpha(
				rect_boxbg,
				motifEvent.event_info.menu.boxbg.alpha[1],
				motifEvent.event_info.menu.boxbg.alpha[2]
			)
			rectSetWindow(rect_boxbg, x1, y1, x1 + w, y1 + h)
			rectUpdate(rect_boxbg)
			rectDraw(rect_boxbg)
		end
	--draw menu items
		local cur = moveTxt
		local tgt = moveTxt
		if motifEvent.event_info.menuTweenData then
			cur = motifEvent.event_info.menuTweenData.currentPos or motifEvent.event_info.menuTweenData.slideOffset or cur
			tgt = motifEvent.event_info.menuTweenData.targetPos or tgt
		end
		local tweenDone = math.abs((cur or 0) - (tgt or 0)) < 1
		local items_shown = item + visible - cursorPosY
		if items_shown > #t or (visible > 0 and items_shown < #t and (motifEvent.event_info.menu.window.margins.y[1] ~= 0 or motifEvent.event_info.menu.window.margins.y[2] ~= 0)) then
			items_shown = #t
		end
	--helper that draws a single item either as active or inactive
		local function drawItem(i, isActive)
			local itemData = t[i]
		--Condition to Show Unlocked Content
			if main.t_unlockLua.modes[selectedEvent] == nil then unlockItem = true else unlockItem = false end
			if main.t_unlockLua.modes[itemData.itemname] == nil then
				if itemData.displayname ~= "" then itemData.displayname = t[i].displaynameunlocked end
				if itemData.vardisplay ~= nil and eventsDat ~= nil and eventsDat[itemData.itemname] ~= nil and eventsDat[itemData.itemname].score ~= nil and eventsDat[itemData.itemname].score > 0 then
					itemData.vardisplay = motifEvent.event_info.menu.itemname.clear
				else
					itemData.vardisplay = ""
				end
			else
				if itemData.displayname ~= "" then itemData.displayname = motifEvent.event_info.menu.itemname.unknown end
				if itemData.vardisplay ~= nil then itemData.vardisplay = "" end
			end
		--display name
			local displayname = itemData.displayname
			if itemData.itemname:match("^spacer%d*$") then
				displayname = ""
			end
		--shared position
			local posX = offx + motifEvent.event_info.menu.pos[1] + (i - 1) * motifEvent.event_info.menu.item.spacing[1]
			local posY = offy + motifEvent.event_info.menu.pos[2] + (i - 1) * motifEvent.event_info.menu.item.spacing[2] - moveTxt
	--[[
		--background params
			local bgTable = isActive and motifEvent.event_info.menu.item.active.bg or motifEvent.event_info.menu.item.bg
			local params = bgTable[itemData.paramname] or bgTable.default
		--draw background
			local bgPosX = offx 
			local bgPosY = offy
			if bgTable.default.spacing[1] ~= 0 or bgTable.default.spacing[2] ~= 0 then
				bgPosX = bgPosX + (i - 1) * bgTable.default.spacing[1]
				bgPosY = bgPosY + (i - 1) * bgTable.default.spacing[2] - moveTxt
			end
			main.f_animPosDraw(params.AnimData, bgPosX, bgPosY)
	--]]
		--text sprite for label
			local labelSprite
			if itemData.selected then
				labelSprite = isActive and motifEvent.event_info.menu.item.selected.active.TextSpriteData or motifEvent.event_info.menu.item.selected.TextSpriteData
			else
				labelSprite = isActive and motifEvent.event_info.menu.item.active.TextSpriteData or motifEvent.event_info.menu.item.TextSpriteData
			end
			textImgReset(labelSprite)
			textImgAddPos(labelSprite, posX, posY)
			textImgSetText(labelSprite, displayname)
			textImgDraw(labelSprite)
		--value / info sprites
			if itemData.vardisplay ~= nil then
				if itemData.conflict and motifEvent.event_info.menu.item.value.conflict and motifEvent.event_info.menu.item.value.conflict.TextSpriteData then
					local spr = motifEvent.event_info.menu.item.value.conflict.TextSpriteData
					textImgReset(spr)
					textImgAddPos(spr, posX, posY)
					textImgSetText(spr, itemData.vardisplay)
					textImgDraw(spr)
				else
					local spr = isActive and motifEvent.event_info.menu.item.value.active.TextSpriteData or motifEvent.event_info.menu.item.value.TextSpriteData
					textImgReset(spr)
					textImgAddPos(spr, posX, posY)
					textImgSetText(spr, itemData.vardisplay)
					textImgDraw(spr)
				end
			elseif itemData.infodisplay ~= nil then
				local spr = isActive and motifEvent.event_info.menu.item.info.active.TextSpriteData or motifEvent.event_info.menu.item.info.TextSpriteData
				textImgReset(spr)
				textImgAddPos(spr, posX, posY)
				textImgSetText(spr, itemData.infodisplay)
				textImgDraw(spr)
			end
		end
	--draw not active items
		for i = 1, items_shown do
			if i > item - cursorPosY or not tweenDone then
				local isSelected = (i == item) --and (not forceInactive)
				if not isSelected then
					drawItem(i, false)
				end
			end
		end
	--draw active items
		for i = 1, items_shown do
			if i > item - cursorPosY or not tweenDone then
				local isSelected = (i == item) --and (not forceInactive)
				if isSelected then
					drawItem(i, true)
				end
			end
		end
	--initialize storage for boxcursor per section if missing
		if not motifEvent.event_info.boxCursorData then
			motifEvent.event_info.boxCursorData = {
				offsetY = 0, 
				snap = 0, 
				init = false
			}
		end
	--calculate target Y position for cursor
		local targetY = offy + motifEvent.event_info.menu.pos[2] + motifEvent.event_info.menu.boxcursor.coords[2] + (cursorPosY - 1) * motifEvent.event_info.menu.item.spacing[2]
		local t_factor = motifEvent.event_info.menu.boxcursor.tween.factor
	--snap cursor immediately if first use or snap enabled
		if motifEvent.event_info.boxCursorData.snap == 1 or not motifEvent.event_info.boxCursorData.init then
			motifEvent.event_info.boxCursorData.offsetY = targetY
			motifEvent.event_info.boxCursorData.init = true
			motifEvent.event_info.boxCursorData.snap = -1
		end
		if motifEvent.event_info.menu.boxcursor.tween.wrap.snap and main.menuWrapped then
			motifEvent.event_info.boxCursorData.offsetY = targetY
		end
	--apply tween if enabled, otherwise snap to target
		if t_factor[1] > 0 then
			motifEvent.event_info.boxCursorData.offsetY = f_tweenStep(motifEvent.event_info.boxCursorData.offsetY, targetY, t_factor[1])
		else
			motifEvent.event_info.boxCursorData.offsetY = targetY
		end
	--draw menu cursor
		if motifEvent.event_info.menu.boxcursor.visible == 1 and not main.fadeActive then
			local x1 = offx + motifEvent.event_info.menu.pos[1] + motifEvent.event_info.menu.boxcursor.coords[1] + (cursorPosY - 1) * motifEvent.event_info.menu.item.spacing[1]
			local y1 = motifEvent.event_info.boxCursorData.offsetY
			local w  = motifEvent.event_info.menu.boxcursor.coords[3] - motifEvent.event_info.menu.boxcursor.coords[1] + 1
			local h  = motifEvent.event_info.menu.boxcursor.coords[4] - motifEvent.event_info.menu.boxcursor.coords[2] + 1
			rectSetColor(
				rect_boxcursor,
				motifEvent.event_info.menu.boxcursor.col[1],
				motifEvent.event_info.menu.boxcursor.col[2],
				motifEvent.event_info.menu.boxcursor.col[3]
			)
			rectSetAlphaPulse(
				rect_boxcursor,
				motifEvent.event_info.menu.boxcursor.pulse[1],
				motifEvent.event_info.menu.boxcursor.pulse[2],
				motifEvent.event_info.menu.boxcursor.pulse[3]
			)
			rectSetWindow(rect_boxcursor, x1, y1, x1 + w, y1 + h)
			rectUpdate(rect_boxcursor)
			rectDraw(rect_boxcursor)
		end
	--draw scroll arrows
		if #t > visible then
			if item > cursorPosY then
				animReset(motifEvent.event_info.menu.arrow.up.AnimData, {'pos'})
				animSetPos(motifEvent.event_info.menu.arrow.up.AnimData, motifEvent.event_info.menu.arrow.up.offset[1], motifEvent.event_info.menu.arrow.up.offset[2])
				animUpdate(motifEvent.event_info.menu.arrow.up.AnimData)
				animDraw(motifEvent.event_info.menu.arrow.up.AnimData)
			end
			if item >= cursorPosY and item + visible - cursorPosY < #t then
				animReset(motifEvent.event_info.menu.arrow.down.AnimData, {'pos'})
				animSetPos(motifEvent.event_info.menu.arrow.down.AnimData, motifEvent.event_info.menu.arrow.down.offset[1], motifEvent.event_info.menu.arrow.down.offset[2])
				animUpdate(motifEvent.event_info.menu.arrow.down.AnimData)
				animDraw(motifEvent.event_info.menu.arrow.down.AnimData)
			end
		end
	--draw preview sprites
		if t[item].itemspr[1] == nil or t[item].itemspr[2] == nil or not unlockItem then
			main.f_animPosDraw(
				spr_previewUnknow,
				motifEvent.event_info.menu.pos[1] + motifEvent.event_info.preview.unknown.offset[1],
				motifEvent.event_info.menu.pos[2] + motifEvent.event_info.preview.unknown.offset[2],
				motifEvent.event_info.preview.unknown.facing
			)
		else
			f_drawCustomPreview(
				t[item].itemspr[1],
				t[item].itemspr[2],
				motifEvent.event_info.menu.pos[1] + motifEvent.event_info.preview.offset[1],
				motifEvent.event_info.menu.pos[2] + motifEvent.event_info.preview.offset[2],
				motifEvent.event_info.preview.scale[1],
				motifEvent.event_info.preview.scale[2],
				motifEvent.event_info.preview.window[1],
				motifEvent.event_info.preview.window[2],
				motifEvent.event_info.preview.window[3],
				motifEvent.event_info.preview.window[4],
				motifEvent.event_info.preview.angle,
				motifEvent.event_info.preview.xangle,
				motifEvent.event_info.preview.yangle,
				motifEvent.event_info.preview.focallength,
				motifEvent.event_info.preview.projection,
				motifEvent.event_info.preview.layerno
			)
		end
	--No Events Data
		if selectedEvent == 'back' then
			textImgSetText(txt_titleEvent, "NO EVENTS DATA")
	--draw other text only if there is event data stored in select.def
		else
			if unlockItem then
				textImgSetText(txt_hiscoreEvent, motifEvent.event_info.hiscore.text..' '..f_setThousandsFormat(eventsDat[selectedEvent].score)..motifEvent.event_info.hiscore.suffix)
				textImgDraw(txt_hiscoreEvent)
				local bestTime = nil
				if motifEvent.event_info.recordtime.default ~= nil and eventsDat[selectedEvent].recordtime == defaultRecord then
					bestTime = motifEvent.event_info.recordtime.default
				else
					bestTime = f_setTimeFormat(eventsDat[selectedEvent].recordtime)
				end
				textImgSetText(txt_recordTimeEvent, motifEvent.event_info.recordtime.text..' '..bestTime)
				textImgDraw(txt_recordTimeEvent)
				cdText = t[item].info
			else
				cdText = motifEvent.event_info.info.unknown
			end
			infoTextActive = f_textRender(
				txt_infoEvent,
				cdText,
				infoTextCnt,
				motifEvent.event_info.info.offset[1],
				motifEvent.event_info.info.offset[2],
				motifEvent.event_info.info.scale[1],
				motifEvent.event_info.info.scale[2],
				motifEvent.event_info.info.spacing,
				motifEvent.event_info.info.delay,
				motifEvent.event_info.info.length
			)
			if infoTextActive > 0 then infoTextCnt = infoTextCnt + 1 end
			--textImgSetText(txt_infoEvent, cdText)
			--textImgUpdate(txt_infoEvent)
			--textImgDraw(txt_infoEvent)
		end
	--draw title
		textImgDraw(txt_titleEvent)
	--draw credits text
		if motif.attract_mode.enabled and getCredits() ~= -1 then
			textImgReset(motif.attract_mode.credits.TextSpriteData)
			textImgSetText(motif.attract_mode.credits.TextSpriteData, string.format(motif.attract_mode.credits.text, getCredits()))
			textImgDraw(motif.attract_mode.credits.TextSpriteData)
		end
	--draw layerno = 1 backgrounds
		bgDraw(motifEvent.eventbgdef.BGDef, 1)
	--draw fadein / fadeout
		main.f_fadeAnim(main.fadeGroup)
--;---------------------------------------------------------------------------------------------------------------------
	--Cursor Move
		if not main.fadeActive then
			cursorPosY, moveTxt, item = main.f_menuCommonCalc(t, item, cursorPosY, moveTxt, motifEvent.event_info, motifEvent.event_info.cursor)
			if currentCursor ~= item then
				--textImgReset(txt_infoEvent)
				f_resetEventInfoTxt()
				currentCursor = item
			end
		end
	--Close Screen
		if main.close and not main.fadeActive then
			bgReset(motif[main.background].BGDef)
			main.f_fadeReset('fadein', motif[main.group])
			playBgm({source = "motif.title", interrupt = true})
			main.close = false
			eventModeActive = false
			break
	--Back Button
		elseif (esc() or getInput(-1, motifEvent.event_info.menu.cancel.key) or (selectedEvent == 'back' and getInput(-1, motifEvent.event_info.menu.done.key))) and not main.fadeActive then
			sndPlay(motif.Snd, motifEvent.event_info.cursor.cancel.snd[1], motifEvent.event_info.cursor.cancel.snd[2])
			main.f_fadeReset('fadeout', motifEvent.event_info)
			main.close = true
	--Accept Button
		elseif getInput(-1, motifEvent.event_info.menu.done.key) and not main.fadeActive then
			if main.t_unlockLua.modes[t[item].itemname] == nil then --If the event is unlocked
				main.f_default()
				sndPlay(motif.Snd, motifEvent.event_info.cursor.done.snd[1], motifEvent.event_info.cursor.done.snd[2])
			--START EVENT
				remapInput(1, getLastInputController())
				remapInput(getLastInputController(), 1)
				textImgSetText(motif.select_info.title.TextSpriteData, motifEvent.event_info.title.select) --Character Select Title
				main.selectMenu[1] = t[item].charsel --Enable or Disable Character Select for Event Selected
				main.teamMenu[1].single = t[item].single
				main.teamMenu[1].simul = t[item].simul
				main.teamMenu[1].tag = t[item].tag
				main.teamMenu[1].turns = t[item].turns
				main.teamMenu[1].ratio = t[item].ratio
				main.stageMenu = t[item].stgsel --Enable or Disable Stage Select for Event Selected
				main.motif.vsscreen = t[item].vsscreen --Enable or Disable Versus Screen for Event Selected
				main.orderSelect[1] = t[item].ordersel --Enable or Disable Order Select for Event Selected
			--Which fight screen elements should be rendered
				main.fightscreen.bars = t[item].lfbar --main.fightscreen.active = t[item].lfbar
				main.fightscreen.match = t[item].lfbarmatchno
				main.fightscreen.timer = t[item].lfbartimer
				main.fightscreen.p1score = t[item].lfbarscorep1
				main.fightscreen.p2score = t[item].lfbarscorep2
				main.fightscreen.p1aiLevel = t[item].lfbaraip1
				main.fightscreen.p2aiLevel = t[item].lfbaraip2
				main.fightscreen.p1winCount = t[item].lfbarwinp1
				main.fightscreen.p2winCount = t[item].lfbarwinp2
			--Hiscore Stuff
				--main.motif.hiscore = false
				--main.rankingCondition = true
				main.motif.victoryScreen = t[item].winscreen --Enable or Disable Victory Screen for Event Selected
				main.motif.continueScreen = t[item].continue --Enable or Disable Continue Screen for Event Selected
				main.quickContinue = t[item].quickcontinue --Enable or Disable skip player selection when continuing for Event Selected
				setGameMode(t[item].itemname) --This uses t_selEventMode[id] name
				hook.run("main.t_itemname")
				main.luaPath = t[item].path
				main.f_fadeReset('fadeout', motifEvent.event_info)
			--Check Unlocks before enter in Character Select
				main.f_unlock(false)
				f_refreshUnlockDat()
				start.f_selectMode()
				if motifEvent.music.menu.bgm ~= "" then f_playEventBGM() end --Play Event Menu BGM
			--Check Unlocks after play events
				main.f_unlock(false)
				f_refreshUnlockDat()
				f_resetEventInfoTxt()
				main.f_fadeAnim(motif.select_info) --fadein / fadeout
			end
		end
		refresh()
	end
end

main.t_itemname.events = function()
	return f_events() --Call above function (that contains a custom sub-menu) when enter in main menu item
end
--;===========================================================
--; MODES LOOP (copy from external/script/start.lua)
--;===========================================================
function start.f_selectMode()
	start.f_selectReset(true)
	while true do
		--select screen
		if not start.f_selectScreen() then
			sndPlay(motif.Snd, motif.select_info.cancel.snd[1], motif.select_info.cancel.snd[2])
			bgReset(motif[main.background].BGDef)
			main.f_fadeReset('fadein', motif[main.group])
			playBgm({source = "motif.title", interrupt = true})
			return
		end
		--first match
		if start.reset then
			-- Save current remap state. main.f_restoreInput() should restore to this.
			main.f_saveBaseRemapInput()
			main.t_availableChars = main.f_tableCopy(main.t_orderChars)
			--generate default roster
			if main.makeRoster then
				start.t_roster = start.f_makeRoster()
			end
			--generate AI ramping table
			if main.aiRamp then
				start.f_aiRamp(1)
			end
			start.reset = false
		end
		--lua file with custom arcade path detection
		local path = main.luaPath
		if main.charparam.arcadepath then
			if start.p[2].ratio and start.f_getCharData(start.p[1].t_selected[1].ref).ratiopath ~= '' then
				path = start.f_getCharData(start.p[1].t_selected[1].ref).ratiopath
				if not main.f_fileExists(path) then
					panicError("\n" .. start.f_getCharData(start.p[1].t_selected[1].ref).name .. " ratiopath doesn't exist: " .. path .. "\n")
				end
			elseif not start.p[2].ratio and start.f_getCharData(start.p[1].t_selected[1].ref).arcadepath ~= '' then
				path = start.f_getCharData(start.p[1].t_selected[1].ref).arcadepath
				if not main.f_fileExists(path) then
					panicError("\n" .. start.f_getCharData(start.p[1].t_selected[1].ref).name .. " arcadepath doesn't exist: " .. path .. "\n")
				end
			end
		end
		--external script execution
		assert(loadfile(path))()
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
				bgReset(motif[main.background].BGDef)
				main.f_fadeReset('fadein', motif[main.group])
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