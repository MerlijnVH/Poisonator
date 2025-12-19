Poisonator = {}

-- Constants

local FRAME_SIZE = 40
local UPDATE_INTERVAL = 1.0
local TIMER_OFFSET_Y = 4
local CHARGES_OFFSET_Y = -10
local FONT_TIMER_SIZE = 10
local FONT_CHARGES_SIZE = 12

local updateLast = 0
local mainHandExpireTime = 0
local offHandExpireTime = 0

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameStrata("BACKGROUND")
frame:SetWidth(FRAME_SIZE)
frame:SetHeight(FRAME_SIZE)
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")

frame:SetScript("OnUpdate", function(self, elapsed)
	updateLast = updateLast + elapsed

	while updateLast > UPDATE_INTERVAL do
		Poisonator:Init()
		updateLast = updateLast - UPDATE_INTERVAL
	end
end)

frame:SetScript("OnEvent", function(self, event, ...)
	Poisonator:Init()
end)

-- Background Frames

local frameHandMain = CreateFrame("Frame", nil, UIParent)
frameHandMain:SetFrameStrata("BACKGROUND")
frameHandMain:SetWidth(FRAME_SIZE)
frameHandMain:SetHeight(FRAME_SIZE)

local frameHandSecondary = CreateFrame("Frame", nil, UIParent)
frameHandSecondary:SetFrameStrata("BACKGROUND")
frameHandSecondary:SetWidth(FRAME_SIZE)
frameHandSecondary:SetHeight(FRAME_SIZE)

-- Icon Frames

local frameHandMainIcon = CreateFrame("Frame", nil, UIParent)
frameHandMainIcon:SetFrameStrata("BACKGROUND")
frameHandMainIcon:SetWidth(FRAME_SIZE)
frameHandMainIcon:SetHeight(FRAME_SIZE)

local frameHandSecondaryIcon = CreateFrame("Frame", nil, UIParent)
frameHandSecondaryIcon:SetFrameStrata("BACKGROUND")
frameHandSecondaryIcon:SetWidth(FRAME_SIZE)
frameHandSecondaryIcon:SetHeight(FRAME_SIZE)

-- Label Charges

local frameHandMainCharges = CreateFrame("Frame", nil, UIParent)
frameHandMainCharges:SetWidth(FRAME_SIZE)
frameHandMainCharges:SetHeight(FRAME_SIZE)

local frameHandSecondaryCharges = CreateFrame("Frame", nil, UIParent)
frameHandSecondaryCharges:SetWidth(FRAME_SIZE)
frameHandSecondaryCharges:SetHeight(FRAME_SIZE)

-- Textures

local texMain = frameHandMain:CreateTexture(nil, "BACKGROUND")
texMain:SetTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand.blp")
texMain:SetAllPoints(frameHandMain)
frameHandMain.texture = texMain

local texSecondary = frameHandSecondary:CreateTexture(nil, "BACKGROUND")
texSecondary:SetTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand.blp")
texSecondary:SetAllPoints(frameHandSecondary)
frameHandSecondary.texture = texSecondary

local texMainIcon = frameHandMainIcon:CreateTexture(nil, "BACKGROUND")
texMainIcon:SetTexture("Interface\\Icons\\ABILITY_POISONS.blp")
texMainIcon:SetAllPoints(frameHandMainIcon)
frameHandMainIcon.texture = texMainIcon

local texSecondaryIcon = frameHandSecondaryIcon:CreateTexture(nil, "BACKGROUND")
texSecondaryIcon:SetTexture("Interface\\Icons\\ABILITY_POISONS.blp")
texSecondaryIcon:SetAllPoints(frameHandSecondaryIcon)
frameHandSecondaryIcon.texture = texSecondaryIcon

-- Font Strings

frameHandMain.text = frameHandMain:CreateFontString(nil, "ARTWORK")
frameHandMain.text:SetFont("Fonts\\ARIALN.ttf", FONT_TIMER_SIZE, "OUTLINE")
frameHandMain.text:SetPoint("CENTER", 0, TIMER_OFFSET_Y)
frameHandMain.text:SetText("")

frameHandSecondary.text = frameHandSecondary:CreateFontString(nil, "ARTWORK")
frameHandSecondary.text:SetFont("Fonts\\ARIALN.ttf", FONT_TIMER_SIZE, "OUTLINE")
frameHandSecondary.text:SetPoint("CENTER", 0, TIMER_OFFSET_Y)
frameHandSecondary.text:SetText("")

frameHandMainCharges.text = frameHandMain:CreateFontString(nil, "ARTWORK")
frameHandMainCharges.text:SetFont("Fonts\\ARIALN.ttf", FONT_CHARGES_SIZE, "OUTLINE")
frameHandMainCharges.text:SetPoint("CENTER", 0, CHARGES_OFFSET_Y)
frameHandMainCharges.text:SetText("")

frameHandSecondaryCharges.text = frameHandSecondary:CreateFontString(nil, "ARTWORK")
frameHandSecondaryCharges.text:SetFont("Fonts\\ARIALN.ttf", FONT_CHARGES_SIZE, "OUTLINE")
frameHandSecondaryCharges.text:SetPoint("CENTER", 0, CHARGES_OFFSET_Y)
frameHandSecondaryCharges.text:SetText("")

-- Frame Positioning

frameHandMain:SetPoint("TOP", -(FRAME_SIZE / 2), 0)
frameHandMain:Show()

frameHandSecondary:SetPoint("TOP", (FRAME_SIZE / 2), 0)
frameHandSecondary:Show()

frameHandMainIcon:SetPoint("TOP", -(FRAME_SIZE / 2), 0)
frameHandMainIcon:Hide()

frameHandSecondaryIcon:SetPoint("TOP", (FRAME_SIZE / 2), 0)
frameHandSecondaryIcon:Hide()

frameHandMainCharges:SetPoint("TOP", -(FRAME_SIZE / 2), 0)
frameHandMainCharges:Show()

frameHandSecondaryCharges:SetPoint("TOP", (FRAME_SIZE / 2), 0)
frameHandSecondaryCharges:Show()

-- Helper Functions

local function FormatTimeRemaining(expirationMs)
	local expireTimeSeconds = math.floor(expirationMs / 1000)
	local minutes = math.floor(expireTimeSeconds / 60)
	local seconds = expireTimeSeconds % 60
	return string.format("%02d:%02d", minutes, seconds)
end

local function UpdateWeaponDisplay(hasEnchant, expiration, charges, iconFrame, textFrame, chargesFrame)
	if hasEnchant then
		iconFrame:Show()
		textFrame:SetText(FormatTimeRemaining(expiration))
		chargesFrame:SetText(charges)
	else
		iconFrame:Hide()
		textFrame:SetText("")
		chargesFrame:SetText("")
	end
end

function Poisonator:Init()
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID,
	      hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()

	UpdateWeaponDisplay(hasMainHandEnchant, mainHandExpiration, mainHandCharges,
	                    frameHandMainIcon, frameHandMain.text, frameHandMainCharges.text)
	
	UpdateWeaponDisplay(hasOffHandEnchant, offHandExpiration, offHandCharges,
	                    frameHandSecondaryIcon, frameHandSecondary.text, frameHandSecondaryCharges.text)
end

Poisonator:Init()
