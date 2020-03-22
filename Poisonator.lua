Poisonator = {}

local frameSize = 40;
local updateInterval = 1.0;
local updateLast = 0;

local mainHandexpireTime = 0;
local offHandexpireTime = 0;

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameStrata("BACKGROUND")
frame:SetWidth(frameSize)
frame:SetHeight(frameSize)
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")

frame:SetScript("OnUpdate", function(self, elapsed)
  updateLast = updateLast + elapsed; 	

  while (updateLast > updateInterval) do
	Poisonator:Init()

    updateLast = updateLast - updateInterval;
  end
end)

frame:SetScript("OnEvent", function(self, event, ...)
	Poisonator:Init()
end)

-- Background Frames

local frameHandMain = CreateFrame("Frame", nil, UIParent)
frameHandMain:SetFrameStrata("BACKGROUND")
frameHandMain:SetWidth(frameSize)
frameHandMain:SetHeight(frameSize)

local frameHandSecondary = CreateFrame("Frame", nil, UIParent)
frameHandSecondary:SetFrameStrata("BACKGROUND")
frameHandSecondary:SetWidth(frameSize)
frameHandSecondary:SetHeight(frameSize)

-- Icon Frames

local frameHandMainIcon = CreateFrame("Frame", nil, UIParent)
frameHandMainIcon:SetFrameStrata("BACKGROUND")
frameHandMainIcon:SetWidth(frameSize)
frameHandMainIcon:SetHeight(frameSize)

local frameHandSecondaryIcon = CreateFrame("Frame", nil, UIParent)
frameHandSecondaryIcon:SetFrameStrata("BACKGROUND")
frameHandSecondaryIcon:SetWidth(frameSize)
frameHandSecondaryIcon:SetHeight(frameSize)

-- Label Charges

local frameHandMainCharges = CreateFrame("Frame", nil, UIParent)
frameHandMainCharges:SetWidth(frameSize)
frameHandMainCharges:SetHeight(frameSize)

local frameHandSecondaryCharges = CreateFrame("Frame", nil, UIParent)
frameHandSecondaryCharges:SetWidth(frameSize)
frameHandSecondaryCharges:SetHeight(frameSize)

-- Textures

local tex = frameHandMain:CreateTexture(nil, "BACKGROUND")
tex:SetTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand.blp")
tex:SetAllPoints(frameHandMain)
frameHandMain.texture = tex

local tex = frameHandSecondary:CreateTexture(nil, "BACKGROUND")
tex:SetTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand.blp")
tex:SetAllPoints(frameHandSecondary)
frameHandSecondary.texture = tex

local texMainIcon = frameHandMainIcon:CreateTexture(nil, "BACKGROUND")
texMainIcon:SetTexture("Interface\\Icons\\ABILITY_POISONS.blp")
texMainIcon:SetAllPoints(frameHandMainIcon)
frameHandMainIcon.texture = texMainIcon

local texSecondaryIcon = frameHandSecondaryIcon:CreateTexture(nil, "BACKGROUND")
texSecondaryIcon:SetTexture("Interface\\Icons\\ABILITY_POISONS.blp")
texSecondaryIcon:SetAllPoints(frameHandSecondaryIcon)
frameHandSecondaryIcon.texture = texSecondaryIcon

--

frameHandMain.text = frameHandMain:CreateFontString(nil, "ARTWORK") 
frameHandMain.text:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE")
frameHandMain.text:SetPoint("CENTER", 0, 4)
frameHandMain.text:SetText("0")

frameHandSecondary.text = frameHandSecondary:CreateFontString(nil, "ARTWORK") 
frameHandSecondary.text:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE")
frameHandSecondary.text:SetPoint("CENTER", 0, 4)
frameHandSecondary.text:SetText("0")

frameHandMainCharges.text = frameHandMain:CreateFontString(nil, "ARTWORK") 
frameHandMainCharges.text:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
frameHandMainCharges.text:SetPoint("CENTER", 0, -10)
frameHandMainCharges.text:SetText("16")

frameHandSecondaryCharges.text = frameHandSecondary:CreateFontString(nil, "ARTWORK") 
frameHandSecondaryCharges.text:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
frameHandSecondaryCharges.text:SetPoint("CENTER", 0, -10)
frameHandSecondaryCharges.text:SetText("32")

--

frameHandMain:SetPoint("TOP", -(frameSize / 2), 0)
frameHandMain:Show()

frameHandSecondary:SetPoint("TOP", (frameSize / 2), 0)
frameHandSecondary:Show()

frameHandMainIcon:SetPoint("TOP", -(frameSize / 2), 0)
frameHandMainIcon:Hide()

frameHandSecondaryIcon:SetPoint("TOP", (frameSize / 2), 0)
frameHandSecondaryIcon:Hide()

frameHandMainCharges:SetPoint("TOP", -(frameSize / 2), 0)
frameHandMainCharges:Show()

frameHandSecondaryCharges:SetPoint("TOP", (frameSize / 2), 0)
frameHandSecondaryCharges:Show()

--

function Poisonator:Init()
    hasMainHandEnchant,
    mainHandExpiration,
    mainHandCharges,
    mainHandEnchantID,
    hasOffHandEnchant,
    offHandExpiration,
    offHandCharges,
    offHandEnchantId = GetWeaponEnchantInfo()
	
    if hasMainHandEnchant then
		frameHandMainIcon:Show()
		
		mainHandexpireTime = math.floor(mainHandExpiration / 1000)
		
		local hours = math.floor(mainHandexpireTime / 3600)
		local minutes = math.floor(mainHandexpireTime / 60 - (hours * 60))
		local seconds = math.floor(mainHandexpireTime - hours * 3600 - minutes * 60)
		
		local timeLeft = string.format("%02d:%02d", minutes, seconds)
		
        frameHandMain.text:SetText(timeLeft)
		frameHandMainCharges.text:SetText(mainHandCharges)
	else
		frameHandMainIcon:Hide()
		frameHandMain.text:SetText("")
		frameHandMainCharges.text:SetText("")
	end
	
	if hasOffHandEnchant then
		frameHandSecondaryIcon:Show()
	
		offHandexpireTime = math.floor(offHandExpiration / 1000)
		
		local hours = math.floor(offHandexpireTime / 3600)
		local minutes = math.floor(offHandexpireTime / 60 - (hours * 60))
		local seconds = math.floor(offHandexpireTime - hours * 3600 - minutes * 60)
		
		local timeLeft = string.format("%02d:%02d", minutes, seconds)
		
        frameHandSecondary.text:SetText(timeLeft)
		frameHandSecondaryCharges.text:SetText(offHandCharges)
	else
		frameHandSecondaryIcon:Hide()
		frameHandSecondary.text:SetText("")
		frameHandSecondaryCharges.text:SetText("")
	end
end

function Poisonator:HideGryphons()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
end

Poisonator:Init()
