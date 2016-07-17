local CDC = CreateFrame('Frame')
CDC:SetScript('OnUpdate', function()
	this:UPDATE(arg1)
end)
CDC:SetScript('OnEvent', function()
	this[event](this)
end)
CDC:RegisterEvent('ADDON_LOADED')

CDC_Settings = nil

CDC_IgnoreList = "ignoredcd1,ignoredcd2,ignoredcd3"
CDC_ClickThrough = false

CDC_Position = {UIParent:GetWidth()/2, UIParent:GetHeight()/2}
CDC_Orientation = 'U'

function CDC:enum(...)
	for i=1,arg.n do
		self[arg[i]] = arg[i]
	end
end

function CDC.tokenize(str)
	local tokens = {}
	for token in string.gfind(str, '%S+') do
		tinsert(tokens, token)
	end
	return tokens
end

function CDC:ADDON_LOADED()
	if arg1 ~= 'CDC' then
		return
	end

	self:enum('R', 'D', 'L', 'U')
	self:enum('PLAYER', 'ENEMY')

	CDC_Settings = CDC_Settings or {
		position = {UIParent:GetWidth()/2, UIParent:GetHeight()/2},
		orientation = self.R,
		ignoreList = '',
		clickThrough = false,
	}

	for _, module in {self.PLAYER, self.ENEMY} do
		local frame = CreateFrame('Frame', nil, UIParent)
		frame:SetWidth(32)
		frame:SetHeight(32)
		frame:SetFrameStrata('HIGH')
		frame:SetMovable(true)
		frame:SetToplevel(true)

		frame.button = CreateFrame('Button', nil, frame)
		frame.button:SetWidth(32)
		frame.button:SetHeight(40)
		frame.button:SetPoint('CENTER', 0, 8)
		frame.button:RegisterForDrag('LeftButton')
		frame.button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame.button:SetScript('OnDragStart', self.OnDragStart)
		frame.button:SetScript('OnDragStop', self.OnDragStop)
		frame.button:SetScript('OnClick', self.OnClick)
		frame.button:SetScript('OnEnter', self.OnDragStop, function()
    		GameTooltip_SetDefaultAnchor(GameTooltip, this)
    		GameTooltip:AddLine('Player cooldowns')
			GameTooltip:AddLine('Left-click/drag to position', .8, .8, .8)
			GameTooltip:AddLine('Right-click to lock', .8, .8, .8)
    		GameTooltip:Show()
		end)
		frame.button:SetScript('OnLeave', function()
			GameTooltip:Hide()
		end)

		frame.CDs = {}
		for i=1,10 do
			tinsert(frame.CDs, CDC_CDFrame(frame, i))
		end

		self[module].frame = frame
	end

	self.frames = {PLAYER = {}, ENEMY = {}}
	for i=1,10 do
		for _, module in {self.PLAYER, self.ENEMY} do
			tinsert(self.frames[module], CDC_CDFrame(i))
		end
	end

	CDC_Frame:SetPoint('BOTTOMLEFT', unpack(CDC_Position))

	CDC_ToolTips = {}
	CDC_ToolTipDetails = {}
	CDC_UsedSkills = {}

	CDC_Button:SetNormalTexture([[Interface\Buttons\UI-MicroButton-Abilities-Up.blp]])

	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('SPELL_UPDATE_COOLDOWN')

	CDC:ToggleStack(self.PLAYER)
	if CDC_Locked then
		CDC:Lock(self.PLAYER)
	else
		CDC:Unlock(self.PLAYER)
	end

	for _, frame in self.frames.PLAYER do
		frame:EnableMouse(not CDC_ClickThrough)
	end

	self:DetectItemCooldowns()
	self:DetectSpellCooldowns()
end

function CDC:Lock(type)
	CDC_Button:Hide()
	for _, frame in self.frames[type] do
		frame:Hide()
	end
	CDC_Locked = true
end

function CDC:Unlock(type)
	CDC_Button:Show()
	for i, frame in self.frames[type] do
		CDC_ToolTips[i] = 'test'..i
		CDC_ToolTipDetails[i] = 'test'..i
		frame.texture:SetTexture([[Interface\Icons\temp]])
		frame.count:SetText()
		frame:Show()
	end
	CDC_Locked = false
end

function CDC_CDFrame(parent, i)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetWidth(32)
	frame:SetHeight(32)
	frame:EnableMouse(true)
	frame:SetScript('OnEnter', function()
		CDC_Tooltip(i)
	end)
	frame:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)
	frame.texture = frame:CreateTexture()
	frame.texture:SetAllPoints()
	frame.count = frame:CreateFontString()
	frame.count:SetFont([[Fonts\ARIALN.TTF]], 14, 'THICKOUTLINE')
	frame.count:SetWidth(32)
	frame.count:SetHeight(12)
	frame.count:SetPoint('BOTTOM', 0, 10)
	return frame
end

function CDC:ToggleStack(module)
	for i, frame in self.frames[module] do
		frame:ClearAllPoints()
		local reference, offset = self[module].frame, (i-1)*32
		if CDC_Orientation == self.U then
			frame:SetPoint('BOTTOM', reference, 'TOP', 0, offset-3)
		elseif CDC_Orientation == self.D then
			frame:SetPoint('TOP', reference, 'BOTTOM', 0, 3-offset)
		elseif CDC_Orientation == self.L then
			frame:SetPoint('RIGHT', reference, 'LEFT', -offset, 0)
		elseif CDC_Orientation == self.R then
			frame:SetPoint('LEFT', reference, 'RIGHT', offset, 0)
		end
	end
end

function CDC_Click()
	local succ = {
		R = self.D,
		D = self.L,
		L = self.U,
		U = self.R,
	}
	if arg1 == 'LeftButton' then
		CDC_Orientation = succ(CDC_Orientation)
		CDC:ToggleStack(self.PLAYER)
	elseif arg1 == 'RightButton' then
		CDC:Lock(self.PLAYER)
	end
end

function CDC_ToolTip(tooltipnum)
	GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
	GameTooltip:AddLine(CDC_ToolTips[tooltipnum])
	GameTooltip:AddLine(CDC_ToolTipDetails[tooltipnum], .8, .8, .8, 1)
	GameTooltip:Show()
end

function CDC:OnDragStart()
	self.PLAYER.frame:StartMoving()
end

function CDC:OnDragStop()
	self.PLAYER.frame:StopMovingOrSizing()
	CDC_Position = { CDC_Frame:GetLeft(), CDC_Frame:GetBottom() }
end

SLASH_CDC1 = '/CDC'
function SlashCmdList.CDC()
	if CDC_Locked then
		CDC:Unlock(self.PLAYER)
	else
		CDC:Lock(self.PLAYER)
	end
end

function CDC:Ignored(name)
	for entry in string.gfind(CDC_IgnoreList, '[^,]+') do
		if strupper(entry) == strupper(name) then
			return true
		end
	end
end

function CDC:StartCooldown(name, texture, started, duration)
	if CDC:Ignored(name) then
		return
	end

	for i, skill in CDC_UsedSkills do
		if skill.skill == name then
			tremove(CDC_UsedSkills, i)
			break
		end
	end
	table.insert(CDC_UsedSkills, {skill = name, info = '', texture = strsub(texture, 17), countdown = duration, started = started})
end

function CDC:DetectItemCooldowns()	
    for bag=0,4 do
        if GetBagName(bag) then
            for slot = 1, GetContainerNumSlots(bag) do
				local started, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = self:LinkName(GetContainerItemLink(bag, slot))
					if duration == 0 or duration > 3 and duration <= 1800 and GetItemInfo(6948) ~= name then
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
			if duration == 0 or duration > 3 and duration <= 1800 then
				self:StartCooldown(
					name,
					GetInventoryItemTexture('player', slot),
					started,
					duration
				)
			end
		end
	end
end

function CDC:DetectSpellCooldowns()	
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

function CDC:BAG_UPDATE_COOLDOWN()
	self:DetectItemCooldowns()
end

function CDC:SPELL_UPDATE_COOLDOWN()
	self:DetectSpellCooldowns()
end

function CDC:UPDATE()
	if CDC_Locked then
		local i = 1

		local temp = {}
		sort(CDC_UsedSkills, function(a, b) local ta, tb = a.started + a.countdown - GetTime(), b.started + b.countdown - GetTime() return ta < tb or tb == ta and a.skill < b.skill end)
		for k, v in CDC_UsedSkills do
			local timeleft = v.started + v.countdown - GetTime()

			if timeleft > 0 then
				tinsert(temp, v)

				if i <= 10 then
					local CDFrame = self.frames.PLAYER[i]
					if timeleft <= 5 then
						CDFrame.texture:SetAlpha(1 - (math.sin(GetTime() * 1.3 * math.pi) + 1) / 2 * .7)
					else
						CDFrame.texture:SetAlpha(1)
					end

					timeleft = ceil(timeleft)
					if timeleft >= 60 then
						timeleft = ceil((timeleft/60)*10)/10
						CDFrame.count:SetTextColor(0, 1, 0)
					else
						CDFrame.count:SetTextColor(1, 1, 0)
					end

					CDFrame.texture:SetTexture([[Interface\Icons\]]..v.texture)
					CDFrame.count:SetText(timeleft)
					CDFrame:Show()

					CDC_ToolTips[i] = v.skill
					CDC_ToolTipDetails[i] = v.info

					i = i + 1
				end
			end
		end
		CDC_UsedSkills = temp

		while i <= 10 do
			self.frames.PLAYER[i]:Hide()
			i = i + 1
		end
	end
end

function CDC:LinkName(link)
    local _, _, name = strfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h')
    return name
end