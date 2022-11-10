--[[
* Adds a button "sell junk" to every merchant window.
* Pressing tat button playr are able to sell all grey-quality items from his backpacks
]]--
local _, ptable = ...
AutoTurnIn.SellJunk = {
	vendorAvailable		= false,
	amount 				= 0,
	count				= 0,
	total_template      = "Sold %s junk item(s) for %s"
}
local selljunk = AutoTurnIn.SellJunk
local _ = nil

local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem

-- Moves localized repair string to bottom a bit
MerchantRepairText:SetPoint("BOTTOMLEFT", 14, 35)
local SellButton = CreateFrame("Button", "MerchantFrameSellJunkButton", MerchantFrame, ptable.interface10 and "UIPanelButtonTemplate" or "OptionsButtonTemplate")
SellButton:SetPoint("TOPRIGHT",  -200, -32)
SellButton:SetText("Sell junk")
SellButton:SetWidth(75)
SellButton:SetScript("OnClick", function()
	selljunk.count = 0
	selljunk.amount= 0

	for container = 0, NUM_BAG_SLOTS do
		numSlots = GetContainerNumSlots(container)
		for slot = 1, numSlots do

			if (not selljunk.vendorAvailable and selljunk.amount > 0) then
				AutoTurnIn:Print(selljunk.total_template:format(selljunk.count, GetCoinTextureString(selljunk.amount)))
				return
			end

			local link = GetContainerItemLink(container, slot)

			if (link) then
				_, _, quality, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(link)
			end

			if (link and quality == Enum.ItemQuality.Poor) then
				local itemInfo, count = GetContainerItemInfo(container, slot)

				local stackCount = 0

				if (type(itemInfo) == 'table') then
					stackCount = itemInfo.stackCount
				else
					stackCount = count
				end

				selljunk.amount = selljunk.amount + (vendorPrice * count)
				selljunk.count = selljunk.count + 1
				UseContainerItem(container, slot)
			end
		end
	end

	if (selljunk.amount > 0) then
		AutoTurnIn:Print(selljunk.total_template:format(selljunk.count, GetCoinTextureString(selljunk.amount)))
	end
end)

-- [[ hooking MailFrame ]]--
hooksecurefunc(MerchantFrame, "Show", function()
	selljunk.vendorAvailable = true;
	if AutoTurnIn.db.profile.sell_junk == 2 then
		SellButton:Click()
	end
end)
hooksecurefunc(MerchantFrame, "Hide", function() selljunk.vendorAvailable = false; end)

function AutoTurnIn:SwitchSellJunk(flag)
	if flag == 3 then
		SellButton:Show()
	elseif flag == 1 then
		SellButton:Hide()
	end
end
