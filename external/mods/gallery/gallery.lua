--[[					GALLERY MODULE
===================================================================
Version: 1.0
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2025-01-02 Nightly Build
Description:
Adds a Custom Gallery Mode entry to the Main Menu.
===================================================================
]]
nightlyVer = true --Indicates if you are using Nightly IkemenGO version, to adjust some values ​​to draw the background...
--;===========================================================================================
--; 							      MOTIF STUFF
--;===========================================================================================
--[Music]
if motif.music.gallery_bgm == nil then
	motif.music.gallery_bgm = ""
end
if motif.music.gallery_bgm_volume == nil then
	motif.music.gallery_bgm_volume = 100
end
if motif.music.gallery_bgm_loop == nil then
	motif.music.gallery_bgm_loop = 1
end
if motif.music.gallery_bgm_loopstart == nil then
	motif.music.gallery_bgm_loopstart = 0
end
if motif.music.gallery_bgm_loopend == nil then
	motif.music.gallery_bgm_loopend = 0
end

--[Gallery Info] default parameters (used for rendering gallery select screen assets)
local t_base = {
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	menu_uselocalcoord = 1,
	menu_pos = {0, 0},
	
	cursor_move_snd = {100, 0},
	cursor_done_snd = {100, 1},
	cancel_snd = {100, 2},
	
	title_offset = {159, 15},
	title_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	title_scale = {1.0, 1.0},
	title_text = 'GALLERY',
	
	info_offset = {5, 230},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {0.95, 0.95},
	info_text = '',
	info_unknown_text = '???',
	
	artworks_def = "external/mods/gallery/artworks.def",
	artworks_spr = "external/mods/gallery/artworks.sff",
	
	preview_art_columns = 3,
	preview_art_rows = 3,
	preview_art_hiddencolumns = 0,
	preview_art_hiddenrows = 0,
	
	preview_art_offset = {50, 50},
	preview_art_spacing = {6, 6},
	preview_art_scale = {1.0, 1.0},
	preview_art_window = {0, 0, main.SP_Localcoord[1]-50, main.SP_Localcoord[2]},
	
	preview_bg_anim = -1,
	preview_bg_spr = {},
	preview_bg_offset = {5, 13},
	preview_bg_spacing = {6, 6},
	preview_bg_facing = 1,
	preview_bg_scale = {1.0, 1.0},
	preview_bg_size = {96, 56},
	preview_bg_window = {0, 0, main.SP_Localcoord[1]-50, main.SP_Localcoord[2]},

	preview_cursor_anim = -1,
	preview_cursor_spr = {},
	preview_cursor_offset = {5, 13},
	preview_cursor_spacing = {6, 6},
	preview_cursor_facing = 1,
	preview_cursor_scale = {1.0, 1.0},
	preview_cursor_size = {96, 56},
	preview_cursor_window = {0, 0, main.SP_Localcoord[1]-50, main.SP_Localcoord[2]},
	
	preview_unknown_anim = -1,
	preview_unknown_spr = {},
	preview_unknown_offset = {6.9, 14.9},
	preview_unknown_spacing = {12, 12},
	preview_unknown_facing = 1,
	preview_unknown_size = {90, 50},
	preview_unknown_scale = {1.0, 1.0},
	preview_unknown_window = {0, 0, main.SP_Localcoord[1]-50, main.SP_Localcoord[2]},
}
if motif.gallery_info == nil then
	motif.gallery_info = {}
end
motif.gallery_info = main.f_tableMerge(t_base, motif.gallery_info)

--If not defined [GalleryBGdef]
if motif.gallerybgdef == nil then
	motif.gallerybgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
end

-- This code creates data out of optional [GalleryBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.gallerybgdef.spr ~= nil and motif.gallerybgdef.spr ~= '' then
	motif.gallerybgdef.spr = searchFile(motif.gallerybgdef.spr, {motif.fileDir, '', 'data/'})
	motif.gallerybgdef.spr_data = sffNew(motif.gallerybgdef.spr)
else
	motif.gallerybgdef.spr = motif.files.spr
	motif.gallerybgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.gallerybgdef.bg = bgNew(motif.gallerybgdef.spr_data, motif.def, 'gallerybg')

-- fadein/fadeout anim data generation.
if motif.gallery_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.gallery_info, {s = 'fadein_'})
end
if motif.gallery_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.gallery_info, {s = 'fadeout_'})
end

--[ArtViewer Info] default parameters (used for rendering artwork viewer screen assets)
local t_base2 = {
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	menu_pos = {0, 0},
	
	cursor_move_snd = {100, 0},
	cursor_done_snd = {100, 2},
	
	art_offset = {190, 0},
	art_size = {120, 140},
	art_scale = {0.3, 0.3},
	art_movespeed = 10,
	art_movelimit = {0, 0, main.SP_Localcoord[1]-50, main.SP_Localcoord[2]},
	art_zoomspeed = 0.01,
	art_zoomlimit = {0.05, 1.99},
	
	info_offset = {5, 230},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {0.95, 0.95},
	info_text = '',
	
	page_offset = {312, 15},
	page_font = {'f-6x9.def', 0, -1, 255, 255, 255, -1},
	page_scale = {1.0, 1.0},
	page_text = 'PAGE ',
	
	menu_arrow_left_anim = -1,
	menu_arrow_left_spr = {},
	menu_arrow_left_offset = {0, 0},
	menu_arrow_left_facing = -1,
	menu_arrow_left_scale = {1.0, 1.0},
	
	menu_arrow_right_anim = -1,
	menu_arrow_right_spr = {},
	menu_arrow_right_offset = {0, 0},
	menu_arrow_right_facing = 1,
	menu_arrow_right_scale = {1.0, 1.0},
}
if motif.artviewer_info == nil then
	motif.artviewer_info = {}
end
motif.artviewer_info = main.f_tableMerge(t_base2, motif.artviewer_info)

--If not defined [ArtViewerBGdef]
if motif.artviewerbgdef == nil then
	motif.artviewerbgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
end

-- This code creates data out of optional [ArtViewerBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.artviewerbgdef.spr ~= nil and motif.artviewerbgdef.spr ~= '' then
	motif.artviewerbgdef.spr = searchFile(motif.artviewerbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.artviewerbgdef.spr_data = sffNew(motif.artviewerbgdef.spr)
else
	motif.artviewerbgdef.spr = motif.files.spr
	motif.artviewerbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.artviewerbgdef.bg = bgNew(motif.artviewerbgdef.spr_data, motif.def, 'artviewerbg')

-- fadein/fadeout anim data generation.
if motif.artviewer_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.artviewer_info, {s = 'fadein_'})
end
if motif.artviewer_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.artviewer_info, {s = 'fadeout_'})
end

--arrows spr/anim data generation.
for _, v in ipairs({motif.artviewer_info}) do
	motif.f_loadSprData(v, {s = 'menu_arrow_left_',   x = v.menu_pos[1], y = v.menu_pos[2]})
	motif.f_loadSprData(v, {s = 'menu_arrow_right_', x = v.menu_pos[1], y = v.menu_pos[2]})
end

--disabled scaling if element uses default values (non-existing in mugen)
motif.defaultgallery = motif.gallery_info.menu_uselocalcoord == 0

if main.debugLog then main.f_printTable(motif, "debug/t_motif.txt") end
local t_debugTxT = {
debugcursor_offset = {10, 15},
debugcursor_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debugcursor_scale = {1.0, 1.0},
debugcursor_text = '',
--
debugcursorx_offset = {10, 30},
debugcursorx_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debugcursorx_scale = {1.0, 1.0},
debugcursorx_text = '',
--
debugcursory_offset = {10, 45},
debugcursory_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debugcursory_scale = {1.0, 1.0},
debugcursory_text = '',
--
debuggallerymovex_offset = {10, 60},
debuggallerymovex_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debuggallerymovex_scale = {1.0, 1.0},
debuggallerymovex_text = '',
--
debuggallerymovey_offset = {10, 75},
debuggallerymovey_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debuggallerymovey_scale = {1.0, 1.0},
debuggallerymovey_text = '',
--
debugzoom_offset = {10, 15},
debugzoom_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debugzoom_scale = {1.0, 1.0},
debugzoom_text = '',
--
debugxpos_offset = {10, 30},
debugxpos_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debugxpos_scale = {1.0, 1.0},
debugxpos_text = '',
--
debugypos_offset = {10, 45},
debugypos_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
debugypos_scale = {1.0, 1.0},
debugypos_text = '',
}
local txt_debugCursor = main.f_createTextImg(t_debugTxT, 'debugcursor', {defsc = motif.defaultgallery})
local txt_debugCursorX = main.f_createTextImg(t_debugTxT, 'debugcursorx', {defsc = motif.defaultgallery})
local txt_debugCursorY = main.f_createTextImg(t_debugTxT, 'debugcursory', {defsc = motif.defaultgallery})
local txt_debugGalleryMoveX = main.f_createTextImg(t_debugTxT, 'debuggallerymovex', {defsc = motif.defaultgallery})
local txt_debugGalleryMoveY = main.f_createTextImg(t_debugTxT, 'debuggallerymovey', {defsc = motif.defaultgallery})

local txt_debugZoom = main.f_createTextImg(t_debugTxT, 'debugzoom', {defsc = motif.defaultgallery})
local txt_debugPosX = main.f_createTextImg(t_debugTxT, 'debugxpos', {defsc = motif.defaultgallery})
local txt_debugPosY = main.f_createTextImg(t_debugTxT, 'debugypos', {defsc = motif.defaultgallery})
--;===========================================================================================
--; GALLERY MENU
--;===========================================================================================
local txt_titleMenu = main.f_createTextImg(motif.gallery_info, 'title', {defsc = motif.defaultgallery})
local txt_previewInfo = main.f_createTextImg(motif.gallery_info, 'info', {defsc = motif.defaultgallery})
local txt_noData = "NO SPRITE DATA FOUND."

local function f_loadGallery() --Load def file which contains artworks data
	t_gallery = {}
	local section = 0
	local row = 0
	local content = main.f_fileRead(motif.gallery_info.artworks_def)
	content = content:gsub('([^\r\n;]*)%s*;[^\r\n]*', '%1')
	content = content:gsub('\n%s*\n', '\n')
	for line in content:gmatch('[^\r\n]+') do
		local lineCase = line:lower()
		if lineCase:match('^%s*%[%s*galleryartworks%s*%]') then
			row = 0
			section = 1
		elseif lineCase:match('^%s*%[%w+%]$') then
			section = -1
		elseif section == 1 then --[GalleryArtworks]
			local param, value = line:match('^%s*(.-)%s*=%s*(.-)%s*$')
			if param ~= nil and value ~= nil and param ~= '' and value ~= '' then
			--Generate Table to manage each item with default values
				if param:match('^id$') then
					table.insert(t_gallery,
						{
							id = value,
							spr = {},
							size = {motif.artviewer_info.art_size[1], motif.artviewer_info.art_size[2]},
							pos = {motif.artviewer_info.art_offset[1], motif.artviewer_info.art_offset[2]},
							scale = {motif.artviewer_info.art_scale[1], motif.artviewer_info.art_scale[2]},
							zoomlimit = {motif.artviewer_info.art_zoomlimit[1], motif.artviewer_info.art_zoomlimit[2]},
							movelimit = {motif.artviewer_info.art_movelimit[1], motif.artviewer_info.art_movelimit[2], motif.artviewer_info.art_movelimit[3], motif.artviewer_info.art_movelimit[4]},
							info = motif.gallery_info.info_unknown_text,
							previewpos = motif.gallery_info.preview_art_offset,
							previewspacing = motif.gallery_info.preview_art_spacing,
							previewscale = motif.gallery_info.preview_art_scale,
							unlock = 'true'
						}
					)
			--Store comma separated number values to table
				elseif param:match('^spr$') or param:match('^size$') or param:match('^pos$') or param:match('^scale$') or param:match('^zoomlimit$') or param:match('^movelimit$') or param:match('^previewpos$') or param:match('^previewspacing$') or param:match('^previewscale$') then
					local tbl = {}
					for num in value:gmatch('([^,]+)') do
						table.insert(tbl, tonumber(num))
					end
					t_gallery[#t_gallery][param] = tbl
			--Store extra values
				elseif t_gallery[#t_gallery][param] ~= nil then
					t_gallery[#t_gallery][param] = value
				end
			end
		end
	end
	for k, v in ipairs(t_gallery) do --Set Unlock Conditions
		if main.t_unlockLua.gallery == nil then main.t_unlockLua['gallery'] = {} end
		main.t_unlockLua.gallery[v.id] = v.unlock
	end
	if main.debugLog then main.f_printTable(t_gallery, 'debug/t_gallery.txt') end
--Load .sff file with Artworks
	if main.f_fileExists(motif.gallery_info.artworks_spr) then
		motif.files.gallery_data = sffNew(motif.gallery_info.artworks_spr)
	else
		motif.files.gallery_data = sffNew()
	end
end
f_loadGallery()

local function f_saveData()
	if main.debugLog then main.f_printTable(stats, 'debug/t_stats.txt') end --Print Debug Info
	main.f_fileWrite(main.flags['-stats'], json.encode(stats, {indent = 2})) --Write in stats.json file
end

--asserts gallery unlock conditions
local function f_unlockGallery(permanent)
	for group, t in pairs(main.t_unlockLua) do
		local t_del = {}
		for k, v in pairs(t) do
			local bool = assert(loadstring('return ' .. v))()
			if type(bool) == 'boolean' then
				if bool and (permanent or group == 'modes' or group == 'gallery') then
					table.insert(t_del, k)
				end
			else
				panicError("\nmain.t_unlockLua." .. group .. "[" .. k .. "]\n" .. "Following Lua code does not return boolean value: \n" .. v .. "\n")
			end
		end
		--clean lua code that already returned true
		for k, v in ipairs(t_del) do
			t[v] = nil
		end
	end
end

--creates sprite data out of table values
local anim = ''
local facing = ''
local function f_loadGallerySprData(t, v) --This function uses motif.files.gallery_data instead system.sff data
	local animParam = v.s .. 'anim'
	local sprParam = v.s .. 'spr'
	local data = v.s .. 'data'
	-- optional prefix argument only changes parameter name for anim/spr numbers assignment
	if v.prefix ~= nil then
		animParam = v.s .. v.prefix .. 'anim'
		sprParam = v.s .. v.prefix .. 'spr'
		data = v.s .. v.prefix .. 'data'
	end
	if t[v.s .. 'offset'] == nil then t[v.s .. 'offset'] = {0, 0} end
	if t[v.s .. 'scale'] == nil then t[v.s .. 'scale'] = {1.0, 1.0} end
	if t[animParam] ~= nil and t[animParam] ~= -1 and motif.anim[t[animParam]] ~= nil then --create animation data
		if t[v.s .. 'facing'] == nil then t[v.s .. 'facing'] = 1 end
		t[data] = main.f_animFromTable(
			motif.anim[t[animParam]],
			motif.files.gallery_data,
			(t[v.s .. 'offset'][1] + (v.x or 0)) / t[v.s .. 'scale'][1],
			(t[v.s .. 'offset'][2] + (v.y or 0)) / t[v.s .. 'scale'][2],
			t[v.s .. 'scale'][1],
			t[v.s .. 'scale'][2],
			motif.f_animFacing(t[v.s .. 'facing'])
		)
	elseif t[sprParam] ~= nil and #t[sprParam] > 0 then --create sprite data
		if #t[sprParam] == 1 then --fix values
			if type(t[sprParam][1]) == 'string' then
				t[sprParam] = {tonumber(t[sprParam][1]:match('^([0-9]+)')), 0}
			else
				t[sprParam] = {t[sprParam][1], 0}
			end
		end
		if t[v.s .. 'facing'] == -1 then facing = ', H' else facing = '' end
		t[data] = animNew(motif.files.gallery_data, t[sprParam][1] .. ', ' .. t[sprParam][2] .. ', ' .. (t[v.s .. 'offset'][1] + (v.x or 0)) / t[v.s .. 'scale'][1] .. ', ' .. (t[v.s .. 'offset'][2] + (v.y or 0)) / t[v.s .. 'scale'][2] .. ', -1' .. facing)
		animSetScale(t[data], t[v.s .. 'scale'][1], t[v.s .. 'scale'][2])
		animUpdate(t[data])
	else --create dummy data
		t[data] = animNew(motif.files.gallery_data, '-1,0, 0,0, -1')
		animUpdate(t[data])
	end
	animSetWindow(t[data], 0, 0, motif.info.localcoord[1], motif.info.localcoord[2])
end
f_loadGallerySprData(motif.gallery_info, {s = 'preview_bg_'}) --Generate motif.gallery_info.preview_bg_data
f_loadGallerySprData(motif.gallery_info, {s = 'preview_cursor_'}) --Generate motif.gallery_info.preview_cursor_data
f_loadGallerySprData(motif.gallery_info, {s = 'preview_unknown_'}) --Generate motif.gallery_info.preview_unknown_data

local function f_drawArtworkPreview(group, index, x, y, scaleX, scaleY, x1, y1, x2, y2)
	local x = x or 0
	local y = y or 0
	local scaleX = scaleX or 1
	local scaleY = scaleY or 1
	local anim = group .. ',' .. index .. ',' .. x .. ',' .. y .. ',' .. '-1'
	anim = animNew(motif.files.gallery_data, anim)
	animSetScale(anim, scaleX, scaleY)
	animSetWindow(anim, x1, y1, x2, y2)
	animUpdate(anim)
	animDraw(anim)
end

local function f_drawGallery(t, columns, rows) --Draw Gallery Content
	for i=0, columns-1 do
		for j=0, rows-1 do
			local index = (i + columns * j) + 1 --This is the same logic of f_setCursorPos() function
			if index <= #t then
			--Draw Artwork Preview Cell BG
				main.f_animPosDraw(
					motif.gallery_info.preview_bg_data,
					motif.gallery_info.menu_pos[1] + motif.gallery_info.preview_bg_offset[1] + i * (motif.gallery_info.preview_bg_size[1] + motif.gallery_info.preview_bg_spacing[1]) - (galleryMoveX * (motif.gallery_info.preview_bg_size[1] + motif.gallery_info.preview_bg_spacing[1])),
					motif.gallery_info.menu_pos[2] + motif.gallery_info.preview_bg_offset[2] + j * (motif.gallery_info.preview_bg_size[2] + motif.gallery_info.preview_bg_spacing[2]) - (galleryMoveY * (motif.gallery_info.preview_bg_size[2] + motif.gallery_info.preview_bg_spacing[2])),
					motif.gallery_info.preview_bg_facing,
					false
				)
				animSetWindow(motif.gallery_info.preview_bg_data, motif.gallery_info.preview_bg_window[1], motif.gallery_info.preview_bg_window[2], motif.gallery_info.preview_bg_window[3], motif.gallery_info.preview_bg_window[4])
			--Draw Artwork Preview (only if has Spr Data defined)
				if t[index].spr[1] and t[index].spr[2] ~= nil then
					if main.t_unlockLua.gallery[t[index].id] == nil then --If the artwork is Unlocked
						f_drawArtworkPreview(
							t[index].spr[1], t[index].spr[2],
							motif.gallery_info.menu_pos[1] + t[index].previewpos[1] + i * (t[index].size[1] + t[index].previewspacing[1]) - (galleryMoveX * (t[index].size[1] + t[index].previewspacing[1])),
							motif.gallery_info.menu_pos[2] + t[index].previewpos[2] + j * (t[index].size[2] + t[index].previewspacing[2]) - (galleryMoveY * (t[index].size[2] + t[index].previewspacing[2])),
							t[index].previewscale[1], t[index].previewscale[2],
							motif.gallery_info.preview_art_window[1], motif.gallery_info.preview_art_window[2], motif.gallery_info.preview_art_window[3], motif.gallery_info.preview_art_window[4]
						)
					else --If the artwork is Locked
						main.f_animPosDraw(
							motif.gallery_info.preview_unknown_data,
							motif.gallery_info.menu_pos[1] + motif.gallery_info.preview_unknown_offset[1] + i * (motif.gallery_info.preview_unknown_size[1] + motif.gallery_info.preview_unknown_spacing[1]) - (galleryMoveX * (motif.gallery_info.preview_unknown_size[1] + motif.gallery_info.preview_unknown_spacing[1])),
							motif.gallery_info.menu_pos[2] + motif.gallery_info.preview_unknown_offset[2] + j * (motif.gallery_info.preview_unknown_size[2] + motif.gallery_info.preview_unknown_spacing[2]) - (galleryMoveY * (motif.gallery_info.preview_unknown_size[2] + motif.gallery_info.preview_unknown_spacing[2])),
							motif.gallery_info.preview_unknown_facing,
							false
						)
						animSetWindow(motif.gallery_info.preview_unknown_data, motif.gallery_info.preview_unknown_window[1], motif.gallery_info.preview_unknown_window[2], motif.gallery_info.preview_unknown_window[3], motif.gallery_info.preview_unknown_window[4])
					end
				end
			end
		end
	end
end

local function f_setCursorPos() --Used to calculate gallery cursor pos in gallery menu
	galleryCursor = (galleryCursorX+(motif.gallery_info.preview_art_columns+hiddenColumns)*galleryCursorY) + 1
end

main.t_itemname.gallery = function()
	return f_galleryMenu()
end

function f_galleryMenu()
	f_loadGallery() --Load each time that gallery is initialized
	if #t_gallery == 0 then --If there is not gallery data
		return
	else --If there is gallery data
		f_unlockGallery(false) --Check Gallery Unlocks
		if main.debugLog then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
	end
	main.f_bgReset(motif.gallerybgdef.bg)
	main.f_fadeReset('fadein', motif.gallery_info)
	main.close = false
	sndPlay(motif.files.snd_data, motif.gallery_info.cursor_done_snd[1], motif.gallery_info.cursor_done_snd[2])
	if motif.music.gallery_bgm ~= '' then
		main.f_playBGM(false, motif.music.gallery_bgm, motif.music.gallery_bgm_loop, motif.music.gallery_bgm_volume, motif.music.gallery_bgm_loopstart, motif.music.gallery_bgm_loopend)
	end
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	galleryCursorX = 0
	galleryCursorY = 0
	hiddenColumns = motif.gallery_info.preview_art_hiddencolumns
	hiddenRows = motif.gallery_info.preview_art_hiddenrows
	galleryMoveX = 0
	galleryMoveY = 0
	f_setCursorPos()
	local slotMax = (motif.gallery_info.preview_art_columns + motif.gallery_info.preview_art_hiddencolumns)*(motif.gallery_info.preview_art_rows + motif.gallery_info.preview_art_hiddenrows)
	local artMax = nil
	if slotMax > #t_gallery then
		artMax = #t_gallery --Set artworks loaded in t_gallery as slotMax amount to prevent issues
	else
		artMax = slotMax
	end
	local textData = nil
	while true do
	--Clear Color
		if not skipClear then
			clearColor(motif.gallerybgdef.bgclearcolor[1], motif.gallerybgdef.bgclearcolor[2], motif.gallerybgdef.bgclearcolor[3])
		end
	--Layerno = 0 backgrounds
		bgDraw(motif.gallerybgdef.bg, falseBool)
	--Draw Title Text
		txt_titleMenu:draw()
		txt_titleMenu:update({
			x = motif.gallery_info.menu_pos[1] + motif.gallery_info.title_offset[1],
			y = motif.gallery_info.menu_pos[2] + motif.gallery_info.title_offset[2]
		})
	--Draw Gallery Content
		f_drawGallery(t_gallery, motif.gallery_info.preview_art_columns+hiddenColumns, motif.gallery_info.preview_art_rows+hiddenRows)
	--Draw Gallery Cursor
		main.f_animPosDraw(
			motif.gallery_info.preview_cursor_data,
			motif.gallery_info.menu_pos[1] + motif.gallery_info.preview_cursor_offset[1] + (galleryCursorX-galleryMoveX) * (motif.gallery_info.preview_cursor_size[1] + motif.gallery_info.preview_cursor_spacing[1]),
			motif.gallery_info.menu_pos[2] + motif.gallery_info.preview_cursor_offset[2] + (galleryCursorY-galleryMoveY) * (motif.gallery_info.preview_cursor_size[2] + motif.gallery_info.preview_cursor_spacing[2]),
			motif.gallery_info.preview_cursor_facing,
			false
		)
		animSetWindow(motif.gallery_info.preview_cursor_data, motif.gallery_info.preview_cursor_window[1], motif.gallery_info.preview_cursor_window[2], motif.gallery_info.preview_cursor_window[3], motif.gallery_info.preview_cursor_window[4])
	--Condition to Show Unlocked Text
		if t_gallery[galleryCursor].spr[1] and t_gallery[galleryCursor].spr[2] ~= nil then
			if main.t_unlockLua.gallery[t_gallery[galleryCursor].id] == nil then textData = t_gallery[galleryCursor].info else textData = motif.gallery_info.info_unknown_text end
		else
			textData = txt_noData
		end
	--Draw Artwork Info
		txt_previewInfo:draw()
		txt_previewInfo:update({
			text = textData,
			x = motif.gallery_info.menu_pos[1] + motif.gallery_info.info_offset[1],
			y = motif.gallery_info.menu_pos[2] + motif.gallery_info.info_offset[2]
		})
	--[[Attract Credits/Coins
		if motif.attract_mode.enabled == 1 and main.credits ~= -1 then
			txt_attract_credits:update({text = main.f_extractText(motif.attract_mode.credits_text, main.credits)[1]})
			txt_attract_credits:draw()
		end
	]]
	--Layerno = 1 backgrounds
		bgDraw(motif.gallerybgdef.bg, trueBool)
	--Fadein/Fadeout
		main.f_fadeAnim(motif.gallery_info)
	--DEBUG STUFF
	--[[
		txt_debugCursor:draw()
		txt_debugCursorX:draw()
		txt_debugCursorY:draw()
		txt_debugGalleryMoveX:draw()
		txt_debugGalleryMoveY:draw()
		txt_debugCursor:update({text = "ITEM: "..galleryCursor})
		txt_debugCursorX:update({text = "CURSOR X: "..galleryCursorX})
		txt_debugCursorY:update({text = "CURSOR Y: "..galleryCursorY})
		txt_debugGalleryMoveX:update({text = "MOVE X: "..galleryMoveX})
		txt_debugGalleryMoveY:update({text = "MOVE Y: "..galleryMoveY})
	--]]
	--Close Menu
		if main.close and not main.fadeActive then
			main.f_bgReset(motif.gallerybgdef.bg)
			main.f_fadeReset('fadein', motif.gallery_info)
			main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
			main.close = false
			break
	--Back To Main Menu
		elseif esc() or main.f_input(main.t_players, {'m'}) then
			sndPlay(motif.files.snd_data, motif.gallery_info.cancel_snd[1], motif.gallery_info.cancel_snd[2])
			main.f_fadeReset('fadeout', motif.gallery_info)
			main.close = true
	--Start Artwork Viewer
		elseif main.f_input(main.t_players, {'pal', 's'}) and not main.fadeActive then
			--If the artwork is unlocked
			if main.t_unlockLua.gallery[t_gallery[galleryCursor].id] == nil then
				sndPlay(motif.files.snd_data, motif.gallery_info.cursor_done_snd[1], motif.gallery_info.cursor_done_snd[2])
				main.f_fadeReset('fadeout', motif.gallery_info)
				f_artMenu(artMax)
				
				f_setCursorPos() --Replace with a logic that calculates the new position of the cursor after having moved in artwork viewer...
				
				main.f_fadeAnim(motif.artviewer_info) --fadein / fadeout
			end
	--SCROLL LEFT (Cursor X - Previous Column)
		elseif (commandGetState(main.t_cmd[main.playerInput], '$B') or (commandGetState(main.t_cmd[main.playerInput], 'holdl') and bufl >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.gallery_info.cursor_move_snd[1], motif.gallery_info.cursor_move_snd[2])
			if galleryCursorX > 0 then
				galleryCursorX = galleryCursorX - 1
			--Hidden Columns Logic
				if galleryMoveX > 0 then
					galleryMoveX = galleryMoveX - 1
				end
			else --Wrap
				galleryCursorX = motif.gallery_info.preview_art_columns-1 + hiddenColumns
				--if hiddenColumns > 0 then
					galleryMoveX = hiddenColumns
				--end
			end
			f_setCursorPos() --Set New Cursor Pos
		--Prevent fall out of t_gallery items
			if galleryCursor > artMax then
				while t_gallery[galleryCursor] == nil do
					galleryCursorX = galleryCursorX - 1
					if galleryMoveX > 0 then
						galleryMoveX = galleryMoveX - 1
					end
					f_setCursorPos()
				end
			end
	--SCROLL RIGHT (Cursor X - Next Column)
		elseif (commandGetState(main.t_cmd[main.playerInput], '$F') or (commandGetState(main.t_cmd[main.playerInput], 'holdr') and bufr >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.gallery_info.cursor_move_snd[1], motif.gallery_info.cursor_move_snd[2])
			if galleryCursorX < motif.gallery_info.preview_art_columns-1 + hiddenColumns then
				galleryCursorX = galleryCursorX + 1
			--Hidden Columns Logic
				if galleryCursorX > motif.gallery_info.preview_art_columns-1 then
					galleryMoveX = galleryMoveX + 1
				end
			else --Wrap
				galleryCursorX = 0
				galleryMoveX = 0
			end
			f_setCursorPos() --Set New Cursor Pos
		--Prevent fall out of t_gallery items
			if galleryCursor > artMax then
				galleryCursorX = 0
				galleryMoveX = 0
				f_setCursorPos()
			end
	--SCROLL UP (Cursor Y - Previous Row)
		elseif (commandGetState(main.t_cmd[main.playerInput], '$U') or (commandGetState(main.t_cmd[main.playerInput], 'holdu') and bufu >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.gallery_info.cursor_move_snd[1], motif.gallery_info.cursor_move_snd[2])
			if galleryCursorY > 0 then
				galleryCursorY = galleryCursorY - 1
			--Hidden Rows Logic
				if galleryMoveY > 0 then
					galleryMoveY = galleryMoveY - 1
				end
			else --Wrap
				galleryCursorY = motif.gallery_info.preview_art_rows-1 + hiddenRows
				--if hiddenRows > 0 then
					galleryMoveY = hiddenRows
				--end
			end
			f_setCursorPos() --Set New Cursor Pos
		--Prevent fall out of t_gallery items
			if galleryCursor > artMax then
				while t_gallery[galleryCursor] == nil do
					galleryCursorY = galleryCursorY - 1
					if galleryMoveY > 0 then
						galleryMoveY = galleryMoveY - 1
					end
					f_setCursorPos()
				end
			end
	--SCROLL DOWN (Cursor Y - Next Row)
		elseif (commandGetState(main.t_cmd[main.playerInput], '$D') or (commandGetState(main.t_cmd[main.playerInput], 'holdd') and bufd >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.gallery_info.cursor_move_snd[1], motif.gallery_info.cursor_move_snd[2])
			if galleryCursorY < motif.gallery_info.preview_art_rows-1 + hiddenRows then
				galleryCursorY = galleryCursorY + 1
			--Hidden Rows Logic
				if galleryCursorY > motif.gallery_info.preview_art_rows-1 then
					galleryMoveY = galleryMoveY + 1
				end
			else --Wrap
				galleryCursorY = 0
				galleryMoveY = 0
			end
			f_setCursorPos() --Set New Cursor Pos
		--Prevent fall out of t_gallery items
			if galleryCursor > artMax then
				galleryCursorY = 0
				galleryMoveY = 0
				f_setCursorPos()
			end
		end
	--VERTICAL BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0			
		end
	--HORIZONTAL BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdr') then
			bufl = 0
			bufr = bufr + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdl') then
			bufr = 0
			bufl = bufl + 1
		else
			bufr = 0
			bufl = 0
		end
		main.f_cmdInput()
		main.f_refresh()
	end
end
--;===========================================================================================
--; ARTWORK VIEWER MENU
--;===========================================================================================
local txt_pageInfo = main.f_createTextImg(motif.artviewer_info, 'page', {defsc = motif.defaultgallery})
local txt_artInfo = main.f_createTextImg(motif.artviewer_info, 'info', {defsc = motif.defaultgallery})
local artPosX = nil
local artPosY = nil
local artScaleX = nil
local artScaleY = nil

local function f_getNewCursorPos() --Get new gallery cursor position when exit from artwork viewer (Unfinished)
	galleryCursorX = (galleryCursor - 1) - motif.gallery_info.preview_art_columns*galleryCursorY
	galleryCursorY = (galleryCursor - 1 - galleryCursorX) / motif.gallery_info.preview_art_columns
end

local function f_resetArtPos()
artPosX = t_gallery[galleryCursor].pos[1]
artPosY = t_gallery[galleryCursor].pos[2]
artScaleX = t_gallery[galleryCursor].scale[1]
artScaleY = t_gallery[galleryCursor].scale[2]
end

local function f_nextArt(limit)
	local limit = limit
	galleryCursor = galleryCursor + 1
	if galleryCursor > limit then --Go to first art
		galleryCursor = 1
	end
end

local function f_previousArt(limit)
	local limit = limit
	galleryCursor = galleryCursor - 1
	if galleryCursor < 1 then --Go to last art
		galleryCursor = limit
	end
end

local function f_drawArtwork()
local artPic = t_gallery[galleryCursor].spr[1] ..','.. t_gallery[galleryCursor].spr[2] ..','.. artPosX ..','.. artPosY ..','.. '-1'
artPic = animNew(motif.files.gallery_data, artPic)
animSetScale(artPic, artScaleX, artScaleY)
animUpdate(artPic)
animDraw(artPic)
end

function f_artMenu(artLimit)
	main.f_bgReset(motif.artviewerbgdef.bg)
	main.f_fadeReset('fadein', motif.artviewer_info)
	main.close = false
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local bufc = 0
	local bufb = 0
	local bufz = 0
	local bufy = 0
	local bufx = 0
	local maxArt = artLimit
	local artZero = ""
	local artLimitZero = ""
	if maxArt < 10 then artLimitZero = "0" end
	local hideMenu = false
	local textData = nil
	f_resetArtPos()
	main.f_cmdInput()
	while true do
	--Clear Color
		if not skipClear then
			clearColor(motif.artviewerbgdef.bgclearcolor[1], motif.artviewerbgdef.bgclearcolor[2], motif.artviewerbgdef.bgclearcolor[3])
		end
	--Layerno = 0 backgrounds
		bgDraw(motif.artviewerbgdef.bg, falseBool)
	--Draw Artwork (only if has Spr Data defined)
		if t_gallery[galleryCursor].spr[1] and t_gallery[galleryCursor].spr[2] ~= nil then
			f_drawArtwork()
			textData = t_gallery[galleryCursor].info
		else
			textData = txt_noData
		end
	--Draw HUD Assets
		if not hideMenu then
		--Layerno = 1 backgrounds
			bgDraw(motif.artviewerbgdef.bg, trueBool)
		--Draw Artwork Info
			txt_artInfo:draw()
			txt_artInfo:update({
				text = textData,
				x = motif.artviewer_info.menu_pos[1] + motif.artviewer_info.info_offset[1],
				y = motif.artviewer_info.menu_pos[2] + motif.artviewer_info.info_offset[2]
			})
		--Draw Page Info
			if galleryCursor < 10 then artZero = "0" else artZero = "" end
			txt_pageInfo:draw()
			txt_pageInfo:update({
				text = motif.artviewer_info.page_text..artZero..galleryCursor.."/".. artLimitZero..maxArt,
				x = motif.artviewer_info.menu_pos[1] + motif.artviewer_info.page_offset[1],
				y = motif.artviewer_info.menu_pos[2] + motif.artviewer_info.page_offset[2]
			})
			--if galleryCursor > 1 then
				animUpdate(motif['artviewer_info'].menu_arrow_left_data)
				animDraw(motif['artviewer_info'].menu_arrow_left_data)
			--end
			--if galleryCursor < maxArt then
				animUpdate(motif['artviewer_info'].menu_arrow_right_data)
				animDraw(motif['artviewer_info'].menu_arrow_right_data)
			--end
		end
	--DEBUG STUFF
	--[[
		txt_debugZoom:draw()
		txt_debugPosX:draw()
		txt_debugPosY:draw()
		txt_debugZoom:update({text = "ZOOM: "..artScaleX})
		txt_debugPosX:update({text = "POS X: "..artPosX})
		txt_debugPosY:update({text = "POS Y: "..artPosY})
	--]]
	--Fadein/Fadeout
		main.f_fadeAnim(motif.artviewer_info)
	--Close Menu
		if main.close and not main.fadeActive then
			main.f_bgReset(motif.gallerybgdef.bg)
			main.f_fadeReset('fadein', motif.gallery_info)
			main.close = false
			break
	--Back to Gallery Menu
		elseif esc() or main.f_input(main.t_players, {'m'}) or commandGetState(main.t_cmd[main.playerInput], 'b') then
			sndPlay(motif.files.snd_data, motif.artviewer_info.cursor_done_snd[1], motif.artviewer_info.cursor_done_snd[2])
			main.f_fadeReset('fadeout', motif.artviewer_info)
			main.close = true
	--NEXT ART PAGE
		elseif (commandGetState(main.t_cmd[main.playerInput], 'w') or (commandGetState(main.t_cmd[main.playerInput], 'holdnext') and bufc >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.artviewer_info.cursor_move_snd[1], motif.artviewer_info.cursor_move_snd[2])
			f_nextArt(maxArt)
		--If current item is not unlocked
			while main.t_unlockLua.gallery[t_gallery[galleryCursor].id] ~= nil do
				f_nextArt(maxArt) --Go to an unlocked art
			end
			f_resetArtPos()
	--PREVIOUS ART PAGE
		elseif (commandGetState(main.t_cmd[main.playerInput], 'd') or (commandGetState(main.t_cmd[main.playerInput], 'holdprevious') and bufb >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.artviewer_info.cursor_move_snd[1], motif.artviewer_info.cursor_move_snd[2])
			f_previousArt(maxArt)
		--If current item is not unlocked
			while main.t_unlockLua.gallery[t_gallery[galleryCursor].id] ~= nil do
				f_previousArt(maxArt) --Go to an unlocked art
			end
			f_resetArtPos()
	--RESET ART POSITION
		elseif commandGetState(main.t_cmd[main.playerInput], 'a') and not main.fadeActive then
			f_resetArtPos()
	--HIDE MENU
		elseif commandGetState(main.t_cmd[main.playerInput], 's') and not main.fadeActive then
			if not hideMenu then hideMenu = true else hideMenu = false end
		end
	--MOVE UP ART
		if (commandGetState(main.t_cmd[main.playerInput], '$U') or (commandGetState(main.t_cmd[main.playerInput], 'holdu') and bufu >= 3)) and not main.fadeActive then
			if artPosY > t_gallery[galleryCursor].movelimit[2] then
				artPosY = artPosY - motif.artviewer_info.art_movespeed
			end
	--MOVE DOWN ART
		elseif (commandGetState(main.t_cmd[main.playerInput], '$D') or (commandGetState(main.t_cmd[main.playerInput], 'holdd') and bufd >= 3)) and not main.fadeActive then
			if artPosY < t_gallery[galleryCursor].movelimit[4] then
				artPosY = artPosY + motif.artviewer_info.art_movespeed
			end
		end
	--MOVE LEFT ART
		if (commandGetState(main.t_cmd[main.playerInput], '$B') or (commandGetState(main.t_cmd[main.playerInput], 'holdl') and bufl >= 3)) and not main.fadeActive then
			if artPosX > t_gallery[galleryCursor].movelimit[1] then
				artPosX = artPosX - motif.artviewer_info.art_movespeed
			end
	--MOVE RIGHT ART
		elseif (commandGetState(main.t_cmd[main.playerInput], '$F') or (commandGetState(main.t_cmd[main.playerInput], 'holdr') and bufr >= 3)) and not main.fadeActive then
			if artPosX < t_gallery[galleryCursor].movelimit[3] then
				artPosX = artPosX + motif.artviewer_info.art_movespeed
			end
		end
	--ZOOM IN ART
		if (commandGetState(main.t_cmd[main.playerInput], 'y') or (commandGetState(main.t_cmd[main.playerInput], 'holdy') and bufy >= 10)) and not main.fadeActive then
			if artScaleX < t_gallery[galleryCursor].zoomlimit[2] and artScaleY < t_gallery[galleryCursor].zoomlimit[2] then
				artScaleX = artScaleX + motif.artviewer_info.art_zoomspeed
				artScaleY = artScaleY + motif.artviewer_info.art_zoomspeed
			end
	--ZOOM OUT ART
		elseif (commandGetState(main.t_cmd[main.playerInput], 'x') or (commandGetState(main.t_cmd[main.playerInput], 'holdx') and bufx >= 10)) and not main.fadeActive then
			if artScaleX > t_gallery[galleryCursor].zoomlimit[1] and artScaleY > t_gallery[galleryCursor].zoomlimit[1] then
				artScaleX = artScaleX - motif.artviewer_info.art_zoomspeed
				artScaleY = artScaleY - motif.artviewer_info.art_zoomspeed
			end
		end
	--ART PAGE BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdnext') then
			bufb = 0
			bufc = bufc + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdprevious') then
			bufc = 0
			bufb = bufb + 1
		else
			bufb = 0
			bufc = 0
		end
	--VERTICAL BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0			
		end
	--HORIZONTAL BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdr') then
			bufl = 0
			bufr = bufr + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdl') then
			bufr = 0
			bufl = bufl + 1
		else
			bufr = 0
			bufl = 0
		end
	--ZOOM BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdy') then
			bufx = 0
			bufy = bufy + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdx') then
			bufy = 0
			bufx = bufx + 1
		else
			bufx = 0
			bufy = 0
		end
		main.f_cmdInput()
		main.f_refresh()
	end
end

--Adds new commands for menu control
main.f_commandAdd("holdu", "/U", 1, 1)
main.f_commandAdd("holdd", "/D", 1, 1)
main.f_commandAdd("holdr", "/F", 1, 1)
main.f_commandAdd("holdl", "/B", 1, 1)

main.f_commandAdd("holdprevious", "/d", 1, 1)
main.f_commandAdd("holdnext", "/w", 1, 1)
main.f_commandAdd("holdx", "/x", 1, 1)
main.f_commandAdd("holdy", "/y", 1, 1)

--Setup argument for bgDraw functions
if nightlyVer then
	trueBool = 1
	falseBool = 0
else
	trueBool = true
	falseBool = false
end