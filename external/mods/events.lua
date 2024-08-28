--[[	   				  EVENTS MODULE
===================================================================
Version: 1.0
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build
Description:
Add Events Mode Entry for Main Menus
===================================================================
]]

--[[
[Title Info]

; Event Mode
menu.itemname.eventmode = "EVENTS"

;Event select screen background
[EventBGdef]

[EventBG 1]
type = normal
spriteno = 100, 0
start = 0, 0
tile = 1, 1
velocity = -1.000, -0.618
]]

--===================================================================================
--								MOTIF STUFF
--===================================================================================
if motif.music.event_bgm == nil then
	motif.music.event_bgm = ""
end
if motif.music.event_bgm_volume == nil then
	motif.music.event_bgm_volume = 100
end
if motif.music.event_bgm_loop == nil then
	motif.music.event_bgm_loop = 1
end
if motif.music.event_bgm_loopstart == nil then
	motif.music.event_bgm_loopstart = 0
end
if motif.music.event_bgm_loopend == nil then
	motif.music.event_bgm_loopend = 0
end

--if motif.event_info == nil then

	motif.event_info = {
		fadein_time = 10,
		fadein_col = {0, 0, 0},
		fadein_anim = -1,
		fadeout_time = 10,
		fadeout_col = {0, 0, 0},
		fadeout_anim = -1,
		title_offset = {159, 15},
		title_font = {'f-6x9.def', 0, 0, 255, 255, 255, -1},
		title_scale = {1.0, 1.0},
		title_text = 'EVENT MATCH',
		menu_uselocalcoord = 0,
		menu_pos = {85, 33},
		--menu_bg_<itemname>_anim = -1,
		--menu_bg_<itemname>_spr = {},
		--menu_bg_<itemname>_offset = {0, 0},
		--menu_bg_<itemname>_facing = 1,
		--menu_bg_<itemname>_scale = {1.0, 1.0},
		--menu_bg_active_<itemname>_anim = -1,
		--menu_bg_active_<itemname>_spr = {},
		--menu_bg_active_<itemname>_offset = {0, 0},
		--menu_bg_active_<itemname>_facing = 1,
		--menu_bg_active_<itemname>_scale = {1.0, 1.0},
		menu_item_offset = {0, 0},
		menu_item_font = {'f-6x9.def', 0, 1, 191, 191, 191, -1},
		menu_item_scale = {1.0, 1.0},
		menu_item_active_offset = {0, 0},
		menu_item_active_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
		menu_item_active_scale = {1.0, 1.0},
		menu_item_spacing = {0, 14},
		menu_window_margins_y = {0, 0},
		menu_window_visibleitems = 13,
		menu_boxcursor_visible = 1,
		menu_boxcursor_coords = {-5, -10, 154, 3},
		menu_boxcursor_col = {255, 255, 255},
		menu_boxcursor_alpharange = {10, 40, 2, 255, 255, 0},
		menu_boxbg_visible = 1,
		menu_boxbg_col = {0, 0, 0},
		menu_boxbg_alpha = {0, 128},
		menu_arrow_up_anim = -1,
		menu_arrow_up_spr = {},
		menu_arrow_up_offset = {0, 0},
		menu_arrow_up_facing = 1,
		menu_arrow_up_scale = {1.0, 1.0},
		menu_arrow_down_anim = -1,
		menu_arrow_down_spr = {},
		menu_arrow_down_offset = {0, 0},
		menu_arrow_down_facing = 1,
		menu_arrow_down_scale = {1.0, 1.0},
		menu_title_uppercase = 1,
		cursor_move_snd = {100, 0},
		cursor_done_snd = {100, 1},
		cancel_snd = {100, 2},
		menu_itemname_back = 'Back',
	}
	
--end

--if motif.eventbgdef == nil then

	motif.eventbgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
	
--end

--motif background data
for k, _ in pairs(motif) do
	if k:match('bgdef$') then
		--optional sff paths and data
		if motif[k].spr ~= nil and motif[k].spr ~= '' then
			motif[k].spr = searchFile(motif[k].spr, {motif.fileDir, '', 'data/'})
			motif[k].spr_data = sffNew(motif[k].spr)
			main.f_loadingRefresh()
		else
			motif[k].spr = motif.files.spr
			motif[k].spr_data = motif.files.spr_data
		end
		--backgrounds
		motif[k].bg = bgNew(motif[k].spr_data, motif.def, k:match('^(.+)def$'))
		main.f_loadingRefresh()
	end
end

--arrows spr/anim data
for _, v in ipairs({motif.event_info}) do
	motif.f_loadSprData(v, {s = 'menu_arrow_up_',   x = v.menu_pos[1], y = v.menu_pos[2]})
	motif.f_loadSprData(v, {s = 'menu_arrow_down_', x = v.menu_pos[1], y = v.menu_pos[2]})
end

--disabled scaling if element uses default values (non-existing in mugen)
motif.defaultEvent = motif.event_info.menu_uselocalcoord == 0

if main.debugLog then main.f_printTable(motif, "debug/t_motif.txt") end

--===================================================================================
--									MENU LOGIC
--===================================================================================
eventsPath = "data/events/" --Where you gonna store the events files

t_selEventMode = { --Generate Table to manage each event
{id = "event1", name = "Event 1", path = eventsPath.."event1.lua", unlock = true},
{id = "event2", name = "Event 2", path = eventsPath.."event2.lua", unlock = false},
{id = "event3", name = "Event 3", path = eventsPath.."event3.lua", unlock = false},
{id = "event4", name = "Event 4", path = eventsPath.."event4.lua", unlock = false},
{id = "event5", name = "Event 5", path = eventsPath.."event5.lua", unlock = false},
}
if main.debugLog then main.f_printTable(t_selEventMode, 'debug/t_selEventMode.txt') end

main.t_itemname.eventmode = function()
	return f_events() --Go to below function (that contains a custom sub-menu) when you enter in main menu item
end

local txt_titleEvent = main.f_createTextImg(motif.event_info, 'title', {defsc = motif.defaultEvent})
local t_menuWindowEvent = main.f_menuWindow(motif.event_info)
function f_events()
	sndPlay(motif.files.snd_data, motif.event_info.cursor_done_snd[1], motif.event_info.cursor_done_snd[2])
	local cursorPosY = 1
	local moveTxt = 0
	local item = 1
	local t = {}
	for k, v in ipairs(t_selEventMode) do
		table.insert(t, {data = text:create({window = t_menuWindowEvent}), itemname = v.id, displayname = v.name, path = v.path, unlock = v.unlock})
	end
	table.insert(t, {data = text:create({window = t_menuWindowEvent}), itemname = 'back', displayname = motif.event_info.menu_itemname_back})
	main.f_bgReset(motif.eventbgdef.bg)
	main.f_fadeReset('fadein', motif.event_info)
	if motif.music.event_bgm ~= '' then
		main.f_playBGM(false, motif.music.event_bgm, motif.music.event_bgm_loop, motif.music.event_bgm_volume, motif.music.event_bgm_loopstart, motif.music.event_bgm_loopend)
	end
	main.close = false
	while true do
		main.f_menuCommonDraw(t, item, cursorPosY, moveTxt, 'event_info', 'eventbgdef', txt_titleEvent, motif.defaultEvent, {})
		cursorPosY, moveTxt, item = main.f_menuCommonCalc(t, item, cursorPosY, moveTxt, 'event_info', {'$U'}, {'$D'})
		if main.close and not main.fadeActive then
			main.f_bgReset(motif[main.background].bg)
			main.f_fadeReset('fadein', motif[main.group])
			main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
			main.close = false
			break
		elseif esc() or main.f_input(main.t_players, {'m'}) or (t[item].itemname == 'back' and main.f_input(main.t_players, {'pal', 's'})) then
			sndPlay(motif.files.snd_data, motif.event_info.cancel_snd[1], motif.event_info.cancel_snd[2])
			main.f_fadeReset('fadeout', motif.event_info)
			main.close = true
		elseif main.f_input(main.t_players, {'pal', 's'}) then
			if t[item].unlock then --If the event is unlocked
				sndPlay(motif.files.snd_data, motif[main.group].cursor_done_snd[1], motif[main.group].cursor_done_snd[2])
				--START EVENT
				main.f_playerInput(main.playerInput, 1)
				main.continueScreen = true
				main.selectMenu[1] = false
				setGameMode(t[item].itemname) --This uses t_selEventMode[id] name
				main.luaPath = t[item].path
				--main.txt_mainSelect:update({text = 'TEST'})
				start.f_selectMode()
				main.f_cmdBufReset()
			end
		end
	end
end