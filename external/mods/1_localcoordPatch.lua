--[[	   					     LOCALCOORD PATCH MODULE
=======================================================================================================
Author: CD2
ONLY FOR: IKEMEN GO 2025-10-10 Nightly Build onwards
Description:
This external module ensures backward compatibility of localcoord values ​​by obtaining them from
the new motifLocalcoord() function, for use in the main.SP_Localcoord table in window modules paramvalues.
=======================================================================================================
]]
main.SP_Localcoord = {motifLocalcoord(0), motifLocalcoord(1)}
main.SP_Viewport43 = {motifViewport43(0), motifViewport43(1), motifViewport43(2), motifViewport43(3)}
if main.debugLog then
	main.f_printTable(main.SP_Localcoord, "debug/SP_Localcoord.txt")
	main.f_printTable(main.SP_Viewport43, "debug/SP_Viewport43.txt")
end