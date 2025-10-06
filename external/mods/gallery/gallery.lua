--[[					GALLERY MODULE
===================================================================
Version: 1.2
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2025-10-01 Nightly Build
Description: Adds a Custom Gallery Mode entry to the Main Menu.
===================================================================
]]
local nightlyVer = true --Indicates if you are using Nightly IkemenGO version, to adjust some values ​​to draw the background...
--TODO: Implement Multiple Artworks in a same Slot/Cell to Switch in Artwork Viewer.
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

--[Gallery Info] default parameters (used for rendering gallery screen assets)
local t_base = {
	reload_enabled = 0,
	
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	menu_uselocalcoord = 1,
	menu_pos = {0, 0},
	
	cursor_move_snd = {100, 0},
	cursor_category_snd = {100, 0},
	cursor_done_snd = {100, 1},
	cancel_snd = {100, 2},
	
	title_offset = {159, 15},
	title_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	title_scale = {1.0, 1.0},
	title_text = 'GALLERY',
	title_text_artworks = 'ARTWORKS',
	title_text_storyboards = 'CUTSCENES',
	title_text_music = 'MUSIC',
	
	info_offset = {5, 230},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {0.95, 0.95},
	info_text = '',
	info_unknown_text = '???',
	
	common_spr = "external/mods/gallery/common.sff",
	
	artworks_def = "external/mods/gallery/artworks.def",
	artworks_spr = "external/mods/gallery/artworks.sff",
	
	storyboards_def = "external/mods/gallery/storyboards.def",
	storyboards_spr = "external/mods/gallery/storyboards.sff",
	
	music_def = "external/mods/gallery/music.def",
	music_spr = "external/mods/gallery/music.sff",
	
	preview_art_columns = 3,
	preview_art_rows = 3,
	preview_art_hiddencolumns = 0,
	preview_art_hiddenrows = 1,
	
	preview_art_offset = {1015, 968},
	preview_art_spacing = {950, 218},
	preview_art_scale = {0.0558, 0.0558},
	preview_art_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_storyboard_offset = {825, 767},
	preview_storyboard_spacing = {165, 168},
	preview_storyboard_size = {1280, 720},
	preview_storyboard_scale = {0.0705, 0.07},
	preview_storyboard_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_music_offset = {825, 767},
	preview_music_spacing = {165, 168},
	preview_music_size = {1280, 720},
	preview_music_scale = {0.0705, 0.07},
	preview_music_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_bg_anim = -1,
	preview_bg_spr = {0, 0},
	preview_bg_offset = {5, 13},
	preview_bg_spacing = {6, 6},
	preview_bg_facing = 1,
	preview_bg_scale = {1.0, 1.0},
	preview_bg_size = {96, 56},
	preview_bg_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},

	preview_cursor_anim = -1,
	preview_cursor_spr = {1, 0},
	preview_cursor_offset = {5, 13},
	preview_cursor_spacing = {6, 6},
	preview_cursor_facing = 1,
	preview_cursor_scale = {1.0, 1.0},
	preview_cursor_size = {96, 56},
	preview_cursor_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_locked_anim = -1,
	preview_locked_spr = {2, 0},
	preview_locked_offset = {6.9, 14.9},
	preview_locked_spacing = {12, 12},
	preview_locked_facing = 1,
	preview_locked_size = {90, 50},
	preview_locked_scale = {1.0, 1.0},
	preview_locked_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_unknown_anim = -1,
	preview_unknown_spr = {3, 0},
	preview_unknown_offset = {6.9, 14.9},
	preview_unknown_spacing = {12, 12},
	preview_unknown_facing = 1,
	preview_unknown_size = {90, 50},
	preview_unknown_scale = {1.0, 1.0},
	preview_unknown_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_unknown_music_anim = -1,
	preview_unknown_music_spr = {4, 0},
	preview_unknown_music_offset = {6.9, 14.9},
	preview_unknown_music_spacing = {12, 12},
	preview_unknown_music_facing = 1,
	preview_unknown_music_size = {90, 50},
	preview_unknown_music_scale = {1.0, 1.0},
	preview_unknown_music_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
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
local t_baseArtwork = {
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	menu_pos = {0, 0},
	
	cursor_move_snd = {100, 0},
	cursor_done_snd = {100, 2},
	
	art_offset = {159, 120},
	art_size = {894, 894},
	art_scale = {0.27, 0.27},
	art_movespeed = 10,
	art_movelimit = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	art_zoomspeed = 0.01,
	art_zoomlimit = {0.21, 0.85},
	
	zoomin_key = 'y',
	zoomout_key = 'x',
	next_key = 'w',
	previous_key = 'd',
	switch_key = 'c',
	reset_key = 'a',
	hide_key = 's',
	back_key = 'b',
	
	info_offset = {5, 230},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {0.95, 0.95},
	info_text = '',
	
	page_offset = {312, 15},
	page_font = {'f-6x9.def', 0, -1, 255, 255, 255, -1},
	page_scale = {1.0, 1.0},
	page_text = 'PAGE ',
	
	menu_arrow_left_anim = -1,
	menu_arrow_left_spr = {402, 0},
	menu_arrow_left_offset = {10, 120},
	menu_arrow_left_facing = -1,
	menu_arrow_left_scale = {0.5, 0.5},
	
	menu_arrow_right_anim = -1,
	menu_arrow_right_spr = {402, 0},
	menu_arrow_right_offset = {310, 120},
	menu_arrow_right_facing = 1,
	menu_arrow_right_scale = {0.5, 0.5},
}
if motif.artviewer_info == nil then
	motif.artviewer_info = {}
end
motif.artviewer_info = main.f_tableMerge(t_baseArtwork, motif.artviewer_info)

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
	motif.f_loadSprData(v, {s = 'menu_arrow_left_',  x = v.menu_pos[1], y = v.menu_pos[2]})
	motif.f_loadSprData(v, {s = 'menu_arrow_right_', x = v.menu_pos[1], y = v.menu_pos[2]})
end

--[MusicPlayer Info] default parameters (used for rendering music player screen assets)
local t_baseBGM = {
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	menu_pos = {0, 0},
	
	cursor_move_snd = {100, 0},
	cursor_change_snd = {100, 1},
	cursor_done_snd = {-1, -1},
	
	loop_key = 'x',
	pause_key = 'a',
	back_key = 'b',
	
	info_offset = {160, 120},
	info_spacing = {0, 5},
	info_font = {'Open_Sans.def', 0, 0, 255, 255, 255, -1},
	info_scale = {0.5, 0.5},
	info_text = '',
	info_delay = 0,
	info_textwrap = 'w',
	info_window = {5, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	menu_arrow_left_anim = -1,
	menu_arrow_left_spr = {402, 0},
	menu_arrow_left_offset = {10, 120},
	menu_arrow_left_facing = -1,
	menu_arrow_left_scale = {0.5, 0.5},
	
	menu_arrow_right_anim = -1,
	menu_arrow_right_spr = {402, 0},
	menu_arrow_right_offset = {310, 120},
	menu_arrow_right_facing = 1,
	menu_arrow_right_scale = {0.5, 0.5},
}
if motif.musicplayer_info == nil then
	motif.musicplayer_info = {}
end
motif.musicplayer_info = main.f_tableMerge(t_baseBGM, motif.musicplayer_info)

--If not defined [MusicPlayerBGdef]
if motif.musicplayerbgdef == nil then
	motif.musicplayerbgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
end

-- This code creates data out of optional [MusicPlayerBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.musicplayerbgdef.spr ~= nil and motif.musicplayerbgdef.spr ~= '' then
	motif.musicplayerbgdef.spr = searchFile(motif.musicplayerbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.musicplayerbgdef.spr_data = sffNew(motif.musicplayerbgdef.spr)
else
	motif.musicplayerbgdef.spr = motif.files.spr
	motif.musicplayerbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.musicplayerbgdef.bg = bgNew(motif.musicplayerbgdef.spr_data, motif.def, 'musicplayerbg')

-- fadein/fadeout anim data generation.
if motif.musicplayer_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.musicplayer_info, {s = 'fadein_'})
end
if motif.musicplayer_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.musicplayer_info, {s = 'fadeout_'})
end

--arrows spr/anim data generation.
for _, v in ipairs({motif.musicplayer_info}) do
	motif.f_loadSprData(v, {s = 'menu_arrow_left_',  x = v.menu_pos[1], y = v.menu_pos[2]})
	motif.f_loadSprData(v, {s = 'menu_arrow_right_', x = v.menu_pos[1], y = v.menu_pos[2]})
end

--disabled scaling if element uses default values (non-existing in mugen)
motif.defaultgallery = motif.gallery_info.menu_uselocalcoord == 0

--Setup argument for bgDraw functions
if nightlyVer then
	trueBool = 1
	falseBool = 0
else
	trueBool = true
	falseBool = false
end

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
--; 								 GALLERY LOGIC
--;===========================================================================================
local txt_titleMenu = main.f_createTextImg(motif.gallery_info, 'title', {defsc = motif.defaultgallery})
local txt_previewInfo = main.f_createTextImg(motif.gallery_info, 'info', {defsc = motif.defaultgallery})
local txt_noData = "NO ARTWORK DATA FOUND."
local txt_songInfo = main.f_createTextImg(motif.musicplayer_info, 'info', {defsc = motif.defaultgallery})

local txt_pageInfo = main.f_createTextImg(motif.artviewer_info, 'page', {defsc = motif.defaultgallery})
local txt_artInfo = main.f_createTextImg(motif.artviewer_info, 'info', {defsc = motif.defaultgallery})
local artPosX = nil
local artPosY = nil
local artScaleX = nil
local artScaleY = nil

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
	--[[
		elseif lineCase:match('^%s*%[%s*artworkslot%s*(%d+)%s*%]') then
			item = item + 1
			if item < #t_gallery[section] then
				section = 1
				category = "artwork"
				slot = true
			end
	]]
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
			--[[
				if lineCase:match('^%s*slot%s*=%s*{%s*$') then --start of the 'multiple artworks in one slot' assignment
					table.insert(t_gallery[section], {['slot'] = 1})
					slot = true
				elseif slot and lineCase:match('^%s*}%s*$') then --end of 'multiple artworks in one slot' assignment
					slot = false
				end
			]]
				if param:match('^id$') then
				--[GalleryArtworks]
					if section == 1 then
						table.insert(t_gallery[section],
							{
								--slot = {},
								id = value,
								spr = {},
								size = motif.artviewer_info.art_size,
								pos = motif.artviewer_info.art_offset,
								scale = motif.artviewer_info.art_scale,
								zoomlimit = motif.artviewer_info.art_zoomlimit,
								movelimit = motif.artviewer_info.art_movelimit,
								info = motif.gallery_info.info_unknown_text,
								previewpos = motif.gallery_info.preview_art_offset,
								previewspacing = motif.gallery_info.preview_art_spacing,
								previewscale = motif.gallery_info.preview_art_scale,
								unlock = 'true'
							}
						)
				--[[
					elseif section == 1 and slot then
						table.insert(t_gallery[section][item].slot,
							{
								id = value,
								spr = {},
								size = motif.artviewer_info.art_size,
								pos = motif.artviewer_info.art_offset,
								scale = motif.artviewer_info.art_scale,
								zoomlimit = motif.artviewer_info.art_zoomlimit,
								movelimit = motif.artviewer_info.art_movelimit,
								info = motif.gallery_info.info_unknown_text,
								previewpos = motif.gallery_info.preview_art_offset,
								previewspacing = motif.gallery_info.preview_art_spacing,
								previewscale = motif.gallery_info.preview_art_scale,
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
								info = motif.gallery_info.info_unknown_text,
								volume = 100,
								loopstart = 0,
								loopend = 0,
								previewspr = {},
								previewsize = motif.gallery_info['preview_'..category..'_size'],
								previewpos = motif.gallery_info['preview_'..category..'_offset'],
								previewspacing = motif.gallery_info['preview_'..category..'_spacing'],
								previewscale = motif.gallery_info['preview_'..category..'_scale'],
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
	if main.debugLog then main.f_printTable(t_gallery, 'debug/t_gallery.txt') end
--Set Unlock Conditions
	for i=1, #t_gallery do
		for k, v in ipairs(t_gallery[i]) do
			if main.t_unlockLua.gallery == nil then main.t_unlockLua['gallery'] = {} end
			main.t_unlockLua.gallery[v.id] = v.unlock
		end
	end
--Load .sff files (only if .def data is detected)
	if category == "artwork" then
		if main.f_fileExists(motif.gallery_info.artworks_def) then
			t_gallery[1].name = motif.gallery_info.title_text_artworks
			if main.f_fileExists(motif.gallery_info.artworks_spr) then
				motif.files.galleryArtworks_data = sffNew(motif.gallery_info.artworks_spr)
			else
				motif.files.galleryArtworks_data = sffNew()
			end
		end
	elseif category == "storyboard" then
		if main.f_fileExists(motif.gallery_info.storyboards_def) then
			t_gallery[2].name = motif.gallery_info.title_text_storyboards
			if main.f_fileExists(motif.gallery_info.storyboards_spr) then
				motif.files.galleryStoryboards_data = sffNew(motif.gallery_info.storyboards_spr)
			else
				motif.files.galleryStoryboards_data = sffNew()
			end
		end
	elseif category == "music" then
		if main.f_fileExists(motif.gallery_info.music_def) then
			t_gallery[3].name = motif.gallery_info.title_text_music
			if main.f_fileExists(motif.gallery_info.music_spr) then
				motif.files.galleryMusic_data = sffNew(motif.gallery_info.music_spr)
			else
				motif.files.galleryMusic_data = sffNew()
			end
		end
	end
	if main.debugLog then main.f_printTable(t_gallery, 'debug/t_gallery.txt') end
end

local function f_loadFiles()
--Load .def file with Artworks
	if main.f_fileExists(motif.gallery_info.artworks_def) then
		motif.files.galleryArtworks_def = motif.gallery_info.artworks_def
	else
		motif.files.galleryArtworks_def = motif.files.select
	end
	f_loadGallery(motif.files.galleryArtworks_def, true) --Load gallery artworks data
--Load .def file with Storyboards
	if main.f_fileExists(motif.gallery_info.storyboards_def) then
		motif.files.galleryStoryboards_def = motif.gallery_info.storyboards_def
	else
		motif.files.galleryStoryboards_def = motif.files.select
	end
	f_loadGallery(motif.files.galleryStoryboards_def) --Load gallery storyboards data
--Load .def with Music
	if main.f_fileExists(motif.gallery_info.music_def) then
		motif.files.galleryMusic_def = motif.gallery_info.music_def
	else
		motif.files.galleryMusic_def = motif.files.select
	end
	f_loadGallery(motif.files.galleryMusic_def) --Load gallery music data
end
f_loadFiles()

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
	if main.debugLog then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
end

--creates sprite data out of table values
local anim = ''
local facing = ''
if main.f_fileExists(motif.gallery_info.common_spr) then
	motif.files.gallery_data = sffNew(motif.gallery_info.common_spr)
else
	motif.files.gallery_data = sffNew()
end
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
f_loadGallerySprData(motif.gallery_info, {s = 'preview_locked_'}) --Generate motif.gallery_info.preview_locked_data
f_loadGallerySprData(motif.gallery_info, {s = 'preview_unknown_'}) --Generate motif.gallery_info.preview_unknown_data
f_loadGallerySprData(motif.gallery_info, {s = 'preview_unknown_music_'}) --Generate motif.gallery_info.preview_unknown_music_data

local function f_drawPreview(animdata, group, index, x, y, scaleX, scaleY, x1, y1, x2, y2)
	local x = x or 0
	local y = y or 0
	local scaleX = scaleX or 1
	local scaleY = scaleY or 1
	local anim = group .. ',' .. index .. ',' .. x .. ',' .. y .. ',' .. '-1'
	--local anim = group .. ',' .. index .. ', 0,0, -1'
	anim = animNew(animdata, anim)
	animSetScale(anim, scaleX, scaleY)
	--animSetPos(anim, x, y)
	animSetWindow(anim, x1, y1, x2, y2)
	animUpdate(anim)
	animDraw(anim)
end

local function f_drawGallery(t, columns, rows) --Draw Gallery Content
	for i=0, columns-1 do
		for j=0, rows-1 do
			local index = (i + columns * j) + 1 --This is the same logic of f_setCursorPos() function
			if index <= #t then
			--Draw Item Preview Cell BG
				main.f_animPosDraw(
					motif.gallery_info.preview_bg_data,
					motif.gallery_info.menu_pos[1] + motif.gallery_info.preview_bg_offset[1] + i * (motif.gallery_info.preview_bg_size[1] + motif.gallery_info.preview_bg_spacing[1]) - (galleryMoveX * (motif.gallery_info.preview_bg_size[1] + motif.gallery_info.preview_bg_spacing[1])),
					motif.gallery_info.menu_pos[2] + motif.gallery_info.preview_bg_offset[2] + j * (motif.gallery_info.preview_bg_size[2] + motif.gallery_info.preview_bg_spacing[2]) - (galleryMoveY * (motif.gallery_info.preview_bg_size[2] + motif.gallery_info.preview_bg_spacing[2])),
					motif.gallery_info.preview_bg_facing,
					false
				)
				animSetWindow(motif.gallery_info.preview_bg_data, motif.gallery_info.preview_bg_window[1], motif.gallery_info.preview_bg_window[2], motif.gallery_info.preview_bg_window[3], motif.gallery_info.preview_bg_window[4])
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
				if t_gallery[gallerySection].name == motif.gallery_info.title_text_artworks then
					sprData = "spr"
					sprSize = "size"
					sprWindow = "art"
					sffData = motif.files.galleryArtworks_data
					unknownData = motif.gallery_info.preview_unknown_data
					unknownPos = motif.gallery_info.preview_unknown_offset
					unknownSpacing = motif.gallery_info.preview_unknown_spacing
					unknownSize = motif.gallery_info.preview_unknown_size
					unknownScale = motif.gallery_info.preview_unknown_scale
					unknowFacing = motif.gallery_info.preview_unknown_facing
					unknownWindow = motif.gallery_info.preview_unknown_window
			--Not Artworks section
				else
					sprData = "previewspr"
					sprSize = "previewsize"
					if t_gallery[gallerySection].name == motif.gallery_info.title_text_storyboards then
						sffData = motif.files.galleryStoryboards_data
						sprWindow = "storyboard"
						unknownData = motif.gallery_info.preview_unknown_data
						unknownPos = motif.gallery_info.preview_unknown_offset
						unknownSpacing = motif.gallery_info.preview_unknown_spacing
						unknownSize = motif.gallery_info.preview_unknown_size
						unknownScale = motif.gallery_info.preview_unknown_scale
						unknowFacing = motif.gallery_info.preview_unknown_facing
						unknownWindow = motif.gallery_info.preview_unknown_window
					elseif t_gallery[gallerySection].name == motif.gallery_info.title_text_music then
						sffData = motif.files.galleryMusic_data
						sprWindow = "music"
						unknownData = motif.gallery_info.preview_unknown_music_data
						unknownPos = motif.gallery_info.preview_unknown_music_offset
						unknownSpacing = motif.gallery_info.preview_unknown_music_spacing
						unknownSize = motif.gallery_info.preview_unknown_music_size
						unknownScale = motif.gallery_info.preview_unknown_music_scale
						unknowFacing = motif.gallery_info.preview_unknown_music_facing
						unknownWindow = motif.gallery_info.preview_unknown_music_window
					end
				end
			--Draw Unlocked Item Preview
				if main.t_unlockLua.gallery[t[index].id] == nil then --If the item is Unlocked
				--If Spr Data is defined
					if t[index][sprData][1] and t[index][sprData][2] ~= nil then
						f_drawPreview(sffData,
							t[index][sprData][1], t[index][sprData][2],
							motif.gallery_info.menu_pos[1] + t[index].previewpos[1] + i * (t[index][sprSize][1] + t[index].previewspacing[1]) - (galleryMoveX * (t[index][sprSize][1] + t[index].previewspacing[1])),
							motif.gallery_info.menu_pos[2] + t[index].previewpos[2] + j * (t[index][sprSize][2] + t[index].previewspacing[2]) - (galleryMoveY * (t[index][sprSize][2] + t[index].previewspacing[2])),
							t[index].previewscale[1], t[index].previewscale[2],
							motif.gallery_info['preview_'..sprWindow..'_window'][1], motif.gallery_info['preview_'..sprWindow..'_window'][2], motif.gallery_info['preview_'..sprWindow..'_window'][3], motif.gallery_info['preview_'..sprWindow..'_window'][4]
						)
				--If Spr Data is NOT defined
					else
						main.f_animPosDraw(
							unknownData,
							motif.gallery_info.menu_pos[1] + unknownPos[1] + i * (unknownSize[1] + unknownSpacing[1]) - (galleryMoveX * (unknownSize[1] + unknownSpacing[1])),
							motif.gallery_info.menu_pos[2] + unknownPos[2] + j * (unknownSize[2] + unknownSpacing[2]) - (galleryMoveY * (unknownSize[2] + unknownSpacing[2])),
							unknowFacing,
							false
						)
						animSetWindow(unknownData, unknownWindow[1], unknownWindow[2], unknownWindow[3], unknownWindow[4])
					end
			--Draw Locked Item Preview
				else
					main.f_animPosDraw(
						motif.gallery_info.preview_locked_data,
						motif.gallery_info.menu_pos[1] + motif.gallery_info.preview_locked_offset[1] + i * (motif.gallery_info.preview_locked_size[1] + motif.gallery_info.preview_locked_spacing[1]) - (galleryMoveX * (motif.gallery_info.preview_locked_size[1] + motif.gallery_info.preview_locked_spacing[1])),
						motif.gallery_info.menu_pos[2] + motif.gallery_info.preview_locked_offset[2] + j * (motif.gallery_info.preview_locked_size[2] + motif.gallery_info.preview_locked_spacing[2]) - (galleryMoveY * (motif.gallery_info.preview_locked_size[2] + motif.gallery_info.preview_locked_spacing[2])),
						motif.gallery_info.preview_locked_facing,
						false
					)
					animSetWindow(motif.gallery_info.preview_locked_data, motif.gallery_info.preview_locked_window[1], motif.gallery_info.preview_locked_window[2], motif.gallery_info.preview_locked_window[3], motif.gallery_info.preview_locked_window[4])
				end
			end
		end
	end
end

local function f_setCursorPos() --Used to calculate gallery cursor pos in gallery menu
	galleryCursor = (galleryCursorX+(motif.gallery_info.preview_art_columns+hiddenColumns)*galleryCursorY) + 1
end

local function f_getNewCursorPos() --Get new gallery cursor position when exit from artwork viewer (Unfinished)
	galleryCursorX = (galleryCursor - 1) - motif.gallery_info.preview_art_columns*galleryCursorY
	galleryCursorY = (galleryCursor - 1 - galleryCursorX) / motif.gallery_info.preview_art_columns
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
artPic = animNew(motif.files.galleryArtworks_data, artPic)
animSetScale(artPic, artScaleX, artScaleY)
animSetPos(artPic, artPosX, artPosY)
animUpdate(artPic)
animDraw(artPic)
end

local function f_resetArtPos()
artPosX = t_gallery[gallerySection][galleryCursor].pos[1]
artPosY = t_gallery[gallerySection][galleryCursor].pos[2]
artScaleX = t_gallery[gallerySection][galleryCursor].scale[1]
artScaleY = t_gallery[gallerySection][galleryCursor].scale[2]
end

local function f_artMenu(artLimit)
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
		if t_gallery[gallerySection][galleryCursor].spr[1] and t_gallery[gallerySection][galleryCursor].spr[2] ~= nil then
			f_drawArtwork()
			textData = t_gallery[gallerySection][galleryCursor].info
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
				text = artZero..galleryCursor..". "..textData,
				x = motif.artviewer_info.menu_pos[1] + motif.artviewer_info.info_offset[1],
				y = motif.artviewer_info.menu_pos[2] + motif.artviewer_info.info_offset[2]
			})
		--Draw Page Info
			if galleryCursor < 10 then artZero = "0" else artZero = "" end
			txt_pageInfo:draw()
			txt_pageInfo:update({
				text = motif.artviewer_info.page_text.."1".."/".."1",
				x = motif.artviewer_info.menu_pos[1] + motif.artviewer_info.page_offset[1],
				y = motif.artviewer_info.menu_pos[2] + motif.artviewer_info.page_offset[2]
			})
			--if galleryCursor > 1 then
				animUpdate(motif.artviewer_info.menu_arrow_left_data)
				animDraw(motif.artviewer_info.menu_arrow_left_data)
			--end
			--if galleryCursor < maxArt then
				animUpdate(motif.artviewer_info.menu_arrow_right_data)
				animDraw(motif.artviewer_info.menu_arrow_right_data)
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
		elseif (esc() or main.f_input(main.t_players, {'m'}) or commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.back_key)) and not main.close then
			sndPlay(motif.files.snd_data, motif.artviewer_info.cursor_done_snd[1], motif.artviewer_info.cursor_done_snd[2])
			main.f_fadeReset('fadeout', motif.artviewer_info)
			main.close = true
	--NEXT ART PAGE
		elseif (commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.next_key) or (commandGetState(main.t_cmd[main.playerInput], 'holdnext') and bufc >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.artviewer_info.cursor_move_snd[1], motif.artviewer_info.cursor_move_snd[2])
			f_nextItem(maxArt)
		--If current item is not unlocked
			while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
				f_nextItem(maxArt) --Go to an unlocked art
			end
			f_resetArtPos()
	--PREVIOUS ART PAGE
		elseif (commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.previous_key) or (commandGetState(main.t_cmd[main.playerInput], 'holdprevious') and bufb >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.artviewer_info.cursor_move_snd[1], motif.artviewer_info.cursor_move_snd[2])
			f_previousItem(maxArt)
		--If current item is not unlocked
			while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
				f_previousItem(maxArt) --Go to an unlocked art
			end
			f_resetArtPos()
	--SWITCH SLOT ART
		elseif commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.switch_key) and not main.fadeActive then
			--TODO
	--RESET ART POSITION
		elseif commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.reset_key) and not main.fadeActive then
			f_resetArtPos()
	--HIDE MENU
		elseif commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.hide_key) and not main.fadeActive then
			if not hideMenu then hideMenu = true else hideMenu = false end
		end
	--MOVE UP ART
		if (commandGetState(main.t_cmd[main.playerInput], '$U') or (commandGetState(main.t_cmd[main.playerInput], 'holdu') or commandGetState(main.t_cmd[main.playerInput], 'holdul') or commandGetState(main.t_cmd[main.playerInput], 'holdur') and bufu >= 3)) and not main.fadeActive then
			if artPosY > t_gallery[gallerySection][galleryCursor].movelimit[2] then
				artPosY = artPosY - motif.artviewer_info.art_movespeed
			end
	--MOVE DOWN ART
		elseif (commandGetState(main.t_cmd[main.playerInput], '$D') or (commandGetState(main.t_cmd[main.playerInput], 'holdd') or commandGetState(main.t_cmd[main.playerInput], 'holddl') or commandGetState(main.t_cmd[main.playerInput], 'holddr') and bufd >= 3)) and not main.fadeActive then
			if artPosY < t_gallery[gallerySection][galleryCursor].movelimit[4] then
				artPosY = artPosY + motif.artviewer_info.art_movespeed
			end
		end
	--MOVE LEFT ART
		if (commandGetState(main.t_cmd[main.playerInput], '$B') or (commandGetState(main.t_cmd[main.playerInput], 'holdl') or commandGetState(main.t_cmd[main.playerInput], 'holdul') or commandGetState(main.t_cmd[main.playerInput], 'holddl') and bufl >= 3)) and not main.fadeActive then
			if artPosX > t_gallery[gallerySection][galleryCursor].movelimit[1] then
				artPosX = artPosX - motif.artviewer_info.art_movespeed
			end
	--MOVE RIGHT ART
		elseif (commandGetState(main.t_cmd[main.playerInput], '$F') or (commandGetState(main.t_cmd[main.playerInput], 'holdr') or commandGetState(main.t_cmd[main.playerInput], 'holdur') or commandGetState(main.t_cmd[main.playerInput], 'holddr') and bufr >= 3)) and not main.fadeActive then
			if artPosX < t_gallery[gallerySection][galleryCursor].movelimit[3] then
				artPosX = artPosX + motif.artviewer_info.art_movespeed
			end
		end
	--ZOOM IN ART
		if (commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.zoomin_key) or (commandGetState(main.t_cmd[main.playerInput], 'holdy') and bufy >= 10)) and not main.fadeActive then
			if artScaleX < t_gallery[gallerySection][galleryCursor].zoomlimit[2] and artScaleY < t_gallery[gallerySection][galleryCursor].zoomlimit[2] then
				artScaleX = artScaleX + motif.artviewer_info.art_zoomspeed
				artScaleY = artScaleY + motif.artviewer_info.art_zoomspeed
			end
	--ZOOM OUT ART
		elseif (commandGetState(main.t_cmd[main.playerInput], motif.artviewer_info.zoomout_key) or (commandGetState(main.t_cmd[main.playerInput], 'holdx') and bufx >= 10)) and not main.fadeActive then
			if artScaleX > t_gallery[gallerySection][galleryCursor].zoomlimit[1] and artScaleY > t_gallery[gallerySection][galleryCursor].zoomlimit[1] then
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
		if commandGetState(main.t_cmd[main.playerInput], 'holdu') or commandGetState(main.t_cmd[main.playerInput], 'holdur') or commandGetState(main.t_cmd[main.playerInput], 'holdul') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdd') or commandGetState(main.t_cmd[main.playerInput], 'holddr') or commandGetState(main.t_cmd[main.playerInput], 'holddl') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0			
		end
	--HORIZONTAL BUF KEY CONTROL
		if commandGetState(main.t_cmd[main.playerInput], 'holdr') or commandGetState(main.t_cmd[main.playerInput], 'holdur') or commandGetState(main.t_cmd[main.playerInput], 'holddr') then
			bufl = 0
			bufr = bufr + 1
		elseif commandGetState(main.t_cmd[main.playerInput], 'holdl') or commandGetState(main.t_cmd[main.playerInput], 'holdul') or commandGetState(main.t_cmd[main.playerInput], 'holddl') then
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

local function f_resetVolume()
galleryBGMVolume = tonumber(t_gallery[gallerySection][galleryCursor].volume) or 100
end

local function f_musicPlayer(songLimit)
	main.f_bgReset(motif.musicplayerbgdef.bg)
	main.f_fadeReset('fadein', motif.musicplayer_info)
	main.close = false
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local maxSong = songLimit
	local loopState = 1
	local update = true
	f_resetVolume()
	main.f_cmdInput()
	while true do
	--Clear Color
		if not skipClear then
			clearColor(motif.musicplayerbgdef.bgclearcolor[1], motif.musicplayerbgdef.bgclearcolor[2], motif.musicplayerbgdef.bgclearcolor[3])
		end
	--Layerno = 0 backgrounds
		bgDraw(motif.musicplayerbgdef.bg, falseBool)
	--Draw Song Info
		main.f_textRender(
			txt_songInfo,
			t_gallery[gallerySection][galleryCursor].info,
			1,
			motif.musicplayer_info.menu_pos[1] + motif.musicplayer_info.info_offset[1],
			motif.musicplayer_info.menu_pos[2] + motif.musicplayer_info.info_offset[2],
			motif.musicplayer_info.info_spacing[1],
			motif.musicplayer_info.info_spacing[2],
			main.font_def[motif.musicplayer_info.info_font[1]..motif.musicplayer_info.info_font[7]],
			0,
			main.f_lineLength(
				motif.musicplayer_info.menu_pos[1] + motif.musicplayer_info.info_offset[1],
				motif.info.localcoord[1],
				motif.musicplayer_info.info_font[3],
				motif.musicplayer_info.info_window,
				'[wl]'
			)
		)
		--if galleryCursor > 1 then
			--animUpdate(motif.musicplayer_info.menu_arrow_left_data)
			--animDraw(motif.musicplayer_info.menu_arrow_left_data)
		--end
		--if galleryCursor < maxSong then
			--animUpdate(motif.musicplayer_info.menu_arrow_right_data)
			--animDraw(motif.musicplayer_info.menu_arrow_right_data)
		--end
	--Layerno = 1 backgrounds
		bgDraw(motif.musicplayerbgdef.bg, trueBool)
	--Fadein/Fadeout
		main.f_fadeAnim(motif.musicplayer_info)
	--Close Menu
		if main.close and not main.fadeActive then
			main.f_bgReset(motif.gallerybgdef.bg)
			main.f_fadeReset('fadein', motif.gallery_info)
			main.close = false
			break
	--Back to Gallery Menu
		elseif (esc() or main.f_input(main.t_players, {'m'})) and not main.close then
			sndPlay(motif.files.snd_data, motif.musicplayer_info.cursor_done_snd[1], motif.musicplayer_info.cursor_done_snd[2])
			main.f_fadeReset('fadeout', motif.musicplayer_info)
			main.close = true
--[[
	--Enable/Disable Loop
		elseif commandGetState(main.t_cmd[main.playerInput], motif.musicplayer_info.loop_key) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.musicplayer_info.cursor_move_snd[1], motif.musicplayer_info.cursor_move_snd[2])
			if loopState == 1 then loopState = 0 else loopState = 1 end
			update = true
	--NEXT SONG
		elseif (commandGetState(main.t_cmd[main.playerInput], '$F') or (commandGetState(main.t_cmd[main.playerInput], 'holdr') and bufr >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.musicplayer_info.cursor_move_snd[1], motif.musicplayer_info.cursor_move_snd[2])
			f_nextItem(maxSong)
		--If current item is not unlocked
			while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
				f_nextItem(maxSong) --Go to an unlocked song
			end
			f_resetVolume()
			update = true
	--PREVIOUS SONG
		elseif (commandGetState(main.t_cmd[main.playerInput], '$B') or (commandGetState(main.t_cmd[main.playerInput], 'holdl') and bufl >= 30)) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.musicplayer_info.cursor_move_snd[1], motif.musicplayer_info.cursor_move_snd[2])
			f_previousItem(maxSong)
		--If current item is not unlocked
			while main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] ~= nil do
				f_previousItem(maxSong) --Go to an unlocked song
			end
			f_resetVolume()
			update = true
	--VOLUME UP
		elseif (commandGetState(main.t_cmd[main.playerInput], '$U') or (commandGetState(main.t_cmd[main.playerInput], 'holdu') and bufu >= 3)) and not main.fadeActive then
			if galleryBGMVolume < 100 then
				galleryBGMVolume = galleryBGMVolume + 1
			end
			update = true
	--VOLUME DOWN
		elseif (commandGetState(main.t_cmd[main.playerInput], '$D') or (commandGetState(main.t_cmd[main.playerInput], 'holdd') and bufd >= 3)) and not main.fadeActive then
			if galleryBGMVolume > 0 then
				galleryBGMVolume = galleryBGMVolume - 1
			end
			update = true
--]]
		end
	--Play BGM
		if file ~= '' and update then
			main.f_playBGM(
				false,
				t_gallery[gallerySection][galleryCursor].path,
				loopState,
				galleryBGMVolume,
				tonumber(t_gallery[gallerySection][galleryCursor].loopstart),
				tonumber(t_gallery[gallerySection][galleryCursor].loopend)
			)
			update = false
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

local function f_restoreGalleryBGM()
	if motif.music.gallery_bgm ~= '' then
		main.f_playBGM(false, motif.music.gallery_bgm, motif.music.gallery_bgm_loop, motif.music.gallery_bgm_volume, motif.music.gallery_bgm_loopstart, motif.music.gallery_bgm_loopend)
	end
end

local function f_galleryMenu()
	if motif.gallery_info.reload_enabled == 1 then f_loadFiles() end --Reload gallery data (.def & .sff files) each time that gallery menu is initialized
	if #t_gallery == 0 then return end --If there is not gallery data, return to main menu
--If there is gallery data, enter in gallery menu
	f_unlockGallery(false) --Check Gallery Unlocks
	main.f_bgReset(motif.gallerybgdef.bg)
	main.f_fadeReset('fadein', motif.gallery_info)
	main.close = false
	sndPlay(motif.files.snd_data, motif.gallery_info.cursor_done_snd[1], motif.gallery_info.cursor_done_snd[2])
	local textData = nil
	local titleData = nil
	local sprData = nil
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
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
		hiddenColumns = motif.gallery_info.preview_art_hiddencolumns
		hiddenRows = motif.gallery_info.preview_art_hiddenrows
		galleryMoveX = 0
		galleryMoveY = 0
		f_setCursorPos()
		slotMax = (motif.gallery_info.preview_art_columns + motif.gallery_info.preview_art_hiddencolumns)*(motif.gallery_info.preview_art_rows + motif.gallery_info.preview_art_hiddenrows)
		contentMax = nil
		if slotMax > #t_gallery[gallerySection] then
			contentMax = #t_gallery[gallerySection] --Set content loaded in t_gallery[gallerySection] as slotMax amount to prevent issues
		else
			contentMax = slotMax
		end
	end
	f_resetCursor()
	f_restoreGalleryBGM()
	while true do
	--To Detect section data
		if t_gallery[gallerySection].name == motif.gallery_info.title_text_artworks then --This is artworks section
			sprData = "spr"
		else --This is not an artworks section
			sprData = "previewspr"
		end
	--Clear Color
		if not skipClear then
			clearColor(motif.gallerybgdef.bgclearcolor[1], motif.gallerybgdef.bgclearcolor[2], motif.gallerybgdef.bgclearcolor[3])
		end
	--Layerno = 0 backgrounds
		bgDraw(motif.gallerybgdef.bg, falseBool)
	--Draw Title Text
		if #t_gallery < 2 then
			titleData = motif.gallery_info.title_text --Use title.text paramvalue
		else
			titleData = t_gallery[gallerySection].name --Use Gallery Section Name
		end
		txt_titleMenu:draw()
		txt_titleMenu:update({
			text = titleData,
			x = motif.gallery_info.menu_pos[1] + motif.gallery_info.title_offset[1],
			y = motif.gallery_info.menu_pos[2] + motif.gallery_info.title_offset[2]
		})
	--Draw Gallery Content
		f_drawGallery(t_gallery[gallerySection], motif.gallery_info.preview_art_columns+hiddenColumns, motif.gallery_info.preview_art_rows+hiddenRows)
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
		if main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] == nil then
			textData = t_gallery[gallerySection][galleryCursor].info
		else
			textData = motif.gallery_info.info_unknown_text
		end
	--Draw Artwork Info
		txt_previewInfo:draw()
		txt_previewInfo:update({
			text = textData,
			x = motif.gallery_info.menu_pos[1] + motif.gallery_info.info_offset[1],
			y = motif.gallery_info.menu_pos[2] + motif.gallery_info.info_offset[2]
		})
	--Attract Credits/Coins
		if motif.attract_mode.enabled == 1 and main.credits ~= -1 then
			txt_attract_credits:update({text = main.f_extractText(motif.attract_mode.credits_text, main.credits)[1]})
			txt_attract_credits:draw()
		end
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
		elseif (esc() or main.f_input(main.t_players, {'m'})) and not main.close then
			sndPlay(motif.files.snd_data, motif.gallery_info.cancel_snd[1], motif.gallery_info.cancel_snd[2])
			main.f_fadeReset('fadeout', motif.gallery_info)
			main.close = true
	--ENTER ACTION
		elseif main.f_input(main.t_players, {'pal', 's'}) and not main.fadeActive then
		--If the item is unlocked
			if main.t_unlockLua.gallery[t_gallery[gallerySection][galleryCursor].id] == nil then
				sndPlay(motif.files.snd_data, motif.gallery_info.cursor_done_snd[1], motif.gallery_info.cursor_done_snd[2])
			--Start Artwork Viewer
				if t_gallery[gallerySection].name == motif.gallery_info.title_text_artworks then
					main.f_fadeReset('fadeout', motif.gallery_info)
					f_artMenu(contentMax)
					f_setCursorPos() --Replace with a logic that calculates the new position of the cursor after having moved in artwork viewer...
					main.f_fadeAnim(motif.artviewer_info) --fadein / fadeout
			--Play Storyboard
				elseif t_gallery[gallerySection].name == motif.gallery_info.title_text_storyboards then
					launchStoryboard(t_gallery[gallerySection][galleryCursor].path)
					main.f_fadeReset('fadein', motif.gallery_info)
					main.f_fadeAnim(motif.gallery_info) --fadein / fadeout
					f_restoreGalleryBGM()
			--Start Music Player
				elseif t_gallery[gallerySection].name == motif.gallery_info.title_text_music then
					main.f_fadeReset('fadeout', motif.gallery_info)
					f_musicPlayer(contentMax)
					main.f_fadeAnim(motif.musicplayer_info) --fadein / fadeout
					f_restoreGalleryBGM()
				end
			end
	--Previous Section
		elseif commandGetState(main.t_cmd[main.playerInput], 'd') and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.gallery_info.cursor_category_snd[1], motif.gallery_info.cursor_category_snd[2])
			gallerySection = gallerySection - 1
			f_resetCursor()
	--Next Section
		elseif commandGetState(main.t_cmd[main.playerInput], 'w') and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.gallery_info.cursor_category_snd[1], motif.gallery_info.cursor_category_snd[2])
			gallerySection = gallerySection + 1
			f_resetCursor()
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
		--Prevent fall out of t_gallery[gallerySection] items
			if galleryCursor > contentMax then
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
		--Prevent fall out of t_gallery[gallerySection] items
			if galleryCursor > contentMax then
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
--Adds new commands for menu control
main.f_commandAdd("holdu", "/U", 1, 1)
main.f_commandAdd("holdd", "/D", 1, 1)
main.f_commandAdd("holdl", "/B", 1, 1)
main.f_commandAdd("holdr", "/F", 1, 1)
--[[
main.f_commandAdd("ul", "$UB", 1, 1)
main.f_commandAdd("ur", "$UF", 1, 1)
main.f_commandAdd("dl", "$DB", 1, 1)
main.f_commandAdd("dr", "$DF", 1, 1)
]]
main.f_commandAdd("holdul", "/UB", 1, 1)
main.f_commandAdd("holdur", "/UF", 1, 1)
main.f_commandAdd("holddl", "/DB", 1, 1)
main.f_commandAdd("holddr", "/DF", 1, 1)

main.f_commandAdd("holdprevious", "/"..motif.artviewer_info.previous_key, 1, 1)
main.f_commandAdd("holdnext", "/"..motif.artviewer_info.next_key, 1, 1)
main.f_commandAdd("holdx", "/"..motif.artviewer_info.zoomout_key, 1, 1)
main.f_commandAdd("holdy", "/"..motif.artviewer_info.zoomin_key, 1, 1)

if main.debugLog then main.f_printTable(motif, "debug/t_motif.txt") end

main.t_itemname.gallery = function()
	return f_galleryMenu()
end