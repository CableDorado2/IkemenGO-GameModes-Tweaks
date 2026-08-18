--[[	   					       NETPLAY DIRECT JOIN MODULE
=======================================================================================================
Author: Cable Dorado 2 (CD2)
Tested on: I.K.E.M.E.N. GO Engine (v1.0.0-rc.3)
Description: Restores S-SIZE I.K.E.M.E.N. direct Netplay Join behavior, allowing Player 2 to
enter an IP address and connect immediately to Player 1 (Host).

This is an alternative to the default system.def "menu.itemname.menunetwork.serverjoin = JOIN GAME".
=======================================================================================================
]]

local function isValidIp(address)
	local a, b, c, d = address:match('^(%d+)%.(%d+)%.(%d+)%.(%d+)$')
	if a ~= nil then
		a, b, c, d = tonumber(a), tonumber(b), tonumber(c), tonumber(d)
		return a <= 255 and b <= 255 and c <= 255 and d <= 255
	end
	if address:match('^[0-9A-Fa-f:]+$') and not address:match(':::') then
		local _, dbl = address:gsub('::', '')
		if dbl <= 1 then
			local parts, bad = 0, false
			for h in address:gmatch('[^:]+') do
				parts = parts + 1
				if #h > 4 then bad = true break end
			end
			return not bad and ((dbl == 1 and parts < 8) or (dbl == 0 and parts == 8))
		end
	end
	return false
end

local function enterSyncedNetplayMenu()
	main.f_clearShuffleTables()
	main.f_menuSnap(motif[main.group])
	main.f_menuItemBgAnimReset(motif[main.group])
	fadeInInit(motif[main.group].fadein.FadeData)
	main.menu.submenu.server.loop()
end

local function showSessionWarning()
	local text = getSessionWarning()
	if text == nil or text == '' then
		return false
	end
	main.f_warning(text, motif[main.group], motif[main.background])
	return true
end

main.t_itemname.directjoin = function(t, item)
	sndPlay(motif.Snd, motif[main.group].cursor.done.snd.default[1], motif[main.group].cursor.done.snd.default[2])
--Insert IP Address Screen
	local address = main.f_drawInput(
		motif[main.group].textinput.TextSpriteData,
		motif[main.group].textinput.text.address,
		motif[main.group],
		motif[main.background],
		motif[main.group].textinput.overlay.RectData
	)
	if isValidIp(address) then
	--SERVER CONNECT
		main.f_waitForPreloads(true)
		local doneSnd = motif[main.group].cursor.done.snd.serverconnect or motif[main.group].cursor.done.snd.default
		sndPlay(motif.Snd, doneSnd[1], doneSnd[2])
		hook.run("main.t_itemname", t, item)
		if main.f_connect(address, "Player 1") then
			if synchronize() then
				enterSyncedNetplayMenu()
			end
			replayStop()
			exitNetPlay()
			exitReplay()
			showSessionWarning()
		end
	else
		sndPlay(motif.Snd, motif[main.group].cancel.snd[1], motif[main.group].cancel.snd[2])
	end
	return nil
end