--[[	   				  EVENTS MODULE
===================================================================
Version: 1.0
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build
Description:
Add Events Mode Entry for Main Menus
===================================================================
]]

--[[Example SELECT.DEF parameters assignments
;-------------------------------------------------------------------------------
 ;Events Mode custom fights declaration. Assigned events are selectable via Events Mode
 ;submenu ('menu.itemname.events' parameter in screenpack DEF file)
 ;
 ;Declaring events consists of setting up following parameters:
 ; - id
 ;   IKEMEN feature: Set to name that should be returned by GameMode trigger.
 ;   This parameter also initiates new events declaration, so it has to be
 ;   assigned before any other parameter used by the same event. All events should
 ;   have unique id names.
 ;
 ; - name
 ;   IKEMEN feature: Set to name that should be displayed in Events Mode submenu.
 ;
 ; - path
 ;   IKEMEN feature: Path to file with lua extension (relative to game
 ;   directory), containing event mode custom fight coded in Lua language.
 ;   https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-Info#arcs
 ;
 ; - unlock
 ;   IKEMEN feature: Pure Lua code, executed exactly as is, each time upon
 ;   loading main menu. If it evaluates to boolean 'true' the event will be
 ;   selectable from events mode submenu, or hidden on 'false'. Default: true.
 ;   https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-Info#lua_unlock
 ;
 ;Examples:
 
[EventsMode]
id = event1
name = Trouble Dude
path = data/events/event1.lua
unlock = true

id = event2
name = Lord of the Temple
path = data/events/event2.lua
unlock = true

]]

--[[Example SYSTEM.DEF parameters assignments

[Music]

;Music to play at event mode screen.
event.bgm = 
event.bgm.volume = 100
event.bgm.loop = 1
event.bgm.loopstart = 
event.bgm.loopend = 

[Title Info]

;Event Mode
menu.itemname.events = "EVENTS"

;Events select screen definition
[Event Info]
fadein.time = 10
fadein.col = 0,0,0
fadeout.time = 10
fadeout.col = 0,0,0
title.offset = 159,15
title.font = 2,0,0
title.scale = 1.0, 1.0
title.text = "EVENT SELECT"
menu.uselocalcoord = 0
menu.pos = 85,33
menu.item.offset = 0,0
menu.item.font = 2,0,1
menu.item.scale = 1.0, 1.0
menu.item.active.offset = 0,0
menu.item.active.font = 2,0,1
menu.item.active.scale = 1.0, 1.0
menu.item.spacing = 0,14
;menu.window.margins.y = 0,0
menu.window.visibleitems = 13
menu.boxcursor.visible = 1
menu.boxcursor.coords = -5, -10, 154, 3
menu.boxcursor.col = 255, 255, 255
menu.boxcursor.alpharange = 10, 40, 2, 255, 255, 0
menu.boxbg.visible = 1
menu.boxbg.col = 0,0,0
menu.boxbg.alpha = 0,128
;menu.arrow.up.anim =
menu.arrow.up.spr = 400,0
menu.arrow.up.offset = 141, -20
menu.arrow.up.facing = 1
menu.arrow.up.scale = 0.5, 0.5
;menu.arrow.down.anim =
menu.arrow.down.spr = 401,0
menu.arrow.down.offset = 141,176
menu.arrow.down.facing = 1
menu.arrow.down.scale = 0.5, 0.5
menu.title.uppercase = 1
cursor.move.snd = 100,0
cursor.done.snd = 100,1
cancel.snd = 100,2
menu.itemname.back = "Back"

;Event select screen background
[EventBGdef]
bgclearcolor = 0,0,0

[EventBG 1]
type = normal
spriteno = 100,0
start = 0,0
tile = 1,1
velocity = -1, -1

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

--[Event Info] default parameters (used for rendering event select screen assets)
local t_base = {
	fadein_time = 10,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	fadeout_time = 10,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	title_offset = {159, 15},
	title_font = {'f-6x9.def', 0, 0, 255, 255, 255, -1},
	title_scale = {1.0, 1.0},
	title_text = 'EVENT SELECT',
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
if motif.event_info == nil then
	motif.event_info = {}
end
motif.event_info = main.f_tableMerge(t_base, motif.event_info)

--If not defined, [EventBGdef] group defaults to [OptionBGdef].
if motif.eventbgdef == nil then
	motif.eventbgdef = {spr = '', bgclearcolor = {0, 0, 0},} --motif.optionbgdef --reuse options data causes black screen in both..
end

-- This code creates data out of optional [EventBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.eventbgdef.spr ~= nil and motif.eventbgdef.spr ~= '' then
	motif.eventbgdef.spr = searchFile(motif.eventbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.eventbgdef.spr_data = sffNew(motif.eventbgdef.spr)
else
	motif.eventbgdef.spr = motif.files.spr
	motif.eventbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.eventbgdef.bg = bgNew(motif.eventbgdef.spr_data, motif.def, 'eventbg')

-- fadein/fadeout anim data generation.
if motif.event_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.event_info, {s = 'fadein_'})
end
if motif.event_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.event_info, {s = 'fadeout_'})
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
t_selEventMode = {}
local section = 0
local row = 0
local content = main.f_fileRead(motif.files.select)
content = content:gsub('([^\r\n;]*)%s*;[^\r\n]*', '%1')
content = content:gsub('\n%s*\n', '\n')
for line in content:gmatch('[^\r\n]+') do
--for line in io.lines("data/select.def") do
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
				table.insert(t_selEventMode, {id = value, name = '', path = '', unlock = 'true'})
			elseif t_selEventMode[#t_selEventMode][param] ~= nil then
				t_selEventMode[#t_selEventMode][param] = value
			end
		end
	end
end

for k, v in ipairs(t_selEventMode) do --Check Events Unlocks
	main.t_unlockLua.modes[v.name] = v.unlock
end

if main.debugLog then main.f_printTable(t_selEventMode, 'debug/t_selEventMode.txt') end

main.t_itemname.events = function()
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