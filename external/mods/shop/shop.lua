--[[					 		   SHOP MODULE
===========================================================================================
Version: 1.2.1
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2025-10-01 Nightly Build
Description:
Adds:
- In-Game Currency System (Player Currency will increase after win a match).
- Shop Mode entry for the Main Menu (To spend In-Game Currency).
===========================================================================================
						           DISCLAIMER
In Network (Online Mode), as happens with Game Settings, a desynchronization may occur
if the host and client have not unlocked the same content.

Due to current engine limitations, to manage this situation, network() function has been added
to the shop item examples that will temporarily cause the content to be unlocked
(even if neither party has purchased it), only during online session.
===========================================================================================
]]
local nightlyVer = true --Indicates if you are using Nightly IkemenGO version, to setup some stuff...
--[[README!
- HOW TO FIX:
shop.lua: "attempt to index a non-table object(nil) with key 'p1score" error (appears after win a fight):
GO TO "external/script/start.lua" AND FOR "local t_gameStats = {}" remove "local" and save the file.

- HOW TO LOAD CUSTOM PORTRAITS for CHARACTERS or STAGES using [Shop Info] .preview paramvalues:
GO TO "external/script/main.lua" and below: "--generate preload stage spr/anim list"
copy and paste the next block of code above "warning display" function:

--generate preload custom shop character preview spr/anim list
f_preloadList(motif.shop_info.character_preview_anim)
f_preloadList(motif.shop_info.character_preview_spr)

--generate preload custom shop stage preview spr/anim list
if #motif.shop_info.stage_preview_spr >= 2 and motif.shop_info.stage_preview_spr[1] >= 0 then
	preloadListStage(motif.shop_info.stage_preview_spr[1], motif.shop_info.stage_preview_spr[2])
end
if motif.shop_info.stage_preview_anim ~= nil and motif.shop_info.stage_preview_anim >= 0 then
	preloadListStage(motif.shop_info.stage_preview_anim)
end

]]
--;===========================================================================================
--; 							      MOTIF STUFF
--;===========================================================================================
--[Music]
if motif.music.shop_bgm == nil then
	motif.music.shop_bgm = ""
end
if motif.music.shop_bgm_volume == nil then
	motif.music.shop_bgm_volume = 100
end
if motif.music.shop_bgm_loop == nil then
	motif.music.shop_bgm_loop = 1
end
if motif.music.shop_bgm_loopstart == nil then
	motif.music.shop_bgm_loopstart = 0
end
if motif.music.shop_bgm_loopend == nil then
	motif.music.shop_bgm_loopend = 0
end

--[Shop Info] default parameters (used for rendering shop menu screen assets)
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
	cursor_done_snd = {100, 1},
	cursor_category_snd = {100, 0},
	cursor_purchase_snd = {600, 0},
	cursor_error_snd = {600, 1},
	cancel_snd = {100, 2},
	
	title_offset = {5, 15},
	title_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
	title_scale = {1.0, 1.0},
	title_text = 'ITEM SHOP',
	
	category_offset = {77, 45},
	category_font = {'jg.fnt', 5, 0, 255, 255, 255, -1},
	category_scale = {1.0, 1.0},
	category_text = 'CATEGORIES',
	
	currency_offset = {318, 15},
	currency_font = {'jg.fnt', 0, -1, 255, 255, 255, -1},
	currency_scale = {1.0, 1.0},
	currency_text = 'P$',
	
	price_offset = {240, 197},
	price_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	price_scale = {1.0, 1.0},
	price_text = '',
	price_text_sold = 'SOLD OUT',
	price_default = 500,
	
	info_offset = {5, 230},
	info_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	info_scale = {0.95, 0.95},
	info_text = '',
	info_text_unknown = '???',
	info_text_unlock = 'Unlocks',
	info_text_locked = 'This item has yet to be discovered...',
	info_text_purchase = 'Purchase',
	
	items_def = "external/mods/shop/items.def",
	items_spr = "external/mods/shop/items.sff",
	
	preview_bg_anim = -1,
	preview_bg_spr = {0, 1},
	preview_bg_offset = {80.6, 14},
	preview_bg_facing = 1,
	preview_bg_scale = {1.05, 1.1},
	preview_bg_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	preview_unknown_anim = -1,
	preview_unknown_spr = {0, 2},
	preview_unknown_offset = {82.395, 16},
	preview_unknown_facing = 1,
	preview_unknown_scale = {1.03, 1.1},
	preview_unknown_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	character_preview_resetanim = 0,
	character_preview_anim = -1,
	character_preview_spr = {9000, 1},
	character_preview_offset = {177, 45},
	character_preview_facing = 1,
	character_preview_scale = {1.0, 1.0},
	character_preview_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	stage_preview_resetanim = 0,
	stage_preview_anim = -1,
	stage_preview_spr = {9000, 1},
	stage_preview_offset = {163, 31},
	stage_preview_facing = 1,
	stage_preview_scale = {0.63, 1.68},
	stage_preview_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	custom_preview_offset = {0, 0},
	custom_preview_scale = {1.0, 1.0},
	custom_preview_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
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
	
	menu_item_offset = {5, 61},
	menu_item_font = {'f-6x9.def', 0, 1, 191, 191, 191, -1},
	menu_item_scale = {1.0, 1.0},
	menu_item_active_offset = {5, 61},
	menu_item_active_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1},
	menu_item_active_scale = {1.0, 1.0},
	menu_item_spacing = {0, 15},
	
	menu_window_margins_y = {0, 0},
	menu_window_visibleitems = 10,
	
	menu_boxcursor_visible = 1,
	menu_boxcursor_coords = {-5, 50, 156, 65},
	menu_boxcursor_col = {255, 255, 255},
	menu_boxcursor_alpharange = {10, 40, 2, 255, 255, 0},
	
	menu_boxbg_visible = 1,
	menu_boxbg_col = {0, 0, 0},
	menu_boxbg_alpha = {0, 128},
	
	menu_arrow_up_anim = -1,
	menu_arrow_up_spr = {400, 0},
	menu_arrow_up_offset = {146, 42},
	menu_arrow_up_facing = 1,
	menu_arrow_up_scale = {0.5, 0.5},
	
	menu_arrow_down_anim = -1,
	menu_arrow_down_spr = {401, 0},
	menu_arrow_down_offset = {146, 203},
	menu_arrow_down_facing = 1,
	menu_arrow_down_scale = {0.5, 0.5},
	
	purchase_overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	purchase_overlay_col = {0, 0, 0},
	purchase_overlay_alpha = {0, 128},
	
	purchase_bg_anim = -1,
	purchase_bg_spr = {0, 1},
	purchase_bg_offset = {22, 35},
	purchase_bg_facing = 1,
	purchase_bg_scale = {1.5, 0.7},
	purchase_bg_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	purchase_cursor_anim = -1,
	purchase_cursor_spr = {},
	purchase_cursor_offset = {80.6, 100},
	purchase_cursor_spacing = {0, 15},
	purchase_cursor_facing = 1,
	purchase_cursor_scale = {1.0, 1.0},
	purchase_cursor_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	purchase_boxcursor_visible = 1,
	purchase_boxcursor_spacing = {0, 20},
	purchase_boxcursor_coords = {47, 138, 262, 153},
	purchase_boxcursor_col = {255, 255, 255},
	purchase_boxcursor_alpharange = {10, 40, 2, 255, 255, 0},
	
	purchase_info_offset = {160, 90},
	purchase_info_spacing = {0, 5},
	purchase_info_window = {50, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	purchase_info_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	purchase_info_scale = {1.0, 1.0},
	purchase_info_text = 'You do not have enough P$ to buy this content.',
	
	purchase_question_offset = {160, 90},
	purchase_question_font = {'jg.fnt', 5, 0, 255, 255, 255, -1},
	purchase_question_scale = {1.0, 1.0},
	purchase_question_text = 'Purchase with P$?',
	
	purchase_yes_text = 'Yes',
	purchase_ok_text = 'Accept',
	purchase_no_text = 'No',
	
	purchase_yes_offset = {155, 150},
	purchase_yes_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	purchase_yes_scale = {1.0, 1.0},
	
	purchase_yes_active_offset = {155, 150},
	purchase_yes_active_font = {'jg.fnt', 5, 0, 255, 255, 255, -1},
	purchase_yes_active_scale = {1.0, 1.0},
	
	purchase_no_offset = {155, 170},
	purchase_no_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	purchase_no_scale = {1.0, 1.0},
	
	purchase_no_active_offset = {155, 170},
	purchase_no_active_font = {'jg.fnt', 5, 0, 255, 255, 255, -1},
	purchase_no_active_scale = {1.0, 1.0},
	
	balance_old_offset = {140, 125},
	balance_old_font = {'jg.fnt', 0, -1, 255, 255, 255, -1},
	balance_old_scale = {1.0, 1.0},
	balance_old_text = '',
	
	balance_arrow_anim = -1,
	balance_arrow_spr = {0, 0},
	balance_arrow_offset = {77, 58},
	balance_arrow_facing = 1,
	balance_arrow_scale = {0.5, 0.5},
	balance_arrow_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]},
	
	balance_new_offset = {170, 125},
	balance_new_font = {'jg.fnt', 0, 1, 255, 255, 255, -1},
	balance_new_scale = {1.0, 1.0},
	balance_new_text = '',
}
if motif.shop_info == nil then
	motif.shop_info = {}
end
motif.shop_info = main.f_tableMerge(t_base, motif.shop_info)

--If not defined [ShopBGdef]
if motif.shopbgdef == nil then
	motif.shopbgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
end

-- This code creates data out of optional [ShopBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.shopbgdef.spr ~= nil and motif.shopbgdef.spr ~= '' then
	motif.shopbgdef.spr = searchFile(motif.shopbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.shopbgdef.spr_data = sffNew(motif.shopbgdef.spr)
else
	motif.shopbgdef.spr = motif.files.spr
	motif.shopbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.shopbgdef.bg = bgNew(motif.shopbgdef.spr_data, motif.def, 'shopbg')

-- fadein/fadeout anim data generation.
if motif.shop_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.shop_info, {s = 'fadein_'})
end
if motif.shop_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.shop_info, {s = 'fadeout_'})
end

--arrows spr/anim data
for _, v in ipairs({motif.shop_info}) do
	motif.f_loadSprData(v, {s = 'menu_arrow_up_',   x = v.menu_pos[1], y = v.menu_pos[2]})
	motif.f_loadSprData(v, {s = 'menu_arrow_down_', x = v.menu_pos[1], y = v.menu_pos[2]})
end

--[Reward Info] default parameters (used for rendering reward screen assets)
local t_base2 = {
	fadein_time = 20,
	fadein_col = {0, 0, 0},
	fadein_anim = -1,
	
	fadeout_time = 20,
	fadeout_col = {0, 0, 0},
	fadeout_anim = -1,
	
	menu_pos = {0, 0},
	
	reward_snd = {600, 0},
	accept_snd = {100, 2},
	
	victory_reward = 500,
	firstattack_reward = 100,
	specialko_reward = 1000,
	superko_reward = 1500,
	perfectko_reward = 2000,
	
	reward_offset = {160, 100},
	reward_font = {'jg.fnt', 0, 0, 255, 255, 255, -1},
	reward_scale = {1.0, 1.0},
	reward_text = 'P$ Earned!',
	
	accept_offset = {160, 135},
	accept_font = {'jg.fnt', 5, 0, 255, 255, 255, -1},
	accept_scale = {1.0, 1.0},
	accept_text = 'Accept',
}
if motif.reward_info == nil then
	motif.reward_info = {}
end
motif.reward_info = main.f_tableMerge(t_base2, motif.reward_info)

--If not defined [RewardBGdef]
if motif.rewardbgdef == nil then
	motif.rewardbgdef = {
		spr = '',
		bgclearcolor = {0, 0, 0},
	}
end

-- This code creates data out of optional [RewardBGdef] sff file.
-- Defaults to motif.files.spr_data, defined in screenpack, if not declared.
if motif.rewardbgdef.spr ~= nil and motif.rewardbgdef.spr ~= '' then
	motif.rewardbgdef.spr = searchFile(motif.rewardbgdef.spr, {motif.fileDir, '', 'data/'})
	motif.rewardbgdef.spr_data = sffNew(motif.rewardbgdef.spr)
else
	motif.rewardbgdef.spr = motif.files.spr
	motif.rewardbgdef.spr_data = motif.files.spr_data
end

-- Background data generation.
-- Refer to official Elecbyte docs for information how to define backgrounds.
-- http://www.elecbyte.com/mugendocs/bgs.html#description-of-background-elements
motif.rewardbgdef.bg = bgNew(motif.rewardbgdef.spr_data, motif.def, 'rewardbg')

-- fadein/fadeout anim data generation.
if motif.reward_info.fadein_anim ~= -1 then
	motif.f_loadSprData(motif.reward_info, {s = 'fadein_'})
end
if motif.reward_info.fadeout_anim ~= -1 then
	motif.f_loadSprData(motif.reward_info, {s = 'fadeout_'})
end

--disabled scaling if element uses default values (non-existing in mugen)
motif.defaultShop = motif.shop_info.menu_uselocalcoord == 0

--Setup argument for bgDraw functions
if nightlyVer then
	trueBool = 1
	falseBool = 0
else
	trueBool = true
	falseBool = false
end

--Setup function to use for preloaded data
local function f_getPreloadedData(dataType, id, group, index)
	local animDat = nil
	if nightlyVer then --For the lastest nightly
		if dataType == 'char' then
			animDat = animGetPreloadedCharData(id, group, index)
		elseif dataType == 'stage' then
			animDat = animGetPreloadedStageData(id, group, index)
		end
	else --For Old Ikemen GO versions
		animDat = animGetPreloadedData(dataType, id, group, index)
	end
	return animDat
end
--;===========================================================================================
--; 									SHOP LOGIC
--;===========================================================================================
local txt_shopTitle = main.f_createTextImg(motif.shop_info, 'title', {defsc = motif.defaultShop})
local txt_shopCategory = main.f_createTextImg(motif.shop_info, 'category', {defsc = motif.defaultShop})
local txt_shopItemInfo = main.f_createTextImg(motif.shop_info, 'info', {defsc = motif.defaultShop})

local txt_shopCurrency = main.f_createTextImg(motif.shop_info, 'currency', {defsc = motif.defaultShop})
local txt_shopPriceInfo = main.f_createTextImg(motif.shop_info, 'price', {defsc = motif.defaultShop})

local txt_shopBalanceOld = main.f_createTextImg(motif.shop_info, 'balance_old', {defsc = motif.defaultShop})
local txt_shopBalanceNew = main.f_createTextImg(motif.shop_info, 'balance_new', {defsc = motif.defaultShop})

local txt_shopPurchaseQuestion = main.f_createTextImg(motif.shop_info, 'purchase_question', {defsc = motif.defaultShop})
local txt_shopPurchaseInfo = main.f_createTextImg(motif.shop_info, 'purchase_info', {defsc = motif.defaultShop})
local txt_shopPurchaseYes = main.f_createTextImg(motif.shop_info, 'purchase_yes', {defsc = motif.defaultShop})
local txt_shopPurchaseNo = main.f_createTextImg(motif.shop_info, 'purchase_no', {defsc = motif.defaultShop})

local rect_boxcursor = rect:create({})
local rect_boxbg = rect:create({})
local t_menuWindowShop = main.f_menuWindow(motif.shop_info)

local overlay_purchase = main.f_createOverlay(motif.shop_info, 'purchase_overlay')
local rect_purchaseboxcursor = rect:create({})

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

local function f_saveStats()
	if main.debugLog then main.f_printTable(stats, 'debug/t_stats.txt') end --Print Debug Info
	main.f_fileWrite(main.flags['-stats'], json.encode(stats, {indent = 2})) --Write in stats.json file
end

if stats.playerCurrency == nil then stats.playerCurrency = 0 end --Create space to save money
stats.playerCurrencyOLD = stats.playerCurrency --Save player currency backup to do calculations
local function f_earnMoney()
	if stats.playerCurrencyOLD == -1 then stats.playerCurrencyOLD = stats.playerCurrency end
	stats.playerCurrency = stats.playerCurrency + motif.reward_info.victory_reward
	if firstattack() then stats.playerCurrency = stats.playerCurrency + motif.reward_info.firstattack_reward end
	if winspecial() then stats.playerCurrency = stats.playerCurrency + motif.reward_info.specialko_reward end
	if winhyper() then stats.playerCurrency = stats.playerCurrency + motif.reward_info.superko_reward end
	if winperfect() then stats.playerCurrency = stats.playerCurrency + motif.reward_info.perfectko_reward end
	f_saveStats()
end

function start.f_saveData()
	if main.debugLog then main.f_printTable(t_gameStats, 'debug/t_gameStats.txt') end
	if winnerteam() == -1 then
		return
	end
	--win/lose matches count, total score
	if winnerteam() == 1 then
		f_earnMoney() --Win money
		start.t_savedData.win[1] = start.t_savedData.win[1] + 1
		start.t_savedData.lose[2] = start.t_savedData.lose[2] + 1
		start.t_savedData.score.total[1] = t_gameStats.p1score
	else --if winnerteam() == 2 then
		start.t_savedData.win[2] = start.t_savedData.win[2] + 1
		start.t_savedData.lose[1] = start.t_savedData.lose[1] + 1
		if main.resetScore and matchno() ~= -1 then --loosing sets score for the next match to lose count
			start.t_savedData.score.total[1] = start.t_savedData.lose[1]
			start.t_savedData.debugflag[1] = false
		else
			start.t_savedData.score.total[1] = t_gameStats.p1score
		end
	end
	start.t_savedData.score.total[2] = t_gameStats.p2score
	--total time
	start.t_savedData.time.total = start.t_savedData.time.total + t_gameStats.matchTime
	--time in each round
	table.insert(start.t_savedData.time.matches, t_gameStats.timerRounds)
	--score in each round
	table.insert(start.t_savedData.score.matches, t_gameStats.scoreRounds)
	--max consecutive wins
	for side = 1, 2 do
		if getConsecutiveWins(side) > start.t_savedData.consecutive[side] then
			start.t_savedData.consecutive[side] = getConsecutiveWins(side)
		end
	end
	if main.debugLog then main.f_printTable(start.t_savedData, 'debug/t_savedData.txt') end
end

if stats.shopstock == nil then stats.shopstock = {} end --Create space to sell shop items
local function f_setShopStock(t)
	for item=1, #t do
	--Add Category to shop stock
		local category = t.category --t[item].category
		if stats.shopstock[category] == nil then stats.shopstock[category] = {} end
	--Add item to shop stock
		local itemname = t[item].id
		if stats.shopstock[category][itemname] == nil then stats.shopstock[category][itemname] = true end
	end
end

--asserts shop unlock conditions
local function f_unlockShop(permanent)
	for group, t in pairs(main.t_unlockLua) do
		local t_del = {}
		for k, v in pairs(t) do
			local bool = assert(loadstring('return ' .. v))()
			if type(bool) == 'boolean' then
				if bool and (permanent or group == 'modes' or group == 'shop') then
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
local function reindexTableInPlace(t)
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
	reindexTableInPlace(t)
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
	for _, v in pairs({{motif.shop_info.character_preview_anim, -1}, motif.shop_info.character_preview_spr}) do
		if #v > 0 and v[1] ~= -1 then
			main.t_selChars[charNo+1].shopAnim_data = f_getPreloadedData('char', charNo, v[1], v[2])
			if main.t_selChars[charNo+1].shopAnim_data ~= nil then
				local xscale = start.f_getCharData(charNo).portrait_scale / (main.SP_Viewport43[3] / main.SP_Localcoord[1])
				local yscale = xscale
				if v[2] == -1 then
					xscale = xscale * (start.f_getCharData(charNo).cns_scale[1] or 1)
					yscale = yscale * (start.f_getCharData(charNo).cns_scale[2] or 1)
				end
				animSetScale(
					main.t_selChars[charNo+1].shopAnim_data,
					motif.shop_info.character_preview_scale[1] * xscale,
					motif.shop_info.character_preview_scale[2] * yscale,
					false
				)
				animSetWindow(
					main.t_selChars[charNo+1].shopAnim_data,
					motif.shop_info.character_preview_window[1],
					motif.shop_info.character_preview_window[2],
					motif.shop_info.character_preview_window[3],
					motif.shop_info.character_preview_window[4]
				)
				animUpdate(main.t_selChars[charNo+1].shopAnim_data)
				break
			end
		end
	end
	if main.t_selChars[charNo+1].shopAnim_data == nil then
		main.t_selChars[charNo+1].shopAnim_data = animNew(main.dummySff, '-1,0, 0,0, -1')
	end
end

local function f_loadStagePreviewData(stageNo)
--anim data
	for _, v in pairs({{motif.shop_info.stage_preview_anim, -1}, motif.shop_info.stage_preview_spr}) do
		if #v > 0 and v[1] ~= -1 then
			main.t_selStages[stageNo].shopAnim_data = f_getPreloadedData('stage', stageNo, v[1], v[2])
			if main.t_selStages[stageNo].shopAnim_data ~= nil then
				animSetScale(
					main.t_selStages[stageNo].shopAnim_data,
					motif.shop_info.stage_preview_scale[1] * main.t_selStages[stageNo].portrait_scale / (main.SP_Viewport43[3] / main.SP_Localcoord[1]),
					motif.shop_info.stage_preview_scale[2] * main.t_selStages[stageNo].portrait_scale / (main.SP_Viewport43[3] / main.SP_Localcoord[1]),
					false
				)
				animSetWindow(
					main.t_selStages[stageNo].shopAnim_data,
					motif.shop_info.stage_preview_window[1],
					motif.shop_info.stage_preview_window[2],
					motif.shop_info.stage_preview_window[3],
					motif.shop_info.stage_preview_window[4]
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
	t_shopMenu = {}
	local t_tempShop = {}
	local sectionName = nil
	local section = 0
	local content = main.f_fileRead(motif.shop_info.items_def)
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
							name = motif.shop_info.info_text_unknown,
							info = nil,
							price = motif.shop_info.price_default,
							spr = {},
							offset = motif.shop_info.custom_preview_offset,
							scale = motif.shop_info.custom_preview_scale,
							window = motif.shop_info.custom_preview_window,
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
	if main.debugLog then main.f_printTable(t_tempShop, 'debug/t_tempShop.txt') end
--Check that the added items exist to add them to the shop menu 
	for categoryNo=1, #t_tempShop do
		if t_tempShop[categoryNo].category ~= nil then t_shopMenu[categoryNo] = {} end
	--Filter Chars/Costumes
		if t_tempShop[categoryNo].category == "Characters" or t_tempShop[categoryNo].category == "Chars"
		or t_tempShop[categoryNo].category == "chars" or t_tempShop[categoryNo].category == "characters"
		or t_tempShop[categoryNo].category == "CHARS" or t_tempShop[categoryNo].category == "CHARACTERS"
		or t_tempShop[categoryNo].category == "Costumes" or t_tempShop[categoryNo].category == "costumes"
		or t_tempShop[categoryNo].category == "COSTUMES" then
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].id:lower()
				if main.t_charDef[pathID] ~= nil then --If char has been added via select.def, add to the shop
					t_shopMenu[categoryNo][itemNo] = {data = text:create({window = t_menuWindowShop})} --Create text data
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motif.shop_info.info_text_purchase..' '..t_tempShop[categoryNo].category
					f_loadCharPreviewData(main.t_charDef[pathID])
					f_readCharName(main.t_charDef[pathID]+1)
					local baseName = main.t_selChars[main.t_charDef[pathID]+1].basename
					local displayName = main.t_selChars[main.t_charDef[pathID]+1].name
					local infoData = t_tempShop[categoryNo][itemNo].info
					if baseName then
						t_shopMenu[categoryNo][itemNo]['itemname'] = baseName
						if infoData ~= nil then
							t_shopMenu[categoryNo][itemNo]['info'] = infoData
						else
							t_shopMenu[categoryNo][itemNo]['info'] = motif.shop_info.info_text_unlock..' '..baseName
						end
					else
						t_shopMenu[categoryNo][itemNo]['itemname'] = displayName
						if infoData ~= nil then
							t_shopMenu[categoryNo][itemNo]['info'] = infoData
						else
							t_shopMenu[categoryNo][itemNo]['info'] = motif.shop_info.info_text_unlock..' '..displayName
						end
					end
					t_shopMenu[categoryNo][itemNo]['id'] = pathID
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
				else --Ignore items that are not recognized
					
				end
			end
	--Filter Stages
		elseif t_tempShop[categoryNo].category == "Stages" or t_tempShop[categoryNo].category == "stages" or t_tempShop[categoryNo].category == "STAGES" then
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].id:lower()
				if main.t_stageDef[pathID] ~= nil then --If stage has been added via select.def, add to the shop
					local infoData = t_tempShop[categoryNo][itemNo].info
					t_shopMenu[categoryNo][itemNo] = {data = text:create({window = t_menuWindowShop})}
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motif.shop_info.info_text_purchase..' '..t_tempShop[categoryNo].category
					f_loadStagePreviewData(main.t_stageDef[pathID])
					if infoData ~= nil then
						t_shopMenu[categoryNo][itemNo]['info'] = infoData
					else
						t_shopMenu[categoryNo][itemNo]['info'] = motif.shop_info.info_text_unlock..' '..main.t_selStages[main.t_stageDef[pathID]].name
					end
					t_shopMenu[categoryNo][itemNo]['id'] = pathID
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['itemname'] = main.t_selStages[main.t_stageDef[pathID]].name
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
				end
			end
	--Custom Stuff
		else
			for itemNo=1, #t_tempShop[categoryNo] do
				local pathID = t_tempShop[categoryNo][itemNo].id:lower()
				--if t_itemDef[pathID] ~= nil then --If item exists, add to the shop
					local infoData = t_tempShop[categoryNo][itemNo].info
					t_shopMenu[categoryNo][itemNo] = {data = text:create({window = t_menuWindowShop})}
					t_shopMenu[categoryNo]['category'] = t_tempShop[categoryNo].category
					t_shopMenu[categoryNo]['info'] = motif.shop_info.info_text_purchase..' '..t_tempShop[categoryNo].category
					if infoData ~= nil then
						t_shopMenu[categoryNo][itemNo]['info'] = infoData
					else
						t_shopMenu[categoryNo][itemNo]['info'] = motif.shop_info.info_text_unlock..' '..t_tempShop[categoryNo][itemNo].name
					end
					t_shopMenu[categoryNo][itemNo]['id'] = pathID
					t_shopMenu[categoryNo][itemNo]['price'] = tonumber(t_tempShop[categoryNo][itemNo].price)
					t_shopMenu[categoryNo][itemNo]['itemname'] = t_tempShop[categoryNo][itemNo].name
					t_shopMenu[categoryNo][itemNo]['unlock'] = t_tempShop[categoryNo][itemNo].unlock
					
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
	--Create Shop Stock in stats.json
		if #t_shopMenu[i] ~= 0 then
			f_setShopStock(t_shopMenu[i])
		end
	--Set Shop Item "Discovered" Conditions
		for k, v in ipairs(t_shopMenu[i]) do
			if main.t_unlockLua.shop == nil then main.t_unlockLua['shop'] = {} end
			main.t_unlockLua.shop[v.id] = v.unlock
		end
	end
	f_saveStats()
	if main.debugLog then main.f_printTable(t_shopMenu, 'debug/t_shopMenu.txt') end
	if main.debugLog then main.f_printTable(main.t_selChars, "debug/t_selChars.txt") end
	if main.debugLog then main.f_printTable(main.t_selStages, "debug/t_selStages.txt") end
--Load .sff file with Shop Items
	if main.f_fileExists(motif.shop_info.items_spr) then
		motif.files.shop_data = sffNew(motif.shop_info.items_spr)
	else
		motif.files.shop_data = sffNew()
	end
end
f_loadShop() --Load shop data (items.def & items.sff files) when engine starts

--creates sprite data out of table values
local anim = ''
local facing = ''
local function f_loadShopSprData(t, v) --This function uses motif.files.shop_data instead system.sff data
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
			motif.files.shop_data,
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
		t[data] = animNew(motif.files.shop_data, t[sprParam][1] .. ', ' .. t[sprParam][2] .. ', ' .. (t[v.s .. 'offset'][1] + (v.x or 0)) / t[v.s .. 'scale'][1] .. ', ' .. (t[v.s .. 'offset'][2] + (v.y or 0)) / t[v.s .. 'scale'][2] .. ', -1' .. facing)
		animSetScale(t[data], t[v.s .. 'scale'][1], t[v.s .. 'scale'][2])
		animUpdate(t[data])
	else --create dummy data
		t[data] = animNew(motif.files.shop_data, '-1,0, 0,0, -1')
		animUpdate(t[data])
	end
	animSetWindow(t[data], 0, 0, motif.info.localcoord[1], motif.info.localcoord[2])
end
f_loadShopSprData(motif.shop_info, {s = 'preview_bg_'}) --Generate motif.shop_info.preview_bg_data
f_loadShopSprData(motif.shop_info, {s = 'preview_unknown_'}) --Generate motif.shop_info.preview_unknown_data
f_loadShopSprData(motif.shop_info, {s = 'purchase_bg_'}) --Generate motif.shop_info.purchase_bg_data
f_loadShopSprData(motif.shop_info, {s = 'balance_arrow_'}) --Generate motif.shop_info.balance_arrow_data
f_loadShopSprData(motif.shop_info, {s = 'purchase_cursor_'}) --Generate motif.shop_info.purchase_cursor_data

local function f_drawCustomPreview(group, index, x, y, scaleX, scaleY, x1, y1, x2, y2)
	local anim = group..','..index..', 0,0, -1' --local anim = group..','..index..','..x..','..y..','..'-1'
	anim = animNew(motif.files.shop_data, anim)
	animSetScale(anim, scaleX, scaleY)
	animSetPos(anim, x, y)
	animSetWindow(anim, x1, y1, x2, y2)
	animUpdate(anim)
	animDraw(anim)
end

local function f_drawShopItemPreview(category, itemNo)
	local itemID = t_shopMenu[shopCategoryNo][itemNo].id --:lower()
--Character Preview
	if category == "chars" or category == "characters" or category == "costumes" then
		local shopCharAnimDat = main.t_selChars[main.t_charDef[itemID]+1].shopAnim_data
		if motif.shop_info.character_preview_resetanim == 1 and resetShopAnim then
			animReset(shopCharAnimDat)
		end
		if resetShopAnim then resetShopAnim = false end
		main.f_animPosDraw(
			shopCharAnimDat,
			motif.shop_info.menu_pos[1] + motif.shop_info.character_preview_offset[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.character_preview_offset[2],
			motif.shop_info.character_preview_facing,
			true
		)
--Stage Preview
	elseif category == "stages" then
		main.f_animPosDraw(
			motif.shop_info.preview_unknown_data,
			motif.shop_info.menu_pos[1] + motif.shop_info.preview_unknown_offset[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.preview_unknown_offset[2],
			motif.shop_info.preview_unknown_facing,
			true
		)
		local shopStageAnimDat = main.t_selStages[main.t_stageDef[itemID]].shopAnim_data --main.t_selStages[main.t_selectableStages[main.t_stageDef[itemID]]].shopAnim_data
		if motif.shop_info.stage_preview_resetanim == 1 and resetShopAnim then
			animReset(shopStageAnimDat)
		end
		if resetShopAnim then resetShopAnim = false end
		main.f_animPosDraw(
			shopStageAnimDat,
			motif.shop_info.menu_pos[1] + motif.shop_info.stage_preview_offset[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.stage_preview_offset[2],
			motif.shop_info.stage_preview_facing,
			true
		)
--Custom Stuff Preview
	else
		if t_shopMenu[shopCategoryNo][itemNo].spr == nil then
			main.f_animPosDraw(
				motif.shop_info.preview_unknown_data,
				motif.shop_info.menu_pos[1] + motif.shop_info.preview_unknown_offset[1],
				motif.shop_info.menu_pos[2] + motif.shop_info.preview_unknown_offset[2],
				motif.shop_info.preview_unknown_facing,
				true
			)
		else
			f_drawCustomPreview(
				t_shopMenu[shopCategoryNo][itemNo].spr[1], --group
				t_shopMenu[shopCategoryNo][itemNo].spr[2], --index
				motif.shop_info.menu_pos[1] + t_shopMenu[shopCategoryNo][itemNo].offset[1], --x
				motif.shop_info.menu_pos[2] + t_shopMenu[shopCategoryNo][itemNo].offset[2], --y
				t_shopMenu[shopCategoryNo][itemNo].scale[1], --scaleX
				t_shopMenu[shopCategoryNo][itemNo].scale[2], --scaleY
				t_shopMenu[shopCategoryNo][itemNo].window[1], --x1
				t_shopMenu[shopCategoryNo][itemNo].window[2], --y1
				t_shopMenu[shopCategoryNo][itemNo].window[3], --x2
				t_shopMenu[shopCategoryNo][itemNo].window[4] --y2
			)
		end
	end
end

local function f_confirmShopReset()
	confirmPurchase = false
	purchaseCursor = 2
end

local function f_confirmPurchase(item, enoughMoney)
	main.f_cmdInput()
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
		fontYes = motif.shop_info.purchase_yes_active_font[1]
		bankYes = motif.shop_info.purchase_yes_active_font[2]
		alignYes = motif.shop_info.purchase_yes_active_font[3]
		rYes = motif.shop_info.purchase_yes_active_font[4]
		gYes = motif.shop_info.purchase_yes_active_font[5]
		bYes = motif.shop_info.purchase_yes_active_font[6]
		heightYes = motif.shop_info.purchase_yes_active_font[7]
		xYes = motif.shop_info.menu_pos[1] + motif.shop_info.purchase_yes_active_offset[1]
		yYes = motif.shop_info.menu_pos[2] + motif.shop_info.purchase_yes_active_offset[2]
		scaleXYes = motif.shop_info.purchase_yes_active_scale[1]
		scaleYYes = motif.shop_info.purchase_yes_active_scale[2]
	--No Inactive
		fontNo = motif.shop_info.purchase_no_font[1]
		bankNo = motif.shop_info.purchase_no_font[2]
		alignNo = motif.shop_info.purchase_no_font[3]
		rNo = motif.shop_info.purchase_no_font[4]
		gNo = motif.shop_info.purchase_no_font[5]
		bNo = motif.shop_info.purchase_no_font[6]
		heightNo = motif.shop_info.purchase_no_font[7]
		xNo = motif.shop_info.menu_pos[1] + motif.shop_info.purchase_no_offset[1]
		yNo = motif.shop_info.menu_pos[2] + motif.shop_info.purchase_no_offset[2]
		scaleXNo = motif.shop_info.purchase_no_scale[1]
		scaleYNo = motif.shop_info.purchase_no_scale[2]
	elseif purchaseCursor == 2 then
	--Yes Inactive
		fontYes = motif.shop_info.purchase_yes_font[1]
		bankYes = motif.shop_info.purchase_yes_font[2]
		alignYes = motif.shop_info.purchase_yes_font[3]
		rYes = motif.shop_info.purchase_yes_font[4]
		gYes = motif.shop_info.purchase_yes_font[5]
		bYes = motif.shop_info.purchase_yes_font[6]
		heightYes = motif.shop_info.purchase_yes_font[7]
		xYes = motif.shop_info.menu_pos[1] + motif.shop_info.purchase_yes_offset[1]
		yYes = motif.shop_info.menu_pos[2] + motif.shop_info.purchase_yes_offset[2]
		scaleXYes = motif.shop_info.purchase_yes_scale[1]
		scaleYYes = motif.shop_info.purchase_yes_scale[2]
	--No Active	
		fontNo = motif.shop_info.purchase_no_active_font[1]
		bankNo = motif.shop_info.purchase_no_active_font[2]
		alignNo = motif.shop_info.purchase_no_active_font[3]
		rNo = motif.shop_info.purchase_no_active_font[4]
		gNo = motif.shop_info.purchase_no_active_font[5]
		bNo = motif.shop_info.purchase_no_active_font[6]
		heightNo = motif.shop_info.purchase_no_active_font[7]
		xNo = motif.shop_info.menu_pos[1] + motif.shop_info.purchase_no_active_offset[1]
		yNo = motif.shop_info.menu_pos[2] + motif.shop_info.purchase_no_active_offset[2]
		scaleXNo = motif.shop_info.purchase_no_active_scale[1]
		scaleYNo = motif.shop_info.purchase_no_active_scale[2]
	end
--Actions
	if esc() or main.f_input(main.t_players, {'m'}) then
		sndPlay(motif.files.snd_data, motif.shop_info.cancel_snd[1], motif.shop_info.cancel_snd[2])
		f_confirmShopReset()
--Previous Item
	elseif commandGetState(main.t_cmd[main.playerInput], '$U') then
		if enoughMoney then
			sndPlay(motif.files.snd_data, motif.shop_info.cursor_move_snd[1], motif.shop_info.cursor_move_snd[2])
			purchaseCursor = purchaseCursor - 1
		end
--Next Item
	elseif commandGetState(main.t_cmd[main.playerInput], '$D') then
		if enoughMoney then
			sndPlay(motif.files.snd_data, motif.shop_info.cursor_move_snd[1], motif.shop_info.cursor_move_snd[2])
			purchaseCursor = purchaseCursor + 1
		end
--Accept Button
	elseif main.f_input(main.t_players, {'pal', 's'}) then
	--YES
		if purchaseCursor == 1 then
		--Item Purchased (Save Data)
			sndPlay(motif.files.snd_data, motif.shop_info.cursor_purchase_snd[1], motif.shop_info.cursor_purchase_snd[2])
			stats.playerCurrency = stats.playerCurrency - t_shopMenu[shopCategoryNo][item].price
			stats.shopstock[t_shopMenu[shopCategoryNo].category][t_shopMenu[shopCategoryNo][item].id] = false --Item Sold out
			f_saveStats()
			f_unlockShop(false) --Check Shop Items Discovery/Unlocks
	--NO/ACCEPT
		elseif purchaseCursor == 2 then
			sndPlay(motif.files.snd_data, motif.shop_info.cancel_snd[1], motif.shop_info.cancel_snd[2])
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
	overlay_purchase:draw()
--Draw Purchase Screen BG
	main.f_animPosDraw(
		motif.shop_info.purchase_bg_data,
		motif.shop_info.menu_pos[1] + motif.shop_info.purchase_bg_offset[1],
		motif.shop_info.menu_pos[2] + motif.shop_info.purchase_bg_offset[2],
		motif.shop_info.purchase_bg_facing,
		false
	)
	animSetWindow(motif.shop_info.purchase_bg_data, motif.shop_info.purchase_bg_window[1], motif.shop_info.purchase_bg_window[2], motif.shop_info.purchase_bg_window[3], motif.shop_info.purchase_bg_window[4])
	if enoughMoney then
		cursorText = motif.shop_info.purchase_no_text
	--Draw Question Title
		txt_shopPurchaseQuestion:draw()
		txt_shopPurchaseQuestion:update({
			x = motif.shop_info.menu_pos[1] + motif.shop_info.purchase_question_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.purchase_question_offset[2]
		})
	--Draw Balance Text
	--Before Purchase
		txt_shopBalanceOld:draw()
		txt_shopBalanceOld:update({
			text = stats.playerCurrency..motif.shop_info.currency_text,
			x = motif.shop_info.menu_pos[1] + motif.shop_info.balance_old_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.balance_old_offset[2]
		})
	--After Purchase
		txt_shopBalanceNew:draw()
		txt_shopBalanceNew:update({
			text = stats.playerCurrency - t_shopMenu[shopCategoryNo][item].price..motif.shop_info.currency_text,
			x = motif.shop_info.menu_pos[1] + motif.shop_info.balance_new_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.balance_new_offset[2]
		})
	--Draw Balance Arrow Sprite
		main.f_animPosDraw(
			motif.shop_info.balance_arrow_data,
			motif.shop_info.menu_pos[1] + motif.shop_info.balance_arrow_offset[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.balance_arrow_offset[2],
			motif.shop_info.balance_arrow_facing,
			false
		)
		animSetWindow(motif.shop_info.balance_arrow_data, motif.shop_info.balance_arrow_window[1], motif.shop_info.balance_arrow_window[2], motif.shop_info.balance_arrow_window[3], motif.shop_info.balance_arrow_window[4])
	--Draw Purchase Options Text
	--Yes
		txt_shopPurchaseYes:draw()
		txt_shopPurchaseYes:update({
			font = fontYes,
			bank = bankYes,
			align = alignYes,
			x = xYes,
			y = yYes,
			scaleX = scaleXYes,
			scaleY = scaleYYes,
			r = rYes,
			g = gYes,
			b = bYes,
			height = heightYes
		})
	else
	--Draw Info Title
		main.f_textRender(
			txt_shopPurchaseInfo,
			motif.shop_info.purchase_info_text,
			1,
			motif.shop_info.menu_pos[1] + motif.shop_info.purchase_info_offset[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.purchase_info_offset[2],
			motif.shop_info.purchase_info_spacing[1],
			motif.shop_info.purchase_info_spacing[2],
			main.font_def[motif.shop_info.purchase_info_font[1]..motif.shop_info.purchase_info_font[7]],
			0,
			main.f_lineLength(
				motif.shop_info.menu_pos[1] + motif.shop_info.purchase_info_offset[1],
				motif.info.localcoord[1],
				motif.shop_info.purchase_info_font[3],
				motif.shop_info.purchase_info_window,
				'[wl]'
			)
		)
		cursorText = motif.shop_info.purchase_ok_text
	end
--No/Accept
	txt_shopPurchaseNo:draw()
	txt_shopPurchaseNo:update({
		font = fontNo,
		bank = bankNo,
		align = alignNo,
		text = cursorText,
		x = xNo,
		y = yNo,
		scaleX = scaleXNo,
		scaleY = scaleYNo,
		r = rNo,
		g = gNo,
		b = bNo,
		height = heightNo
	})
--Draw Cursor
	if motif.shop_info.purchase_boxcursor_visible == 1 then
		local src, dst = main.f_boxcursorAlpha(
			motif.shop_info.purchase_boxcursor_alpharange[1],
			motif.shop_info.purchase_boxcursor_alpharange[2],
			motif.shop_info.purchase_boxcursor_alpharange[3],
			motif.shop_info.purchase_boxcursor_alpharange[4],
			motif.shop_info.purchase_boxcursor_alpharange[5],
			motif.shop_info.purchase_boxcursor_alpharange[6]
		)
		rect_purchaseboxcursor:update({
			x1 =    motif.shop_info.menu_pos[1] + motif.shop_info.purchase_boxcursor_coords[1] + (purchaseCursor - 1) * motif.shop_info.purchase_boxcursor_spacing[1],
			y1 =    motif.shop_info.menu_pos[2] + motif.shop_info.purchase_boxcursor_coords[2] + (purchaseCursor - 1) * motif.shop_info.purchase_boxcursor_spacing[2],
			x2 =    motif.shop_info.purchase_boxcursor_coords[3] - motif.shop_info.purchase_boxcursor_coords[1] + 1,
			y2 =    motif.shop_info.purchase_boxcursor_coords[4] - motif.shop_info.purchase_boxcursor_coords[2] + 1,
			r =     motif.shop_info.purchase_boxcursor_col[1],
			g =     motif.shop_info.purchase_boxcursor_col[2],
			b =     motif.shop_info.purchase_boxcursor_col[3],
			src =   src,
			dst =   dst,
			defsc = motif.defaultShop,
		})
		rect_purchaseboxcursor:draw()
--Draw Custom Cursor if purchase_boxcursor_visible is 0
	else
		main.f_animPosDraw(
			motif.shop_info.purchase_cursor_data,
			motif.shop_info.menu_pos[1] + motif.shop_info.purchase_cursor_offset[1] + (purchaseCursor - 1) * motif.shop_info.purchase_cursor_spacing[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.purchase_cursor_offset[2] + (purchaseCursor - 1) * motif.shop_info.purchase_cursor_spacing[2],
			motif.shop_info.purchase_cursor_facing,
			false
		)
		animSetWindow(motif.shop_info.purchase_cursor_data, motif.shop_info.purchase_cursor_window[1], motif.shop_info.purchase_cursor_window[2], motif.shop_info.purchase_cursor_window[3], motif.shop_info.purchase_cursor_window[4])
	end
end

local function f_shopMenu()
	if motif.shop_info.reload_enabled == 1 then f_loadShop() end --Reload shop data (items.def & items.sff files) each time that shop menu is initialized
	if #t_shopMenu == 0 then return end --If there is not shop data, return to main menu
--If there is shop data, enter in shop menu
	f_unlockShop(false) --Check Shop Items Discovery/Unlocks
	main.f_bgReset(motif.shopbgdef.bg)
	main.f_fadeReset('fadein', motif.shop_info)
	main.close = false
	sndPlay(motif.files.snd_data, motif.shop_info.cursor_done_snd[1], motif.shop_info.cursor_done_snd[2])
	if motif.music.shop_bgm ~= '' then
		main.f_playBGM(false, motif.music.shop_bgm, motif.music.shop_bgm_loop, motif.music.shop_bgm_volume, motif.music.shop_bgm_loopstart, motif.music.shop_bgm_loopend)
	end
	local cursorPosY = 1
	local moveTxt = 0
	local item = 1
	f_confirmShopReset()
	shopCategoryNo = 1
	resetShopAnim = true
	local function f_resetCursor()
		resetShopAnim = true
		cursorPosY = 1
		moveTxt = 0
		item = 1
		if main.debugLog then main.f_printTable(t_shopMenu, "debug/t_shopMenu.txt") end
	end
	local enoughMoney = nil
	local inCategory = true --Start inside Category 1
	local nameTextData = nil
	local infoTextData = nil
	local infoPriceData = nil
	local categoryTitle = nil
	local currencyTextData = nil
	while true do
	--Clear Color
		if not skipClear then
			clearColor(motif.shopbgdef.bgclearcolor[1], motif.shopbgdef.bgclearcolor[2], motif.shopbgdef.bgclearcolor[3])
		end
	--Layerno = 0 backgrounds
		bgDraw(motif.shopbgdef.bg, falseBool)
	--Draw Item Preview BG
		main.f_animPosDraw(
			motif.shop_info.preview_bg_data,
			motif.shop_info.menu_pos[1] + motif.shop_info.preview_bg_offset[1],
			motif.shop_info.menu_pos[2] + motif.shop_info.preview_bg_offset[2],
			motif.shop_info.preview_bg_facing,
			false
		)
		animSetWindow(motif.shop_info.preview_bg_data, motif.shop_info.preview_bg_window[1], motif.shop_info.preview_bg_window[2], motif.shop_info.preview_bg_window[3], motif.shop_info.preview_bg_window[4])
	--Draw Menu Box
		if motif.shop_info.menu_boxbg_visible == 1 then
			rect_boxbg:update({
				x1 =    motif.shop_info.menu_pos[1] + motif.shop_info.menu_boxcursor_coords[1],
				y1 =    motif.shop_info.menu_pos[2] + motif.shop_info.menu_boxcursor_coords[2],
				x2 =    motif.shop_info.menu_boxcursor_coords[3] - motif.shop_info.menu_boxcursor_coords[1] + 1,
				y2 =    motif.shop_info.menu_boxcursor_coords[4] - motif.shop_info.menu_boxcursor_coords[2] + 1 + (math.min(#t_shopMenu[shopCategoryNo], motif.shop_info.menu_window_visibleitems) - 1) * motif.shop_info.menu_item_spacing[2],
				r =     motif.shop_info.menu_boxbg_col[1],
				g =     motif.shop_info.menu_boxbg_col[2],
				b =     motif.shop_info.menu_boxbg_col[3],
				src =   motif.shop_info.menu_boxbg_alpha[1],
				dst =   motif.shop_info.menu_boxbg_alpha[2],
				defsc = motif.defaultShop,
			})
			rect_boxbg:draw()
		end
	--Draw Menu Title Text
		txt_shopTitle:draw()
		txt_shopTitle:update({
			x = motif.shop_info.menu_pos[1] + motif.shop_info.title_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.title_offset[2]
		})
	--Draw Category Title Text
		txt_shopCategory:draw()
		txt_shopCategory:update({
			text = categoryTitle,
			x = motif.shop_info.menu_pos[1] + motif.shop_info.category_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.category_offset[2]
		})
	--Draw Currency Text
		currencyTextData = stats.playerCurrency..motif.shop_info.currency_text
		txt_shopCurrency:draw()
		txt_shopCurrency:update({
			text = currencyTextData,
			x = motif.shop_info.menu_pos[1] + motif.shop_info.currency_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.currency_offset[2]
		})
	--Draw Menu Items
		local items_shown = item + motif.shop_info.menu_window_visibleitems - cursorPosY
		if items_shown > #t_shopMenu[shopCategoryNo] or (motif.shop_info.menu_window_visibleitems > 0 and items_shown < #t_shopMenu[shopCategoryNo] and (motif.shop_info.menu_window_margins_y[1] ~= 0 or motif.shop_info.menu_window_margins_y[2] ~= 0)) then
			items_shown = #t_shopMenu[shopCategoryNo]
		end
		for i = 1, items_shown do
			if not inCategory then
				nameTextData = t_shopMenu[i].category
			else
			--If the item has been Discovered
				if main.t_unlockLua.shop[t_shopMenu[shopCategoryNo][i].id] == nil then
					nameTextData = t_shopMenu[shopCategoryNo][i].itemname
			--Item not Discovered
				else
					nameTextData = motif.shop_info.info_text_unknown
				end
			end
			if i > item - cursorPosY then
				if i == item then
				--Draw active item background
					if t_shopMenu[shopCategoryNo][i].paramname ~= nil then
						animDraw(motif.shop_info[t_shopMenu[shopCategoryNo][i].paramname:gsub('menu_itemname_', 'menu_bg_active_') .. '_data'])
						animUpdate(motif.shop_info[t_shopMenu[shopCategoryNo][i].paramname:gsub('menu_itemname_', 'menu_bg_active_') .. '_data'])
					end
				--Draw active item font
					if t_shopMenu[shopCategoryNo][i].selected then
						t_shopMenu[shopCategoryNo][i].data:update({
							font =   motif.shop_info.menu_item_selected_active_font[1],
							bank =   motif.shop_info.menu_item_selected_active_font[2],
							align =  motif.shop_info.menu_item_selected_active_font[3],
							text =   nameTextData,
							x =      motif.shop_info.menu_pos[1] + motif.shop_info.menu_item_offset[1] + (i - 1) * motif.shop_info.menu_item_spacing[1],
							y =      motif.shop_info.menu_pos[2] + motif.shop_info.menu_item_offset[2] + (i - 1) * motif.shop_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.shop_info.menu_item_selected_active_scale[1],
							scaleY = motif.shop_info.menu_item_selected_active_scale[2],
							r =      motif.shop_info.menu_item_selected_active_font[4],
							g =      motif.shop_info.menu_item_selected_active_font[5],
							b =      motif.shop_info.menu_item_selected_active_font[6],
							height = motif.shop_info.menu_item_selected_active_font[7],
							defsc =  motif.defaultShop,
						})
						t_shopMenu[shopCategoryNo][i].data:draw()
					else
						t_shopMenu[shopCategoryNo][i].data:update({
							font =   motif.shop_info.menu_item_active_font[1],
							bank =   motif.shop_info.menu_item_active_font[2],
							align =  motif.shop_info.menu_item_active_font[3],
							text =   nameTextData,
							x =      motif.shop_info.menu_pos[1] + motif.shop_info.menu_item_active_offset[1] + (i - 1) * motif.shop_info.menu_item_spacing[1],
							y =      motif.shop_info.menu_pos[2] + motif.shop_info.menu_item_active_offset[2] + (i - 1) * motif.shop_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.shop_info.menu_item_active_scale[1],
							scaleY = motif.shop_info.menu_item_active_scale[2],
							r =      motif.shop_info.menu_item_active_font[4],
							g =      motif.shop_info.menu_item_active_font[5],
							b =      motif.shop_info.menu_item_active_font[6],
							height = motif.shop_info.menu_item_active_font[7],
							defsc =  motif.defaultShop,
						})
						t_shopMenu[shopCategoryNo][i].data:draw()
					end
				else
				--Draw not active item background
					if t_shopMenu[shopCategoryNo][i].paramname ~= nil then
						animDraw(motif.shop_info[t_shopMenu[shopCategoryNo][i].paramname:gsub('menu_itemname_', 'menu_bg_') .. '_data'])
						animUpdate(motif.shop_info[t_shopMenu[shopCategoryNo][i].paramname:gsub('menu_itemname_', 'menu_bg_') .. '_data'])
					end
				--Draw not active item font
					if t_shopMenu[shopCategoryNo][i].selected then
						t_shopMenu[shopCategoryNo][i].data:update({
							font =   motif.shop_info.menu_item_selected_font[1],
							bank =   motif.shop_info.menu_item_selected_font[2],
							align =  motif.shop_info.menu_item_selected_font[3],
							text =   nameTextData,
							x =      motif.shop_info.menu_pos[1] + motif.shop_info.menu_item_selected_offset[1] + (i - 1) * motif.shop_info.menu_item_spacing[1],
							y =      motif.shop_info.menu_pos[2] + motif.shop_info.menu_item_selected_offset[2] + (i - 1) * motif.shop_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.shop_info.menu_item_selected_scale[1],
							scaleY = motif.shop_info.menu_item_selected_scale[2],
							r =      motif.shop_info.menu_item_selected_font[4],
							g =      motif.shop_info.menu_item_selected_font[5],
							b =      motif.shop_info.menu_item_selected_font[6],
							height = motif.shop_info.menu_item_selected_font[7],
							defsc =  motif.defaultShop,
						})
						t_shopMenu[shopCategoryNo][i].data:draw()
					else
						t_shopMenu[shopCategoryNo][i].data:update({
							font =   motif.shop_info.menu_item_font[1],
							bank =   motif.shop_info.menu_item_font[2],
							align =  motif.shop_info.menu_item_font[3],
							text =   nameTextData,
							x =      motif.shop_info.menu_pos[1] + motif.shop_info.menu_item_offset[1] + (i - 1) * motif.shop_info.menu_item_spacing[1],
							y =      motif.shop_info.menu_pos[2] + motif.shop_info.menu_item_offset[2] + (i - 1) * motif.shop_info.menu_item_spacing[2] - moveTxt,
							scaleX = motif.shop_info.menu_item_scale[1],
							scaleY = motif.shop_info.menu_item_scale[2],
							r =      motif.shop_info.menu_item_font[4],
							g =      motif.shop_info.menu_item_font[5],
							b =      motif.shop_info.menu_item_font[6],
							height = motif.shop_info.menu_item_font[7],
							defsc =  motif.defaultShop,
						})
						t_shopMenu[shopCategoryNo][i].data:draw()
					end
				end
			end
		end
	--Draw menu cursor
		if motif.shop_info.menu_boxcursor_visible == 1 and not confirmPurchase and not main.fadeActive then
			local src, dst = main.f_boxcursorAlpha(
				motif.shop_info.menu_boxcursor_alpharange[1],
				motif.shop_info.menu_boxcursor_alpharange[2],
				motif.shop_info.menu_boxcursor_alpharange[3],
				motif.shop_info.menu_boxcursor_alpharange[4],
				motif.shop_info.menu_boxcursor_alpharange[5],
				motif.shop_info.menu_boxcursor_alpharange[6]
			)
			rect_boxcursor:update({
				x1 =    motif.shop_info.menu_pos[1] + motif.shop_info.menu_boxcursor_coords[1] + (cursorPosY - 1) * motif.shop_info.menu_item_spacing[1],
				y1 =    motif.shop_info.menu_pos[2] + motif.shop_info.menu_boxcursor_coords[2] + (cursorPosY - 1) * motif.shop_info.menu_item_spacing[2],
				x2 =    motif.shop_info.menu_boxcursor_coords[3] - motif.shop_info.menu_boxcursor_coords[1] + 1,
				y2 =    motif.shop_info.menu_boxcursor_coords[4] - motif.shop_info.menu_boxcursor_coords[2] + 1,
				r =     motif.shop_info.menu_boxcursor_col[1],
				g =     motif.shop_info.menu_boxcursor_col[2],
				b =     motif.shop_info.menu_boxcursor_col[3],
				src =   src,
				dst =   dst,
				defsc = motif.defaultShop,
			})
			rect_boxcursor:draw()
		end
	--Draw Scroll Arrows
		if #t_shopMenu[shopCategoryNo] > motif.shop_info.menu_window_visibleitems then
			if item > cursorPosY then
				animUpdate(motif.shop_info.menu_arrow_up_data)
				animDraw(motif.shop_info.menu_arrow_up_data)
			end
			if item >= cursorPosY and item + motif.shop_info.menu_window_visibleitems - cursorPosY < #t_shopMenu[shopCategoryNo] then
				animUpdate(motif.shop_info.menu_arrow_down_data)
				animDraw(motif.shop_info.menu_arrow_down_data)
			end
		end
	--Draw Items Stuff
		if inCategory and main.t_unlockLua.shop[t_shopMenu[shopCategoryNo][item].id] == nil then --If are inside a category and the item has been Discovered
			f_drawShopItemPreview(t_shopMenu[shopCategoryNo].category:lower(), item)
		--Draw Shop Item Price Info
			if stats.shopstock[t_shopMenu[shopCategoryNo].category][t_shopMenu[shopCategoryNo][item].id] then
				infoPriceData = t_shopMenu[shopCategoryNo][item].price..motif.shop_info.currency_text
			else
				infoPriceData = motif.shop_info.price_text_sold
			end
			txt_shopPriceInfo:draw()
			txt_shopPriceInfo:update({
				text = infoPriceData,
				x = motif.shop_info.menu_pos[1] + motif.shop_info.price_offset[1],
				y = motif.shop_info.menu_pos[2] + motif.shop_info.price_offset[2]
			})
		end
	--Draw Shop Item Info
		txt_shopItemInfo:draw()
		txt_shopItemInfo:update({
			text = infoTextData,
			x = motif.shop_info.menu_pos[1] + motif.shop_info.info_offset[1],
			y = motif.shop_info.menu_pos[2] + motif.shop_info.info_offset[2]
		})
	--Attract Credits/Coins
		if motif.attract_mode.enabled == 1 and main.credits ~= -1 then
			txt_attract_credits:update({text = main.f_extractText(motif.attract_mode.credits_text, main.credits)[1]})
			txt_attract_credits:draw()
		end
	--Layerno = 1 backgrounds
		bgDraw(motif.shopbgdef.bg, trueBool)
	--Fadein/Fadeout
		main.f_fadeAnim(motif.shop_info)
--;---------------------------------------------------------------------------------------------------------------------
		if not confirmPurchase then
			if not main.fadeActive then
				if inCategory then
					cursorPosY, moveTxt, item = f_menuCommonCalc(t_shopMenu[shopCategoryNo], item, cursorPosY, moveTxt, 'shop_info', {'$U'}, {'$D'})
				--else
				--	cursorPosY, moveTxt, shopCategoryNo = f_menuCommonCalc(t_shopMenu, shopCategoryNo, cursorPosY, moveTxt, 'shop_info', {'$U'}, {'$D'})
				end
			end
		--Close Menu
			if main.close and not main.fadeActive then
				main.f_bgReset(motif.shopbgdef.bg)
				main.f_fadeReset('fadein', motif.shop_info)
				main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				main.close = false
				main.f_unlock(false) --Check Menu Unlocks
				stats.playerCurrencyOLD = stats.playerCurrency --Refresh player currency backup to do calculations
				break
			elseif (esc() or main.f_input(main.t_players, {'m'})) and not main.close then
				sndPlay(motif.files.snd_data, motif.shop_info.cancel_snd[1], motif.shop_info.cancel_snd[2])
			--Back to Category Select
				--if inCategory then
				--	f_resetCursor()
				--	inCategory = false
			--Exit to Main Menu
				--else
					main.f_fadeReset('fadeout', motif.shop_info)
					main.close = true
				--end
		--Previous Category
			elseif commandGetState(main.t_cmd[main.playerInput], 'd') and inCategory and not main.fadeActive then
				sndPlay(motif.files.snd_data, motif.shop_info.cursor_category_snd[1], motif.shop_info.cursor_category_snd[2])
				f_resetCursor()
				shopCategoryNo = shopCategoryNo - 1
		--Next Category
			elseif commandGetState(main.t_cmd[main.playerInput], 'w') and inCategory and not main.fadeActive then
				sndPlay(motif.files.snd_data, motif.shop_info.cursor_category_snd[1], motif.shop_info.cursor_category_snd[2])
				f_resetCursor()
				shopCategoryNo = shopCategoryNo + 1
		--Previous Item
			elseif commandGetState(main.t_cmd[main.playerInput], '$U') and not main.fadeActive then
				resetShopAnim = true
				if inCategory then
					--item = item - 1 --This is already managed by f_menuCommonCalc
				else
					shopCategoryNo = shopCategoryNo - 1
				end
		--Next Item
			elseif commandGetState(main.t_cmd[main.playerInput], '$D') and not main.fadeActive then
				resetShopAnim = true
				if inCategory then
					--item = item + 1 --This is already managed by f_menuCommonCalc
				else
					shopCategoryNo = shopCategoryNo + 1
				end
		--Enter Actions
			elseif main.f_input(main.t_players, {'pal', 's'}) and not main.fadeActive then
			--Outside a Category
				if not inCategory then
				--Open Category (Items Available)
					if #t_shopMenu[shopCategoryNo] ~= 0 then
						sndPlay(motif.files.snd_data, motif.shop_info.cursor_done_snd[1], motif.shop_info.cursor_done_snd[2])
						f_resetCursor()
						inCategory = true
				--Can't Open Category (No Items Available)
					else
						sndPlay(motif.files.snd_data, motif.shop_info.cursor_error_snd[1], motif.shop_info.cursor_error_snd[2])
					end
			--Inside a Category
				else
				--Purchase item
					if stats.shopstock[t_shopMenu[shopCategoryNo].category][t_shopMenu[shopCategoryNo][item].id] and main.t_unlockLua.shop[t_shopMenu[shopCategoryNo][item].id] == nil then
						sndPlay(motif.files.snd_data, motif.shop_info.cursor_done_snd[1], motif.shop_info.cursor_done_snd[2])
						if stats.playerCurrency >= t_shopMenu[shopCategoryNo][item].price then
							enoughMoney = true
						else --No enough Money
							enoughMoney = false
						end
						confirmPurchase = true --Show Confirm Purchase
				--Item Sold Out or Item has not been discovered
					else
						sndPlay(motif.files.snd_data, motif.shop_info.cursor_error_snd[1], motif.shop_info.cursor_error_snd[2])
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
			categoryTitle = motif.shop_info.category_text
			infoTextData = t_shopMenu[shopCategoryNo].info
	--Show Item Data
		else
			categoryTitle = t_shopMenu[shopCategoryNo].category
			if main.t_unlockLua.shop[t_shopMenu[shopCategoryNo][item].id] == nil then --If the item has been Discovered
				infoTextData = t_shopMenu[shopCategoryNo][item].info
			else
				infoTextData = motif.shop_info.info_text_locked
			end
		end
		if not confirmPurchase then main.f_cmdInput() end --To avoid issues with inputs in f_confirmPurchase()
		main.f_refresh()
	end
end
--;===========================================================================================
--; 							  REWARD MESSAGE LOGIC
--;===========================================================================================
local txt_reward = main.f_createTextImg(motif.reward_info, 'reward', {defsc = motif.defaultShop})
local txt_rewardAccept = main.f_createTextImg(motif.reward_info, 'accept', {defsc = motif.defaultShop})

local function f_rewardScreen()
	if stats.playerCurrency == stats.playerCurrencyOLD or stats.playerCurrencyOLD == -1 then return end --Skip this screen
	local rewardTextData = (stats.playerCurrency - stats.playerCurrencyOLD)..motif.reward_info.reward_text
	local done = false
	stats.playerCurrencyOLD = -1 --Reset Var
	f_saveStats()
	main.f_bgReset(motif.rewardbgdef.bg)
	main.f_fadeReset('fadein', motif.reward_info)
	sndPlay(motif.files.snd_data, motif.reward_info.reward_snd[1], motif.reward_info.reward_snd[2]) --Play Reward SFX
	--if motif.music.reward_bgm ~= '' then
		main.f_playBGM(false, "", 0, 100, 0, 0)
	--end
	while true do
	--Clear Color
		if not skipClear then
			clearColor(motif.rewardbgdef.bgclearcolor[1], motif.rewardbgdef.bgclearcolor[2], motif.rewardbgdef.bgclearcolor[3])
		end
	--Layerno = 0 backgrounds
		bgDraw(motif.rewardbgdef.bg, falseBool)
	--Draw Reward Text
		txt_reward:draw()
		txt_reward:update({
			text = rewardTextData,
			x = motif.reward_info.menu_pos[1] + motif.reward_info.reward_offset[1],
			y = motif.reward_info.menu_pos[2] + motif.reward_info.reward_offset[2]
		})
	--Draw Accept Text
		txt_rewardAccept:draw()
		txt_rewardAccept:update({
			x = motif.reward_info.menu_pos[1] + motif.reward_info.accept_offset[1],
			y = motif.reward_info.menu_pos[2] + motif.reward_info.accept_offset[2]
		})
	--Attract Credits/Coins
		if motif.attract_mode.enabled == 1 and main.credits ~= -1 then
			txt_attract_credits:update({text = main.f_extractText(motif.attract_mode.credits_text, main.credits)[1]})
			txt_attract_credits:draw()
		end
	--Layerno = 1 backgrounds
		bgDraw(motif.rewardbgdef.bg, trueBool)
	--Fadein/Fadeout
		main.f_fadeAnim(motif.reward_info)
	--Close Menu
		if done and not main.fadeActive then
			main.f_bgReset(motif.rewardbgdef.bg)
			main.f_fadeReset('fadein', motif.reward_info)
			main.f_unlock(false) --Check Menu Unlocks
			break
		elseif main.f_input(main.t_players, {'pal', 's', 'm'}) and not main.fadeActive then
			sndPlay(motif.files.snd_data, motif.reward_info.accept_snd[1], motif.reward_info.accept_snd[2])
			main.f_fadeReset('fadeout', motif.reward_info)
			done = true
		end
		main.f_cmdInput()
		main.f_refresh()
	end
end
--;===========================================================
--; MODES LOOP
--;===========================================================
function start.f_selectMode()
	start.f_selectReset(true)
	while true do
		--select screen
		if not start.f_selectScreen() then
			f_rewardScreen() --Display Currency Reward Screen before back to main menu
			sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
			main.f_bgReset(motif[main.background].bg)
			main.f_fadeReset('fadein', motif[main.group])
			main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
			return
		end
		--first match
		if start.reset then
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
		if main.makeRoster and start.t_roster[matchno()] ~= nil and start.t_roster[matchno()][1] == -1 then
			table.remove(start.t_roster, matchno())
			start.t_roster = start.f_makeRoster(start.t_roster)
			if main.aiRamp then
				start.f_aiRamp(matchno())
			end
		--otherwise
		else
			if matchno() == -1 then --no more matches left
				--hiscore and stats data
				local cleared, place = start.f_storeStats()
				if main.hiscoreScreen and main.t_hiscoreData[gamemode()] ~= nil and motif.hiscore_info.enabled == 1 and place > 0 then
					start.hiscoreInit = false
					while start.f_hiscore(main.t_hiscoreData[gamemode()], true, place) do
						main.f_refresh()
					end
				end
				f_saveStats()
				--credits
				if cleared and main.storyboard.credits and motif.end_credits.enabled == 1 and main.f_fileExists(motif.end_credits.storyboard) then
					storyboard.f_storyboard(motif.end_credits.storyboard)
				end
				--game over
				if main.storyboard.gameover and motif.game_over_screen.enabled == 1 and main.f_fileExists(motif.game_over_screen.storyboard) then
					if cleared or not main.continueScreen or (not continue() and motif.continue_screen.gameover_enabled == 1) then
						storyboard.f_storyboard(motif.game_over_screen.storyboard)
					end
				end
				--exit to main menu
				if main.exitSelect then
					if motif.files.intro_storyboard ~= '' and motif.attract_mode.enabled == 0 then
						storyboard.f_storyboard(motif.files.intro_storyboard)
					end
				end
				start.exit = start.exit or main.exitSelect or not main.selectMenu[1]
			end
			if start.exit then
				f_rewardScreen() --Display Currency Reward Screen before back to main menu
				main.f_bgReset(motif[main.background].bg)
				main.f_fadeReset('fadein', motif[main.group])
				main.f_playBGM(false, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				start.exit = false
				return
			end
			if not continue() or esc() then
				start.f_selectReset(false)
			else
				t_reservedChars = {{}, {}}
			end
		end
	end
end
if main.debugLog then main.f_printTable(motif, "debug/t_motif.txt") end
main.t_itemname.shop = function()
	return f_shopMenu()
end