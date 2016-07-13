local PCDC = CreateFrame('Frame')
PCDC:SetScript('OnUpdate', function()
	this:UPDATE(arg1)
end)
PCDC:SetScript('OnEvent', function()
	this[event](this)
end)
PCDC:RegisterEvent('ADDON_LOADED')

PCDC_Position = {UIParent:GetWidth()/2, UIParent:GetHeight()/2}
PCDC_Orientation = 1

local R, D, L, U = 1, 2, 3, 4

function PCDC:Lock()
	PCDC_Button:Hide()
	for i=1,10 do
		getglobal('PCDC_Tex'..i):Hide()
	end
	PCDC_Locked = true
end

function PCDC:Unlock()
	PCDC_Button:Show()
	for i=1,10 do
		PCDC_ToolTips[i] = 'test'..i
		PCDC_ToolTipDetails[i] = 'test'..i
		getglobal('PCDC_Tex'..i):SetTexture([[Interface\Icons\temp]])
		getglobal('PCDC_Frame'..i):Show()
		getglobal('PCDC_Tex'..i):Show()
		getglobal('PCDC_CD'..i):Hide()
	end
	PCDC_Locked = false
end

function PCDC_ToggleStack()
	if PCDC_Orientation == U then
		PCDC_Tex1:ClearAllPoints() PCDC_Tex1:SetPoint('BOTTOM', 'PCDC_Frame', 'TOP', 0, -3)
		PCDC_Tex2:ClearAllPoints() PCDC_Tex2:SetPoint('BOTTOM', 'PCDC_Tex1', 'TOP', 0, 0)
		PCDC_Tex3:ClearAllPoints() PCDC_Tex3:SetPoint('BOTTOM', 'PCDC_Tex2', 'TOP', 0, 0)
		PCDC_Tex4:ClearAllPoints() PCDC_Tex4:SetPoint('BOTTOM', 'PCDC_Tex3', 'TOP', 0, 0)
		PCDC_Tex5:ClearAllPoints() PCDC_Tex5:SetPoint('BOTTOM', 'PCDC_Tex4', 'TOP', 0, 0)
		PCDC_Tex6:ClearAllPoints() PCDC_Tex6:SetPoint('BOTTOM', 'PCDC_Tex5', 'TOP', 0, 0)
		PCDC_Tex7:ClearAllPoints() PCDC_Tex7:SetPoint('BOTTOM', 'PCDC_Tex6', 'TOP', 0, 0)
		PCDC_Tex8:ClearAllPoints() PCDC_Tex8:SetPoint('BOTTOM', 'PCDC_Tex7', 'TOP', 0, 0)
		PCDC_Tex9:ClearAllPoints() PCDC_Tex9:SetPoint('BOTTOM', 'PCDC_Tex8', 'TOP', 0, 0)
		PCDC_Tex10:ClearAllPoints() PCDC_Tex10:SetPoint('BOTTOM', 'PCDC_Tex9', 'TOP', 0, 0)
	elseif PCDC_Orientation == D then
		PCDC_Tex1:ClearAllPoints() PCDC_Tex1:SetPoint('TOP', 'PCDC_Frame', 'BOTTOM', 0, 3)
		PCDC_Tex2:ClearAllPoints() PCDC_Tex2:SetPoint('TOP', 'PCDC_Tex1', 'BOTTOM', 0, 0)
		PCDC_Tex3:ClearAllPoints() PCDC_Tex3:SetPoint('TOP', 'PCDC_Tex2', 'BOTTOM', 0, 0)
		PCDC_Tex4:ClearAllPoints() PCDC_Tex4:SetPoint('TOP', 'PCDC_Tex3', 'BOTTOM', 0, 0)
		PCDC_Tex5:ClearAllPoints() PCDC_Tex5:SetPoint('TOP', 'PCDC_Tex4', 'BOTTOM', 0, 0)
		PCDC_Tex6:ClearAllPoints() PCDC_Tex6:SetPoint('TOP', 'PCDC_Tex5', 'BOTTOM', 0, 0)
		PCDC_Tex7:ClearAllPoints() PCDC_Tex7:SetPoint('TOP', 'PCDC_Tex6', 'BOTTOM', 0, 0)
		PCDC_Tex8:ClearAllPoints() PCDC_Tex8:SetPoint('TOP', 'PCDC_Tex7', 'BOTTOM', 0, 0)
		PCDC_Tex9:ClearAllPoints() PCDC_Tex9:SetPoint('TOP', 'PCDC_Tex8', 'BOTTOM', 0, 0)
		PCDC_Tex10:ClearAllPoints() PCDC_Tex10:SetPoint('TOP', 'PCDC_Tex9', 'BOTTOM', 0, 0)
	elseif PCDC_Orientation == L then
		PCDC_Tex1:ClearAllPoints() PCDC_Tex1:SetPoint('RIGHT', 'PCDC_Frame', 'LEFT', 0, 0)
		PCDC_Tex2:ClearAllPoints() PCDC_Tex2:SetPoint('RIGHT', 'PCDC_Tex1', 'LEFT', 0, 0)
		PCDC_Tex3:ClearAllPoints() PCDC_Tex3:SetPoint('RIGHT', 'PCDC_Tex2', 'LEFT', 0, 0)
		PCDC_Tex4:ClearAllPoints() PCDC_Tex4:SetPoint('RIGHT', 'PCDC_Tex3', 'LEFT', 0, 0)
		PCDC_Tex5:ClearAllPoints() PCDC_Tex5:SetPoint('RIGHT', 'PCDC_Tex4', 'LEFT', 0, 0)
		PCDC_Tex6:ClearAllPoints() PCDC_Tex6:SetPoint('RIGHT', 'PCDC_Tex5', 'LEFT', 0, 0)
		PCDC_Tex7:ClearAllPoints() PCDC_Tex7:SetPoint('RIGHT', 'PCDC_Tex6', 'LEFT', 0, 0)
		PCDC_Tex8:ClearAllPoints() PCDC_Tex8:SetPoint('RIGHT', 'PCDC_Tex7', 'LEFT', 0, 0)
		PCDC_Tex9:ClearAllPoints() PCDC_Tex9:SetPoint('RIGHT', 'PCDC_Tex8', 'LEFT', 0, 0)
		PCDC_Tex10:ClearAllPoints() PCDC_Tex10:SetPoint('RIGHT', 'PCDC_Tex9', 'LEFT', 0, 0)
	elseif PCDC_Orientation == R then
		PCDC_Tex1:ClearAllPoints() PCDC_Tex1:SetPoint('LEFT', 'PCDC_Frame', 'RIGHT', 0, 0)
		PCDC_Tex2:ClearAllPoints() PCDC_Tex2:SetPoint('LEFT', 'PCDC_Tex1', 'RIGHT', 0, 0)
		PCDC_Tex3:ClearAllPoints() PCDC_Tex3:SetPoint('LEFT', 'PCDC_Tex2', 'RIGHT', 0, 0)
		PCDC_Tex4:ClearAllPoints() PCDC_Tex4:SetPoint('LEFT', 'PCDC_Tex3', 'RIGHT', 0, 0)
		PCDC_Tex5:ClearAllPoints() PCDC_Tex5:SetPoint('LEFT', 'PCDC_Tex4', 'RIGHT', 0, 0)
		PCDC_Tex6:ClearAllPoints() PCDC_Tex6:SetPoint('LEFT', 'PCDC_Tex5', 'RIGHT', 0, 0)
		PCDC_Tex7:ClearAllPoints() PCDC_Tex7:SetPoint('LEFT', 'PCDC_Tex6', 'RIGHT', 0, 0)
		PCDC_Tex8:ClearAllPoints() PCDC_Tex8:SetPoint('LEFT', 'PCDC_Tex7', 'RIGHT', 0, 0)
		PCDC_Tex9:ClearAllPoints() PCDC_Tex9:SetPoint('LEFT', 'PCDC_Tex8', 'RIGHT', 0, 0)
		PCDC_Tex10:ClearAllPoints() PCDC_Tex10:SetPoint('LEFT', 'PCDC_Tex9', 'RIGHT', 0, 0)
	end
end

function PCDC_Click()
	if arg1 == 'LeftButton' then
		PCDC_Orientation = mod(PCDC_Orientation, 4) + 1
		PCDC_ToggleStack()
	elseif arg1 == 'RightButton' then
		PCDC:Lock()
	end
end

function PCDC_ToolTip(tooltipnum)
	GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
	GameTooltip:AddLine(PCDC_ToolTips[tooltipnum])
	GameTooltip:AddLine(PCDC_ToolTipDetails[tooltipnum], .8, .8, .8, 1)
	GameTooltip:Show()
end

function PCDC_OnDragStart()
	PCDC_Frame:StartMoving()
end

function PCDC_OnDragStop()
	PCDC_Frame:StopMovingOrSizing()
	PCDC_Position = { PCDC_Frame:GetLeft(), PCDC_Frame:GetBottom() }
end

SLASH_PCDC1 = '/pcdc'
function SlashCmdList.PCDC()
	if PCDC_Locked then
		PCDC:Unlock()
	else
		PCDC:Lock()
	end
end

function PCDC:ADDON_LOADED()
	if arg1 ~= 'PCDC' then
		return
	end

	PCDC_Frame:SetPoint('BOTTOMLEFT', unpack(PCDC_Position))

	PCDC_ToolTips = {}
	PCDC_ToolTipDetails = {}
	PCDC_UsedSkills = {}

	PCDC_Button:SetNormalTexture([[Interface\Buttons\UI-MicroButton-Abilities-Up.blp]])

	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('SPELL_UPDATE_COOLDOWN')

	PCDC_ToggleStack()
	if PCDC_Locked then
		PCDC:Lock()
	else
		PCDC:Unlock()
	end

	self:DetectCooldowns()
end

function PCDC:StartCooldown(name, texture, started, duration)
	for i, skill in PCDC_UsedSkills do
		if skill.skill == name then
			tremove(PCDC_UsedSkills, i)
			break
		end
	end
	table.insert(PCDC_UsedSkills, {skill = name, info = '', texture = strsub(texture, 17), countdown = duration, started = started})
end

function PCDC:DetectCooldowns()	
    for bag=0,4 do
        if GetBagName(bag) then
            for slot = 1, GetContainerNumSlots(bag) do
				local started, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = self:LinkName(GetContainerItemLink(bag, slot))
					if duration == 0 or duration > 3 and duration <= 1200 then
						self:StartCooldown(
							name,
							GetContainerItemInfo(bag, slot),
							started,
							duration
						)
					end
				end
            end
        end
    end
	
	for slot=0,19 do
		local started, duration, enabled = GetInventoryItemCooldown('player', slot)
		if enabled == 1 then
			local name = self:LinkName(GetInventoryItemLink('player', slot))
			if duration == 0 or duration > 3 and duration <= 1200 then
				self:StartCooldown(
					name,
					GetInventoryItemTexture('player', slot),
					started,
					duration
				)
			end
		end
	end
	
	local _, _, offset, spellCount = GetSpellTabInfo(GetNumSpellTabs())
	local totalSpells = offset + spellCount
	for id=1,totalSpells do
		local started, duration, enabled = GetSpellCooldown(id, BOOKTYPE_SPELL)
		local name = GetSpellName(id, BOOKTYPE_SPELL)
		if duration == 0 or enabled == 1 and duration > 2.5 then
			self:StartCooldown(
				name,
				GetSpellTexture(id, BOOKTYPE_SPELL),
				started,
				duration
			)
		end
	end
end

function PCDC:BAG_UPDATE_COOLDOWN()
	self:DetectCooldowns()
end

function PCDC:SPELL_UPDATE_COOLDOWN()
	self:DetectCooldowns()
end

function PCDC:UPDATE()
	if PCDC_Locked then
		local i = 1

		local temp = {}
		sort(PCDC_UsedSkills, function(a, b) local ta, tb = a.started + a.countdown - GetTime(), b.started + b.countdown - GetTime() return ta < tb or tb == ta and a.skill < b.skill end)
		for k, v in PCDC_UsedSkills do
			local timeleft = v.started + v.countdown - GetTime()

			if timeleft > 0 then
				tinsert(temp, v)

				if i <= 10 then
					if timeleft <= 5 then
						getglobal('PCDC_Tex'..i):SetAlpha(1 - (math.sin(GetTime() * 1.3 * math.pi) + 1) / 2 * .7)
					else
						getglobal('PCDC_Tex'..i):SetAlpha(1)
					end

					PCDC_ToolTips[i] = v.skill
					PCDC_ToolTipDetails[i] = v.info
					timeleft = ceil(timeleft)
					if timeleft >= 60 then
						timeleft = ceil((timeleft/60)*10)/10
						getglobal('PCDC_CD'..i):SetTextColor(0, 1, 0)
					else
						getglobal('PCDC_CD'..i):SetTextColor(1, 1, 0)
					end
					getglobal('PCDC_CD'..i):SetText(timeleft)
					getglobal('PCDC_Tex'..i):SetTexture([[Interface\Icons\]]..v.texture)
					getglobal('PCDC_Frame'..i):Show()
					getglobal('PCDC_CD'..i):Show()
					getglobal('PCDC_Tex'..i):Show()
					i = i + 1
				end
			end
		end
		PCDC_UsedSkills = temp

		while i <= 10 do
			getglobal('PCDC_Frame'..i):Hide()
			getglobal('PCDC_CD'..i):Hide()
			getglobal('PCDC_Tex'..i):Hide()
			i = i + 1
		end
	end
end

function PCDC:LinkName(link)
    local _, _, name = strfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h')
    return name
end