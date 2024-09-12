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
 ;   Set to name that should be returned by GameMode trigger.
 ;   This parameter also initiates new events declaration, so it has to be
 ;   assigned before any other parameter used by the same event. All events should
 ;   have unique id names.
 ;
 ; - name
 ;   Set to name that should be displayed in Events Mode submenu.
 ;
 ; - description
 ;   Set to description that should be displayed in Events Mode submenu.
 ;
 ; - path
 ;   Path to file with lua extension (relative to game
 ;   directory), containing event mode custom fight coded in Lua language.
 ;   https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-Info#arcs
 ;
 ; - unlock
 ;   Pure Lua code, executed exactly as is, each time upon
 ;   loading main menu. If it evaluates to boolean 'true' the event will be
 ;   selectable from events mode submenu, or hidden on 'false'. Default: true.
 ;   https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-Info#lua_unlock
 ;
 ;Examples:
 
[EventsMode]
id = event1
name = Trouble Dude
description = Event 1 Description
path = data/events/event1.lua
unlock = true

id = event2
name = Lord of the Temple
description = Event 2 Description
path = data/events/event2.lua
unlock = true

]]

--[[Example SYSTEM.DEF parameters assignments

[Music]

;Music to play at event mode screen.
event.bgm = ""
event.bgm.volume = 100
event.bgm.loop = 1
event.bgm.loopstart = 0
event.bgm.loopend = 0

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
info.offset = 80,200
info.font = 2,0,1
info.scale = 1.0, 1.0
hiscore.offset = 80,180
hiscore.font = 3,0,1
hiscore.text = "HIGH SCORE:"
hiscore.scale = 1.0, 1.0
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
menu.window.visibleitems = 10
menu.boxcursor.visible = 1
menu.boxcursor.coords = -5, -10, 154, 3
menu.boxcursor.col = 255, 255, 255
menu.boxcursor.alpharange = 10, 40, 2, 255, 255, 0
menu.boxbg.visible = 1
menu.boxbg.col = 0,0,0
menu.boxbg.alpha = 0,128
;menu.arrow.up.anim =
menu.arrow.up.spr = 400,0
menu.arrow.up.offset = 400, 10
menu.arrow.up.facing = 1
menu.arrow.up.scale = 0.5, 0.5
;menu.arrow.down.anim =
menu.arrow.down.spr = 401,0
menu.arrow.down.offset = 400,280
menu.arrow.down.facing = 1
menu.arrow.down.scale = 0.5, 0.5
menu.title.uppercase = 1
cursor.move.snd = 100,0
cursor.done.snd = 100,1
cancel.snd = 100,2

;Event select screen background
[EventBGdef]
spr = ""
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
	info_offset = {80, 200},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {1.0, 1.0},
	hiscore_offset = {80, 180},
	hiscore_font = {'jg.fnt ', 0, 1, 255, 255, 255, -1},
	hiscore_scale = {1.0, 1.0},
	hiscore_text = 'HIGH SCORE: ',
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
	menu_window_visibleitems = 10,
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
function f_loadEvents()
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
					table.insert(t_selEventMode, {id = value, name = '', description = '', path = '', unlock = 'true'})
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
end

main.t_itemname.events = function()
	return f_events() --Go to below function (that contains a custom sub-menu) when you enter in main menu item
end

local rect_boxcursor = rect:create({})
local rect_boxbg = rect:create({})
local t_menuWindowEvent = main.f_menuWindow(motif.event_info)

local txt_titleEvent = main.f_createTextImg(motif.event_info, 'title', {defsc = motif.defaultEvent})
local txt_infoEvent = main.f_createTextImg(motif.event_info, 'info', {defsc = motif.defaultEvent})
local txt_hiscoreEvent = main.f_createTextImg(motif.event_info, 'hiscore', {defsc = motif.defaultEvent})

function f_events()
	sndPlay(motif.files.snd_data, motif.event_info.cursor_done_snd[1], motif.event_info.cursor_done_snd[2])
	local cursorPosY = 1
	local moveTxt = 0
	local item = 1
	local t = {}
	f_loadEvents() --Load select.def events data
	for k, v in ipairs(t_selEventMode) do
		table.insert(t, {data = text:create({window = t_menuWindowEvent}), itemname = v.id, displayname = v.name, info = v.description, path = v.path, unlock = v.unlock})
	end
	if #t_selEventMode == 0 then --If there is not event data
		table.insert(t, {data = text:create({window = t_menuWindowEvent}), itemname = 'back', displayname = motif.event_info.menu_itemname_back, info = ""})
	end
	main.f_bgReset(motif.eventbgdef.bg)
	main.f_fadeReset('fadein', motif.event_info)
	if motif.music.event_bgm ~= '' then
		main.f_playBGM(false, motif.music.event_bgm, motif.music.event_bgm_loop, motif.music.event_bgm_volume, motif.music.event_bgm_loopstart, motif.music.event_bgm_loopend)
	end
	main.close = false
	while true do
		--f_menuCommonDraw(t, item, cursorPosY, moveTxt, 'event_info', 'eventbgdef', txt_titleEvent, motif.defaultEvent, {txt_infoEvent, txt_hiscoreEvent})
--;---------------------------------------------------------------------------------------------------------------------
		--draw clearcolor
		if not skipClear then
		clearColor(motif['eventbgdef'].bgclearcolor[1], motif['eventbgdef'].bgclearcolor[2], motif['eventbgdef'].bgclearcolor[3])
		end
		--draw layerno = 0 backgrounds
		bgDraw(motif['eventbgdef'].bg, 0)
		--draw menu box
		if motif['event_info'].menu_boxbg_visible == 1 then
			rect_boxbg:update({
				x1 =    motif['event_info'].menu_pos[1] + motif['event_info'].menu_boxcursor_coords[1],
				y1 =    motif['event_info'].menu_pos[2] + motif['event_info'].menu_boxcursor_coords[2],
				x2 =    motif['event_info'].menu_boxcursor_coords[3] - motif['event_info'].menu_boxcursor_coords[1] + 1,
				y2 =    motif['event_info'].menu_boxcursor_coords[4] - motif['event_info'].menu_boxcursor_coords[2] + 1 + (math.min(#t, motif['event_info'].menu_window_visibleitems) - 1) * motif['event_info'].menu_item_spacing[2],
				r =     motif['event_info'].menu_boxbg_col[1],
				g =     motif['event_info'].menu_boxbg_col[2],
				b =     motif['event_info'].menu_boxbg_col[3],
				src =   motif['event_info'].menu_boxbg_alpha[1],
				dst =   motif['event_info'].menu_boxbg_alpha[2],
				defsc = motif.defaultEvent,
			})
			rect_boxbg:draw()
		end
		--draw title
		txt_titleEvent:draw()
		--draw menu items
		local items_shown = item + motif['event_info'].menu_window_visibleitems - cursorPosY
		if items_shown > #t or (motif['event_info'].menu_window_visibleitems > 0 and items_shown < #t and (motif['event_info'].menu_window_margins_y[1] ~= 0 or motif['event_info'].menu_window_margins_y[2] ~= 0)) then
			items_shown = #t
		end
		for i = 1, items_shown do
			if i > item - cursorPosY then
				if i == item then
					--Draw active item background
					if t[i].paramname ~= nil then
						animDraw(motif['event_info'][t[i].paramname:gsub('menu_itemname_', 'menu_bg_active_') .. '_data'])
						animUpdate(motif['event_info'][t[i].paramname:gsub('menu_itemname_', 'menu_bg_active_') .. '_data'])
					end
					--Draw active item font
					if t[i].selected then
						t[i].data:update({
							font =   motif['event_info'].menu_item_selected_active_font[1],
							bank =   motif['event_info'].menu_item_selected_active_font[2],
							align =  motif['event_info'].menu_item_selected_active_font[3],
							text =   t[i].displayname,
							x =      motif['event_info'].menu_pos[1] + motif['event_info'].menu_item_offset[1] + (i - 1) * motif['event_info'].menu_item_spacing[1],
							y =      motif['event_info'].menu_pos[2] + motif['event_info'].menu_item_offset[2] + (i - 1) * motif['event_info'].menu_item_spacing[2] - moveTxt,
							scaleX = motif['event_info'].menu_item_selected_active_scale[1],
							scaleY = motif['event_info'].menu_item_selected_active_scale[2],
							r =      motif['event_info'].menu_item_selected_active_font[4],
							g =      motif['event_info'].menu_item_selected_active_font[5],
							b =      motif['event_info'].menu_item_selected_active_font[6],
							height = motif['event_info'].menu_item_selected_active_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					else
						t[i].data:update({
							font =   motif['event_info'].menu_item_active_font[1],
							bank =   motif['event_info'].menu_item_active_font[2],
							align =  motif['event_info'].menu_item_active_font[3],
							text =   t[i].displayname,
							x =      motif['event_info'].menu_pos[1] + motif['event_info'].menu_item_active_offset[1] + (i - 1) * motif['event_info'].menu_item_spacing[1],
							y =      motif['event_info'].menu_pos[2] + motif['event_info'].menu_item_active_offset[2] + (i - 1) * motif['event_info'].menu_item_spacing[2] - moveTxt,
							scaleX = motif['event_info'].menu_item_active_scale[1],
							scaleY = motif['event_info'].menu_item_active_scale[2],
							r =      motif['event_info'].menu_item_active_font[4],
							g =      motif['event_info'].menu_item_active_font[5],
							b =      motif['event_info'].menu_item_active_font[6],
							height = motif['event_info'].menu_item_active_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					end
					if t[i].vardata ~= nil then
						t[i].vardata:update({
							font =   motif['event_info'].menu_item_value_active_font[1],
							bank =   motif['event_info'].menu_item_value_active_font[2],
							align =  motif['event_info'].menu_item_value_active_font[3],
							text =   t[i].vardisplay,
							x =      motif['event_info'].menu_pos[1] + motif['event_info'].menu_item_value_active_offset[1] + (i - 1) * motif['event_info'].menu_item_spacing[1],
							y =      motif['event_info'].menu_pos[2] + motif['event_info'].menu_item_value_active_offset[2] + (i - 1) * motif['event_info'].menu_item_spacing[2] - moveTxt,
							scaleX = motif['event_info'].menu_item_value_active_scale[1],
							scaleY = motif['event_info'].menu_item_value_active_scale[2],
							r =      motif['event_info'].menu_item_value_active_font[4],
							g =      motif['event_info'].menu_item_value_active_font[5],
							b =      motif['event_info'].menu_item_value_active_font[6],
							height = motif['event_info'].menu_item_value_active_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].vardata:draw()
					end
				else
					--Draw not active item background
					if t[i].paramname ~= nil then
						animDraw(motif['event_info'][t[i].paramname:gsub('menu_itemname_', 'menu_bg_') .. '_data'])
						animUpdate(motif['event_info'][t[i].paramname:gsub('menu_itemname_', 'menu_bg_') .. '_data'])
					end
					--Draw not active item font
					if t[i].selected then
						t[i].data:update({
							font =   motif['event_info'].menu_item_selected_font[1],
							bank =   motif['event_info'].menu_item_selected_font[2],
							align =  motif['event_info'].menu_item_selected_font[3],
							text =   t[i].displayname,
							x =      motif['event_info'].menu_pos[1] + motif['event_info'].menu_item_selected_offset[1] + (i - 1) * motif['event_info'].menu_item_spacing[1],
							y =      motif['event_info'].menu_pos[2] + motif['event_info'].menu_item_selected_offset[2] + (i - 1) * motif['event_info'].menu_item_spacing[2] - moveTxt,
							scaleX = motif['event_info'].menu_item_selected_scale[1],
							scaleY = motif['event_info'].menu_item_selected_scale[2],
							r =      motif['event_info'].menu_item_selected_font[4],
							g =      motif['event_info'].menu_item_selected_font[5],
							b =      motif['event_info'].menu_item_selected_font[6],
							height = motif['event_info'].menu_item_selected_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					else
						t[i].data:update({
							font =   motif['event_info'].menu_item_font[1],
							bank =   motif['event_info'].menu_item_font[2],
							align =  motif['event_info'].menu_item_font[3],
							text =   t[i].displayname,
							x =      motif['event_info'].menu_pos[1] + motif['event_info'].menu_item_offset[1] + (i - 1) * motif['event_info'].menu_item_spacing[1],
							y =      motif['event_info'].menu_pos[2] + motif['event_info'].menu_item_offset[2] + (i - 1) * motif['event_info'].menu_item_spacing[2] - moveTxt,
							scaleX = motif['event_info'].menu_item_scale[1],
							scaleY = motif['event_info'].menu_item_scale[2],
							r =      motif['event_info'].menu_item_font[4],
							g =      motif['event_info'].menu_item_font[5],
							b =      motif['event_info'].menu_item_font[6],
							height = motif['event_info'].menu_item_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					end
					if t[i].vardata ~= nil then
						t[i].vardata:update({
							font =   motif['event_info'].menu_item_value_font[1],
							bank =   motif['event_info'].menu_item_value_font[2],
							align =  motif['event_info'].menu_item_value_font[3],
							text =   t[i].vardisplay,
							x =      motif['event_info'].menu_pos[1] + motif['event_info'].menu_item_value_offset[1] + (i - 1) * motif['event_info'].menu_item_spacing[1],
							y =      motif['event_info'].menu_pos[2] + motif['event_info'].menu_item_value_offset[2] + (i - 1) * motif['event_info'].menu_item_spacing[2] - moveTxt,
							scaleX = motif['event_info'].menu_item_value_scale[1],
							scaleY = motif['event_info'].menu_item_value_scale[2],
							r =      motif['event_info'].menu_item_value_font[4],
							g =      motif['event_info'].menu_item_value_font[5],
							b =      motif['event_info'].menu_item_value_font[6],
							height = motif['event_info'].menu_item_value_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].vardata:draw()
					end
				end
			end
		end
		--draw menu cursor
		if motif['event_info'].menu_boxcursor_visible == 1 and not main.fadeActive then
			local src, dst = main.f_boxcursorAlpha(
				motif['event_info'].menu_boxcursor_alpharange[1],
				motif['event_info'].menu_boxcursor_alpharange[2],
				motif['event_info'].menu_boxcursor_alpharange[3],
				motif['event_info'].menu_boxcursor_alpharange[4],
				motif['event_info'].menu_boxcursor_alpharange[5],
				motif['event_info'].menu_boxcursor_alpharange[6]
			)
			rect_boxcursor:update({
				x1 =    motif['event_info'].menu_pos[1] + motif['event_info'].menu_boxcursor_coords[1] + (cursorPosY - 1) * motif['event_info'].menu_item_spacing[1],
				y1 =    motif['event_info'].menu_pos[2] + motif['event_info'].menu_boxcursor_coords[2] + (cursorPosY - 1) * motif['event_info'].menu_item_spacing[2],
				x2 =    motif['event_info'].menu_boxcursor_coords[3] - motif['event_info'].menu_boxcursor_coords[1] + 1,
				y2 =    motif['event_info'].menu_boxcursor_coords[4] - motif['event_info'].menu_boxcursor_coords[2] + 1,
				r =     motif['event_info'].menu_boxcursor_col[1],
				g =     motif['event_info'].menu_boxcursor_col[2],
				b =     motif['event_info'].menu_boxcursor_col[3],
				src =   src,
				dst =   dst,
				defsc = motif.defaultEvent,
			})
			rect_boxcursor:draw()
		end
		--draw scroll arrows
		if #t > motif['event_info'].menu_window_visibleitems then
			if item > cursorPosY then
				animUpdate(motif['event_info'].menu_arrow_up_data)
				animDraw(motif['event_info'].menu_arrow_up_data)
			end
			if item >= cursorPosY and item + motif['event_info'].menu_window_visibleitems - cursorPosY < #t then
				animUpdate(motif['event_info'].menu_arrow_down_data)
				animDraw(motif['event_info'].menu_arrow_down_data)
			end
		end
		--draw credits text
		if motif.attract_mode.enabled == 1 and main.credits ~= -1 then
			txt_attract_credits:update({text = main.f_extractText(motif.attract_mode.credits_text, main.credits)[1]})
			txt_attract_credits:draw()
		end
		--draw layerno = 1 backgrounds
		bgDraw(motif['eventbgdef'].bg, 1)
		--draw footer overlay
		if motif['event_info'].footer_overlay_window ~= nil then
			overlay_footer:draw()
		end
		--draw other text only if there is event data stored in select.def
		if t[item].itemname ~= 'back' then
			local eventNo = t[item].itemname
			txt_titleEvent:update({text = motif.event_info.title_text})
			txt_infoEvent:draw()
			txt_infoEvent:update({text = t[item].info})
			txt_hiscoreEvent:draw()
			if stats.modes ~= nil and stats.modes[eventNo] ~= nil then
				if stats.modes[eventNo].score ~= nil then --If there is hiscore data detected
					txt_hiscoreEvent:update({text = motif.event_info.hiscore_text..stats.modes[eventNo].score})
				else --If there is not hiscore data detected
					txt_hiscoreEvent:update({text = motif.event_info.hiscore_text})
				end
			else --If there is not event data detected
				txt_hiscoreEvent:update({text = motif.event_info.hiscore_text})
			end
		else
			txt_titleEvent:update({text = "NO EVENT DATA"})
		end
		--draw fadein / fadeout
		main.f_fadeAnim(main.fadeGroup)
--;---------------------------------------------------------------------------------------------------------------------
		cursorPosY, moveTxt, item = main.f_menuCommonCalc(t, item, cursorPosY, moveTxt, 'event_info', {'$U'}, {'$D'})
		if main.close and not main.fadeActive then
			main.f_bgReset(motif[main.background].bg)
			main.f_fadeReset('fadein', motif[main.group])
			main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
			main.close = false
			break
		--Back Button
		elseif esc() or main.f_input(main.t_players, {'m'}) or (t[item].itemname == 'back' and main.f_input(main.t_players, {'pal', 's'})) then
			sndPlay(motif.files.snd_data, motif.event_info.cancel_snd[1], motif.event_info.cancel_snd[2])
			main.f_fadeReset('fadeout', motif.event_info)
			main.close = true
		--Start Button
		elseif main.f_input(main.t_players, {'pal', 's'}) then
			if t[item].unlock == "true" then --If the event is unlocked
				sndPlay(motif.files.snd_data, motif[main.group].cursor_done_snd[1], motif[main.group].cursor_done_snd[2])
				--START EVENT
				main.f_playerInput(main.playerInput, 1)
				main.continueScreen = true
				main.selectMenu[1] = false
				--[[
				main.lifebar.p1score = true
				main.hiscoreScreen = false
				main.rankingCondition = true
				main.resultsTable = motif.bonus_rush_results_screen
				start.t_sortRanking.event2 = start.t_sortRanking.survival
				start.t_clearCondition.event2 = function() return winnerteam() == 1 end
				main.t_hiscoreData.event2 = {mode = t[item].itemname, data = 'score', title = "Event Ranking"}
				]]
				main.txt_mainSelect:update({text = 'EVENT MATCH'})
				setGameMode(t[item].itemname) --This uses t_selEventMode[id] name
				main.luaPath = t[item].path
				hook.run("main.t_itemname")
				start.f_selectMode()
				if winnerteam() == 1 then --Save Score Data only if you complete event
					if stats.modes[t[item].itemname].score == nil then stats.modes[t[item].itemname].score = 0 end --If there is not score data, create one
					if score() > stats.modes[t[item].itemname].score then --Update Hiscore only if is greater than the previous one
						stats.modes[t[item].itemname].score = score()
					end
					saveEventData()
				end
				main.f_cmdBufReset()
				if motif.music.event_bgm ~= '' then
					main.f_playBGM(false, motif.music.event_bgm, motif.music.event_bgm_loop, motif.music.event_bgm_volume, motif.music.event_bgm_loopstart, motif.music.event_bgm_loopend)
				end
			end
		end
		main.f_cmdInput()
		main.f_refresh()
	end
end

function saveEventData()
	if main.debugLog then main.f_printTable(stats, 'debug/t_stats.txt') end --Print Debug Info
	main.f_fileWrite(main.flags['-stats'], json.encode(stats, {indent = 2})) --Write in stats.json file
end