--[[					GALLERY MODULE
===================================================================
Version: 1.3.0
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0-rc.3)
Description: Adds a Custom Gallery Mode entry to the Main Menu.

TODO: Implement Multiple Artworks in a same Slot/Cell to Switch in Artwork Viewer.
===================================================================
]]
local galleryMotifPath = "external/mods/gallery/galleryMenu.def" --Set the motifGallery/Screenpack Definition File Path
local gallerySavePath = "save/galleryDat.json" --Set the Gallery Save Data File Path
--===================================================================================
--								 COMMON FUNCTIONS
--===================================================================================
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

--shortcut for updating text
local function f_updateTextImg(t, sect, textData)
	local section = f_readSubtable(t, sect)
	if not section then return nil end
	textImgSetFont(textData, motifGallery.fontData[section.font[1]] or -1)
	textImgSetBank(textData, section.font[2] or 0)
	textImgSetAlign(textData, section.font[3] or 0)
	textImgSetColor(textData, section.font[4] or 255, section.font[5] or 255, section.font[6] or 255, section.font[7] or 255)
	if section.localcoord ~= nil then --Need to be ALWAYS BEFORE textImgSetPos() to draw the text
		textImgSetLocalcoord(textData, section.localcoord[1], section.localcoord[2])
	else
		textImgSetLocalcoord(textData, motifGallery.info.localcoord[1], motifGallery.info.localcoord[2])
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
		textImgSetWindow(textData, 0, 0, motifGallery.info.localcoord[1], motifGallery.info.localcoord[2])
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
	animSetLocalcoord(animData, motifGallery.info.localcoord[1], motifGallery.info.localcoord[2]) --Need to be ALWAYS BEFORE animSetPos() to draw the animation/sprite
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
		animSetWindow(animData, 0, 0, motifGallery.info.localcoord[1], motifGallery.info.localcoord[2])
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
--Use [Files] "common.sff = " data from module galleryMotifPath, instead system.def file
	else
		sffDat = motifGallery.commonSprData
	end
--Use Animations/Actions data from system.def file
	if (moduleActions and motifGallery.commonAirData == nil) or not moduleActions then
		airDat = motif.AnimTable
--Use [Files] "common.air = " data from module galleryMotifPath, instead system.def file
	else
		airDat = motifGallery.commonAirData
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
--								GALLERY DATA GENERATION
--===================================================================================
motifGallery = loadIni(galleryMotifPath) --Load motifGallery/Screenpack Data
if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifGallery, "debug/galleryMenuMotif.txt") end

local file = io.open(gallerySavePath, "r") --Check that file exists
if not file then
	file = io.open(gallerySavePath, "w") --Create file
	file:write("{}")
	file:close() --Close file in writting mode
else
	file:close() --Close file in reading mode
end
--Data loading from gallerySavePath
galleryDat = jsonDecode(gallerySavePath)

--Data saving to gallerySavePath
local function f_saveGalleryData()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(galleryDat, 'debug/t_galleryDat.txt') end --Print Debug Info
	jsonEncode(galleryDat, gallerySavePath) --Write in gallerySavePath file
end

--Refresh t_unlockLua table
local function f_refreshUnlockDat()
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
end

local t_gallery = {}
local function f_loadGallery(path, reset) --Load def file which contains gallery data
	if reset then t_gallery = {} end
	local category = ""
	local section = 0
	local item = 0
	local slot = false
	local content = main.f_fileRead(path)
	content = content:gsub('([^\r\n;]*)%s*;[^\r\n]*', '%1')
	content = content:gsub('\n%s*\n', '\n')
	for line in content:gmatch('[^\r\n]+') do
		local lineCase = line:lower()
		if lineCase:match('^%s*%[%s*galleryartworks%s*%]') then
			section = 1
			category = "artwork"
			t_gallery[section] = {}
	--[[elseif lineCase:match('^%s*%[%s*artworkslot%s*(%d+)%s*%]') then
			item = item + 1
			if item < #t_gallery[section] then
				section = 1
				category = "artwork"
				slot = true
			end]]
		elseif lineCase:match('^%s*%[%s*gallerystoryboards%s*%]') then
			section = 2
			category = "storyboard"
			t_gallery[section] = {}
		elseif lineCase:match('^%s*%[%s*gallerymusic%s*%]') then
			section = 3
			category = "music"
			t_gallery[section] = {}
		elseif lineCase:match('^%s*%[%w+%]$') then
			section = -1
	--Section Recognition
		elseif section == 1 or section == 2 or section == 3 then
			local param, value = line:match('^%s*(.-)%s*=%s*(.-)%s*$')
			if param ~= nil and value ~= nil and param ~= '' and value ~= '' then
			--Generate Table to manage each item with default values
			--[[if lineCase:match('^%s*slot%s*=%s*{%s*$') then --start of the 'multiple artworks in one slot' assignment
					table.insert(t_gallery[section], {['slot'] = 1})
					slot = true
				elseif slot and lineCase:match('^%s*}%s*$') then --end of 'multiple artworks in one slot' assignment
					slot = false
				end]]
				if param:match('^id$') then
				--[GalleryArtworks]
					if section == 1 then
						table.insert(t_gallery[section],
							{
								--slot = {},
								id = value,
								spr = {},
								size = motifGallery.artviewer_info.art.size,
								pos = motifGallery.artviewer_info.art.offset,
								scale = motifGallery.artviewer_info.art.scale,
								zoomlimit = motifGallery.artviewer_info.art.zoomlimit,
								movelimit = motifGallery.artviewer_info.art.movelimit,
								info = motifGallery.gallery_info.info.unknown,
								previewpos = motifGallery.gallery_info.cell.art.offset,
								previewspacing = motifGallery.gallery_info.cell.art.spacing,
								previewscale = motifGallery.gallery_info.cell.art.scale,
								unlock = 'true'
							}
						)
				--[[
					elseif section == 1 and slot then
						table.insert(t_gallery[section][item].slot,
							{
								id = value,
								spr = {},
								size = motifGallery.artviewer_info.art.size,
								pos = motifGallery.artviewer_info.art.offset,
								scale = motifGallery.artviewer_info.art.scale,
								zoomlimit = motifGallery.artviewer_info.art.zoomlimit,
								movelimit = motifGallery.artviewer_info.art.movelimit,
								info = motifGallery.gallery_info.info.unknown,
								previewpos = motifGallery.gallery_info.cell.art.offset,
								previewspacing = motifGallery.gallery_info.cell.art.spacing,
								previewscale = motifGallery.gallery_info.cell.art.scale,
								unlock = 'true'
							}
						)
				]]
				--[GalleryStoryboards] - [GalleryMusic]
					elseif section == 2 or section == 3 then
						table.insert(t_gallery[section],
							{
								id = value,
								path = "",
								info = motifGallery.gallery_info.info.unknown,
								volume = 100,
								loopstart = 0,
								loopend = 0,
								loopcount = -1,
								startposition = 0,
								freqmul = 1.0,
								previewspr = {},
								previewsize = motifGallery.gallery_info.cell[category].size,
								previewpos = motifGallery.gallery_info.cell[category].offset,
								previewspacing = motifGallery.gallery_info.cell[category].spacing,
								previewscale = motifGallery.gallery_info.cell[category].scale,
								unlock = 'true'
							}
						)
					end
			--Store comma separated number values to table
				elseif param:match('^spr$') or param:match('^size$') or param:match('^pos$') or param:match('^scale$') or param:match('^zoomlimit$') or param:match('^movelimit$')
				or param:match('^previewspr$') or param:match('^previewpos$') or param:match('^previewspacing$') or param:match('^previewsize$') or param:match('^previewscale$') then
					local tbl = {}
					for num in value:gmatch('([^,]+)') do
						table.insert(tbl, tonumber(num))
					end
					t_gallery[section][#t_gallery[section]][param] = tbl
			--Store extra values
				elseif t_gallery[section][#t_gallery[section]][param] ~= nil then
					t_gallery[section][#t_gallery[section]][param] = value
				end
			end
		end
	end
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(t_gallery, 'debug/t_gallery.txt') end
--Set Unlock Conditions
	for i=1, #t_gallery do
		for k, v in ipairs(t_gallery[i]) do
			if main.t_unlockLua.gallery == nil then main.t_unlockLua['gallery'] = {} end
			main.t_unlockLua.gallery[v.id] = v.unlock
		end
	end
--Load .sff files (only if .def data is detected)
	if category == "artwork" then
		if main.f_fileExists(motifGallery.files.artworks.def) then
			t_gallery[1].name = motifGallery.gallery_info.title.artworks
			if main.f_fileExists(motifGallery.files.artworks.sff) then
				motifGallery.artworksSprData = sffNew(motifGallery.files.artworks.sff)
			else
				motifGallery.artworksSprData = sffNew()
			end
		end
	elseif category == "storyboard" then
		if main.f_fileExists(motifGallery.files.storyboards.def) then
			t_gallery[2].name = motifGallery.gallery_info.title.storyboards
			if main.f_fileExists(motifGallery.files.storyboards.sff) then
				motifGallery.storyboardsSprData = sffNew(motifGallery.files.storyboards.sff)
			else
				motifGallery.storyboardsSprData = sffNew()
			end
		end
	elseif category == "music" then
		if main.f_fileExists(motifGallery.files.music.def) then
			t_gallery[3].name = motifGallery.gallery_info.title.music
			if main.f_fileExists(motifGallery.files.music.sff) then
				motifGallery.musicSprData = sffNew(motifGallery.files.music.sff)
			else
				motifGallery.musicSprData = sffNew()
			end
		end
	end
	if gameOption('Debug.DumpLuaTables') then main.f_printTable(t_gallery, 'debug/t_gallery.txt') end
end

local function f_loadFiles()
--Load common sprites from [Files] "common.sff"
	if motifGallery.files.common.sff ~= nil and main.f_fileExists(motifGallery.files.common.sff) then
		motifGallery.commonSprData = sffNew(motifGallery.files.common.sff)
	else
		motifGallery.commonSprData = sffNew() --Create blank sprite data
	end
--Load common sounds from [Files] "common.snd"
	if motifGallery.files.common.snd ~= nil and main.f_fileExists(motifGallery.files.common.snd) then
		motifGallery.commonSndData = sndNew(motifGallery.files.common.snd)
	else
		motifGallery.commonSndData = motif.Snd --Use default system.def sound data
	end
--Load fonts from [Fonts] section
	motifGallery.fontData = motif.Fnt --Use default system.def font data
	if motifGallery.fonts ~= nil then --If gallery fonts section is detected, replace Default Data with Custom Data
		local i = 1
		while motifGallery.fonts["font"..i] ~= nil do
			motifGallery.fontData[i] = fontNew(motifGallery.fonts["font"..i])
			i = i + 1
		end
	end
--Load .def file with Artworks
	if motifGallery.files.artworks.def ~= nil and main.f_fileExists(motifGallery.files.artworks.def) then
		artworksDef = motifGallery.files.artworks.def
	else
		artworksDef = motifGallery.files.select
	end
	f_loadGallery(artworksDef, true) --Load gallery artworks data
--Load .def file with Storyboards
	if motifGallery.files.storyboards.def ~= nil and main.f_fileExists(motifGallery.files.storyboards.def) then
		storyboardsDef = motifGallery.files.storyboards.def
	else
		storyboardsDef = motifGallery.files.select
	end
	f_loadGallery(storyboardsDef) --Load gallery storyboards data
--Load .def with Music
	if motifGallery.files.music.def ~= nil and main.f_fileExists(motifGallery.files.music.def) then
		musicDef = motifGallery.files.music.def
	else
		musicDef = motifGallery.files.select
	end
	f_loadGallery(musicDef) --Load gallery music data
end
f_loadFiles() --Load gallery data (.def & .sff files) when engine starts
--===================================================================================
--								GALLERY ASSETS GENERATION
--===================================================================================
--[[Background data
Refer to official Elecbyte docs for information how to define backgrounds:
http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements

I.K.E.M.E.N. Features:
https://github.com/ikemen-engine/Ikemen-GO/wiki/Background-features
]]
local sffBGDatMenu = nil
if motifGallery.gallerybgdef.spr ~= nil and main.f_fileExists(motifGallery.gallerybgdef.spr) then
	sffBGDatMenu = sffNew(motifGallery.gallerybgdef.spr) --Load a dedicate sprite .sff file
else
	sffBGDatMenu = motif.Sff --Load default system.sff data
end
local modelBGDatMenu = nil
if motifGallery.gallerybgdef.model ~= nil and main.f_fileExists(motifGallery.gallerybgdef.model) then
	modelBGDatMenu = modelNew(motifGallery.gallerybgdef.model) --Load a dedicate 3D Model object
end
motifGallery.gallerybgdef.BGDef = bgNew(sffBGDatMenu, galleryMotifPath, 'gallerybg', modelBGDatMenu)

local sffBGDatArtviewer = nil
if motifGallery.artviewerbgdef.spr ~= nil and main.f_fileExists(motifGallery.artviewerbgdef.spr) then
	sffBGDatArtviewer = sffNew(motifGallery.artviewerbgdef.spr)
else
	sffBGDatArtviewer = motif.Sff
end
local modelBGDatArtviewer = nil
if motifGallery.artviewerbgdef.model ~= nil and main.f_fileExists(motifGallery.artviewerbgdef.model) then
	modelBGDatArtviewer = modelNew(motifGallery.artviewerbgdef.model)
end
motifGallery.artviewerbgdef.BGDef = bgNew(sffBGDatArtviewer, galleryMotifPath, 'artviewerbg', modelBGDatArtviewer)

local sffBGDatMusicPlayer = nil
if motifGallery.musicplayerbgdef.spr ~= nil and main.f_fileExists(motifGallery.musicplayerbgdef.spr) then
	sffBGDatMusicPlayer = sffNew(motifGallery.musicplayerbgdef.spr)
else
	sffBGDatMusicPlayer = motif.Sff
end
local modelBGDatMusicPlayer = nil
if motifGallery.musicplayerbgdef.model ~= nil and main.f_fileExists(motifGallery.musicplayerbgdef.model) then
	modelBGDatMusicPlayer = modelNew(motifGallery.musicplayerbgdef.model)
end
motifGallery.musicplayerbgdef.BGDef = bgNew(sffBGDatMusicPlayer, galleryMotifPath, 'musicplayerbg', modelBGDatMusicPlayer)

--Text Data
local txt_titleMenu = f_createTextImg(motifGallery.gallery_info, 'title')
local txt_previewInfo = f_createTextImg(motifGallery.gallery_info, 'info')
local txt_noData = "NO ARTWORK DATA FOUND."
local txt_pageInfo = f_createTextImg(motifGallery.artviewer_info, 'page')
local txt_artInfo = f_createTextImg(motifGallery.artviewer_info, 'info')
local artPosX = nil
local artPosY = nil
local artScaleX = nil
local artScaleY = nil
local infoTextCnt = 0
local infoTextActive = 1
local function f_resetInfoTxt()
	infoTextCnt = 0
	infoTextActive = 1
end
local txt_songInfo = f_createTextImg(motifGallery.musicplayer_info, 'info')

--Sprite Data
motifGallery.gallery_info.cell.bgData = f_createAnim(motifGallery.gallery_info, 'cell.bg', true, true)
motifGallery.gallery_info.cell.cursorData = f_createAnim(motifGallery.gallery_info, 'cell.cursor', true, true)
motifGallery.gallery_info.cell.lockedData = f_createAnim(motifGallery.gallery_info, 'cell.locked', true, true)
motifGallery.gallery_info.cell.unknownData = f_createAnim(motifGallery.gallery_info, 'cell.unknown', true, true)
motifGallery.gallery_info.cell.unknown.musicData = f_createAnim(motifGallery.gallery_info, 'cell.unknown.music', true, true)

motifGallery.artviewer_info.menu.arrow.left.AnimData = f_createAnim(motifGallery.artviewer_info, 'menu.arrow.left', true, true)
motifGallery.artviewer_info.menu.arrow.right.AnimData = f_createAnim(motifGallery.artviewer_info, 'menu.arrow.right', true, true)

motifGallery.musicplayer_info.menu.arrow.left.AnimData = f_createAnim(motifGallery.musicplayer_info, 'menu.arrow.left', true, true)
motifGallery.musicplayer_info.menu.arrow.right.AnimData = f_createAnim(motifGallery.musicplayer_info, 'menu.arrow.right', true, true)

local function f_drawPreview(animData, group, index, x, y, scaleX, scaleY, x1, y1, x2, y2, angle, xangle, yangle, focallength, projection, layerno)
	local anim = group..','..index..', 0,0, -1'
	anim = animNew(animData, anim)
	animSetLocalcoord(anim, motifGallery.info.localcoord[1], motifGallery.info.localcoord[2])
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

--Fade Data
if motifGallery.gallery_info.fadein.anim ~= -1 then
	motifGallery.gallery_info.fadein.AnimData = f_createAnim(motifGallery.gallery_info, 'fadein', false, false)
end
motifGallery.gallery_info.fadein.FadeData = fadeNew(motifGallery.gallery_info.fadein)

if motifGallery.artviewer_info.fadein.anim ~= -1 then
	motifGallery.artviewer_info.fadein.AnimData = f_createAnim(motifGallery.artviewer_info, 'fadein', false, false)
end
motifGallery.artviewer_info.fadein.FadeData = fadeNew(motifGallery.artviewer_info.fadein)

if motifGallery.musicplayer_info.fadein.anim ~= -1 then
	motifGallery.musicplayer_info.fadein.AnimData = f_createAnim(motifGallery.musicplayer_info, 'fadein', false, false)
end
motifGallery.musicplayer_info.fadein.FadeData = fadeNew(motifGallery.musicplayer_info.fadein)

--Fade Out
if motifGallery.gallery_info.fadeout.anim ~= -1 then
	motifGallery.gallery_info.fadeout.AnimData = f_createAnim(motifGallery.gallery_info, 'fadeout', false, false)
end
motifGallery.gallery_info.fadeout.FadeData = fadeNew(motifGallery.gallery_info.fadeout)

if motifGallery.artviewer_info.fadeout.anim ~= -1 then
	motifGallery.artviewer_info.fadeout.AnimData = f_createAnim(motifGallery.artviewer_info, 'fadeout', false, false)
end
motifGallery.artviewer_info.fadeout.FadeData = fadeNew(motifGallery.artviewer_info.fadeout)

if motifGallery.musicplayer_info.fadeout.anim ~= -1 then
	motifGallery.musicplayer_info.fadeout.AnimData = f_createAnim(motifGallery.musicplayer_info, 'fadeout', false, false)
end
motifGallery.musicplayer_info.fadeout.FadeData = fadeNew(motifGallery.musicplayer_info.fadeout)

if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifGallery, "debug/galleryMenuMotif.txt") end
--===========================================================================================
-- 									 DEBUG STUFF
--===========================================================================================
local t_debugTxT = {
	debugcursor = {
		offset = {10, 15},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debugcursorx = {
		offset = {10, 30},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debugcursory = {
		offset = {10, 45},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debuggallerymovex = {
		offset = {10, 60},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debuggallerymovey = {
		offset = {10, 75},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debugzoom = {
		offset = {10, 15},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debugxpos = {
		offset = {10, 30},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	},
	debugypos = {
		offset = {10, 45},
		font = {1, 0, 1, 255, 255, 255, -1},
		scale = {1.0, 1.0},
		text = ''
	}
}
local txt_debugCursor = f_createTextImg(t_debugTxT, 'debugcursor')
local txt_debugCursorX = f_createTextImg(t_debugTxT, 'debugcursorx')
local txt_debugCursorY = f_createTextImg(t_debugTxT, 'debugcursory')
local txt_debugGalleryMoveX = f_createTextImg(t_debugTxT, 'debuggallerymovex')
local txt_debugGalleryMoveY = f_createTextImg(t_debugTxT, 'debuggallerymovey')

local txt_debugZoom = f_createTextImg(t_debugTxT, 'debugzoom')
local txt_debugPosX = f_createTextImg(t_debugTxT, 'debugxpos')
local txt_debugPosY = f_createTextImg(t_debugTxT, 'debugypos')
--===================================================================================
--								 GALLERY MENU
--===================================================================================
local function f_playGalleryBGM(bgmpath, bgmloop, bgmvolume, bgmloopstart, bgmloopend, bgmstartposition, bgmfreqmul, bgmloopcount, bgminterrupt)
	if bgmpath ~= nil and bgmpath ~= '' then
		playBgm({
			bgm = bgmpath,
			loop = tonumber(bgmloop),
			volume = tonumber(bgmvolume),
			loopstart = tonumber(bgmloopstart),
			loopend = tonumber(bgmloopend),
			startposition = tonumber(bgmstartposition),
			freqmul = tonumber(bgmfreqmul),
			loopcount = tonumber(bgmloopcount),
			interrupt = bgminterrupt or true
		})
	end
end

local function f_restoreGalleryBGM()
	f_playGalleryBGM(
		motifGallery.music.menu.bgm,
		motifGallery.music.menu.loop,
		motifGallery.music.menu.volume,
		motifGallery.music.menu.loopstart,
		motifGallery.music.menu.loopend,
		motifGallery.music.menu.startposition,
		motifGallery.music.menu.freqmul,
		motifGallery.music.menu.loopcount
	)
end

local function f_drawGallery(t, columns, rows) --Draw Gallery Content
	for i=0, columns-1 do
		for j=0, rows-1 do
			local index = (i + columns * j) + 1 --This is the same logic of f_setCursorPos() function
			if index <= #t then
			--Draw Item Preview Cell BG
				main.f_animPosDraw(
					motifGallery.gallery_info.cell.bgData,
					motifGallery.gallery_info.menu.pos[1] + motifGallery.gallery_info.cell.bg.offset[1] + i * (motifGallery.gallery_info.cell.bg.size[1] + motifGallery.gallery_info.cell.bg.spacing[1]) - (galleryMoveX * (motifGallery.gallery_info.cell.bg.size[1] + motifGallery.gallery_info.cell.bg.spacing[1])),
					motifGallery.gallery_info.menu.pos[2] + motifGallery.gallery_info.cell.bg.offset[2] + j * (motifGallery.gallery_info.cell.bg.size[2] + motifGallery.gallery_info.cell.bg.spacing[2]) - (galleryMoveY * (motifGallery.gallery_info.cell.bg.size[2] + motifGallery.gallery_info.cell.bg.spacing[2])),
					motifGallery.gallery_info.cell.bg.facing
				)
				animSetWindow(motifGallery.gallery_info.cell.bgData, motifGallery.gallery_info.cell.bg.window[1], motifGallery.gallery_info.cell.bg.window[2], motifGallery.gallery_info.cell.bg.window[3], motifGallery.gallery_info.cell.bg.window[4])
			--Logic To Detect section data
				local sprData = nil
				local sprSize = nil
				local sprWindow = nil
				local sffData = nil
				local unknownData = nil
				local unknownPos = nil
				local unknownSpacing = nil
				local unknownSize = nil
				local unknownScale = nil
				local unknownFacing = nil
				local unknownWindow = nil
			--Artworks section
				if t_gallery[gallerySection].name == motifGallery.gallery_info.title.artworks then
					sprData = "spr"
					sprSize = "size"
					sprWindow = "art"
					sffData = motifGallery.artworksSprData
					unknownData = motifGallery.gallery_info.cell.unknownData
					unknownPos = motifGallery.gallery_info.cell.unknown.offset
					unknownSpacing = motifGallery.gallery_info.cell.unknown.spacing
					unknownSize = motifGallery.gallery_info.cell.unknown.size
					unknownScale = motifGallery.gallery_info.cell.unknown.scale
					unknowFacing = motifGallery.gallery_info.cell.unknown.facing
					unknownWindow = motifGallery.gallery_info.cell.unknown.window
			--Not Artworks section
				else
					sprData = "previewspr"
					sprSize = "previewsize"
					if t_gallery[gallerySection].name == motifGallery.gallery_info.title.storyboards then
						sffData = motifGallery.storyboardsSprData
						sprWindow = "storyboard"
						unknownData = motifGallery.gallery_info.cell.unknownData
						unknownPos = motifGallery.gallery_info.cell.unknown.offset
						unknownSpacing = motifGallery.gallery_info.cell.unknown.spacing
						unknownSize = motifGallery.gallery_info.cell.unknown.size
						unknownScale = motifGallery.gallery_info.cell.unknown.scale
						unknowFacing = motifGallery.gallery_info.cell.unknown.facing
						unknownWindow = motifGallery.gallery_info.cell.unknown.window
					elseif t_gallery[gallerySection].name == motifGallery.gallery_info.title.music then
						sffData = motifGallery.musicSprData
						sprWindow = "music"
						unknownData = motifGallery.gallery_info.cell.unknown.musicData
						unknownPos = motifGallery.gallery_info.cell.unknown.music.offset
						unknownSpacing = motifGallery.gallery_info.cell.unknown.music.spacing
						unknownSize = motifGallery.gallery_info.cell.unknown.music.size
						unknownScale = motifGallery.gallery_info.cell.unknown.music.scale
						unknowFacing = motifGallery.gallery_info.cell.unknown.music.facing
						unknownWindow = motifGallery.gallery_info.cell.unknown.music.window
					end
				end
			--Draw Unlocked Item Preview
				if main.t_unlockLua.gallery[t[index].id] == nil then --If the item is Unlocked
				--If Spr Data is defined
					if t[index][sprData][1] and t[index][sprData][2] ~= nil then
						f_drawPreview(sffData,
							t[index][sprData][1], t[index][sprData][2],
							motifGallery.gallery_info.menu.pos[1] + t[index].previewpos[1] + i * (t[index][sprSize][1] + t[index].previewspacing[1]) - (galleryMoveX * (t[index][sprSize][1] + t[index].previewspacing[1])),
							motifGallery.gallery_info.menu.pos[2] + t[index].previewpos[2] + j * (t[index][sprSize][2] + t[index].previewspacing[2]) - (galleryMoveY * (t[index][sprSize][2] + t[index].previewspacing[2])),
							t[index].previewscale[1], t[index].previewscale[2],
							motifGallery.gallery_info.cell[sprWindow].window[1], motifGallery.gallery_info.cell[sprWindow].window[2], motifGallery.gallery_info.cell[sprWindow].window[3], motifGallery.gallery_info.cell[sprWindow].window[4]
						)
				--If Spr Data is NOT defined
					else
						main.f_animPosDraw(
							unknownData,
							motifGallery.gallery_info.menu.pos[1] + unknownPos[1] + i * (unknownSize[1] + unknownSpacing[1]) - (galleryMoveX * (unknownSize[1] + unknownSpacing[1])),
							motifGallery.gallery_info.menu.pos[2] + unknownPos[2] + j * (unknownSize[2] + unknownSpacing[2]) - (galleryMoveY * (unknownSize[2] + unknownSpacing[2])),
							unknowFacing
						)
						animSetWindow(unknownData, unknownWindow[1], unknownWindow[2], unknownWindow[3], unknownWindow[4])
					end
			--Draw Locked Item Preview
				else
					main.f_animPosDraw(
						motifGallery.gallery_info.cell.lockedData,
						motifGallery.gallery_info.menu.pos[1] + motifGallery.gallery_info.cell.locked.offset[1] + i * (motifGallery.gallery_info.cell.locked.size[1] + motifGallery.gallery_info.cell.locked.spacing[1]) - (galleryMoveX * (motifGallery.gallery_info.cell.locked.size[1] + motifGallery.gallery_info.cell.locked.spacing[1])),
						motifGallery.gallery_info.menu.pos[2] + motifGallery.gallery_info.cell.locked.offset[2] + j * (motifGallery.gallery_info.cell.locked.size[2] + motifGallery.gallery_info.cell.locked.spacing[2]) - (galleryMoveY * (motifGallery.gallery_info.cell.locked.size[2] + motifGallery.gallery_info.cell.locked.spacing[2])),
						motifGallery.gallery_info.cell.locked.facing
					)
					animSetWindow(motifGallery.gallery_info.cell.lockedData, motifGallery.gallery_info.cell.locked.window[1], motifGallery.gallery_info.cell.locked.window[2], motifGallery.gallery_info.cell.locked.window[3], motifGallery.gallery_info.cell.locked.window[4])
				end
			end
		end
	end
end

local function f_setCursorPos() --Used to calculate gallery cursor pos in gallery menu
	galleryCursor = (galleryCursorX + (motifGallery.gallery_info.cell.columns + hiddenColumns) * galleryCursorY) + 1
end

local function f_getNewCursorPos() --Get new gallery cursor position when exit from artwork viewer (Unfinished)
	galleryCursorX = (galleryCursor - 1) - motifGallery.gallery_info.cell.columns * galleryCursorY
	galleryCursorY = (galleryCursor - 1 - galleryCursorX) / motifGallery.gallery_info.cell.columns
end

local function f_nextItem(limit)
	local limit = limit
	galleryCursor = galleryCursor + 1
	if galleryCursor > limit then --Go to first item
		galleryCursor = 1
	end
end

local function f_previousItem(limit)
	local limit = limit
	galleryCursor = galleryCursor - 1
	if galleryCursor < 1 then --Go to last item
		galleryCursor = limit
	end
end

local function f_drawArtwork()
local artPic = t_gallery[gallerySection][galleryCursor].spr[1] ..','.. t_gallery[gallerySection][galleryCursor].spr[2] ..', 0,0, -1'
artPic = animNew(motifGallery.artworksSprData, artPic)
animSetScale(artPic, artScaleX, artScaleY)
main.f_animPosDraw(artPic, artPosX, artPosY)
end

local function f_resetArtPos()
artPosX = t_gallery[gallerySection][galleryCursor].pos[1]
artPosY = t_gallery[gallerySection][galleryCursor].pos[2]
artScaleX = t_gallery[gallerySection][galleryCursor].scale[1]
artScaleY = t_gallery[gallerySection][galleryCursor].scale[2]
end

local function f_artMenu(artLimit)
	bgReset(motifGallery.artviewerbgdef.BGDef)
	fadeInInit(motifGallery.artviewer_info.fadein.FadeData)
	main.close = false
	local bufPrevious = 0
	local bufNext = 0
	local UiRepeatDelayBackup = gameOption('Input.UiRepeatDelay')
	local UiRepeatRateBackup = gameOption('Input.UiRepeatRate')
	modifyGameOption('Input.UiRepeatDelay', 1) --Set Custom Initial delay (in frames) before repeating starts
	modifyGameOption('Input.UiRepeatRate', 1) --Set Custom Repeat interval (in frames) after the delay
	local maxArt = artLimit
	local artZero = ""
	local artLimitZero = ""
	if maxArt < 10 then artLimitZero = "0" end
	local hideMenu = false
	local textData = nil
	f_resetArtPos()
	f_resetInfoTxt()
	while true do
		clearColor(motifGallery.artviewerbgdef.bgclearcolor[1], motifGallery.artviewerbgdef.bgclearcolor[2], motifGallery.artviewerbgdef.bgclearcolor[3])
	--Layerno = 0 backgrounds
		bgDraw(motifGallery.artviewerbgdef.BGDef, 0)
	--Draw Artwork (only if has Spr Data defined)
		if t_gallery[gallerySection][galleryCursor].spr[1] and t_gallery[gallerySection][galleryCursor].spr[2] ~= nil then
			f_drawArtwork()
			textData = t_gallery[gallerySection][galleryCursor].info
		else
			textData = txt_noData
		end
	--Draw HUD Assets
		if not hideMenu then
		--Layerno = 1 backgrounds
			bgDraw(motifGallery.artviewerbgdef.BGDef, 1)
		--Draw Artwork Info
			infoTextActive = f_textRender(
				txt_artInfo,
				artZero..galleryCursor..". "..textData,
				infoTextCnt,
				motifGallery.artviewer_info.menu.pos[1] + motifGallery.artviewer_info.info.offset[1],
				motifGallery.artviewer_info.menu.pos[2] + motifGallery.artviewer_info.info.offset[2],
				motifGallery.artviewer_info.info.scale[1],
				motifGallery.artviewer_info.info.scale[2],
				motifGallery.artviewer_info.info.spacing,
				motifGallery.artviewer_info.info.delay,
				motifGallery.artviewer_info.info.length
			)
			if infoTextActive > 0 then infoTextCnt = infoTextCnt + 1 end
		--Draw Page Info
			if galleryCursor < 10 then artZero = "0" else artZero = "" end
			textImgSetText(txt_pageInfo, motifGallery.artviewer_info.page.text.."1".."/".."1")
			textImgSetPos(
				txt_pageInfo,
				motifGallery.artviewer_info.menu.pos[1] + motifGallery.artviewer_info.page.offset[1],
				motifGallery.artviewer_info.menu.pos[2] + motifGallery.artviewer_info.page.offset[2]
			)
			textImgDraw(txt_pageInfo)
			--if galleryCursor > 1 then
				animSetScale(
					motifGallery.artviewer_info.menu.arrow.left.AnimData,
					motifGallery.artviewer_info.menu.arrow.left.scale[1],
					motifGallery.artviewer_info.menu.arrow.left.scale[2]
				)
				main.f_animPosDraw(
					motifGallery.artviewer_info.menu.arrow.left.AnimData,
					motifGallery.artviewer_info.menu.pos[1] + motifGallery.artviewer_info.menu.arrow.left.offset[1],
					motifGallery.artviewer_info.menu.pos[2] + motifGallery.artviewer_info.menu.arrow.left.offset[2],
					motifGallery.artviewer_info.menu.arrow.left.facing
				)
			--end
			--if galleryCursor < maxArt then
				animSetScale(
					motifGallery.artviewer_info.menu.arrow.right.AnimData,
					motifGallery.artviewer_info.menu.arrow.right.scale[1],
					motifGallery.artviewer_info.menu.arrow.right.scale[2]
				)
				main.f_animPosDraw(
					motifGallery.artviewer_info.menu.arrow.right.AnimData,
					motifGallery.artviewer_info.menu.pos[1] + motifGallery.artviewer_info.menu.arrow.right.offset[1],
					motifGallery.artviewer_info.menu.pos[2] + motifGallery.artviewer_info.menu.arrow.right.offset[2],
					motifGallery.artviewer_info.menu.arrow.right.facing
				)
			--end
		end
	--DEBUG STUFF
	--[[
		textImgSetText(txt_debugZoom, "ZOOM: "..artScaleX)
		textImgSetText(txt_debugPosX, "POS X: "..artPosX)
		textImgSetText(txt_debugPosY, "POS Y: "..artPosY)
		textImgDraw(txt_debugZoom)
		textImgDraw(txt_debugPosX)
		textImgDraw(txt_debugPosY)
	--]]
	--Fadein/Fadeout
		--animDraw(motifGallery.artviewer_info.fadein.AnimData) --main.f_fadeAnim(motifGallery.artviewer_info)
	--Close Menu
		if not fadeActive() then
			if main.close then
				bgReset(motifGallery.gallerybgdef.BGDef)
				fadeInInit(motifGallery.gallery_info.fadein.FadeData)
				main.close = false
				break
		--Back to Gallery Menu
			elseif (esc() or getInput(-1, motifGallery.artviewer_info.back.key)) and not main.close then
				sndPlay(motifGallery.commonSndData, motifGallery.artviewer_info.cursor.done.snd[1], motifGallery.artviewer_info.cursor.done.snd[2])
				modifyGameOption('Input.UiRepeatDelay', UiRepeatDelayBackup) --Restore Initial delay (in frames) before repeating starts
				modifyGameOption('Input.UiRepeatRate', UiRepeatRateBackup) --Restore Repeat interval (in frames) after the delay
				fadeOutInit(motifGallery.artviewer_info.fadeout.FadeData)
				main.close = true
		--NEXT ART PAGE
			elseif (getInput(-1, motifGallery.artviewer_info.next.key) or (codeInput('holdnext') and bufNext >= 30)) then
				sndPlay(motifGallery.commonSndData, motifGallery.artviewer_info.cursor.move.snd[1], motifGallery.artviewer_info.cursor.move.snd[2])
				f_nextItem(maxArt)
			--If current item is not unlocked
				while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
					f_nextItem(maxArt) --Go to an unlocked art
				end
				f_resetArtPos()
		--PREVIOUS ART PAGE
			elseif (getInput(-1, motifGallery.artviewer_info.previous.key) or (codeInput('holdprevious') and bufPrevious >= 30)) then
				sndPlay(motifGallery.commonSndData, motifGallery.artviewer_info.cursor.move.snd[1], motifGallery.artviewer_info.cursor.move.snd[2])
				f_previousItem(maxArt)
			--If current item is not unlocked
				while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
					f_previousItem(maxArt) --Go to an unlocked art
				end
				f_resetArtPos()
		--SLOT SWITCH ART
			elseif codeInput(motifGallery.artviewer_info.slot.key) then
				--TODO
		--RESET ART POSITION
			elseif getInput(-1, motifGallery.artviewer_info.reset.key) then
				f_resetArtPos()
		--HIDE MENU
			elseif getInput(-1, motifGallery.artviewer_info.hide.key) then
				if not hideMenu then hideMenu = true else hideMenu = false end
			end
		--MOVE UP ART
			if getInput(-1, motifGallery.artviewer_info.up.key) then
				if artPosY > t_gallery[gallerySection][galleryCursor].movelimit[2] then
					artPosY = artPosY - 1
				end
		--MOVE DOWN ART
			elseif getInput(-1, motifGallery.artviewer_info.down.key) then
				if artPosY < t_gallery[gallerySection][galleryCursor].movelimit[4] then
					artPosY = artPosY + 1
				end
			end
		--MOVE LEFT ART
			if getInput(-1, motifGallery.artviewer_info.left.key) then
				if artPosX > t_gallery[gallerySection][galleryCursor].movelimit[1] then
					artPosX = artPosX - 1
				end
		--MOVE RIGHT ART
			elseif getInput(-1, motifGallery.artviewer_info.right.key) then
				if artPosX < t_gallery[gallerySection][galleryCursor].movelimit[3] then
					artPosX = artPosX + 1
				end
			end
		--ZOOM IN ART
			if codeInput('holdzoomin') then
				if artScaleX < t_gallery[gallerySection][galleryCursor].zoomlimit[2] and artScaleY < t_gallery[gallerySection][galleryCursor].zoomlimit[2] then
					artScaleX = artScaleX + motifGallery.artviewer_info.art.zoomspeed
					artScaleY = artScaleY + motifGallery.artviewer_info.art.zoomspeed
				end
		--ZOOM OUT ART
			elseif codeInput('holdzoomout') then
				if artScaleX > t_gallery[gallerySection][galleryCursor].zoomlimit[1] and artScaleY > t_gallery[gallerySection][galleryCursor].zoomlimit[1] then
					artScaleX = artScaleX - motifGallery.artviewer_info.art.zoomspeed
					artScaleY = artScaleY - motifGallery.artviewer_info.art.zoomspeed
				end
			end
		end
	--ART PAGE BUF KEY CONTROL
		if codeInput('holdnext') then
			bufPrevious = 0
			bufNext = bufNext + 1
		elseif codeInput('holdprevious') then
			bufNext = 0
			bufPrevious = bufPrevious + 1
		else
			bufPrevious = 0
			bufNext = 0
		end
		refresh()
	end
end

local function f_resetVolume()
galleryBGMVolume = tonumber(t_gallery[gallerySection][galleryCursor].volume) or 100
end

local function f_musicPlayer(songLimit)
	bgReset(motifGallery.musicplayerbgdef.BGDef)
	fadeInInit(motifGallery.musicplayer_info.fadein.FadeData)
	main.close = false
	local maxSong = songLimit
	local loopState = 1
	local update = true
	f_resetVolume()
	f_resetInfoTxt()
	while true do
		clearColor(motifGallery.musicplayerbgdef.bgclearcolor[1], motifGallery.musicplayerbgdef.bgclearcolor[2], motifGallery.musicplayerbgdef.bgclearcolor[3])
	--Layerno = 0 backgrounds
		bgDraw(motifGallery.musicplayerbgdef.BGDef, 0)
	--Draw Song Info
		infoTextActive = f_textRender(
			txt_songInfo,
			t_gallery[gallerySection][galleryCursor].info,
			infoTextCnt,
			motifGallery.musicplayer_info.menu.pos[1] + motifGallery.musicplayer_info.info.offset[1],
			motifGallery.musicplayer_info.menu.pos[2] + motifGallery.musicplayer_info.info.offset[2],
			motifGallery.musicplayer_info.info.scale[1],
			motifGallery.musicplayer_info.info.scale[2],
			motifGallery.musicplayer_info.info.spacing,
			motifGallery.musicplayer_info.info.delay,
			motifGallery.musicplayer_info.info.length
		)
		if infoTextActive > 0 then infoTextCnt = infoTextCnt + 1 end
		--if galleryCursor > 1 then
			animSetScale(
				motifGallery.musicplayer_info.menu.arrow.left.AnimData,
				motifGallery.musicplayer_info.menu.arrow.left.scale[1],
				motifGallery.musicplayer_info.menu.arrow.left.scale[2]
			)
			main.f_animPosDraw(
				motifGallery.musicplayer_info.menu.arrow.left.AnimData,
				motifGallery.musicplayer_info.menu.pos[1] + motifGallery.musicplayer_info.menu.arrow.left.offset[1],
				motifGallery.musicplayer_info.menu.pos[2] + motifGallery.musicplayer_info.menu.arrow.left.offset[2],
				motifGallery.musicplayer_info.menu.arrow.left.facing
			)
		--end
		--if galleryCursor < maxSong then	
			animSetScale(
				motifGallery.musicplayer_info.menu.arrow.right.AnimData,
				motifGallery.musicplayer_info.menu.arrow.right.scale[1],
				motifGallery.musicplayer_info.menu.arrow.right.scale[2]
			)
			main.f_animPosDraw(
				motifGallery.musicplayer_info.menu.arrow.right.AnimData,
				motifGallery.musicplayer_info.menu.pos[1] + motifGallery.musicplayer_info.menu.arrow.right.offset[1],
				motifGallery.musicplayer_info.menu.pos[2] + motifGallery.musicplayer_info.menu.arrow.right.offset[2],
				motifGallery.musicplayer_info.menu.arrow.right.facing
			)
		--end
	--Layerno = 1 backgrounds
		bgDraw(motifGallery.musicplayerbgdef.BGDef, 1)
	--Fadein/Fadeout
		--animDraw(motifGallery.musicplayer_info.fadein.AnimData) --main.f_fadeAnim(motifGallery.musicplayer_info)
	--Close Menu
		if not fadeActive() then
			if main.close then
				bgReset(motifGallery.gallerybgdef.BGDef)
				fadeInInit(motifGallery.gallery_info.fadein.FadeData)
				main.close = false
				break
		--Back to Gallery Menu
			elseif (esc() or (motifGallery.musicplayer_info.back and getInput(-1, motifGallery.musicplayer_info.back.key))) and not main.close then
				sndPlay(motifGallery.commonSndData, motifGallery.musicplayer_info.cursor.done.snd[1], motifGallery.musicplayer_info.cursor.done.snd[2])
				fadeOutInit(motifGallery.musicplayer_info.fadeout.FadeData)
				main.close = true
		--LOOP CONTROL
			elseif motifGallery.musicplayer_info.loop and getInput(-1, motifGallery.musicplayer_info.loop.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.musicplayer_info.cursor.move.snd[1], motifGallery.musicplayer_info.cursor.move.snd[2])
				if loopState == 1 then loopState = 0 else loopState = 1 end
				update = true
		--VOLUME UP
			elseif motifGallery.musicplayer_info.volumeup and getInput(-1, motifGallery.musicplayer_info.volumeup.key) then
				if galleryBGMVolume < 100 then
					galleryBGMVolume = galleryBGMVolume + 1
				end
				update = true
		--VOLUME DOWN
			elseif motifGallery.musicplayer_info.volumedown and getInput(-1, motifGallery.musicplayer_info.volumedown.key) then
				if galleryBGMVolume > 0 then
					galleryBGMVolume = galleryBGMVolume - 1
				end
				update = true
		--NEXT SONG
			elseif motifGallery.musicplayer_info.next and getInput(-1, motifGallery.musicplayer_info.next.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.musicplayer_info.cursor.move.snd[1], motifGallery.musicplayer_info.cursor.move.snd[2])
				f_nextItem(maxSong)
			--If current item is not unlocked
				while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
					f_nextItem(maxSong) --Go to an unlocked song
				end
				f_resetVolume()
				update = true
		--PREVIOUS SONG
			elseif motifGallery.musicplayer_info.previous and getInput(-1, motifGallery.musicplayer_info.previous.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.musicplayer_info.cursor.move.snd[1], motifGallery.musicplayer_info.cursor.move.snd[2])
				f_previousItem(maxSong)
			--If current item is not unlocked
				while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
					f_previousItem(maxSong) --Go to an unlocked song
				end
				f_resetVolume()
				update = true
			end
		end
	--Play BGM
		if update then
			f_playGalleryBGM(
				t_gallery[gallerySection][galleryCursor].path,
				loopState,
				galleryBGMVolume,
				tonumber(t_gallery[gallerySection][galleryCursor].loopstart),
				tonumber(t_gallery[gallerySection][galleryCursor].loopend),
				tonumber(t_gallery[gallerySection][galleryCursor].startposition),
				tonumber(t_gallery[gallerySection][galleryCursor].freqmul),
				tonumber(t_gallery[gallerySection][galleryCursor].loopcount)
			)
			update = false
		end
		refresh()
	end
end

local function f_galleryMenu()
	if motifGallery.gallery_info.reload.enabled == 1 then f_loadFiles() end --Reload gallery data (.def & .sff files) each time that gallery menu is initialized
	if #t_gallery == 0 then return end --If there is not gallery data, return to main menu
--If there is gallery data, enter in gallery menu
	main.f_unlock(true) --Check Gallery Unlocks
	f_refreshUnlockDat()
	bgReset(motifGallery.gallerybgdef.BGDef)
	fadeInInit(motifGallery.gallery_info.fadein.FadeData)
	main.close = false
	sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.done.snd[1], motifGallery.gallery_info.cursor.done.snd[2])
	local textData = nil
	local titleData = nil
	local sprData = nil
	gallerySection = 1
	local slotMax, contentMax
	local function f_resetCursor()
	--Set correct Section Cursor Pos
		if gallerySection < 1 then
			gallerySection = #t_gallery
		elseif gallerySection > #t_gallery then
			gallerySection = 1
		end
	--Config Slots/cursor limits
		galleryCursorX = 0
		galleryCursorY = 0
		hiddenColumns = motifGallery.gallery_info.cell.hiddencolumns
		hiddenRows = motifGallery.gallery_info.cell.hiddenrows
		galleryMoveX = 0
		galleryMoveY = 0
		f_setCursorPos()
		slotMax = (motifGallery.gallery_info.cell.columns + motifGallery.gallery_info.cell.hiddencolumns) * (motifGallery.gallery_info.cell.rows + motifGallery.gallery_info.cell.hiddenrows)
		contentMax = nil
		if slotMax > #t_gallery[gallerySection] then
			contentMax = #t_gallery[gallerySection] --Set content loaded in t_gallery[gallerySection] as slotMax amount to prevent issues
		else
			contentMax = slotMax
		end
	end
	f_resetCursor()
	f_restoreGalleryBGM()
	f_resetInfoTxt()
	while true do
		clearColor(motifGallery.gallerybgdef.bgclearcolor[1], motifGallery.gallerybgdef.bgclearcolor[2], motifGallery.gallerybgdef.bgclearcolor[3])
	--To Detect section data
		if t_gallery[gallerySection].name == motifGallery.gallery_info.title.artworks then --This is artworks section
			sprData = "spr"
		else --This is not an artworks section
			sprData = "previewspr"
		end
	--Layerno = 0 backgrounds
		bgDraw(motifGallery.gallerybgdef.BGDef, 0)
	--Draw Title Text
		if #t_gallery < 2 then
			titleData = motifGallery.gallery_info.title.text --Use title.text paramvalue
		else
			titleData = t_gallery[gallerySection].name --Use Gallery Section Name
		end
		textImgSetPos(
			txt_titleMenu,
			motifGallery.gallery_info.menu.pos[1] + motifGallery.gallery_info.title.offset[1],
			motifGallery.gallery_info.menu.pos[2] + motifGallery.gallery_info.title.offset[2]
		)
		textImgSetText(txt_titleMenu, titleData)
		textImgDraw(txt_titleMenu)
	--Draw Gallery Content
		f_drawGallery(t_gallery[gallerySection], motifGallery.gallery_info.cell.columns + hiddenColumns, motifGallery.gallery_info.cell.rows + hiddenRows)
	--Draw Gallery Cursor
		main.f_animPosDraw(
			motifGallery.gallery_info.cell.cursorData,
			motifGallery.gallery_info.menu.pos[1] + motifGallery.gallery_info.cell.cursor.offset[1] + (galleryCursorX - galleryMoveX) * (motifGallery.gallery_info.cell.cursor.size[1] + motifGallery.gallery_info.cell.cursor.spacing[1]),
			motifGallery.gallery_info.menu.pos[2] + motifGallery.gallery_info.cell.cursor.offset[2] + (galleryCursorY - galleryMoveY) * (motifGallery.gallery_info.cell.cursor.size[2] + motifGallery.gallery_info.cell.cursor.spacing[2]),
			motifGallery.gallery_info.cell.cursor.facing
		)
		animSetWindow(motifGallery.gallery_info.cell.cursorData, motifGallery.gallery_info.cell.cursor.window[1], motifGallery.gallery_info.cell.cursor.window[2], motifGallery.gallery_info.cell.cursor.window[3], motifGallery.gallery_info.cell.cursor.window[4])
	--Condition to Show Unlocked Text
		if main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] == nil then
			textData = t_gallery[gallerySection][galleryCursor].info
		else
			textData = motifGallery.gallery_info.info.unknown
		end
	--Draw Artwork Info
		infoTextActive = f_textRender(
			txt_previewInfo,
			textData,
			infoTextCnt,
			motifGallery.gallery_info.menu.pos[1] + motifGallery.gallery_info.info.offset[1],
			motifGallery.gallery_info.menu.pos[1] + motifGallery.gallery_info.info.offset[2],
			motifGallery.gallery_info.info.scale[1],
			motifGallery.gallery_info.info.scale[2],
			motifGallery.gallery_info.info.spacing,
			motifGallery.gallery_info.info.delay,
			motifGallery.gallery_info.info.length
		)
		if infoTextActive > 0 then infoTextCnt = infoTextCnt + 1 end
	--Attract Credits/Coins
		if motif.attract_mode.enabled and getCredits() ~= -1 then
			textImgReset(motif.attract_mode.credits.TextSpriteData)
			textImgSetText(motif.attract_mode.credits.TextSpriteData, string.format(motif.attract_mode.credits.text, getCredits()))
			textImgDraw(motif.attract_mode.credits.TextSpriteData)
		end
	--Layerno = 1 backgrounds
		bgDraw(motifGallery.gallerybgdef.BGDef, 1)
	--Fadein/Fadeout
		--animDraw(motifGallery.gallery_info.fadein.AnimData) --main.f_fadeAnim(motifGallery.gallery_info)
	--DEBUG STUFF
	--[[		
		textImgSetText(txt_debugCursor, "ITEM: "..galleryCursor)
		textImgSetText(txt_debugCursorX, "CURSOR X: "..galleryCursorX)
		textImgSetText(txt_debugCursorY, "CURSOR Y: "..galleryCursorY)
		textImgSetText(txt_debugGalleryMoveX, "MOVE X: "..galleryMoveX)
		textImgSetText(txt_debugGalleryMoveY, "MOVE Y: "..galleryMoveY)
		textImgDraw(txt_debugCursor)
		textImgDraw(txt_debugCursorX)
		textImgDraw(txt_debugCursorY)
		textImgDraw(txt_debugGalleryMoveX)
		textImgDraw(txt_debugGalleryMoveY)
	--]]
	--Close Menu
		if not fadeActive() then
			if main.close then
				bgReset(motif[main.background].BGDef) --bgReset(motifGallery.gallerybgdef.BGDef)
				fadeInInit(motif[main.group].fadein.FadeData) --fadeInInit(motifGallery.gallery_info.fadein.FadeData)
				playBgm({source = "motif.title", interrupt = true})
				main.close = false
				break
		--Back To Main Menu
			elseif (esc() or getInput(-1, motifGallery.gallery_info.menu.back.key)) and not main.close then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.cancel.snd[1], motifGallery.gallery_info.cursor.cancel.snd[2])
				fadeOutInit(motifGallery.gallery_info.fadeout.FadeData)
				main.close = true
		--ENTER ACTION
			elseif getInput(-1, motifGallery.gallery_info.menu.done.key) then
			--If the item is unlocked
				if main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] == nil then
					sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.done.snd[1], motifGallery.gallery_info.cursor.done.snd[2])
				--Start Artwork Viewer
					if t_gallery[gallerySection].name == motifGallery.gallery_info.title.artworks then
						fadeOutInit(motifGallery.gallery_info.fadeout.FadeData)
						f_artMenu(contentMax)
						f_setCursorPos() --Replace with a logic that calculates the new position of the cursor after having moved in artwork viewer...
						--animDraw(motifGallery.artviewer_info.fadein.AnimData) --main.f_fadeAnim(motifGallery.artviewer_info) --fadein / fadeout
				--Play Storyboard
					elseif t_gallery[gallerySection].name == motifGallery.gallery_info.title.storyboards then
						launchStoryboard(t_gallery[gallerySection][galleryCursor].path)
						fadeInInit(motifGallery.gallery_info.fadein.FadeData)
						--animDraw(motifGallery.gallery_info.fadein.AnimData) --main.f_fadeAnim(motifGallery.gallery_info) --fadein / fadeout
						f_restoreGalleryBGM()
				--Start Music Player
					elseif t_gallery[gallerySection].name == motifGallery.gallery_info.title.music then
						fadeOutInit(motifGallery.gallery_info.fadeout.FadeData)
						f_musicPlayer(contentMax)
						--animDraw(motifGallery.musicplayer_info.fadein.AnimData) --main.f_fadeAnim(motifGallery.musicplayer_info) --fadein / fadeout
						f_restoreGalleryBGM()
					end
				end
		--Previous Section
			elseif getInput(-1, motifGallery.gallery_info.menu.previouspage.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.category.snd[1], motifGallery.gallery_info.cursor.category.snd[2])
				gallerySection = gallerySection - 1
				f_resetCursor()
		--Next Section
			elseif getInput(-1, motifGallery.gallery_info.menu.nextpage.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.category.snd[1], motifGallery.gallery_info.cursor.category.snd[2])
				gallerySection = gallerySection + 1
				f_resetCursor()
		--SCROLL LEFT (Cursor X - Previous Column)
			elseif getInput(-1, motifGallery.gallery_info.menu.left.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.move.snd[1], motifGallery.gallery_info.cursor.move.snd[2])
				if galleryCursorX > 0 then
					galleryCursorX = galleryCursorX - 1
				--Hidden Columns Logic
					if galleryMoveX > 0 then
						galleryMoveX = galleryMoveX - 1
					end
				else --Wrap
					galleryCursorX = motifGallery.gallery_info.cell.columns - 1 + hiddenColumns
					--if hiddenColumns > 0 then
						galleryMoveX = hiddenColumns
					--end
				end
				f_setCursorPos() --Set New Cursor Pos
			--Prevent fall out of t_gallery[gallerySection] items
				if galleryCursor > contentMax then
					while t_gallery[gallerySection][galleryCursor] == nil do
						galleryCursorX = galleryCursorX - 1
						if galleryMoveX > 0 then
							galleryMoveX = galleryMoveX - 1
						end
						f_setCursorPos()
					end
				end
		--SCROLL RIGHT (Cursor X - Next Column)
			elseif getInput(-1, motifGallery.gallery_info.menu.right.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.move.snd[1], motifGallery.gallery_info.cursor.move.snd[2])
				if galleryCursorX < motifGallery.gallery_info.cell.columns - 1 + hiddenColumns then
					galleryCursorX = galleryCursorX + 1
				--Hidden Columns Logic
					if galleryCursorX > motifGallery.gallery_info.cell.columns-1 then
						galleryMoveX = galleryMoveX + 1
					end
				else --Wrap
					galleryCursorX = 0
					galleryMoveX = 0
				end
				f_setCursorPos() --Set New Cursor Pos
			--Prevent fall out of t_gallery[gallerySection] items
				if galleryCursor > contentMax then
					galleryCursorX = 0
					galleryMoveX = 0
					f_setCursorPos()
				end
		--SCROLL UP (Cursor Y - Previous Row)
			elseif getInput(-1, motifGallery.gallery_info.menu.up.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.move.snd[1], motifGallery.gallery_info.cursor.move.snd[2])
				if galleryCursorY > 0 then
					galleryCursorY = galleryCursorY - 1
				--Hidden Rows Logic
					if galleryMoveY > 0 then
						galleryMoveY = galleryMoveY - 1
					end
				else --Wrap
					galleryCursorY = motifGallery.gallery_info.cell.rows - 1 + hiddenRows
					--if hiddenRows > 0 then
						galleryMoveY = hiddenRows
					--end
				end
				f_setCursorPos() --Set New Cursor Pos
			--Prevent fall out of t_gallery[gallerySection] items
				if galleryCursor > contentMax then
					while t_gallery[gallerySection][galleryCursor] == nil do
						galleryCursorY = galleryCursorY - 1
						if galleryMoveY > 0 then
							galleryMoveY = galleryMoveY - 1
						end
						f_setCursorPos()
					end
				end
		--SCROLL DOWN (Cursor Y - Next Row)
			elseif getInput(-1, motifGallery.gallery_info.menu.down.key) then
				sndPlay(motifGallery.commonSndData, motifGallery.gallery_info.cursor.move.snd[1], motifGallery.gallery_info.cursor.move.snd[2])
				if galleryCursorY < motifGallery.gallery_info.cell.rows - 1 + hiddenRows then
					galleryCursorY = galleryCursorY + 1
				--Hidden Rows Logic
					if galleryCursorY > motifGallery.gallery_info.cell.rows - 1 then
						galleryMoveY = galleryMoveY + 1
					end
				else --Wrap
					galleryCursorY = 0
					galleryMoveY = 0
				end
				f_setCursorPos() --Set New Cursor Pos
			--Prevent fall out of t_gallery[gallerySection] items
				if galleryCursor > contentMax then
					galleryCursorY = 0
					galleryMoveY = 0
					f_setCursorPos()
				end
			end
		end
		refresh()
	end
end

--Adds new commands for art control
commandAdd("holdnext", "/"..motifGallery.artviewer_info.next.key, 1, 1)
commandAdd("holdprevious", "/"..motifGallery.artviewer_info.previous.key, 1, 1)
commandAdd("holdzoomin", "/"..motifGallery.artviewer_info.zoomin.key, 1, 1)
commandAdd("holdzoomout", "/"..motifGallery.artviewer_info.zoomout.key, 1, 1)

if gameOption('Debug.DumpLuaTables') then main.f_printTable(motifGallery, "debug/galleryMenuMotif.txt") end

main.t_itemname.gallery = function()
	return f_galleryMenu()
end