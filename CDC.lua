local CDC = CreateFrame('Frame')
CDC:SetScript('OnUpdate', function()
	this:UPDATE(arg1)
end)
CDC:SetScript('OnEvent', function()
	this[event](this)
end)
CDC:RegisterEvent('ADDON_LOADED')

CDC_Settings = nil

function CDC:Enum(...)
	for i=1,arg.n do
		self[arg[i]] = arg[i]
	end
end

function CDC.Tokenize(str)
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

	SLASH_CDC1 = '/cdc'
	function SlashCmdList.CDC()
		if CDC_Settings[self.PLAYER].locked then
			self:Unlock(self.PLAYER)
		else
			self:Lock(self.PLAYER)
		end
	end

	self:Enum('R', 'D', 'L', 'U')
	self:Enum('PLAYER', 'ENEMY')

	CDC_Settings = CDC_Settings or {}

	table.foreach({self.PLAYER, self.ENEMY}, function(_, module)

		CDC_Settings[module] = CDC_Settings[module] or {
			position = {UIParent:GetWidth()/2, UIParent:GetHeight()/2},
			orientation = self.R,
			locked = false,
			ignoreList = '',
			clickThrough = false,
		}

		local frame = CreateFrame('Frame', nil, UIParent)
		self[module].frame = frame
		frame:SetWidth(32)
		frame:SetHeight(32)
		frame:SetPoint('BOTTOMLEFT', unpack(CDC_Settings[module].position))
		frame:SetFrameStrata('HIGH')
		frame:SetMovable(true)
		frame:SetToplevel(true)

		frame.button = CreateFrame('Button', nil, frame)
		frame.button:SetWidth(32)
		frame.button:SetHeight(40)
		frame.button:SetPoint('CENTER', 0, 8)
		frame.button:SetNormalTexture([[Interface\Buttons\UI-MicroButton-Abilities-Up.blp]])
		frame.button:RegisterForDrag('LeftButton')
		frame.button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame.button:SetScript('OnDragStart', function()
			self.OnDragStart(module)
		end)
		frame.button:SetScript('OnDragStop', function()
			self.OnDragStop(module)
		end)
		frame.button:SetScript('OnClick', function()
			self.OnClick(module)
		end)
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

		self:ToggleStack(module)

		if CDC_Settings[module].locked then
			CDC:Lock(module)
		else
			CDC:Unlock(module)
		end

		for _, frame in self[module].frame.CDs do
			frame:EnableMouse(not CDC_Settings[module].clickThrough)
		end

	end)

	CDC_Tooltips = {}
	CDC_TooltipDetails = {}
	self.CDs = {}

	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('SPELL_UPDATE_COOLDOWN')

	self:DetectItemCooldowns()
	self:DetectSpellCooldowns()
end

function CDC:Lock(module)
	self[module].frame.button:Hide()
	for _, frame in self[module].frame.CDs do
		frame:Hide()
	end
	CDC_Settings[module].locked = true
end

function CDC:Unlock(module)
	self[module].frame.button:Show()
	for i, frame in self[module].frame.CDs do
		CDC_Tooltips[i] = 'test'..i
		CDC_TooltipDetails[i] = 'test'..i
		frame.texture:SetTexture([[Interface\Icons\temp]])
		frame.count:SetText()
		frame:Show()
	end
	CDC_Settings[module].locked = false
end

function CDC:CDFrame(parent, i)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetWidth(32)
	frame:SetHeight(32)
	frame:SetScript('OnEnter', function()
		self:Tooltip(i)
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
	for i, frame in self[module].frame.CDs do
		frame:ClearAllPoints()
		local orientation, reference, offset = CDC_Settings[module].orientation, self[module].frame, (i-1)*32
		if orientation == self.U then
			frame:SetPoint('BOTTOM', reference, 'TOP', 0, offset-3)
		elseif orientation == self.D then
			frame:SetPoint('TOP', reference, 'BOTTOM', 0, 3-offset)
		elseif orientation == self.L then
			frame:SetPoint('RIGHT', reference, 'LEFT', -offset, 0)
		elseif orientation == self.R then
			frame:SetPoint('LEFT', reference, 'RIGHT', offset, 0)
		end
	end
end

function CDC:OnClick(module)
	local succ = {
		R = self.D,
		D = self.L,
		L = self.U,
		U = self.R,
	}
	if arg1 == 'LeftButton' then
		CDC_Settings[module].orientation = succ(CDC_Settings[module].orientation)
		self:ToggleStack(module)
	elseif arg1 == 'RightButton' then
		self:Lock(module)
	end
end

function CDC:Tooltip(i)
	GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
	GameTooltip:AddLine(CDC_Tooltips[i])
	GameTooltip:AddLine(CDC_TooltipDetails[i], .8, .8, .8, 1)
	GameTooltip:Show()
end

function CDC:OnDragStart(module)
	self[module].frame:StartMoving()
end

function CDC:OnDragStop(module)
	self[module].frame:StopMovingOrSizing()
	CDC_Settings[module].position = {self[module].frame:GetLeft(), self[module].frame:GetBottom()}
end

function CDC:Ignored(module, name)
	for entry in string.gfind(CDC_Settings[module].ignoreList, '[^,]+') do
		if strupper(entry) == strupper(name) then
			return true
		end
	end
end

function CDC:StartCooldown(module, name, texture, started, duration)
	if CDC:Ignored(name) then
		return
	end

	for i, skill in self.CDs do
		if skill.skill == name then
			tremove(self.CDs, i)
			break
		end
	end
	table.insert(self.CDs, {skill = name, info = '', texture = strsub(texture, 17), duration = duration, started = started})
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
							self.PLAYER,
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
					self.PLAYER
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
				self.PLAYER,
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
	for _, module in {self.PLAYER, self.ENEMY} do
		self:OnUpdate(module)
	end
end

function CDC:OnUpdate(module)
	if CDC_Settings[module].locked then
		local i = 1

		local temp = {}
		sort(self.CDs, function(a, b) local ta, tb = a.started + a.duration - GetTime(), b.started + b.duration - GetTime() return ta < tb or tb == ta and a.skill < b.skill end)
		for k, v in self.CDs do
			local timeleft = v.started + v.duration - GetTime()

			if timeleft > 0 then
				tinsert(temp, v)

				if i <= 10 then
					local CDFrame = self[module].frame.CDs[i]
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

					CDC_Tooltips[i] = v.skill
					CDC_TooltipDetails[i] = v.info

					i = i + 1
				end
			end
		end
		self.CDs = temp

		while i <= 10 do
			self[module].frame.CDs[i]:Hide()
			i = i + 1
		end
	end	
end

function CDC:LinkName(link)
	for name in string.gfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h') do
		return name
	end
end