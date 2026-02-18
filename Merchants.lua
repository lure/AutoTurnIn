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

				if (type(itemInfo) == 'table') then
					count = itemInfo.stackCount
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

-- [[ hooking Merchant Frame ]]--
hooksecurefunc(MerchantFrame, "Show", function()
	selljunk.vendorAvailable = true;
	if not InCombatLockdown() then
		if AutoTurnIn.db.profile.sell_junk == 2 then
			SellButton:Click()
		end
		if AutoTurnIn.db.profile.auto_repair and CanMerchantRepair() then
			AutoTurnIn:RepairEquipment()
		end
	else
		AutoTurnIn.defer.merchant.sell = AutoTurnIn.db.profile.sell_junk == 2
		AutoTurnIn.defer.merchant.repair = AutoTurnIn.db.profile.auto_repair and CanMerchantRepair()
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

function AutoTurnIn:HandleMerchantDeferred()
	if not MerchantFrame or not MerchantFrame:IsShown() or InCombatLockdown() then
		return
	end
	if self.defer.merchant.sell and self.db.profile.sell_junk == 2 then
		self.defer.merchant.sell = false
		SellButton:Click()
	end
	if self.defer.merchant.repair and self.db.profile.auto_repair and CanMerchantRepair() then
		self.defer.merchant.repair = false
		self:RepairEquipment()
	end
end

--[[ 
		AUTO REPAIR FUNCTIONALITY
]]--
function AutoTurnIn:RepairEquipment()
	local repairCost = GetRepairAllCost()
	if repairCost > 0 then

		-- Blizzard_GuildBankUI.lua: If M >= 0 then it's a regualar member, otherwise it is guildmaster
		-- there is a catch, sometimes the return is NaN. 
		local canUseGuildMoney = false
		local usedGuildMoney = false
		if CanGuildBankRepair() then
			local GUILD_WITHDRAW_UNLIMITED = 2^64
			local withdrawLimit = GetGuildBankWithdrawMoney() or 0
			local unlimited = withdrawLimit >= GUILD_WITHDRAW_UNLIMITED
			canUseGuildMoney = unlimited or withdrawLimit >= repairCost
		end

		if canUseGuildMoney then
			usedGuildMoney = true
			RepairAllItems(true)
			self:Print("Repaired for:", GetCoinTextureString(repairCost))
		elseif GetMoney() >= repairCost then
			RepairAllItems(false)
			self:Print("Repaired for:", GetCoinTextureString(repairCost))
		end
		if AutoTurnIn.db.profile.debug then
			AutoTurnIn:DebugPrint(usedGuildMoney and "Repair used guild funds" or "Repair used personal funds")
		end

		-- if (GetRepairAllCost() > 0 ) then
		-- 	AutoTurnIn:RepairEquipment()
		-- end
	end
end
