--[[
	Adds player's coordinates to the WorldMap and Minimap
]] --
local updater = CreateFrame("Frame", "AutoTurnIn_CoordOverlay_Updater", UIParent)

local coordOverlay = CreateFrame("Frame", "AutoTurnIn_CoordOverlay", UIParent)
coordOverlay:SetPoint("LEFT", WorldMapFrame.BorderFrame, "BOTTOMLEFT", 2, 10)
coordOverlay:SetSize(260, 16)
coordOverlay:SetFrameStrata("FULLSCREEN_DIALOG")

local coordMouse = coordOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
coordMouse:SetPoint("LEFT", coordOverlay, "LEFT", 0, 0)
coordMouse:SetJustifyH("LEFT")

local coordPlayer = coordOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
coordPlayer:SetPoint("RIGHT", coordOverlay, "RIGHT", 0, 0)
coordPlayer:SetJustifyH("RIGHT")

local coordMiniMap
if Minimap then
	coordMiniMap = Minimap:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	coordMiniMap:SetPoint("TOP", Minimap, "BOTTOM", 0, -5)
	coordMiniMap:SetJustifyH("CENTER")
end

local function GetMouseCoord()
	local adjustedX, adjustedY = WorldMapFrame:GetNormalizedCursorPosition()

	if adjustedX and adjustedY and adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
		adjustedX = adjustedX * 100
		adjustedY = adjustedY * 100
	else
		adjustedX = 0
		adjustedY = 0
	end

	return adjustedX, adjustedY
end

local elapsedSinceLast = 0
updater:SetScript("OnUpdate", function(_, elapsed)
	elapsedSinceLast = elapsedSinceLast + elapsed
	if elapsedSinceLast < 0.1 then
		return
	end
	elapsedSinceLast = 0

	if not AutoTurnIn.db or not AutoTurnIn.db.profile then
		return
	end

	if WorldMapFrame:IsShown() and AutoTurnIn.db.profile.map_coords then
		local mx, my = GetMouseCoord()
		coordMouse:SetText(string.format("cursor = %04.1f / %04.1f", mx, my))

		local map = C_Map.GetBestMapForUnit("player")
		if map then
			local pos = C_Map.GetPlayerMapPosition(map, "player")
			if pos then
				local px, py = pos:GetXY()
				coordPlayer:SetText(string.format("you = %04.1f / %04.1f", px * 100, py * 100))
			end
		end
	end

	if coordMiniMap and AutoTurnIn.db.profile.minimap_coords then
		local map = C_Map.GetBestMapForUnit("player")
		if map then
			local pos = C_Map.GetPlayerMapPosition(map, "player")
			if pos then
				local px, py = pos:GetXY()
				coordMiniMap:SetText(string.format("%04.1f / %04.1f", px * 100, py * 100))
			end
		end
	end
end)

function AutoTurnIn:SwitchMapCoords(flag)
	if flag then
		coordOverlay:Show()
		coordMouse:Show()
		coordPlayer:Show()
	else
		coordOverlay:Hide()
		coordMouse:Hide()
		coordPlayer:Hide()
	end
end

function AutoTurnIn:SwitchMiniMapCoords(flag)
	if not coordMiniMap then
		return
	end

	if flag then
		coordMiniMap:Show()
	else
		coordMiniMap:Hide()
	end
end
