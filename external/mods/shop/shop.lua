--[[					 		   SHOP MODULE
===========================================================================================
Version: 1.3.0
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0)
Description: A menu dedicated to spend In-Game Currency and Unlock Content

Module Dependencies Required:
- Currency System: https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/tree/main/external/mods/currency
- Palette Select Plus+ by dionednd (for unlock colors): https://github.com/dionednd/paletteselect-plus
===========================================================================================
						           DISCLAIMER
In Network/Netplay (Online Mode), as happens with Game Settings, a desynchronization may occur
if the host and client have not unlocked the same content.

Due to current engine limitations, to manage this case netPlay() function has been added
to the shop item examples that will temporarily cause the content to be unlocked
(even if online partner has purchased it), only during online session.

Following the engine's wiki recommendation:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Lua#example-allow-unlocks-during-netplay
===========================================================================================
]]
local shopMotifPath = "external/mods/shop/shopMenu.def" --Set the Motif/Screenpack Definition File Path
local shopSavePath = "save/shopDat.json" --Set the Shop Save Data File Path

--[[README!

- HOW TO LOAD CUSTOM PORTRAITS/ANIMS for CHARACTERS or STAGES using [Shop Info] .preview paramvalues:
GO TO "external/script/main.lua" and below: main.t_unlockLua = {chars = {}, stages = {}, modes = {}}
copy and paste the next block of code:

--generate preload custom shop character preview spr/anim list
preloadListChar(group, index) --For a custom character portrait
preloadListChar(actionNo) --For a custom character animation

--generate preload custom shop stage preview spr/anim list
preloadListStage(group, index) --For a custom stage portrait
preloadListStage(actionNo) --For a custom stage animation

]]
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

--Check if a table is empty
local function f_isEmpty(t)
--If it is not a table, is not empty
	if type(t) ~= "table" then return false end
--Check if have data
	for _ in pairs(t) do
		return false
	end
	return true
end

--Reindex numerically
local function f_reindexTableInPlace(t)
	local newIndex = 1
	for i = 1, #t do
		if t[i] ~= nil then
			t[newIndex] = t[i]
			if newIndex ~= i then
				t[i] = nil
			end
			newIndex = newIndex + 1
		end
	end
end

--Clean table recursively
local function f_cleanTable(t)
	for k, v in pairs(t) do
		if type(v) == "table" then
		--If table is empty, delete it
			if f_isEmpty(v) then
				t[k] = nil
		--If is not empty, clean recursively
			else
				f_cleanTable(v)
			end
		end
	end
--Reindex after clean the table, to avoid discontinuous items that cause issues when iterating over table
	f_reindexTableInPlace(t)
end

--shortcut for updating text
local function f_updateTextImg(t, sect, textData)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	textImgSetFont(textData, motifShop.fontData[section.font[1]] or -1)
	textImgSetBank(textData, section.font[2] or 0)
	textImgSetAlign(textData, section.font[3] or 0)
	textImgSetColor(textData, section.font[4] or 255, section.font[5] or 255, section.font[6] or 255, section.font[7] or 255)
	if section.localcoord ~= nil then --Need to be ALWAYS BEFORE textImgSetPos() to draw the text
		textImgSetLocalcoord(textData, section.localcoord[1], section.localcoord[2])
	else
		textImgSetLocalcoord(textData, motifShop.info.localcoord[1], motifShop.info.localcoord[2])
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
		textImgSetWindow(textData, 0, 0, motifShop.info.localcoord[1], motifShop.info.localcoord[2])
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
	animSetLocalcoord(animData, motifShop.info.localcoord[1], motifShop.info.localcoord[2]) --Need to be ALWAYS BEFORE animSetPos() to draw the animation/sprite
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
		animSetWindow(animData, 0, 0, motifShop.info.localcoord[1], motifShop.info.localcoord[2])
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
--Use "events.spr" data from module shopMotifPath, instead system.def file
	else
		sffDat = motifShop.sprData
	end
--Use Animations/Actions data from system.def file
	if (moduleActions and motifShop.airData == nil) or not moduleActions then
		airDat = motif.AnimTable
--Use "events.air" data from module shopMotifPath, instead system.def file
	else
		airDat = motifShop.airData
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

--Setup function to use for preloaded data
local function f_getPreloadedData(dataType, id, group, index)
	if dataType == 'char' then
		animDat = animGetPreloadedCharData(id, group, index)
	elseif dataType == 'stage' then
		animDat = animGetPreloadedStageData(id, group, index)
	end
	return animDat
end

--shortcut for updating rectangle
local function f_updateRect(t, sect, rectData)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	if section.localcoord ~= nil then
		rectSetLocalcoord(rectData, section.localcoord[1], section.localcoord[2])
	else
		rectSetLocalcoord(rectData, motifShop.info.localcoord[1], motifShop.info.localcoord[2])
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
--								SHOP DATA GENERATION
--===================================================================================
motifShop = loadIni(shopMotifPath) --Load Motif/Screenpack Data
if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifShop, "debug/shopMenumotifShop.txt") end

local file = io.open(shopSavePath, "r") --Check that file exists
if not file then
	file = io.open(shopSavePath, "w") --Create file
	file:write("{}")
	file:close() --Close file in writting mode
else
	file:close() --Close file in reading mode
end
--Data loading from shopSavePath
shopDat = jsonDecode(shopSavePath)

--Data saving to shopSavePath
local function f_saveShopData()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(shopDat, 'debug/t_shopDat.txt') end --Print Debug Info
	jsonEncode(shopDat, shopSavePath) --Write in shopSavePath file
end

--Refresh t_unlockLua table
local function f_refreshUnlockDat()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
end

if shopDat.shopstock == nil then shopDat.shopstock = {} end --Create space to sell shop items
local function f_setShopStock(t)
	for item=1, #t do
	--Add Category to shop stock
		local category = t.category --t[item].category
		if shopDat.shopstock[category] == nil then shopDat.shopstock[category] = {} end
	--Add item to shop stock
		local itemname = t[item].id
		if shopDat.shopstock[category][itemname] == nil then shopDat.shopstock[category][itemname] = true end
	end
end

--Store characters "name" content from .def files.
local function f_readCharName(charNo)
	if main.t_selChars[charNo].def ~= nil then --To filter only chars that have their .def file
		local targetDat = nil
		local targetSectionName = "info"
		local charDef = io.open(main.t_selChars[charNo].def, "r") --Open file.def of each char loaded
		local inTargetSection = false  --To indicate if we are in the section [Info]
		for line in charDef:lines() do --Read file.def of each char loaded
		--Check that is inside: [Info]
			if line:match('^%s*%[.-%s*%]%s*$') then --Check if it is a Section line
				local sectionName = line:match('^%s*%[(.-)%s*%]%s*$')
				if sectionName and sectionName:lower() == targetSectionName then
					inTargetSection = true
				else
					inTargetSection = false
				end
			end
		--If you are in the section and find the line "name = "charname" "
			if inTargetSection then
				if line:match('^%s*[Nn][Aa][Mm][Ee]%s*=%s*"([^"]+)"') then
					local targetMatch = line:match('^%s*[Nn][Aa][Mm][Ee]%s*=%s*"([^"]+)"') --Capture the character's name within quotes
					targetDat = targetMatch
				end
			end
		end
		charDef:close()
		main.t_selChars[charNo].basename = targetDat --Store data for each char in the main.t_selChars table
	end
end

local function f_loadCharPreviewData(charNo)
--anim data
	for _, v in pairs({{motifShop.shop_info.character.preview.anim, -1}, motifShop.shop_info.character.preview.spr}) do
		if #v > 0 and v[1] ~= -1 then
			main.t_selChars[charNo + 1].shopAnim_data = f_getPreloadedData('char', charNo, v[1], v[2])
			if main.t_selChars[charNo + 1].shopAnim_data ~= nil then
				local charData = start.f_getCharData(charNo)
				local xscale = start.f_getCharData(charNo).portraitscale * motif.info.localcoord[1] / start.f_getCharData(charNo).localcoord
				local yscale = xscale
				if v[2] == -1 then
					xscale = xscale * (charData.cns_scale[1] or 1)
					yscale = yscale * (charData.cns_scale[2] or 1)
				end
				animSetLocalcoord(
					main.t_selChars[charNo + 1].shopAnim_data,
					motif.info.localcoord[1],
					motif.info.localcoord[2]
				)
				animSetLayerno(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.layerno
				)
			--[[
				animSetVelocity(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.velocity[1],
					motifShop.shop_info.character.preview.velocity[2]
				)
				animSetMaxDist(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.maxdist[1],
					motifShop.shop_info.character.preview.maxdist[2]
				)
				animSetAccel(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.accel[1],
					motifShop.shop_info.character.preview.accel[2]
				)
				animSetFriction(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.friction[1],
					motifShop.shop_info.character.preview.friction[2]
				)
			]]
				animSetPos(main.t_selChars[charNo + 1].shopAnim_data, 0, 0)
				animSetScale(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.scale[1] * xscale,
					motifShop.shop_info.character.preview.scale[2] * yscale
				)
				animSetFacing(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.facing
				)
			--[[
				animSetXShear(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.xshear
				)
				animSetAngle(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.angle
				)
				animSetXAngle(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.xangle
				)
				animSetYAngle(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.yangle
				)
				animSetProjection(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.projection
				)
				animSetFocalLength(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.focallength
				)
			]]
				animSetWindow(
					main.t_selChars[charNo + 1].shopAnim_data,
					motifShop.shop_info.character.preview.window[1],
					motifShop.shop_info.character.preview.window[2],
					motifShop.shop_info.character.preview.window[3],
					motifShop.shop_info.character.preview.window[4]
				)
				animUpdate(main.t_selChars[charNo + 1].shopAnim_data)
				break
			end
		end
	end
	if main.t_selChars[charNo + 1].shopAnim_data == nil then
		main.t_selChars[charNo + 1].shopAnim_data = animNew(main.dummySff, '-1,0, 0,0, -1')
	end
end

local function f_loadCharColorPreviewData(charNo, color)
--anim data
	for _, v in pairs({{motifShop.shop_info.character.preview.anim, -1}, motifShop.shop_info.character.preview.spr}) do
		if #v > 0 and v[1] ~= -1 then
			if main.t_selChars[charNo + 1].shopPalAnim_data == nil then
				main.t_selChars[charNo + 1].shopPalAnim_data = {}
			end
			main.t_selChars[charNo + 1].shopPalAnim_data[color] = f_getPreloadedData('char', charNo, v[1], v[2])
			if main.t_selChars[charNo + 1].shopPalAnim_data[color] ~= nil then
				local charData = start.f_getCharData(charNo)
				local xscale = start.f_getCharData(charNo).portraitscale * motif.info.localcoord[1] / start.f_getCharData(charNo).localcoord
				local yscale = xscale
				if v[2] == -1 then
					xscale = xscale * (charData.cns_scale[1] or 1)
					yscale = yscale * (charData.cns_scale[2] or 1)
				end
				animSetLocalcoord(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motif.info.localcoord[1],
					motif.info.localcoord[2]
				)
				animSetLayerno(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.layerno
				)
			--[[
				animSetVelocity(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.velocity[1],
					motifShop.shop_info.character.preview.velocity[2]
				)
				animSetMaxDist(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.maxdist[1],
					motifShop.shop_info.character.preview.maxdist[2]
				)
				animSetAccel(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.accel[1],
					motifShop.shop_info.character.preview.accel[2]
				)
				animSetFriction(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.friction[1],
					motifShop.shop_info.character.preview.friction[2]
				)
			]]
				animSetPos(main.t_selChars[charNo + 1].shopPalAnim_data[color], 0, 0)
				animSetScale(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.scale[1] * xscale,
					motifShop.shop_info.character.preview.scale[2] * yscale
				)
				animSetFacing(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.facing
				)
			--[[
				animSetXShear(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.xshear
				)
				animSetAngle(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.angle
				)
				animSetXAngle(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.xangle
				)
				animSetYAngle(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.yangle
				)
				animSetProjection(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.projection
				)
				animSetFocalLength(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.focallength
				)
			]]
				animSetWindow(
					main.t_selChars[charNo + 1].shopPalAnim_data[color],
					motifShop.shop_info.character.preview.window[1],
					motifShop.shop_info.character.preview.window[2],
					motifShop.shop_info.character.preview.window[3],
					motifShop.shop_info.character.preview.window[4]
				)
			--Apply color palette
				main.t_selChars[charNo + 1].shopPalAnim_data[color] = start.loadPalettes(main.t_selChars[charNo + 1].shopPalAnim_data[color], main.t_selChars[charNo + 1].char_ref, color)
				animUpdate(main.t_selChars[charNo + 1].shopPalAnim_data[color])
				break
			end
		end
	end
	if main.t_selChars[charNo + 1].shopPalAnim_data[color] == nil then
		main.t_selChars[charNo + 1].shopPalAnim_data[color] = animNew(main.dummySff, '-1,0, 0,0, -1')
	end
end

local function f_loadStagePreviewData(stageNo)
--anim data
	for _, v in pairs({{motifShop.shop_info.stage.preview.anim, -1}, motifShop.shop_info.stage.preview.spr}) do
		if v ~= nil and #v > 0 and v[1] ~= -1 and v[1] ~= nil then
			main.t_selStages[stageNo].shopAnim_data = f_getPreloadedData('stage', stageNo, v[1], v[2])
			if main.t_selStages[stageNo].shopAnim_data ~= nil then
				animSetLocalcoord(
					main.t_selStages[stageNo].shopAnim_data,
					motif.info.localcoord[1],
					motif.info.localcoord[2]
				)
				animSetLayerno(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.layerno
				)
				animSetPos(main.t_selStages[stageNo].shopAnim_data, 0, 0)
				animSetScale(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.scale[1] * main.t_selStages[stageNo].portraitscale * motif.info.localcoord[1] / main.t_selStages[stageNo].localcoord,
					motifShop.shop_info.stage.preview.scale[2] * main.t_selStages[stageNo].portraitscale * motif.info.localcoord[1] / main.t_selStages[stageNo].localcoord
				)
				animSetFacing(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.facing
				)
			--[[
				animSetXShear(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.xshear
				)
				animSetAngle(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.angle
				)
				animSetXAngle(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.xangle
				)
				animSetYAngle(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.yangle
				)
				animSetProjection(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.projection
				)
				animSetFocalLength(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.focallength
				)
			]]
				animSetWindow(
					main.t_selStages[stageNo].shopAnim_data,
					motifShop.shop_info.stage.preview.window[1],
					motifShop.shop_info.stage.preview.window[2],
					motifShop.shop_info.stage.preview.window[3],
					motifShop.shop_info.stage.preview.window[4]
				)
				animUpdate(main.t_selStages[stageNo].shopAnim_data)
				break
			end
		end
	end
	if main.t_selStages[stageNo].shopAnim_data == nil then
		main.t_selStages[stageNo].shopAnim_data = animNew(main.dummySff, '-1,0, 0,0, -1')
	end
end

local function f_loadShop() --Load def file which contains shop items data
--Set Default Data
	local shopItemsDef = nil
	motifShop.sprData = sffNew() --Create blank sprite data
	motifShop.sndData = motif.Snd --Use default system.def sound data
--If events files section is detected, replace Default Data with Custom Data
	if motifShop.files ~= nil then
	--Load .def file with Shop Items
		if motifShop.files.def ~= nil and main.f_fileExists(motifShop.files.def) then
			shopItemsDef = motifShop.files.def
		end
	--Load .sff file with Shop Preview Items
		if motifShop.files.sff ~= nil and main.f_fileExists(motifShop.files.sff) then
			motifShop.sprData = sffNew(motifShop.files.sff)
		end
	--Load .air file with Shop Menu Animations
		if motifShop.files.air ~= nil and main.f_fileExists(motifShop.files.air) then
			motifShop.airData = loadAnimTable(motifShop.files.air, motifShop.sprData)
		end
	--Load .snd file with Shop Menu Sounds
		if motifShop.files.snd ~= nil and main.f_fileExists(motifShop.files.snd) then
			motifShop.sndData = sndNew(motifShop.files.snd)
		end
	end
	motifShop.fontData = motif.Fnt --Use default system.def font data
--If shop fonts section is detected, replace Default Data with Custom Data
	if motifShop.fonts ~= nil then
		local i = 1
		while motifShop.fonts["font"..i] ~= nil do
			motifShop.fontData[i] = fontNew(motifShop.fonts["font"..i])
			i = i + 1
		end
	end
--Load Data
	t_shopMenu = {}
	local t_tempShop = {}
	local sectionName = nil
	local section = 0
	local content = main.f_fileRead(shopItemsDef)
	content = content:gsub('([^\r\n;]*)%s*;[^\r\n]*', '%1')
	content = content:gsub('\n%s*\n', '\n')
	for line in content:gmatch('[^\r\n]+') do
		local lineCase = line:match('^%s*%[%s*([^%]]+)%s*%]')
		if lineCase then
			sectionName = lineCase
			section = section + 1
			t_tempShop[section] = {}
		elseif section >= 1 then --[SectionName]
			t_tempShop[section]['category'] = sectionName
			local param, value = line:match('^%s*(.-)%s*=%s*(.-)%s*$')
			if param ~= nil and value ~= nil and param ~= '' and value ~= '' then
			--Generate Table to manage each item with default values
				if param:match('^id$') then
					table.insert(t_tempShop[section],
						{
							id = value,
							name = motifShop.shop_info.info.unknown,
							info = nil,
							price = motifShop.shop_info.price.default,
							spr = {},
							offset = motifShop.shop_info.custom.preview.offset,
							scale = motifShop.shop_info.custom.preview.scale,
							window = motifShop.shop_info.custom.preview.window,
							unlock = 'true'
						}
					)
			--Update optional comma separated number values to table
				elseif param:match('^spr$') or param:match('^offset$') or param:match('^scale$') or param:match('^window$') then
					local tbl = {}
					for num in value:gmatch('([^,]+)') do
						table.insert(tbl, tonumber(num))
					end
					t_tempShop[section][#t_tempShop[section]][param] = tbl
			--Update optional paramvalues with custom ones
				else
					local lastItem = t_tempShop[section][#t_tempShop[section]]
					if lastItem then lastItem[param] = value end
				end
			end
		end
	end
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(t_tempShop, 'debug/t_tempShop.txt') end
--Check that the added items exist to add them to the shop menu 
	for categoryNo=1, #t_tempShop do
		if t_tempShop[categoryNo].category ~= nil then t_shopMenu[categoryNo] = {} end
	--Filter Chars/Costumes
		if t_tempShop[categoryNo].category:lower() == "chars" or t_tempShop[categoryNo].category:lower() == "costumes"
		or t_tempShop[categoryNo].category:lower() == "characters" then
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].id:lower()
				if main.t_charDef[pathID] ~= nil then --If char has been added via select.def, add to the shop
					t_shopMenu[categoryNo][itemNo] = {data = textImgNew()} --Create text data
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motifShop.shop_info.info.purchase..' '..t_tempShop[categoryNo].category
					f_loadCharPreviewData(main.t_charDef[pathID])
					f_readCharName(main.t_charDef[pathID] + 1)
					local baseName = main.t_selChars[main.t_charDef[pathID] + 1].basename
					local displayName = main.t_selChars[main.t_charDef[pathID] + 1].name
					local infoData = t_tempShop[categoryNo][itemNo].info
					if baseName then
						t_shopMenu[categoryNo][itemNo]['itemname'] = baseName
						t_shopMenu[categoryNo][itemNo]['displayname'] = baseName
						t_shopMenu[categoryNo][itemNo]['displaynameunlocked'] = baseName
						t_shopMenu[categoryNo][itemNo]['vardisplay'] = ""
						if infoData ~= nil then
							t_shopMenu[categoryNo][itemNo]['info'] = infoData
						else
							t_shopMenu[categoryNo][itemNo]['info'] = motifShop.shop_info.info.unlock..' '..baseName
						end
					else
						t_shopMenu[categoryNo][itemNo]['itemname'] = displayName
						t_shopMenu[categoryNo][itemNo]['displayname'] = displayName
						t_shopMenu[categoryNo][itemNo]['displaynameunlocked'] = displayName
						t_shopMenu[categoryNo][itemNo]['vardisplay'] = ""
						if infoData ~= nil then
							t_shopMenu[categoryNo][itemNo]['info'] = infoData
						else
							t_shopMenu[categoryNo][itemNo]['info'] = motifShop.shop_info.info.unlock..' '..displayName
						end
					end
					t_shopMenu[categoryNo][itemNo]['id'] = pathID
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
				else --Ignore items that are not recognized
					
				end
			end
	--Filter Colors
		elseif t_tempShop[categoryNo].category:lower() == "colors"
		or t_tempShop[categoryNo].category:lower() == "palettes" then
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].char:lower()
				local color = tonumber(t_tempShop[categoryNo][itemNo].color)
				if main.t_charDef[pathID] ~= nil then --If char has been added via select.def, add to the shop
					t_shopMenu[categoryNo][itemNo] = {data = textImgNew()} --Create text data
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motifShop.shop_info.info.purchase..' '..t_tempShop[categoryNo].category
					if color ~= nil and color > 0 then
						f_loadCharColorPreviewData(main.t_charDef[pathID], color)
					end
					f_readCharName(main.t_charDef[pathID] + 1)
					local baseName = main.t_selChars[main.t_charDef[pathID] + 1].basename
					local displayName = main.t_selChars[main.t_charDef[pathID] + 1].name
					local infoData = t_tempShop[categoryNo][itemNo].info
					local colorPrefix = motifShop.shop_info.info.color..' '..t_tempShop[categoryNo][itemNo].color
					if baseName then
						t_shopMenu[categoryNo][itemNo]['itemname'] = baseName..' ('..colorPrefix..')'
						t_shopMenu[categoryNo][itemNo]['displayname'] = baseName..' ('..colorPrefix..')'
						t_shopMenu[categoryNo][itemNo]['displaynameunlocked'] = baseName..' ('..colorPrefix..')'
						t_shopMenu[categoryNo][itemNo]['vardisplay'] = ""
						if infoData ~= nil then
							t_shopMenu[categoryNo][itemNo]['info'] = infoData
						else
							t_shopMenu[categoryNo][itemNo]['info'] = motifShop.shop_info.info.unlock..' '..colorPrefix..' for '..baseName
						end
					else
						t_shopMenu[categoryNo][itemNo]['itemname'] = displayName..' ('..colorPrefix..')'
						t_shopMenu[categoryNo][itemNo]['displayname'] = displayName..' ('..colorPrefix..')'
						t_shopMenu[categoryNo][itemNo]['displaynameunlocked'] = displayName..' ('..colorPrefix..')'
						t_shopMenu[categoryNo][itemNo]['vardisplay'] = ""
						if infoData ~= nil then
							t_shopMenu[categoryNo][itemNo]['info'] = infoData
						else
							t_shopMenu[categoryNo][itemNo]['info'] = motifShop.shop_info.info.unlock..' '..colorPrefix..' for '..displayName
						end
					end
					t_shopMenu[categoryNo][itemNo]['id'] = t_tempShop[categoryNo][itemNo].id
					t_shopMenu[categoryNo][itemNo]['char'] = t_tempShop[categoryNo][itemNo].char
					t_shopMenu[categoryNo][itemNo]['color'] = t_tempShop[categoryNo][itemNo].color
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
				else --Ignore items that are not recognized
					
				end
			end
	--Filter Stages
		elseif t_tempShop[categoryNo].category:lower() == "stages" then
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].id:lower()
				if main.t_stageDef[pathID] ~= nil then --If stage has been added via select.def, add to the shop
					local infoData = t_tempShop[categoryNo][itemNo].info
					t_shopMenu[categoryNo][itemNo] = {data = textImgNew()}
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motifShop.shop_info.info.purchase..' '..t_tempShop[categoryNo].category
					f_loadStagePreviewData(main.t_stageDef[pathID])
					if infoData ~= nil then
						t_shopMenu[categoryNo][itemNo]['info'] = infoData
					else
						t_shopMenu[categoryNo][itemNo]['info'] = motifShop.shop_info.info.unlock..' '..main.t_selStages[main.t_stageDef[pathID]].name
					end
					t_shopMenu[categoryNo][itemNo]['id'] = pathID
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['itemname'] = main.t_selStages[main.t_stageDef[pathID]].name
					t_shopMenu[categoryNo][itemNo]['displayname'] = main.t_selStages[main.t_stageDef[pathID]].name
					t_shopMenu[categoryNo][itemNo]['displaynameunlocked'] = main.t_selStages[main.t_stageDef[pathID]].name
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
					t_shopMenu[categoryNo][itemNo]['vardisplay'] = ""
				end
			end
	--Custom Stuff
		else
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].id:lower()
				--if t_itemDef[pathID] ~= nil then --If item exists, add to the shop
					local infoData = t_tempShop[categoryNo][itemNo].info
					t_shopMenu[categoryNo][itemNo] = {data = textImgNew()}
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motifShop.shop_info.info.purchase..' '..t_tempShop[categoryNo].category
					if infoData ~= nil then
						t_shopMenu[categoryNo][itemNo]['info'] = infoData
					else
						t_shopMenu[categoryNo][itemNo]['info'] = motifShop.shop_info.info.unlock..' '..t_tempShop[categoryNo][itemNo].name
					end
					t_shopMenu[categoryNo][itemNo]['id'] = pathID
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['itemname'] = t_tempShop[categoryNo][itemNo].name
					t_shopMenu[categoryNo][itemNo]['displayname'] = t_tempShop[categoryNo][itemNo].name
					t_shopMenu[categoryNo][itemNo]['displaynameunlocked'] = t_tempShop[categoryNo][itemNo].name
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
					t_shopMenu[categoryNo][itemNo]['vardisplay'] = ""
					
					t_shopMenu[categoryNo][itemNo]['spr'] = t_tempShop[categoryNo][itemNo].spr
					t_shopMenu[categoryNo][itemNo]['offset'] = t_tempShop[categoryNo][itemNo].offset
					t_shopMenu[categoryNo][itemNo]['scale'] = t_tempShop[categoryNo][itemNo].scale
					t_shopMenu[categoryNo][itemNo]['window'] = t_tempShop[categoryNo][itemNo].window
				--end
			end
		end
	end
	f_cleanTable(t_shopMenu) --To remove empty categories
	for i=1, #t_shopMenu do
	--Create Shop Stock in shopDat.json
		if #t_shopMenu[i] ~= 0 then
			f_setShopStock(t_shopMenu[i])
		end
	--Set Shop Item "Discovered" Conditions
		for k, v in ipairs(t_shopMenu[i]) do
			if main.t_unlockLua.shop == nil then main.t_unlockLua['shop'] = {} end
			main.t_unlockLua.shop[v.id] = v.unlock
		end
	end
	f_saveShopData()
	if gameOption('Debug.DumpLuaTables') then
		main.f_printTable(t_shopMenu, 'debug/t_shopMenu.txt')
		main.f_printTable(main.t_selChars, "debug/t_selChars.txt")
		main.f_printTable(main.t_selStages, "debug/t_selStages.txt")
	end
end
f_loadShop() --Load shop data (items.def & items.sff files) when engine starts
--===================================================================================
--								SHOP ASSETS GENERATION
--===================================================================================
--[[Background data
Refer to official Elecbyte docs for information how to define backgrounds:
http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements

I.K.E.M.E.N. Features:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Background-features
]]
local sffBGDat = nil
if motifShop.shopbgdef.spr ~= nil and main.f_fileExists(motifShop.shopbgdef.spr) then
	sffBGDat = sffNew(motifShop.shopbgdef.spr) --Load a dedicate sprite .sff file
else
	sffBGDat = motif.Sff --Load default system.sff data
end

local modelBGDat = nil
if motifShop.shopbgdef.model ~= nil and main.f_fileExists(motifShop.shopbgdef.model) then
	modelBGDat = modelNew(motifShop.shopbgdef.model) --Load a dedicate 3D Model object
end

motifShop.shopbgdef.BGDef = bgNew(sffBGDat, shopMotifPath, 'shopbg', modelBGDat)

--Rectangle Data
local rect_boxcursor = f_createRect(motifShop.shop_info, 'menu.boxcursor')
local rect_boxbg = f_createRect(motifShop.shop_info, 'menu.boxbg')
local t_menuWindowShop = main.f_menuWindow(motifShop.shop_info.menu)

local overlay_purchase = f_createRect(motifShop.shop_info, 'purchase.overlay')
local rect_purchaseboxcursor = f_createRect(motifShop.shop_info, 'purchase.boxcursor')

--Text Data
local txt_shopTitle = f_createTextImg(motifShop.shop_info, 'title')
local txt_shopCategory = f_createTextImg(motifShop.shop_info, 'category')
local txt_shopItemInfo = f_createTextImg(motifShop.shop_info, 'info')

local txt_shopCurrency = f_createTextImg(motifShop.shop_info, 'currency')
local txt_shopPriceInfo = f_createTextImg(motifShop.shop_info, 'price')

local txt_shopBalanceOld = f_createTextImg(motifShop.shop_info, 'balance.old')
local txt_shopBalanceNew = f_createTextImg(motifShop.shop_info, 'balance.new')

local txt_shopPurchaseQuestion = f_createTextImg(motifShop.shop_info, 'purchase.question')
local txt_shopPurchaseInfo = f_createTextImg(motifShop.shop_info, 'purchase.info')
local txt_shopPurchaseYes = f_createTextImg(motifShop.shop_info, 'purchase.yes')
local txt_shopPurchaseNo = f_createTextImg(motifShop.shop_info, 'purchase.no')

local infoTextCnt = 0
local infoTextActive = 1
local function f_resetInfoTxt()
	infoTextCnt = 0
	infoTextActive = 1
end
if motifShop.shop_info.menu.item then motifShop.shop_info.menu.item.TextSpriteData = f_createTextImg(motifShop.shop_info, 'menu.item') end
if motifShop.shop_info.menu.item.active then motifShop.shop_info.menu.item.active.TextSpriteData = f_createTextImg(motifShop.shop_info, 'menu.item.active') end
if motifShop.shop_info.menu.item.value then motifShop.shop_info.menu.item.value.TextSpriteData = f_createTextImg(motifShop.shop_info, 'menu.item.value') end
if motifShop.shop_info.menu.item.value.active then motifShop.shop_info.menu.item.value.active.TextSpriteData = f_createTextImg(motifShop.shop_info, 'menu.item.value.active') end

--Sprite Data
local spr_previewBG = f_createAnim(motifShop.shop_info, 'preview.bg', true, true)
local spr_previewUnknow = f_createAnim(motifShop.shop_info, 'preview.unknown', true, true)
local spr_purchaseBG = f_createAnim(motifShop.shop_info, 'purchase.bg', true, true)
local spr_purchaseCursor = f_createAnim(motifShop.shop_info, 'purchase.cursor', true, true)
local spr_balanceArrow = f_createAnim(motifShop.shop_info, 'balance.arrow', true, true)
motifShop.shop_info.menu.arrow.up.AnimData = f_createAnim(motifShop.shop_info, 'menu.arrow.up', false, false)
motifShop.shop_info.menu.arrow.down.AnimData = f_createAnim(motifShop.shop_info, 'menu.arrow.down', false, false)

local function f_drawCustomPreview(group, index, x, y, scaleX, scaleY, x1, y1, x2, y2, angle, xangle, yangle, focallength, projection, layerno)
	local anim = group..','..index..', 0,0, -1' --local anim = group..','..index..','..x..','..y..','..'-1'
	anim = animNew(motifShop.sprData, anim)	
	animSetLocalcoord(anim, motifShop.info.localcoord[1], motifShop.info.localcoord[2])
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

local function f_drawShopItemPreview(category, itemNo, unlocked)
--Item unlocked
	if unlocked then
		local itemID = t_shopMenu[shopCategoryNo][itemNo].id --:lower()
	--Character Preview
		if category == "chars" or category == "characters" or category == "costumes" then
			local shopCharAnimDat = main.t_selChars[main.t_charDef[itemID] + 1].shopAnim_data
			if motifShop.shop_info.character.preview.resetanim == 1 and resetShopAnim then
				animReset(shopCharAnimDat)
			end
			if resetShopAnim then resetShopAnim = false end
			main.f_animPosDraw(
				shopCharAnimDat,
				motifShop.shop_info.menu.pos[1] + motifShop.shop_info.character.preview.offset[1],
				motifShop.shop_info.menu.pos[2] + motifShop.shop_info.character.preview.offset[2],
				motifShop.shop_info.character.preview.facing
			)
	--Character Color Preview
		elseif category == "colors" or category == "palettes" then
			itemID = t_shopMenu[shopCategoryNo][itemNo].char
			local color = tonumber(t_shopMenu[shopCategoryNo][itemNo].color)
			local shopPalAnimDat = main.t_selChars[main.t_charDef[itemID] + 1].shopPalAnim_data[color]
			--start.loadPalettes(shopPalAnimDat, main.t_selChars[main.t_charDef[itemID] + 1].char_ref, t_shopMenu[shopCategoryNo][itemNo].color)
			if motifShop.shop_info.character.preview.resetanim == 1 and resetShopAnim then
				animReset(shopPalAnimDat)
			end
			if resetShopAnim then resetShopAnim = false end
			main.f_animPosDraw(
				shopPalAnimDat,
				motifShop.shop_info.menu.pos[1] + motifShop.shop_info.character.preview.offset[1],
				motifShop.shop_info.menu.pos[2] + motifShop.shop_info.character.preview.offset[2],
				motifShop.shop_info.character.preview.facing
			)
	--Stage Preview
		elseif category == "stages" then
			main.f_animPosDraw(
				spr_previewUnknow,
				motifShop.shop_info.menu.pos[1] + motifShop.shop_info.preview.unknown.offset[1],
				motifShop.shop_info.menu.pos[2] + motifShop.shop_info.preview.unknown.offset[2],
				motifShop.shop_info.preview_unknown_facing
			)
			local shopStageAnimDat = main.t_selStages[main.t_stageDef[itemID]].shopAnim_data --main.t_selStages[main.t_selectableStages[main.t_stageDef[itemID]]].shopAnim_data
			if motifShop.shop_info.stage.preview.resetanim == 1 and resetShopAnim then
				animReset(shopStageAnimDat)
			end
			if resetShopAnim then resetShopAnim = false end
			main.f_animPosDraw(
				shopStageAnimDat,
				motifShop.shop_info.menu.pos[1] + motifShop.shop_info.stage.preview.offset[1],
				motifShop.shop_info.menu.pos[2] + motifShop.shop_info.stage.preview.offset[2],
				motifShop.shop_info.stage.preview.facing
			)
	--Custom Stuff Preview
		else
			if t_shopMenu[shopCategoryNo][itemNo].spr == nil then
				main.f_animPosDraw(
					spr_previewUnknow,
					motifShop.shop_info.menu.pos[1] + motifShop.shop_info.preview.unknown.offset[1],
					motifShop.shop_info.menu.pos[2] + motifShop.shop_info.preview.unknown.offset[2],
					motifShop.shop_info.preview_unknown_facing
				)
			else
				f_drawCustomPreview(
					t_shopMenu[shopCategoryNo][itemNo].spr[1], --group
					t_shopMenu[shopCategoryNo][itemNo].spr[2], --index
					motifShop.shop_info.menu.pos[1] + t_shopMenu[shopCategoryNo][itemNo].offset[1], --x
					motifShop.shop_info.menu.pos[2] + t_shopMenu[shopCategoryNo][itemNo].offset[2], --y
					t_shopMenu[shopCategoryNo][itemNo].scale[1], --scaleX
					t_shopMenu[shopCategoryNo][itemNo].scale[2], --scaleY
					t_shopMenu[shopCategoryNo][itemNo].window[1], --x1
					t_shopMenu[shopCategoryNo][itemNo].window[2], --y1
					t_shopMenu[shopCategoryNo][itemNo].window[3], --x2
					t_shopMenu[shopCategoryNo][itemNo].window[4] --y2
				)
			end
		end
--Item Locked
	else
		main.f_animPosDraw(
			spr_previewUnknow,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.preview.unknown.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.preview.unknown.offset[2],
			motifShop.shop_info.preview_unknown_facing
		)
	end
end

--Fade Data
if motifShop.shop_info.fadein.anim ~= -1 then
	motifShop.shop_info.fadein.AnimData = f_createAnim(motifShop.shop_info, 'fadein', false, false)
end
motifShop.shop_info.fadein.FadeData = fadeNew(motifShop.shop_info.fadein)

if motifShop.shop_info.fadeout.anim ~= -1 then
	motifShop.shop_info.fadeout.AnimData = f_createAnim(motifShop.shop_info, 'fadeout', false, false)
end
motifShop.shop_info.fadeout.FadeData = fadeNew(motifShop.shop_info.fadeout)

if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifShop, "debug/shopMenuMotif.txt") end
--===================================================================================
--								 SHOP MENU
--===================================================================================
local function f_confirmShopReset()
	confirmPurchase = false
	purchaseCursor = 2
end

local function f_confirmPurchase(item, enoughMoney)
	local fontYes = nil
	local fontNo = nil
	local bankYes = nil
	local bankNo = nil
	local alignYes = nil
	local alignNo = nil
	local rYes = nil
	local rNo = nil
	local gYes = nil
	local gNo = nil
	local bYes = nil
	local bNo = nil
	local heightYes = nil
	local heightNo = nil
	local xYes = nil
	local xNo = nil
	local yYes = nil
	local yNo = nil
	local scaleXYes = nil
	local scaleXNo = nil
	local scaleYYes = nil
	local scaleYNo = nil
	local cursorText = ""
	if purchaseCursor == 1 then
	--Yes Active
		fontYes = motifShop.shop_info.purchase.yes.active.font[1]
		bankYes = motifShop.shop_info.purchase.yes.active.font[2]
		alignYes = motifShop.shop_info.purchase.yes.active.font[3]
		rYes = motifShop.shop_info.purchase.yes.active.font[4]
		gYes = motifShop.shop_info.purchase.yes.active.font[5]
		bYes = motifShop.shop_info.purchase.yes.active.font[6]
		heightYes = motifShop.shop_info.purchase.yes.active.font[7]
		xYes = motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.yes.active.offset[1]
		yYes = motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.yes.active.offset[2]
		scaleXYes = motifShop.shop_info.purchase.yes.active.scale[1]
		scaleYYes = motifShop.shop_info.purchase.yes.active.scale[2]
	--No Inactive
		fontNo = motifShop.shop_info.purchase.no.font[1]
		bankNo = motifShop.shop_info.purchase.no.font[2]
		alignNo = motifShop.shop_info.purchase.no.font[3]
		rNo = motifShop.shop_info.purchase.no.font[4]
		gNo = motifShop.shop_info.purchase.no.font[5]
		bNo = motifShop.shop_info.purchase.no.font[6]
		heightNo = motifShop.shop_info.purchase.no.font[7]
		xNo = motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.no.offset[1]
		yNo = motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.no.offset[2]
		scaleXNo = motifShop.shop_info.purchase.no.scale[1]
		scaleYNo = motifShop.shop_info.purchase.no.scale[2]
	elseif purchaseCursor == 2 then
	--Yes Inactive
		fontYes = motifShop.shop_info.purchase.yes.font[1]
		bankYes = motifShop.shop_info.purchase.yes.font[2]
		alignYes = motifShop.shop_info.purchase.yes.font[3]
		rYes = motifShop.shop_info.purchase.yes.font[4]
		gYes = motifShop.shop_info.purchase.yes.font[5]
		bYes = motifShop.shop_info.purchase.yes.font[6]
		heightYes = motifShop.shop_info.purchase.yes.font[7]
		xYes = motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.yes.offset[1]
		yYes = motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.yes.offset[2]
		scaleXYes = motifShop.shop_info.purchase.yes.scale[1]
		scaleYYes = motifShop.shop_info.purchase.yes.scale[2]
	--No Active	
		fontNo = motifShop.shop_info.purchase.no.active.font[1]
		bankNo = motifShop.shop_info.purchase.no.active.font[2]
		alignNo = motifShop.shop_info.purchase.no.active.font[3]
		rNo = motifShop.shop_info.purchase.no.active.font[4]
		gNo = motifShop.shop_info.purchase.no.active.font[5]
		bNo = motifShop.shop_info.purchase.no.active.font[6]
		heightNo = motifShop.shop_info.purchase.no.active.font[7]
		xNo = motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.no.active.offset[1]
		yNo = motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.no.active.offset[2]
		scaleXNo = motifShop.shop_info.purchase.no.active.scale[1]
		scaleYNo = motifShop.shop_info.purchase.no.active.scale[2]
	end
--Actions
	if esc() or getInput(-1, motifShop.shop_info.menu.cancel.key) then
		sndPlay(motifShop.sndData, motifShop.shop_info.cancel.snd[1], motifShop.shop_info.cancel.snd[2])
		f_resetInfoTxt()
		f_confirmShopReset()
--Previous Item
	elseif getInput(-1, motifShop.shop_info.menu.previous.key) then
		if enoughMoney then
			sndPlay(motifShop.sndData, motifShop.shop_info.cursor.move.snd[1], motifShop.shop_info.cursor.move.snd[2])
			purchaseCursor = purchaseCursor - 1
		end
--Next Item
	elseif getInput(-1, motifShop.shop_info.menu.next.key) then
		if enoughMoney then
			sndPlay(motifShop.sndData, motifShop.shop_info.cursor.move.snd[1], motifShop.shop_info.cursor.move.snd[2])
			purchaseCursor = purchaseCursor + 1
		end
--Accept Button
	elseif getInput(-1, motifShop.shop_info.menu.done.key) then
	--YES
		if purchaseCursor == 1 then
		--Item Purchased (Save Data)
			sndPlay(motifShop.sndData, motifShop.shop_info.cursor.purchase.snd[1], motifShop.shop_info.cursor.purchase.snd[2])
			currency.setMoney(- t_shopMenu[shopCategoryNo][item].price)
			shopDat.shopstock[t_shopMenu[shopCategoryNo].category][t_shopMenu[shopCategoryNo][item].id] = false --Item Sold out
			f_saveShopData()
			main.f_unlock(true) --Check Shop Items Discovery/Unlocks
	--NO/ACCEPT
		elseif purchaseCursor == 2 then
			sndPlay(motifShop.sndData, motifShop.shop_info.cancel.snd[1], motifShop.shop_info.cancel.snd[2])
		end
		f_confirmShopReset()
	end
--Cursor Position Logic
	if purchaseCursor < 1 then
		purchaseCursor = 2
	elseif purchaseCursor > 2 then
		purchaseCursor = 1
	end
--Draw Overlay BG
	rectSetColor(
		overlay_purchase,
		motifShop.shop_info.purchase.overlay.col[1],
		motifShop.shop_info.purchase.overlay.col[2],
		motifShop.shop_info.purchase.overlay.col[3]
	)
	rectUpdate(overlay_purchase)
	rectDraw(overlay_purchase)
--Draw Purchase Screen BG
	animSetWindow(spr_purchaseBG, motifShop.shop_info.purchase.bg.window[1], motifShop.shop_info.purchase.bg.window[2], motifShop.shop_info.purchase.bg.window[3], motifShop.shop_info.purchase.bg.window[4])
	main.f_animPosDraw(
		spr_purchaseBG,
		motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.bg.offset[1],
		motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.bg.offset[2],
		motifShop.shop_info.purchase.bg.facing
	)
	if enoughMoney then
		cursorText = motifShop.shop_info.purchase.no.text
	--Draw Question Title
		textImgSetPos(
			txt_shopPurchaseQuestion,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.question.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.question.offset[2]
		)
		textImgDraw(txt_shopPurchaseQuestion)
	--Draw Balance Text
	--Before Purchase
		textImgSetPos(
			txt_shopBalanceOld,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.balance.old.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.balance.old.offset[2]
		)
		textImgSetText(txt_shopBalanceOld, currency.getMoney()..motifCurrency.currency_info.currency.suffix)
		textImgDraw(txt_shopBalanceOld)
	--After Purchase
		textImgSetPos(
			txt_shopBalanceNew,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.balance.new.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.balance.new.offset[2]
		)
		textImgSetText(
			txt_shopBalanceNew,
			currency.getMoney() - t_shopMenu[shopCategoryNo][item].price..motifCurrency.currency_info.currency.suffix
		)
		textImgDraw(txt_shopBalanceNew)
	--Draw Balance Arrow Sprite
		animSetWindow(spr_balanceArrow, motifShop.shop_info.balance.arrow.window[1], motifShop.shop_info.balance.arrow.window[2], motifShop.shop_info.balance.arrow.window[3], motifShop.shop_info.balance.arrow.window[4])
		main.f_animPosDraw(
			spr_balanceArrow,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.balance.arrow.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.balance.arrow.offset[2],
			motifShop.shop_info.balance.arrow.facing
		)
	--Draw Purchase Options Text
	--Yes
		textImgSetFont(txt_shopPurchaseYes, motifShop.fontData[fontYes])
		textImgSetBank(txt_shopPurchaseYes, bankYes)
		textImgSetAlign(txt_shopPurchaseYes, alignYes)
		textImgSetColor(txt_shopPurchaseYes, rYes, gYes, bYes, 255)
		textImgSetPos(txt_shopPurchaseYes, xYes, yYes)
		textImgSetScale(txt_shopPurchaseYes, scaleXYes, scaleYYes)
		textImgDraw(txt_shopPurchaseYes)
	else
	--Draw Info Title
		infoTextActive = f_textRender(
			txt_shopPurchaseInfo,
			motifShop.shop_info.purchase.info.text,
			infoTextCnt,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.info.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.info.offset[2],
			motifShop.shop_info.purchase.info.scale[1],
			motifShop.shop_info.purchase.info.scale[2],
			motifShop.shop_info.purchase.info.spacing,
			motifShop.shop_info.purchase.info.delay,
			motifShop.shop_info.purchase.info.length
		)
		if infoTextActive > 0 then infoTextCnt = infoTextCnt + 1 end
		cursorText = motifShop.shop_info.purchase.ok.text
	end
--No/Accept
	textImgSetFont(txt_shopPurchaseNo, motifShop.fontData[fontNo])
	textImgSetBank(txt_shopPurchaseNo, bankNo)
	textImgSetAlign(txt_shopPurchaseNo, alignNo)
	textImgSetColor(txt_shopPurchaseNo, rNo, gNo, bNo, 255)
	textImgSetPos(txt_shopPurchaseNo, xNo, yNo)
	textImgSetScale(txt_shopPurchaseNo, scaleXNo, scaleYNo)
	textImgSetText(txt_shopPurchaseNo, cursorText)
	textImgDraw(txt_shopPurchaseNo)
--Draw Cursor
	if motifShop.shop_info.purchase.boxcursor.visible == 1 and not fadeActive() then
		local x1 = motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.boxcursor.coords[1] + (purchaseCursor - 1) * motifShop.shop_info.purchase.boxcursor.spacing[1]
		local y1 = motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.boxcursor.coords[2] + (purchaseCursor - 1) * motifShop.shop_info.purchase.boxcursor.spacing[2]
		local w  = motifShop.shop_info.purchase.boxcursor.coords[3] - motifShop.shop_info.purchase.boxcursor.coords[1] + 1
		local h  = motifShop.shop_info.purchase.boxcursor.coords[4] - motifShop.shop_info.purchase.boxcursor.coords[2] + 1
		rectSetColor(
			rect_purchaseboxcursor,
			motifShop.shop_info.purchase.boxcursor.col[1],
			motifShop.shop_info.purchase.boxcursor.col[2],
			motifShop.shop_info.purchase.boxcursor.col[3]
		)
		rectSetAlphaPulse(
			rect_purchaseboxcursor,
			motifShop.shop_info.menu.boxcursor.pulse[1],
			motifShop.shop_info.menu.boxcursor.pulse[2],
			motifShop.shop_info.menu.boxcursor.pulse[3]
		)
		rectSetWindow(rect_purchaseboxcursor, x1, y1, x1 + w, y1 + h)
		rectUpdate(rect_purchaseboxcursor)
		rectDraw(rect_purchaseboxcursor)
--Draw Custom Cursor if purchase.boxcursor.visible is 0
	else
		animSetWindow(spr_purchaseCursor, motifShop.shop_info.purchase.cursor.window[1], motifShop.shop_info.purchase.cursor.window[2], motifShop.shop_info.purchase.cursor.window[3], motifShop.shop_info.purchase.cursor.window[4])
		main.f_animPosDraw(
			spr_purchaseCursor,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.purchase.cursor.offset[1] + (purchaseCursor - 1) * motifShop.shop_info.purchase.cursor.spacing[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.purchase.cursor.offset[2] + (purchaseCursor - 1) * motifShop.shop_info.purchase.cursor.spacing[2],
			motifShop.shop_info.purchase.cursor.facing
		)
	end
end

local function f_shopMenu()
	if motifShop.shop_info.reload.enabled == 1 then f_loadShop() end --Reload shop data (items.def & items.sff files) each time that shop menu is initialized
	if #t_shopMenu == 0 then return end --If there is not shop data, return to main menu
--If there is shop data, enter in shop menu
	main.f_unlock(true) --Check Shop Items Discovery/Unlocks
	bgReset(motifShop.shopbgdef.BGDef)
	fadeInInit(motifShop.shop_info.fadein.FadeData)
	main.close = false
	sndPlay(motifShop.sndData, motifShop.shop_info.cursor.done.snd[1], motifShop.shop_info.cursor.done.snd[2])
	if motifShop.music.menu.bgm ~= '' then
		playBgm({
			bgm = motifShop.music.menu.bgm,
			loop = tonumber(motifShop.music.menu.loop),
			volume = tonumber(motifShop.music.menu.volume),
			loopstart = tonumber(motifShop.music.menu.loopstart),
			loopend = tonumber(motifShop.music.menu.loopend),
			startposition = tonumber(motifShop.music.menu.startposition),
			freqmul = tonumber(motifShop.music.menu.freqmul),
			loopcount = tonumber(motifShop.music.menu.loopcount),
			interrupt = true
		})
	end
	local cursorPosY = 1
	local moveTxt = 0
	local item = 1
	currentCursor = item
	f_resetInfoTxt()
	f_confirmShopReset()
	shopCategoryNo = 1
	resetShopAnim = true
	local function f_resetCursor()
		resetShopAnim = true
		cursorPosY = 1
		moveTxt = 0
		item = 1
		if gameOption('Debug.DumpLuaTables') then main.f_printTable(t_shopMenu, "debug/t_shopMenu.txt") end
	end
	local enoughMoney = nil
	local inCategory = true --Start inside Category 1
	local nameTextData = nil
	local infoTextData = ""
	local infoPriceData = nil
	local categoryTitle = ""
	local currencyTextData = nil
	local unlockItem = nil
	while true do
		local offx = 0
		local offy = 0
	--effective visible-items: treat 0 or 'unlimitedItems' as "all"
		local visible = (motifShop.shop_info.menu.window and motifShop.shop_info.menu.window.visibleitems) or #t_shopMenu[shopCategoryNo]
		if not visible or visible <= 0 then
			visible = #t_shopMenu[shopCategoryNo]
		end
		clearColor(motifShop.shopbgdef.bgclearcolor[1], motifShop.shopbgdef.bgclearcolor[2], motifShop.shopbgdef.bgclearcolor[3])
	--Layerno = 0 backgrounds
		bgDraw(motifShop.shopbgdef.BGDef, 0)
	--Draw Item Preview BG
		animSetWindow(spr_previewBG, motifShop.shop_info.preview.bg.window[1], motifShop.shop_info.preview.bg.window[2], motifShop.shop_info.preview.bg.window[3], motifShop.shop_info.preview.bg.window[4])
		main.f_animPosDraw(
			spr_previewBG,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.preview.bg.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.preview.bg.offset[2],
			motifShop.shop_info.preview.bg.facing
		)
	--Draw Menu Box
		if motifShop.shop_info.menu.boxbg.visible == 1 then
			local x1 = offx + motifShop.shop_info.menu.pos[1] + motifShop.shop_info.menu.boxcursor.coords[1]
			local y1 = offy + motifShop.shop_info.menu.pos[2] + motifShop.shop_info.menu.boxcursor.coords[2]
			local w = motifShop.shop_info.menu.boxcursor.coords[3] - motifShop.shop_info.menu.boxcursor.coords[1] + 1
			local h = motifShop.shop_info.menu.boxcursor.coords[4] - motifShop.shop_info.menu.boxcursor.coords[2] + 1 + (math.min(#t_shopMenu[shopCategoryNo], motifShop.shop_info.menu.window.visibleitems) - 1) * motifShop.shop_info.menu.item.spacing[2]
			rectSetColor(
				rect_boxbg,
				motifShop.shop_info.menu.boxbg.col[1],
				motifShop.shop_info.menu.boxbg.col[2],
				motifShop.shop_info.menu.boxbg.col[3]
			)
			rectSetAlpha(
				rect_boxbg,
				motifShop.shop_info.menu.boxbg.alpha[1],
				motifShop.shop_info.menu.boxbg.alpha[2]
			)
			rectSetWindow(rect_boxbg, x1, y1, x1 + w, y1 + h)
			rectUpdate(rect_boxbg)
			rectDraw(rect_boxbg)
		end
	--Draw Menu Title Text
		textImgSetPos(
			txt_shopTitle,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.title.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.title.offset[2]
		)
		textImgDraw(txt_shopTitle)
	--Draw Category Title Text
		textImgSetText(txt_shopCategory, categoryTitle)
		textImgSetPos(
			txt_shopCategory,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.category.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.category.offset[2]
		)
		textImgDraw(txt_shopCategory)
	--Draw Currency Text
		currencyTextData = currency.getMoney()..motifCurrency.currency_info.currency.suffix
		textImgSetText(txt_shopCurrency, currencyTextData)
		textImgSetPos(
			txt_shopCurrency,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.currency.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.currency.offset[2]
		)
		textImgDraw(txt_shopCurrency)
	--Draw Menu Items
		local cur = moveTxt
		local tgt = moveTxt
		if motifShop.shop_info.menuTweenData then
			cur = motifShop.shop_info.menuTweenData.currentPos or motifShop.shop_info.menuTweenData.slideOffset or cur
			tgt = motifShop.shop_info.menuTweenData.targetPos or tgt
		end
		local tweenDone = math.abs((cur or 0) - (tgt or 0)) < 1
		local items_shown = item + visible - cursorPosY
		if items_shown > #t_shopMenu[shopCategoryNo] or (visible > 0 and items_shown < #t_shopMenu[shopCategoryNo] and (motifShop.shop_info.menu.window.margins.y[1] ~= 0 or motifShop.shop_info.menu.window.margins.y[2] ~= 0)) then
			items_shown = #t_shopMenu[shopCategoryNo]
		end
	--helper that draws a single item either as active or inactive
		local function drawItem(i, isActive)
		--Condition to Show Unlocked Content
			local itemData = t_shopMenu[shopCategoryNo][i]
		--If the item has been Discovered
			if main.t_unlockLua.shop[t_shopMenu[shopCategoryNo][item].id] == nil then
				unlockItem = true
		--Item not Discovered
			else
				unlockItem = false
			end
			if main.t_unlockLua.shop[itemData.id] == nil then
				if itemData.displayname ~= "" then
					itemData.displayname = t_shopMenu[shopCategoryNo][i].displaynameunlocked
				end
				if itemData.vardisplay ~= nil and shopDat ~= nil and shopDat.shopstock ~= nil and shopDat.shopstock[t_shopMenu[shopCategoryNo].category] ~= nil and not shopDat.shopstock[t_shopMenu[shopCategoryNo].category][itemData.id] then
					itemData.vardisplay = motifShop.shop_info.menu.itemname.purchased
				else
					itemData.vardisplay = motifShop.shop_info.menu.itemname.new
				end
			else
				if itemData.displayname ~= "" then
					itemData.displayname = motifShop.shop_info.menu.itemname.unknown
				end
				if itemData.vardisplay ~= nil then
					itemData.vardisplay = ""
				end
			end
		--display name
			local displayname = itemData.displayname
			if itemData.itemname:match("^spacer%d*$") then
				displayname = ""
			end
		--shared position
			local posX = offx + motifShop.shop_info.menu.pos[1] + (i - 1) * motifShop.shop_info.menu.item.spacing[1]
			local posY = offy + motifShop.shop_info.menu.pos[2] + (i - 1) * motifShop.shop_info.menu.item.spacing[2] - moveTxt
	--[[
		--background params
			local bgTable = isActive and motifShop.shop_info.menu.item.active.bg or motifShop.shop_info.menu.item.bg
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
				labelSprite = isActive and motifShop.shop_info.menu.item.selected.active.TextSpriteData or motifShop.shop_info.menu.item.selected.TextSpriteData
			else
				labelSprite = isActive and motifShop.shop_info.menu.item.active.TextSpriteData or motifShop.shop_info.menu.item.TextSpriteData
			end
			textImgReset(labelSprite)
			textImgAddPos(labelSprite, posX, posY)
			textImgSetText(labelSprite, displayname)
			textImgDraw(labelSprite)
		--value / info sprites
			if itemData.vardisplay ~= nil then
				if itemData.conflict and motifShop.shop_info.menu.item.value.conflict and motifShop.shop_info.menu.item.value.conflict.TextSpriteData then
					local spr = motifShop.shop_info.menu.item.value.conflict.TextSpriteData
					textImgReset(spr)
					textImgAddPos(spr, posX, posY)
					textImgSetText(spr, itemData.vardisplay)
					textImgDraw(spr)
				else
					local spr = isActive and motifShop.shop_info.menu.item.value.active.TextSpriteData or motifShop.shop_info.menu.item.value.TextSpriteData
					textImgReset(spr)
					textImgAddPos(spr, posX, posY)
					textImgSetText(spr, itemData.vardisplay)
					textImgDraw(spr)
				end
			elseif itemData.infodisplay ~= nil then
				local spr = isActive and motifShop.shop_info.menu.item.info.active.TextSpriteData or motifShop.shop_info.menu.item.info.TextSpriteData
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
		if not motifShop.shop_info.boxCursorData then
			motifShop.shop_info.boxCursorData = {
				offsetY = 0, 
				snap = 0, 
				init = false
			}
		end
	--calculate target Y position for cursor
		local targetY = offy + motifShop.shop_info.menu.pos[2] + motifShop.shop_info.menu.boxcursor.coords[2] + (cursorPosY - 1) * motifShop.shop_info.menu.item.spacing[2]
		local t_factor = motifShop.shop_info.menu.boxcursor.tween.factor
	--snap cursor immediately if first use or snap enabled
		if motifShop.shop_info.boxCursorData.snap == 1 or not motifShop.shop_info.boxCursorData.init then
			motifShop.shop_info.boxCursorData.offsetY = targetY
			motifShop.shop_info.boxCursorData.init = true
			motifShop.shop_info.boxCursorData.snap = -1
		end
		if motifShop.shop_info.menu.boxcursor.tween.wrap.snap and main.menuWrapped then
			motifShop.shop_info.boxCursorData.offsetY = targetY
		end
	--apply tween if enabled, otherwise snap to target
		if t_factor[1] > 0 then
			motifShop.shop_info.boxCursorData.offsetY = f_tweenStep(motifShop.shop_info.boxCursorData.offsetY, targetY, t_factor[1])
		else
			motifShop.shop_info.boxCursorData.offsetY = targetY
		end
	--Draw menu cursor
		if motifShop.shop_info.menu.boxcursor.visible == 1 and not confirmPurchase and not fadeActive() then
			local x1 = offx + motifShop.shop_info.menu.pos[1] + motifShop.shop_info.menu.boxcursor.coords[1] + (cursorPosY - 1) * motifShop.shop_info.menu.item.spacing[1]
			local y1 = motifShop.shop_info.boxCursorData.offsetY
			local w  = motifShop.shop_info.menu.boxcursor.coords[3] - motifShop.shop_info.menu.boxcursor.coords[1] + 1
			local h  = motifShop.shop_info.menu.boxcursor.coords[4] - motifShop.shop_info.menu.boxcursor.coords[2] + 1
			rectSetColor(
				rect_boxcursor,
				motifShop.shop_info.menu.boxcursor.col[1],
				motifShop.shop_info.menu.boxcursor.col[2],
				motifShop.shop_info.menu.boxcursor.col[3]
			)
			rectSetAlphaPulse(
				rect_boxcursor,
				motifShop.shop_info.menu.boxcursor.pulse[1],
				motifShop.shop_info.menu.boxcursor.pulse[2],
				motifShop.shop_info.menu.boxcursor.pulse[3]
			)
			rectSetWindow(rect_boxcursor, x1, y1, x1 + w, y1 + h)
			rectUpdate(rect_boxcursor)
			rectDraw(rect_boxcursor)
		end
	--Draw Scroll Arrows
		if #t_shopMenu[shopCategoryNo] > visible then
			if item > cursorPosY then
				animReset(motifShop.shop_info.menu.arrow.up.AnimData, {'pos'})
				animSetPos(motifShop.shop_info.menu.arrow.up.AnimData, motifShop.shop_info.menu.arrow.up.offset[1], motifShop.shop_info.menu.arrow.up.offset[2])
				animUpdate(motifShop.shop_info.menu.arrow.up.AnimData)
				animDraw(motifShop.shop_info.menu.arrow.up.AnimData)
			end
			if item >= cursorPosY and item + visible - cursorPosY < #t_shopMenu[shopCategoryNo] then
				animReset(motifShop.shop_info.menu.arrow.down.AnimData, {'pos'})
				animSetPos(motifShop.shop_info.menu.arrow.down.AnimData, motifShop.shop_info.menu.arrow.down.offset[1], motifShop.shop_info.menu.arrow.down.offset[2])
				animUpdate(motifShop.shop_info.menu.arrow.down.AnimData)
				animDraw(motifShop.shop_info.menu.arrow.down.AnimData)
			end
		end
	--Draw Items Stuff
		if inCategory then --If are inside a category
			f_drawShopItemPreview(t_shopMenu[shopCategoryNo].category:lower(), item, unlockItem)
			if unlockItem then --if the item has been Discovered
			--Draw Shop Item Price Info
				if shopDat.shopstock[t_shopMenu[shopCategoryNo].category][t_shopMenu[shopCategoryNo][item].id] then
					infoPriceData = t_shopMenu[shopCategoryNo][item].price..motifCurrency.currency_info.currency.suffix
				else
					infoPriceData = motifShop.shop_info.price.sold
				end
				textImgSetText(txt_shopPriceInfo, infoPriceData)
				textImgSetPos(
					txt_shopPriceInfo,
					motifShop.shop_info.menu.pos[1] + motifShop.shop_info.price.offset[1],
					motifShop.shop_info.menu.pos[2] + motifShop.shop_info.price.offset[2]
				)
				textImgDraw(txt_shopPriceInfo)
			end
		end
	--Draw Shop Item Info
		textImgSetText(txt_shopItemInfo, infoTextData)
		textImgSetPos(
			txt_shopItemInfo,
			motifShop.shop_info.menu.pos[1] + motifShop.shop_info.info.offset[1],
			motifShop.shop_info.menu.pos[2] + motifShop.shop_info.info.offset[2]
		)
		textImgDraw(txt_shopItemInfo)
	--Attract Credits/Coins
		if motif.attract_mode.enabled and getCredits() ~= -1 then
			textImgReset(motif.attract_mode.credits.TextSpriteData)
			textImgSetText(motif.attract_mode.credits.TextSpriteData, string.format(motif.attract_mode.credits.text, getCredits()))
			textImgDraw(motif.attract_mode.credits.TextSpriteData)
		end
	--Layerno = 1 backgrounds
		bgDraw(motifShop.shopbgdef.BGDef, 1)
--;---------------------------------------------------------------------------------------------------------------------
		if not confirmPurchase then
			if not fadeActive() then
				if inCategory then
					cursorPosY, moveTxt, item = main.f_menuCommonCalc(t_shopMenu[shopCategoryNo], item, cursorPosY, moveTxt, motifShop.shop_info, motifShop.shop_info.cursor)
				--else
				--	cursorPosY, moveTxt, shopCategoryNo = main.f_menuCommonCalc(t_shopMenu, shopCategoryNo, cursorPosY, moveTxt, motifShop.shop_info, motifShop.shop_info.cursor)
				end
				if currentCursor ~= item then
					f_resetInfoTxt()
					currentCursor = item
				end
			end
		--Close Menu
			if main.close and not fadeActive() then
				bgReset(motifShop.shopbgdef.BGDef)
				fadeInInit(motifShop.shop_info.fadein.FadeData)
				playBgm({source = "motif.title", interrupt = true})
				main.close = false
				main.f_unlock(true) --Check Menu Unlocks
				currencyDat.moneyOLD = currency.getMoney() --Refresh player currency backup to do calculations
				break
			elseif (esc() or getInput(-1, motifShop.shop_info.menu.cancel.key)) and not main.close then
				sndPlay(motifShop.sndData, motifShop.shop_info.cancel.snd[1], motifShop.shop_info.cancel.snd[2])
			--Back to Category Select
				--if inCategory then
				--	f_resetCursor()
				--	inCategory = false
			--Exit to Main Menu
				--else
					fadeOutInit(motifShop.shop_info.fadeout.FadeData)
					main.close = true
				--end
		--Previous Category
			elseif getInput(-1, motifShop.shop_info.menu.previouscategory.key) and inCategory and not fadeActive() then
				sndPlay(motifShop.sndData, motifShop.shop_info.cursor.category.snd[1], motifShop.shop_info.cursor.category.snd[2])
				f_resetCursor()
				shopCategoryNo = shopCategoryNo - 1
		--Next Category
			elseif getInput(-1, motifShop.shop_info.menu.nextcategory.key) and inCategory and not fadeActive() then
				sndPlay(motifShop.sndData, motifShop.shop_info.cursor.category.snd[1], motifShop.shop_info.cursor.category.snd[2])
				f_resetCursor()
				shopCategoryNo = shopCategoryNo + 1
		--Previous Item
			elseif getInput(-1, motifShop.shop_info.menu.next.key) and not fadeActive() then
				resetShopAnim = true
				if inCategory then
					--item = item - 1 --This is already managed by main.f_menuCommonCalc
				else
					shopCategoryNo = shopCategoryNo - 1
				end
		--Next Item
			elseif getInput(-1, motifShop.shop_info.menu.previous.key) and not fadeActive() then
				resetShopAnim = true
				if inCategory then
					--item = item + 1 --This is already managed by main.f_menuCommonCalc
				else
					shopCategoryNo = shopCategoryNo + 1
				end
		--Enter Actions
			elseif getInput(-1, motifShop.shop_info.menu.done.key) and not fadeActive() then
			--Outside a Category
				if not inCategory then
				--Open Category (Items Available)
					if #t_shopMenu[shopCategoryNo] ~= 0 then
						sndPlay(motifShop.sndData, motifShop.shop_info.cursor.done.snd[1], motifShop.shop_info.cursor.done.snd[2])
						f_resetCursor()
						inCategory = true
				--Can't Open Category (No Items Available)
					else
						sndPlay(motifShop.sndData, motifShop.shop_info.cursor.error.snd[1], motifShop.shop_info.cursor.error.snd[2])
					end
			--Inside a Category
				else
				--Purchase item
					if shopDat.shopstock[t_shopMenu[shopCategoryNo].category][t_shopMenu[shopCategoryNo][item].id] and unlockItem then
						sndPlay(motifShop.sndData, motifShop.shop_info.cursor.done.snd[1], motifShop.shop_info.cursor.done.snd[2])
						if currency.getMoney() >= t_shopMenu[shopCategoryNo][item].price then
							enoughMoney = true
						else --No enough Money
							enoughMoney = false
						end
						confirmPurchase = true --Show Confirm Purchase
				--Item Sold Out or Item has not been discovered
					else
						sndPlay(motifShop.sndData, motifShop.shop_info.cursor.error.snd[1], motifShop.shop_info.cursor.error.snd[2])
					end
				end
			end
		else
			f_confirmPurchase(item, enoughMoney) --Show Purchase Screen
		end
	--Category Cursor Pos
		if shopCategoryNo < 1 then
			shopCategoryNo = #t_shopMenu
		elseif shopCategoryNo > #t_shopMenu then
			shopCategoryNo = 1
		end
	--Show Category Data
		if not inCategory then
			categoryTitle = motifShop.shop_info.category_text
			infoTextData = t_shopMenu[shopCategoryNo].info
	--Show Item Data
		else
			categoryTitle = t_shopMenu[shopCategoryNo].category
			if unlockItem then --If the item has been Discovered
				infoTextData = t_shopMenu[shopCategoryNo][item].info
			else
				infoTextData = motifShop.shop_info.info.locked
			end
		end
		if not confirmPurchase then cmdInput = true end --To avoid issues with inputs in f_confirmPurchase()
		refresh()
	end
end

main.t_itemname.shop = function()
	return f_shopMenu()
end