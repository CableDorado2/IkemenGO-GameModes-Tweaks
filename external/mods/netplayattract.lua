--[[	        ATTRACT NETPLAY ACCESS MODULE
======================================================================
Version: 1.0
Author: Cable Dorado 2 (CD2)
Tested on: IKEMEN GO v0.98.2, v0.99.0 and 2024-08-14 Nightly Build
Description:
Adds missing stuff to start netplay menu, when attract mode is enabled
=======================================================================
]]

--Based on motif.title_info table paramvalues, adds missing ones to motif.attract_mode table:
if motif.attract_mode.connecting_offset == nil then
motif.attract_mode.connecting_offset = {main.f_round(10 * main.SP_Localcoord[1] / 320), 165} --Ikemen feature
end

if motif.attract_mode.connecting_font == nil then
motif.attract_mode.connecting_font = {'f-6x9.def', 0, 1, 255, 255, 255, -1} --Ikemen feature
end

if motif.attract_mode.connecting_scale == nil then
motif.attract_mode.connecting_scale = {1.0, 1.0} --Ikemen feature
end

if motif.attract_mode.connecting_host_text == nil then
motif.attract_mode.connecting_host_text = 'Waiting for player 2... (%s)' --Ikemen feature
end

if motif.attract_mode.connecting_join_text == nil then
motif.attract_mode.connecting_join_text = 'Now connecting to %s... (%s)' --Ikemen feature
end

if motif.attract_mode.connecting_overlay_window == nil then
motif.attract_mode.connecting_overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]} --Ikemen feature
end

if motif.attract_mode.connecting_overlay_col == nil then
motif.attract_mode.connecting_overlay_col = {0, 0, 0} --Ikemen feature
end

if motif.attract_mode.connecting_overlay_alpha == nil then
motif.attract_mode.connecting_overlay_alpha = {0, 128} --Ikemen feature
end

if motif.attract_mode.textinput_offset == nil then
motif.attract_mode.textinput_offset = {25, 165} --Ikemen feature
end

if motif.attract_mode.textinput_font == nil then
motif.attract_mode.textinput_font = {'default-3x5.def', 0, 1, 191, 191, 191, -1} --Ikemen feature
end

if motif.attract_mode.textinput_scale == nil then
motif.attract_mode.textinput_scale = {1.0, 1.0} --Ikemen feature
end

if motif.attract_mode.textinput_name_text == nil then
motif.attract_mode.textinput_name_text = 'Enter Host display name, e.g. John.\nExisting entries can be removed with DELETE button.' --Ikemen feature
end

if motif.attract_mode.textinput_address_text == nil then
motif.attract_mode.textinput_address_text = 'Enter Host IP address, e.g. 127.0.0.1\nCopied text can be pasted with INSERT button.' --Ikemen feature
end

if motif.attract_mode.textinput_overlay_window == nil then
motif.attract_mode.textinput_overlay_window = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]} --Ikemen feature
end

if motif.attract_mode.textinput_overlay_col == nil then
motif.attract_mode.textinput_overlay_col = {0, 0, 0} --Ikemen feature
end

if motif.attract_mode.textinput_overlay_alpha == nil then
motif.attract_mode.textinput_overlay_alpha = {0, 128} --Ikemen feature
end