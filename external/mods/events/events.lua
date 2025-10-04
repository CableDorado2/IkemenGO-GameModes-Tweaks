--[[	   				  EVENTS MODULE
======================================================================
Version: 1.4.1
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2025-10-01 Nightly Build
Description: Adds a Custom Game Mode entry (Events) to the Main Menu.
======================================================================
]]
local nightlyVer = true --Indicates if you are using Nightly IkemenGO version, to adjust some values ​​to draw the background...
--TODO: Fix High Score.
--[[Example SELECT.DEF parameters assignments
;-------------------------------------------------------------------------------
;Events Mode custom fights declaration. Assigned events are selectable via Events Mode
;submenu ('menu.itemname.events' parameter in screenpack DEF file)

;Declaring events consists of setting up following parameters:

; - id (required)
;	Set to name that should be returned by GameMode trigger.
;	This parameter also initiates new events declaration, so it has to be
;	assigned before any other parameter used by the same event. All events should
;	have unique id names.

; - spr (optional)
;	Set groupNo and indexNo to load from the sff file defined in "events.spr" system.def
;	[Event Info] paramvalue, to show a preview sprite for event item.
;	If is not defined, "preview.unknown.spr" will be displayed.

; - name (optional)
;	Set to name that should be displayed for item in Events Mode submenu.
;	If is not defined, "itemname.unknown" system.def [Event Info] paramvalue will be used.

; - description (optional)
;	Set to description that should be displayed for item in Events Mode submenu.
;	If is not defined, "info.unknown" system.def [Event Info] paramvalue will be used.

; - path (required)
;	Path to file with lua extension (relative to game directory)
;	containing event mode custom fight coded in Lua language.
;	https://github.com/ikemen-engine/Ikemen-GO/wiki/Miscellaneous-Info#arcs

; - unlock (optional)
;	Pure Lua code, executed exactly as is, each time upon loading events menu and after complete one.
;	If it evaluates to boolean 'true' the event will be selectable from
;	events mode submenu, or hidden on 'false'. Default: true.
;	https://github.com/ikemen-engine/Ikemen-GO/wiki/Lua#content-unlocking

; - characterselect (optional)
;	If it Evalues to boolean "true" character select will be displayed for the Event Selected.
;	Default: false.

; - singlemode (optional)
;	If it Evalues to boolean "true" Single Team mode will be selectable
;	when Character Select is Enabled for Event Selected.
;	Default: false.

; - simulmode (optional)
;	If it Evalues to boolean "true" Simul Team mode will be selectable
;	when Character Select is Enabled for Event Selected.
;	Default: false.

; - tagmode (optional)
;	If it Evalues to boolean "true" Tag Team mode will be selectable
;	when Character Select is Enabled for Event Selected.
;	Default: false.

; - turnsmode (optional)
;	If it Evalues to boolean "true" Turns Team mode will be selectable
;	when Character Select is Enabled for Event Selected.
;	Default: false.

; - ratiomode (optional)
;	If it Evalues to boolean "true" Ratio Team mode will be selectable
;	when Character Select is Enabled for Event Selected.
;	Default: false.

; - stageselect (optional)
;	If it Evalues to boolean "true" stage select will be displayed for the Event Selected.
;	Default: false.

; - vsscreen (optional)
;	If it Evalues to boolean "true" versus screen will be displayed for the Event Selected.
;	Default: false.

; - orderselect (optional)
;	If it Evalues to boolean "true" order select will be available during versus screen for the Event Selected.
;	Default: false.

; - victoryscreen (optional)
;	If it Evalues to boolean "true" victory screen will not be displayed after win for the Event Selected.
;	Default: true.

; - continuescreen (optional)
;	If it Evalues to boolean "false" continue screen will not be displayed when player lose for the Event Selected.
;	Default: true.

; - quickcontinue (optional)
;	If it Evalues to boolean "true" continuing should skip player selection for the Event Selected.
;	Default: false.

; - lifebar (optional)
;	If it Evalues to boolean "false" Lifebar will be disabled for the Match.
;	Default: true.

; - lifebarwincntp1 (optional)
;	If it Evalues to boolean "true" Win Count for p1 side will be displayed in Lifebar.
;	Default: false.

; - lifebarwincntp2 (optional)
;	If it Evalues to boolean "true" Win Count for p2 side will be displayed in Lifebar.
;	Default: false.

; - lifebartimer (optional)
;	If it Evalues to boolean "true" Timer will be displayed in Lifebar.
;	Note: It will only be displayed if launchFight() round time is different than -1.
;	Default: false.

; - lifebarscorep1 (optional)
;	If it Evalues to boolean "true" Score for p1 side will be displayed in Lifebar.
;	Default: false.

; - lifebarscorep2 (optional)
;	If it Evalues to boolean "true" Score for p2 side will be displayed in Lifebar.
;	Default: false.

; - lifebarmatchno (optional)
;	If it Evalues to boolean "true" Match Number will be displayed in Lifebar.
;	Default: false.

; - lifebarailevelp1 (optional)
;	If it Evalues to boolean "true" AI Level for p1 side will be displayed in Lifebar.
;	Default: false.

; - lifebarailevelp2 (optional)
;	If it Evalues to boolean "true" AI Level for p2 side will be displayed in Lifebar.
;	Default: false.

;Examples:
 
[EventsMode]
id = event1
name = Trouble Dude
description = Event 1 Description...
path = data/events/event1.lua

id = event2
spr = 0,2
name = All-Star Match 1
description = Event 2 Description...
path = data/events/event2.lua
unlock = stats.modes ~= nil and stats.modes.event1 ~= nil and stats.modes.event1.score > 0

characterselect = true
singlemode = true
simulmode = true
tagmode = true
turnsmode = true
ratiomode = true

vsscreen = true
orderselect = true
stageselect = true
victoryscreen = true
continuescreen = true
quickcontinue = false

lifebar = true
lifebarmatchno = true
lifebartimer = false
lifebarscorep1 = true
lifebarscorep2 = false
lifebarailevelp1 = false
lifebarailevelp2 = true
lifebarwincntp1 = false
lifebarwincntp2 = false
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
;Events Mode
menu.itemname.events = "EVENTS" ;Ikemen Feature

[Select Info]
;Text rendered using title element
title.events.text = "Event Match"

;------------------------------------------------------------------------------------------------------------------
;FOR SCREENPACKS BASED IN DEFAULT WINMUGEN MOTIF (localcoord = 320,240):
;------------------------------------------------------------------------------------------------------------------
[Event Info] ;Events select screen definition
reload.enabled = 0 ;Set to 1 to enable select.def events data reload, each time that events menu is initialized (for debug purposes), 0 to disable.

fadein.time = 20
fadein.col = 0,0,0
;fadein.anim = -1

fadeout.time = 20
fadeout.col = 0,0,0
;fadeout.anim = -1

cursor.move.snd = 100,0
cursor.done.snd = 100,1
cancel.snd = 100,2

events.def = external/mods/events/events.def ;load the events items to show. (If is not defined, events will be loaded from select.def)
events.spr = external/mods/events/events.sff ;load sprites for events items. (If is not defined, nothing will be displayed)

;preview.unknown.anim = -1
preview.unknown.spr = 0,0
preview.unknown.offset = 0,0
preview.unknown.facing = 1
preview.unknown.scale = 1.0, 1.0
preview.unknown.window = 0,0, 320,240

preview.offset = 0,0
preview.scale = 1.0, 1.0
preview.window = 0,0, 320,240

title.offset = 159,15
title.font = 3,0,0
title.scale = 1.0, 1.0
title.text = "EVENT SELECT"

hiscore.offset = 80,180
hiscore.font = 3,5,1
hiscore.text = "HIGH SCORE:"
hiscore.scale = 1.0, 1.0

info.unknown = "???"
info.offset = 40,200
info.spacing = 0,0
info.font = 2,0,1
info.scale = 1.0, 1.0
info.window = 0,171, 301,228
info.textwrap = w
info.delay = 2

menu.uselocalcoord = 1
menu.pos = 85,33
menu.title.uppercase = 1

itemname.unknown = "???"
menu.item.offset = 0,0
menu.item.font = 2,0,1
menu.item.scale = 1.0, 1.0
menu.item.spacing = 0,14

menu.item.active.offset = 0,0
menu.item.active.font = 2,0,1
menu.item.active.scale = 1.0, 1.0

;menu.window.margins.y = 0,0
menu.window.visibleitems = 10

menu.boxcursor.visible = 1
menu.boxcursor.coords = -5,-10, 154,3
menu.boxcursor.col = 255,255,255
menu.boxcursor.alpharange = 10,40,2, 255,255,0

menu.boxbg.visible = 1
menu.boxbg.col = 0,0,0
menu.boxbg.alpha = 0,128

;menu.arrow.up.anim = -1
menu.arrow.up.spr = 400,0
menu.arrow.up.offset = 157,-10
menu.arrow.up.facing = 1
menu.arrow.up.scale = 0.5, 0.5

;menu.arrow.down.anim = -1
menu.arrow.down.spr = 401,0
menu.arrow.down.offset = 157,124
menu.arrow.down.facing = 1
menu.arrow.down.scale = 0.5, 0.5

;-------------------------------------------------------------------------------
[EventBGdef] ;Event select screen background
spr = ""
bgclearcolor = 0,0,0

[EventBG 1]
type = normal
spriteno = 100,0
start = 0,0
tile = 1,1
velocity = -1, -1

;------------------------------------------------------------------------------------------------------------------
;FOR SCREENPACKS BASED IN MUGEN1 MOTIF (localcoord = 1280,720):
;------------------------------------------------------------------------------------------------------------------
[Event Info] ;Events select screen definition
reload.enabled = 0 ;Set to 1 to enable select.def events data reload, each time that events menu is initialized (for debug purposes), 0 to disable.

fadein.time = 20
fadein.col = 0,0,0
;fadein.anim = -1

fadeout.time = 20
fadeout.col = 0,0,0
;fadeout.anim = -1

cursor.move.snd = 100,0
cursor.done.snd = 100,1
cancel.snd = 100,2

events.def = external/mods/events/events.def ;load the events items to show. (If is not defined, events will be loaded from select.def)
events.spr = external/mods/events/events.sff ;load sprites for events items. (If is not defined, nothing will be displayed)

;preview.unknown.anim = -1
preview.unknown.spr = 0,0
preview.unknown.offset = 0,0
preview.unknown.facing = 1
preview.unknown.scale = 1.0, 1.0
preview.unknown.window = 0,0, 1280,720

preview.offset = 0,0
preview.scale = 1.0, 1.0
preview.window = 0,0, 1280,720

title.offset = 640,38
title.font = 4,0,0
title.scale = 1.0, 1.0
title.text = "EVENT SELECT"

hiscore.offset = 400,530
hiscore.font = 2,0,1
hiscore.text = "HIGH SCORE:"
hiscore.scale = 1.5, 1.5

info.unknown = "???"
info.offset = 350,580
info.spacing = 0,2
info.font = 5,0,1
info.scale = 1.0, 1.0
info.window = 38,521, 1041,708
info.textwrap = w
info.delay = 0

menu.uselocalcoord = 1
menu.pos = 414,99
menu.title.uppercase = 1

itemname.unknown = "???"
menu.item.offset = 0,0
menu.item.font = 7,0,1
menu.item.scale = 1.0, 1.0
menu.item.spacing = 0,42

menu.item.active.offset = 0,0
menu.item.active.font = 7,0,1
menu.item.active.scale = 1.0, 1.0

;menu.window.margins.y = 0,0
menu.window.visibleitems = 10

menu.boxcursor.visible = 1
menu.boxcursor.coords = -15,-30, 462,11
menu.boxcursor.col = 255,255,255
menu.boxcursor.alpharange = 10,40,2, 255,255,0

menu.boxbg.visible = 1
menu.boxbg.col = 0,0,0
menu.boxbg.alpha = 0,128

;menu.arrow.up.anim = -1
menu.arrow.up.spr = 400,0
menu.arrow.up.offset = 470,-30
menu.arrow.up.facing = 1
menu.arrow.up.scale = 1.5, 1.5

;menu.arrow.down.anim = -1
menu.arrow.down.spr = 401,0
menu.arrow.down.offset = 470,372
menu.arrow.down.facing = 1
menu.arrow.down.scale = 1.5, 1.5

;-------------------------------------------------------------------------------
[EventBGdef] ;Event select screen background
spr = ""
bgclearcolor = 0,0,0

[EventBG 1]
type  = normal
spriteno = 100,0
start = 0,0
tile  = 1,1
velocity = -1, -1

]]
--===================================================================================
--								  MOTIF STUFF
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

-- [Select Info] default parameters. Displayed in select screen.
if motif.select_info.title_events_text == nil then
	motif.select_info.title_events_text = "Event Match"
end

--[Event Info] default parameters (used for rendering event select screen assets)
local t_base = {
	reload_enabled = 0,
	
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	cursor_move_snd = {100, 0},
	cursor_done_snd = {100, 1},
	cancel_snd = {100, 2},

	events_def = "external/mods/events/events.def",
	events_spr = "external/mods/events/events.sff",
	
	preview_unknown_anim = -1,
	preview_unknown_spr = {0, 0},
	preview_unknown_offset = {0, 0},
	preview_unknown_facing = 1,
	preview_unknown_scale = {1.0, 1.0},
	preview_unknown_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_offset = {0, 0},
	preview_facing = 1,
	preview_scale = {1.0, 1.0},
	preview_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	title_offset = {159, 15},
	title_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	title_scale = {1.0, 1.0},
	title_text = 'EVENT SELECT',
	
	hiscore_offset = {80, 180},
	hiscore_font = {'jg.fnt', 5, 1, 255, 255, 255, -1},
	hiscore_scale = {1.0, 1.0},
	hiscore_text = 'HIGH SCORE:',
	
	info_unknown = '???',
	info_offset = {40, 200},
	info_spacing = {0, 0},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {1.0, 1.0},
	info_delay = 2,
	info_textwrap = 'w',
	info_window = {0, 171, main.SP_Localcoord[1]-50, main.SP_Localcoord[2]},
	
	menu_uselocalcoord = 1,
	menu_pos = {85, 33},
	menu_title_uppercase = 1,	
	menu_itemname_back = 'Back',
	itemname_unknown = '???',
	
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
	menu_item_spacing = {0, 14},
	
	menu_item_active_offset = {0, 0},
	menu_item_active_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	menu_item_active_scale = {1.0, 1.0},
	
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
	menu_arrow_up_spr = {400, 0},
	menu_arrow_up_offset = {157, -10},
	menu_arrow_up_facing = 1,
	menu_arrow_up_scale = {0.5, 0.5},
	
	menu_arrow_down_anim = -1,
	menu_arrow_down_spr = {401, 0},
	menu_arrow_down_offset = {157, 124},
	menu_arrow_down_facing = 1,
	menu_arrow_down_scale = {0.5, 0.5},
}
if motif.event_info == nil then
	motif.event_info = {}
end
motif.event_info = main.f_tableMerge(t_base, motif.event_info)

--If not defined [EventBGdef]
if motif.eventbgdef == nil then
	motif.eventbgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
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

if nightlyVer then --Setup argument for bgDraw function
	trueBool = 1
	falseBool = 0
else
	trueBool = true
	falseBool = false
end
--===================================================================================
--								 EVENTS MENU LOGIC
--===================================================================================
local txt_titleEvent = main.f_createTextImg(motif.event_info, 'title', {defsc = motif.defaultEvent})
local txt_hiscoreEvent = main.f_createTextImg(motif.event_info, 'hiscore', {defsc = motif.defaultEvent})
local txt_infoEvent = main.f_createTextImg(motif.event_info, 'info', {defsc = motif.defaultEvent})

local rect_boxcursor = rect:create({})
local rect_boxbg = rect:create({})
local t_menuWindowEvent = main.f_menuWindow(motif.event_info)

local function f_resetEventInfoTxt()
infoTextCnt = 0
end

local function saveEventData()
	if main.debugLog then main.f_printTable(stats, 'debug/t_stats.txt') end --Print Debug Info
	main.f_fileWrite(main.flags['-stats'], json.encode(stats, {indent = 2})) --Write in stats.json file
end

local function f_loadEvents()
	t_selEventMode = {}
--Load .def file with Events Items
	if main.f_fileExists(motif.event_info.events_def) then
		motif.files.event_def = motif.event_info.events_def
	else
		motif.files.event_def = motif.files.select
	end
--Load .sff file with Events Preview Items
	if main.f_fileExists(motif.event_info.events_spr) then
		motif.files.event_data = sffNew(motif.event_info.events_spr)
	else
		motif.files.event_data = sffNew()
	end
	local section = 0
	local row = 0
	local content = main.f_fileRead(motif.files.event_def)
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
	if main.debugLog then main.f_printTable(t_selEventMode, 'debug/t_selEventMode.txt') end
end
f_loadEvents() --Load events data (events.def & events.sff files) when engine starts

--creates sprite data out of table values
local anim = ''
local facing = ''
local function f_loadEventSprData(t, v) --This function uses motif.files.event_data instead system.sff data
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
			motif.files.event_data,
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
		t[data] = animNew(motif.files.event_data, t[sprParam][1] .. ', ' .. t[sprParam][2] .. ', ' .. (t[v.s .. 'offset'][1] + (v.x or 0)) / t[v.s .. 'scale'][1] .. ', ' .. (t[v.s .. 'offset'][2] + (v.y or 0)) / t[v.s .. 'scale'][2] .. ', -1' .. facing)
		animSetScale(t[data], t[v.s .. 'scale'][1], t[v.s .. 'scale'][2])
		animUpdate(t[data])
	else --create dummy data
		t[data] = animNew(motif.files.event_data, '-1,0, 0,0, -1')
		animUpdate(t[data])
	end
	animSetWindow(t[data], 0, 0, motif.info.localcoord[1], motif.info.localcoord[2])
end
f_loadEventSprData(motif.event_info, {s = 'preview_unknown_'}) --Generate motif.event_info.preview_unknown_data

local function f_drawCustomPreview(group, index, x, y, scaleX, scaleY, x1, y1, x2, y2)
	local anim = group..','..index..', 0,0, -1' --local anim = group..','..index..','..x..','..y..','..'-1'
	anim = animNew(motif.files.event_data, anim)
	animSetScale(anim, scaleX, scaleY)
	animSetPos(anim, x, y)
	animSetWindow(anim, x1, y1, x2, y2)
	animUpdate(anim)
	animDraw(anim)
end

--common menu calculations
local function f_menuCommonCalc(t, item, cursorPosY, moveTxt, section, keyPrev, keyNext)
	local startItem = 1
	for _, v in ipairs(t) do
		if v.itemname ~= 'empty' then
			break
		end
		startItem = startItem + 1
	end
	if main.f_input(main.t_players, keyNext) then
		sndPlay(motif.files.snd_data, motif[section].cursor_move_snd[1], motif[section].cursor_move_snd[2])
		while true do
			item = item + 1
			if cursorPosY < motif[section].menu_window_visibleitems then
				cursorPosY = cursorPosY + 1
			end
			if t[item] == nil or t[item].itemname ~= 'empty' then
				break
			end
		end
	elseif main.f_input(main.t_players, keyPrev) then
		sndPlay(motif.files.snd_data, motif[section].cursor_move_snd[1], motif[section].cursor_move_snd[2])
		while true do
			item = item - 1
			if cursorPosY > startItem then
				cursorPosY = cursorPosY - 1
			end
			if t[item] == nil or t[item].itemname ~= 'empty' then
				break
			end
		end
	end
	if item > #t or (item == 1 and t[item].itemname == 'empty') then
		item = 1
		while true do
			if t[item].itemname ~= 'empty' or item >= #t then
				break
			else
				item = item + 1
			end
		end
		cursorPosY = item
	elseif item < 1 then
		item = #t
		while true do
			if t[item].itemname ~= 'empty' or item <= 1 then
				break
			else
				item = item - 1
			end
		end
		if item > motif[section].menu_window_visibleitems then
			cursorPosY = motif[section].menu_window_visibleitems
		else
			cursorPosY = item
		end
	end
	if cursorPosY >= motif[section].menu_window_visibleitems then
		moveTxt = (item - motif[section].menu_window_visibleitems) * motif[section].menu_item_spacing[2]
	elseif cursorPosY <= startItem then
		moveTxt = (item - startItem) * motif[section].menu_item_spacing[2]
	end
	return cursorPosY, moveTxt, item
end

local function f_events()
	sndPlay(motif.files.snd_data, motif.event_info.cursor_done_snd[1], motif.event_info.cursor_done_snd[2])
	local cursorPosY = 1
	local moveTxt = 0
	local item = 1
	local t = {}
	f_resetEventInfoTxt()
	if motif.event_info.reload_enabled == 1 then f_loadEvents() end --Reload select.def events data each time that events menu is initialized
	for k, v in ipairs(t_selEventMode) do
		table.insert(t, {data = text:create({window = t_menuWindowEvent}),
				itemname = v.id,
				itemspr = v.spr,
				displayname = v.name,
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
	if #t_selEventMode == 0 then --If there is not event data
		table.insert(t, {
			data = text:create({window = t_menuWindowEvent}),
			itemname = 'back',
			itemspr = {},
			displayname = motif.event_info.menu_itemname_back,
			info = ""
		})
	else --If there is event data
	--Initialize Statistics
		if stats.modes == nil then stats.modes = {} end
		for i=1, #t do
			if stats.modes[t[i].itemname] == nil then --Create Event Data
				stats.modes[t[i].itemname] = {playtime = 0, score = 0}
			end
		end
		saveEventData()
		main.f_unlock(false) --Check Events Unlocks
		if main.debugLog then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
	end
	if main.debugLog then main.f_printTable(t, 'debug/t_eventsMenu.txt') end
	main.f_bgReset(motif.eventbgdef.bg)
	main.f_fadeReset('fadein', motif.event_info)
	local backupSelSong = motif.music.select_bgm
	local backupSelLoop = motif.music.select_bgm_loop
	local backupSelVolume = motif.music.select_bgm_volume
	local backupSelLoopStart = motif.music.select_bgm_loopstart
	local backupSelLoopEnd = motif.music.select_bgm_loopend
	--
	local backupTitleSong = motif.music.title_bgm
	local backupTitleLoop = motif.music.title_bgm_loop
	local backupTitleVolume = motif.music.title_bgm_volume
	local backupTitleLoopStart = motif.music.title_bgm_loopstart
	local backupTitleLoopEnd = motif.music.title_bgm_loopend
	if motif.music.event_bgm ~= '' then
		main.f_playBGM(false, motif.music.event_bgm, motif.music.event_bgm_loop, motif.music.event_bgm_volume, motif.music.event_bgm_loopstart, motif.music.event_bgm_loopend)
	end
	main.close = false
	while true do
--;---------------------------------------------------------------------------------------------------------------------
	--draw clearcolor
		if not skipClear then
			clearColor(motif.eventbgdef.bgclearcolor[1], motif.eventbgdef.bgclearcolor[2], motif.eventbgdef.bgclearcolor[3])
		end
	--draw layerno = 0 backgrounds
		bgDraw(motif.eventbgdef.bg, falseBool)
	--draw menu box
		if motif.event_info.menu_boxbg_visible == 1 then
			rect_boxbg:update({
				x1 =    motif.event_info.menu_pos[1] + motif.event_info.menu_boxcursor_coords[1],
				y1 =    motif.event_info.menu_pos[2] + motif.event_info.menu_boxcursor_coords[2],
				x2 =    motif.event_info.menu_boxcursor_coords[3] - motif.event_info.menu_boxcursor_coords[1] + 1,
				y2 =    motif.event_info.menu_boxcursor_coords[4] - motif.event_info.menu_boxcursor_coords[2] + 1 + (math.min(#t, motif.event_info.menu_window_visibleitems) - 1) * motif.event_info.menu_item_spacing[2],
				r =     motif.event_info.menu_boxbg_col[1],
				g =     motif.event_info.menu_boxbg_col[2],
				b =     motif.event_info.menu_boxbg_col[3],
				src =   motif.event_info.menu_boxbg_alpha[1],
				dst =   motif.event_info.menu_boxbg_alpha[2],
				defsc = motif.defaultEvent,
			})
			rect_boxbg:draw()
		end
	--draw title
		txt_titleEvent:draw()
	--draw preview sprites
		if t[item].itemspr[1] == nil or t[item].itemspr[2] == nil or main.t_unlockLua.modes[t[item].itemname] ~= nil then
			main.f_animPosDraw(
				motif.event_info.preview_unknown_data,
				motif.event_info.menu_pos[1] + motif.event_info.preview_unknown_offset[1],
				motif.event_info.menu_pos[2] + motif.event_info.preview_unknown_offset[2],
				motif.event_info.preview_unknown_facing,
				true
			)
		else
			f_drawCustomPreview(
				t[item].itemspr[1], --group
				t[item].itemspr[2], --index
				motif.event_info.menu_pos[1] + motif.event_info.preview_offset[1], --x
				motif.event_info.menu_pos[2] + motif.event_info.preview_offset[2], --y
				motif.event_info.preview_scale[1], --scaleX
				motif.event_info.preview_scale[2], --scaleY
				motif.event_info.preview_window[1], --x1
				motif.event_info.preview_window[2], --y1
				motif.event_info.preview_window[3], --x2
				motif.event_info.preview_window[4] --y2
			)
		end
	--draw menu items
		local items_shown = item + motif.event_info.menu_window_visibleitems - cursorPosY
		if items_shown > #t or (motif.event_info.menu_window_visibleitems > 0 and items_shown < #t and (motif.event_info.menu_window_margins_y[1] ~= 0 or motif.event_info.menu_window_margins_y[2] ~= 0)) then
			items_shown = #t
		end
		for i = 1, items_shown do
			local unlockText = ""
			if t[i].displayname ~= "" and main.t_unlockLua.modes[t[i].itemname] == nil then unlockText = t[i].displayname else unlockText = motif.event_info.itemname_unknown end --Condition to Show Unlocked Text
			if i > item - cursorPosY then
				if i == item then
				--Draw active item background
					if t[i].paramname ~= nil then
						animDraw(motif.event_info[t[i].paramname:gsub('menu_itemname_', 'menu_bg_active_') .. '_data'])
						animUpdate(motif.event_info[t[i].paramname:gsub('menu_itemname_', 'menu_bg_active_') .. '_data'])
					end
				--Draw active item font
					if t[i].selected then
						t[i].data:update({
							font =   motif.event_info.menu_item_selected_active_font[1],
							bank =   motif.event_info.menu_item_selected_active_font[2],
							align =  motif.event_info.menu_item_selected_active_font[3],
							text =   unlockText,
							x =      motif.event_info.menu_pos[1] + motif.event_info.menu_item_offset[1] + (i - 1) * motif.event_info.menu_item_spacing[1],
							y =      motif.event_info.menu_pos[2] + motif.event_info.menu_item_offset[2] + (i - 1) * motif.event_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.event_info.menu_item_selected_active_scale[1],
							scaleY = motif.event_info.menu_item_selected_active_scale[2],
							r =      motif.event_info.menu_item_selected_active_font[4],
							g =      motif.event_info.menu_item_selected_active_font[5],
							b =      motif.event_info.menu_item_selected_active_font[6],
							height = motif.event_info.menu_item_selected_active_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					else
						t[i].data:update({
							font =   motif.event_info.menu_item_active_font[1],
							bank =   motif.event_info.menu_item_active_font[2],
							align =  motif.event_info.menu_item_active_font[3],
							text =   unlockText,
							x =      motif.event_info.menu_pos[1] + motif.event_info.menu_item_active_offset[1] + (i - 1) * motif.event_info.menu_item_spacing[1],
							y =      motif.event_info.menu_pos[2] + motif.event_info.menu_item_active_offset[2] + (i - 1) * motif.event_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.event_info.menu_item_active_scale[1],
							scaleY = motif.event_info.menu_item_active_scale[2],
							r =      motif.event_info.menu_item_active_font[4],
							g =      motif.event_info.menu_item_active_font[5],
							b =      motif.event_info.menu_item_active_font[6],
							height = motif.event_info.menu_item_active_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					end
					if t[i].vardata ~= nil then
						t[i].vardata:update({
							font =   motif.event_info.menu_item_value_active_font[1],
							bank =   motif.event_info.menu_item_value_active_font[2],
							align =  motif.event_info.menu_item_value_active_font[3],
							text =   t[i].vardisplay,
							x =      motif.event_info.menu_pos[1] + motif.event_info.menu_item_value_active_offset[1] + (i - 1) * motif.event_info.menu_item_spacing[1],
							y =      motif.event_info.menu_pos[2] + motif.event_info.menu_item_value_active_offset[2] + (i - 1) * motif.event_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.event_info.menu_item_value_active_scale[1],
							scaleY = motif.event_info.menu_item_value_active_scale[2],
							r =      motif.event_info.menu_item_value_active_font[4],
							g =      motif.event_info.menu_item_value_active_font[5],
							b =      motif.event_info.menu_item_value_active_font[6],
							height = motif.event_info.menu_item_value_active_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].vardata:draw()
					end
				else
				--Draw not active item background
					if t[i].paramname ~= nil then
						animDraw(motif.event_info[t[i].paramname:gsub('menu_itemname_', 'menu_bg_') .. '_data'])
						animUpdate(motif.event_info[t[i].paramname:gsub('menu_itemname_', 'menu_bg_') .. '_data'])
					end
				--Draw not active item font
					if t[i].selected then
						t[i].data:update({
							font =   motif.event_info.menu_item_selected_font[1],
							bank =   motif.event_info.menu_item_selected_font[2],
							align =  motif.event_info.menu_item_selected_font[3],
							text =   unlockText,
							x =      motif.event_info.menu_pos[1] + motif.event_info.menu_item_selected_offset[1] + (i - 1) * motif.event_info.menu_item_spacing[1],
							y =      motif.event_info.menu_pos[2] + motif.event_info.menu_item_selected_offset[2] + (i - 1) * motif.event_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.event_info.menu_item_selected_scale[1],
							scaleY = motif.event_info.menu_item_selected_scale[2],
							r =      motif.event_info.menu_item_selected_font[4],
							g =      motif.event_info.menu_item_selected_font[5],
							b =      motif.event_info.menu_item_selected_font[6],
							height = motif.event_info.menu_item_selected_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					else
						t[i].data:update({
							font =   motif.event_info.menu_item_font[1],
							bank =   motif.event_info.menu_item_font[2],
							align =  motif.event_info.menu_item_font[3],
							text =   unlockText,
							x =      motif.event_info.menu_pos[1] + motif.event_info.menu_item_offset[1] + (i - 1) * motif.event_info.menu_item_spacing[1],
							y =      motif.event_info.menu_pos[2] + motif.event_info.menu_item_offset[2] + (i - 1) * motif.event_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.event_info.menu_item_scale[1],
							scaleY = motif.event_info.menu_item_scale[2],
							r =      motif.event_info.menu_item_font[4],
							g =      motif.event_info.menu_item_font[5],
							b =      motif.event_info.menu_item_font[6],
							height = motif.event_info.menu_item_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].data:draw()
					end
					if t[i].vardata ~= nil then
						t[i].vardata:update({
							font =   motif.event_info.menu_item_value_font[1],
							bank =   motif.event_info.menu_item_value_font[2],
							align =  motif.event_info.menu_item_value_font[3],
							text =   t[i].vardisplay,
							x =      motif.event_info.menu_pos[1] + motif.event_info.menu_item_value_offset[1] + (i - 1) * motif.event_info.menu_item_spacing[1],
							y =      motif.event_info.menu_pos[2] + motif.event_info.menu_item_value_offset[2] + (i - 1) * motif.event_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.event_info.menu_item_value_scale[1],
							scaleY = motif.event_info.menu_item_value_scale[2],
							r =      motif.event_info.menu_item_value_font[4],
							g =      motif.event_info.menu_item_value_font[5],
							b =      motif.event_info.menu_item_value_font[6],
							height = motif.event_info.menu_item_value_font[7],
							defsc =  motif.defaultEvent,
						})
						t[i].vardata:draw()
					end
				end
			end
		end
	--draw menu cursor
		if motif.event_info.menu_boxcursor_visible == 1 and not main.fadeActive then
			local src, dst = main.f_boxcursorAlpha(
				motif.event_info.menu_boxcursor_alpharange[1],
				motif.event_info.menu_boxcursor_alpharange[2],
				motif.event_info.menu_boxcursor_alpharange[3],
				motif.event_info.menu_boxcursor_alpharange[4],
				motif.event_info.menu_boxcursor_alpharange[5],
				motif.event_info.menu_boxcursor_alpharange[6]
			)
			rect_boxcursor:update({
				x1 =    motif.event_info.menu_pos[1] + motif.event_info.menu_boxcursor_coords[1] + (cursorPosY - 1) * motif.event_info.menu_item_spacing[1],
				y1 =    motif.event_info.menu_pos[2] + motif.event_info.menu_boxcursor_coords[2] + (cursorPosY - 1) * motif.event_info.menu_item_spacing[2],
				x2 =    motif.event_info.menu_boxcursor_coords[3] - motif.event_info.menu_boxcursor_coords[1] + 1,
				y2 =    motif.event_info.menu_boxcursor_coords[4] - motif.event_info.menu_boxcursor_coords[2] + 1,
				r =     motif.event_info.menu_boxcursor_col[1],
				g =     motif.event_info.menu_boxcursor_col[2],
				b =     motif.event_info.menu_boxcursor_col[3],
				src =   src,
				dst =   dst,
				defsc = motif.defaultEvent,
			})
			rect_boxcursor:draw()
		end
	--draw scroll arrows
		if #t > motif.event_info.menu_window_visibleitems then
			if item > cursorPosY then
				animUpdate(motif.event_info.menu_arrow_up_data)
				animDraw(motif.event_info.menu_arrow_up_data)
			end
			if item >= cursorPosY and item + motif.event_info.menu_window_visibleitems - cursorPosY < #t then
				animUpdate(motif.event_info.menu_arrow_down_data)
				animDraw(motif.event_info.menu_arrow_down_data)
			end
		end
	--draw credits text
		if motif.attract_mode.enabled == 1 and main.credits ~= -1 then
			txt_attract_credits:update({text = main.f_extractText(motif.attract_mode.credits_text, main.credits)[1]})
			txt_attract_credits:draw()
		end
	--draw footer overlay
		if motif.event_info.footer_overlay_window ~= nil then
			overlay_footer:draw()
		end
	--draw other text only if there is event data stored in select.def
		if t[item].itemname ~= 'back' then
			txt_titleEvent:update({text = motif.event_info.title_text})
			local eventNo = t[item].itemname
			local cdText = ""
		--Set text data
			if t[item].info ~= "" and main.t_unlockLua.modes[t[item].itemname] == nil then cdText = t[item].info else cdText = motif.event_info.info_unknown end
		--draw description text
			infoTextEnd = main.f_textRender(
				txt_infoEvent,
				cdText,
				infoTextCnt,
				motif.event_info.info_offset[1],
				motif.event_info.info_offset[2],
				motif.event_info.info_spacing[1],
				motif.event_info.info_spacing[2],
				main.font_def[motif.event_info.info_font[1] .. motif.event_info.info_font[7]],
				motif.event_info.info_delay,
				main.f_lineLength(
					motif.event_info.info_offset[1],
					motif.info.localcoord[1],
					motif.event_info.info_font[3],
					motif.event_info.info_window,
					motif.event_info.info_textwrap:match('[wl]')
				)
			)
			if not infoTextEnd then infoTextCnt = infoTextCnt + 1 end
		--draw hiscore text
			txt_hiscoreEvent:draw()
			if stats.modes ~= nil and stats.modes[eventNo] ~= nil then
				if stats.modes[eventNo].score ~= nil then --If there is hiscore data detected
					txt_hiscoreEvent:update({text = motif.event_info.hiscore_text..' '..stats.modes[eventNo].score})
				else --If there is not hiscore data detected
					txt_hiscoreEvent:update({text = motif.event_info.hiscore_text})
				end
			else --If there is not event data detected
				txt_hiscoreEvent:update({text = motif.event_info.hiscore_text})
			end
		else
			txt_titleEvent:update({text = "NO EVENT DATA"})
		end
	--draw layerno = 1 backgrounds
		bgDraw(motif.eventbgdef.bg, trueBool)
	--draw fadein / fadeout
		main.f_fadeAnim(motif.event_info)
--;---------------------------------------------------------------------------------------------------------------------
		cursorPosY, moveTxt, item = f_menuCommonCalc(t, item, cursorPosY, moveTxt, 'event_info', {'$U'}, {'$D'})
	--Cursor Move
		if commandGetState(main.t_cmd[main.playerInput], '$U') or commandGetState(main.t_cmd[main.playerInput], '$D') then
			f_resetEventInfoTxt()
		end
	--Close Screen
		if main.close and not main.fadeActive then
			main.f_bgReset(motif[main.background].bg)
			main.f_fadeReset('fadein', motif[main.group])
			motif.music.title_bgm = backupTitleSong
			motif.music.title_bgm_loop = backupTitleLoop
			motif.music.title_bgm_volume = backupTitleVolume
			motif.music.title_bgm_loopstart = backupTitleLoopStart
			motif.music.title_bgm_loopend = backupTitleLoopEnd
			main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
			main.close = false
			break
	--Back Button
		elseif not main.close and (esc() or main.f_input(main.t_players, {'m'}) or (t[item].itemname == 'back' and main.f_input(main.t_players, {'pal', 's'}))) then
			sndPlay(motif.files.snd_data, motif.event_info.cancel_snd[1], motif.event_info.cancel_snd[2])
			main.f_fadeReset('fadeout', motif.event_info)
			main.close = true
	--Accept Button
		elseif main.f_input(main.t_players, {'pal', 's'}) then
			if main.t_unlockLua.modes[t[item].itemname] == nil then --If the event is unlocked
				sndPlay(motif.files.snd_data, motif[main.group].cursor_done_snd[1], motif[main.group].cursor_done_snd[2])
			--START EVENT
				main.txt_mainSelect:update({text = motif.select_info.title_events_text}) --Character Select Title
				main.f_playerInput(main.playerInput, 1)
				main.selectMenu[1] = t[item].charsel --Enable or Disable Character Select for Event Selected
				main.teamMenu[1].single = t[item].single
				main.teamMenu[1].simul = t[item].simul
				main.teamMenu[1].tag = t[item].tag
				main.teamMenu[1].turns = t[item].turns
				main.teamMenu[1].ratio = t[item].ratio
				main.stageMenu = t[item].stgsel --Enable or Disable Stage Select for Event Selected
				main.versusScreen = t[item].vsscreen --Enable or Disable Versus Screen for Event Selected
				main.orderSelect[1] = t[item].ordersel --Enable or Disable Order Select for Event Selected
			--which lifebar elements should be rendered
				main.lifebar.bars = t[item].lfbar --main.lifebar.active = t[item].lfbar
				main.lifebar.match = t[item].lfbarmatchno
				main.lifebar.timer = t[item].lfbartimer
				main.lifebar.p1score = t[item].lfbarscorep1
				main.lifebar.p2score = t[item].lfbarscorep2
				main.lifebar.p1aiLevel = t[item].lfbaraip1
				main.lifebar.p2aiLevel = t[item].lfbaraip2
				main.lifebar.p1winCount = t[item].lfbarwinp1
				main.lifebar.p2winCount = t[item].lfbarwinp2
			--Hiscore Stuff
			--[[
				main.hiscoreScreen = false
				main.rankingCondition = true
				main.resultsTable = motif.bonus_rush_results_screen
				start.t_sortRanking.event1 = start.t_sortRanking.survival
				start.t_clearCondition.event1 = function() return winnerteam() == 1 end
				main.t_hiscoreData.event1 = {mode = t[item].itemname, data = 'score', title = "Event Ranking"}
			--]]
				main.victoryScreen = t[item].winscreen --Enable or Disable Victory Screen for Event Selected
				main.continueScreen = t[item].continue --Enable or Disable Continue Screen for Event Selected
				main.quickContinue = t[item].quickcontinue --Enable or Disable skip player selection when continuing for Event Selected
				setGameMode(t[item].itemname) --This uses t_selEventMode[id] name
				hook.run("main.t_itemname")
				main.luaPath = t[item].path
				if motif.music.event_bgm ~= "" then --Keep playing Event Menu BGM in Character Select
					motif.music.select_bgm = motif.music.event_bgm
					motif.music.title_bgm = motif.music.event_bgm
				end
				main.f_fadeReset('fadeout', motif.event_info)
				main.f_unlock(false) --To check Unlocks before enter in Character Select
				if main.debugLog then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
				start.f_selectMode()
				if winnerteam() == 1 then --Save Score Data only if you complete event
					if score() > stats.modes[t[item].itemname].score then --Update Hiscore only if is greater than the previous one
						stats.modes[t[item].itemname].score = score()
					end
					saveEventData()
				end
				main.f_unlock(false) --To Check Unlocks after play events
				if main.debugLog then main.f_printTable(main.t_unlockLua, 'debug/t_unlockLua.txt') end
				main.f_cmdBufReset()
				f_resetEventInfoTxt()
				if motif.music.event_bgm ~= "" then
					motif.music.select_bgm = backupSelSong --Restore Character Select BGM
					motif.music.select_bgm_loop = backupSelLoop
					motif.music.select_bgm_volume = backupSelVolume
					motif.music.select_bgm_loopstart = backupSelLoopStart
					motif.music.select_bgm_loopend = backupSelLoopEnd
					if not t[item].charsel then --Play Event Select BGM
						main.f_playBGM(false, motif.music.event_bgm, motif.music.event_bgm_loop, motif.music.event_bgm_volume, motif.music.event_bgm_loopstart, motif.music.event_bgm_loopend)
					end
				end
				main.f_fadeAnim(motif.select_info) --fadein / fadeout
			end
		end
		main.f_cmdInput()
		main.f_refresh()
	end
end
if main.debugLog then main.f_printTable(motif, "debug/t_motif.txt") end

main.t_itemname.events = function()
	return f_events() --Call above function (that contains a custom sub-menu) when you enter in main menu item
end