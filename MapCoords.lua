--[[ 	
	Adds player's coordinates to the map WorldMapFrameCloseButton
]]--
local coordMouse = WorldMapFrameCloseButton:CreateFontString(nil, "BORDER", "GameFontNormal")
coordMouse:SetPoint("TOPLEFT", WorldMapFrame.BorderFrame.Tutorial, "TOPRIGHT", -5, -25)
coordMouse:SetJustifyH("LEFT")
local coordPlayer = WorldMapFrameCloseButton:CreateFontString(nil, "BORDER", "GameFontNormal")
coordPlayer:SetPoint("TOPLEFT", WorldMapFrame.BorderFrame.Tutorial, "TOPRIGHT", 125, -25)
coordPlayer:SetJustifyH("LEFT")

local function GetMouseCoord()
	local scale = WorldMapFrame.BorderFrame:GetEffectiveScale()
	local width = WorldMapFrame.ScrollContainer:GetWidth()
	local height = WorldMapFrame.ScrollContainer:GetHeight()
	local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter()
	local x, y = GetCursorPosition()	
	local adjustedX = (x / scale - (centerX - width / 2)) / width
	local adjustedY = (centerY + (height/2) - y / scale) / height

	if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
		adjustedX = adjustedX * 100
		adjustedY = adjustedY * 100
	else 
		adjustedX = 0
		adjustedY = 0
	end

	return adjustedX, adjustedY
end

--[[ 
	I do not remember why I needed this. Let it be here for a while
--]]
local function roundCoords(varx, vary)
	varx = math.floor(varx * 1000 + 0.5)/10
	vary = math.floor(vary * 1000 + 0.5)/10
	return varx, vary
end

WorldMapFrame:HookScript("OnUpdate", function(self, button)	
	if  not AutoTurnIn.db.profile.map_coords then
		return
	end
	local mx, my = GetMouseCoord()
	coordMouse:SetText(string.format("mouse = %04.1f / %04.1f", mx, my))

	local map = C_Map.GetBestMapForUnit("player")
	if (map) then
		local pos = C_Map.GetPlayerMapPosition(map, "player")
		if (pos) then
			local px, py = pos:GetXY()	
			coordPlayer:SetText(string.format("you = %04.1f / %04.1f", px * 100, py * 100))
		end
	end
end)

function AutoTurnIn:SwitchMapCoords(flag)
	if flag then
		coordMouse:Show()
		coordPlayer:Show()
	else
		coordMouse:Hide()
		coordPlayer:Hide()
	end
end