CDFrames 'frame'

private.ORIENTATIONS = A('RU', 'RD', 'DR', 'DL', 'LD', 'LU', 'UL', 'UR')

private.DEFAULT_SETTINGS = T(
	'active', true,
	'locked', false,
	'position', A(0, 0),
	'scale', 1,
	'size', 16,
	'line', 8,
	'spacing', 0,
	'orientation', 'RU',
	'text', 1,
	'blink', 7,
	'animation', false,
	'clickThrough', false,
	'ignoreList', ''
)

function public.New(title, color, settings)
	local self = t
	for k, v in method do self[k] = v end
	self.title = title
	self.color = color
	self.cooldowns = t
	self.iconFramePool = t
	self:LoadSettings(settings)
	return self
end

private.method = t

function method:LoadSettings(settings)
	for k, v in DEFAULT_SETTINGS do
		if settings[k] == nil then settings[k] = v end
	end
	self.settings = settings
	self:Configure()
end

function method:CreateFrames()
	if not self.frame then
		local frame = CreateFrame('Button')
		self.frame = frame
		frame:SetMovable(true)
		frame:SetToplevel(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag('LeftButton')
		frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame:SetScript('OnDragStart', function() self.frame:StartMoving() end)
		frame:SetScript('OnDragStop', function()
			this:StopMovingOrSizing()
			local scale = self.settings.scale
			local x, y = self.frame.cd_frames[1]:GetCenter()
			wipe(self.settings.position)
			self.settings.position = A(x * scale, y * scale)
		end)
		frame:SetScript('OnClick', function() self:OnClick() end) -- TODO string lambdas?
		frame:SetScript('OnEnter', function() self:Tooltip() end)
		frame:SetScript('OnLeave', function() GameTooltip:Hide() end)
		frame:SetScript('OnUpdate', function() return self.settings.locked and self:Update() end)
		frame.cd_frames = t
	end

	for i = getn(self.frame.cd_frames) + 1, self.settings.size do
		tinsert(self.frame.cd_frames, self:CDFrame(i))
	end
	for i = self.settings.size + 1, getn(self.frame.cd_frames) do
		self.frame.cd_frames[i]:Hide()
	end
	for i = 1, self.settings.size do
		local cd_frame = self.frame.cd_frames[i]
		cd_frame:EnableMouse(not self.settings.clickThrough)
		cd_frame.cooldown:SetSequenceTime(0, 1000)
		if self.settings.text == 1 then
			cd_frame.text:SetPoint('CENTER', 0, 0)
			cd_frame.text:SetFont([[Fonts\ARIALN.ttf]], 16.5, 'THICKOUTLINE')
		elseif self.settings.text == 2 then
			cd_frame.text:SetPoint('CENTER', 0, 1)
			cd_frame.text:SetFont(STANDARD_TEXT_FONT, 16.5, 'OUTLINE')
		elseif cd_frame.text:GetText() then
			cd_frame.text:SetText('')
		end
	end
end

local id = 0
function method:CDFrame(i)
	id = id + 1
	local name = 'kekkek'..id
	local frame = CreateFrame('CheckButton', name, self.frame, 'PetActionButtonTemplate')
	frame:SetScript('OnEnter', function() self:CDTooltip() end)
	frame:SetScript('OnLeave', function() GameTooltip:Hide() end)
	do
		local background = frame:CreateTexture(nil, 'BACKGROUND')
		background:SetTexture(unpack(self.color))
		background:SetAllPoints()
		frame.background = background
	end
	do
		frame.icon = _G[name..'Icon']
		frame.icon:SetTexCoord(.06, .94, .06, .94)
	end
	do
		frame.border = frame:GetNormalTexture()
	end
	do
		local autocast = _G[name..'AutoCast']
--		autocast:Show()
	end
	do
		local cooldown = _G[name..'Cooldown']
		cooldown:SetScript('OnAnimFinished', nil)
		cooldown:SetScript('OnUpdateModel', function()
			if self.settings.animation and this.started then
				local progress = (GetTime() - this.started) / this.duration
				this:SetSequenceTime(0, (1 - progress) * 1000)
			end
		end)
		cooldown:Show()
		frame.cooldown = cooldown
	end
	do
		local text_frame = CreateFrame('Frame', nil, frame)
		text_frame:SetFrameLevel(4)
		local text = text_frame:CreateFontString()
		text:ClearAllPoints()
		frame.text = text
	end
--	frame:SetChecked(1)
	frame.tooltip = t
	return frame
end

function method:SetDummyStyle(frame)
	frame:EnableMouse(false)
	frame.icon:SetTexture([[Interface\Icons\INV_Misc_QuestionMark]])
	frame.icon:SetBlendMode('ADD')
	if frame.id == 1 then
		local text = frame.text
		text:SetPoint('CENTER', frame, 'CENTER', 0, 0)
		text:SetFont([[Fonts\ARIALN.ttf]], 30, 'OUTLINE')
		text:SetTextColor(1, 1, 1, .7)
		text:SetText('●') -- ×
	end
	return frame
end

function method:Configure()
	self:CreateFrames()
	if self.settings.active then self.frame:Show() else self.frame:Hide() end
	if self.settings.locked then self:Lock() else self:Unlock() end
	self:PlaceFrames()
end

function method:PlaceFrames()
	local scale = self.settings.scale
	self.frame:SetScale(scale)
	local orientation = self.settings.orientation
	local axis1, axis2 = unpack(strfind(orientation, '^[LR]') and temp-A('x', 'y') or temp-A('y', 'x'))
	local sign = temp-T(
		'x', (strfind(orientation, 'R') and 1 or -1),
		'y', (strfind(orientation, 'U') and 1 or -1)
	)
	local anchor = (strfind(orientation, 'D') and 'TOP' or 'BOTTOM')..(strfind(orientation, 'R') and 'LEFT' or 'RIGHT')

	local spacing = self.settings.spacing * 32.5
	local slotSize = 32.5 + spacing

	local size = temp-T(
		axis1, min(self.settings.size, self.settings.line) * slotSize - spacing,
		axis2, ceil(self.settings.size / self.settings.line) * slotSize - spacing
	)

	self.frame:SetWidth(size.x)
	self.frame:SetHeight(size.y)
	
	for i = 1, self.settings.size do
		local frame = self.frame.cd_frames[i]
		frame:ClearAllPoints()
		local offset = temp-T(
			axis1, sign[axis1] * mod(i - 1, self.settings.line) * slotSize,
			axis2, sign[axis2] * floor((i - 1) / self.settings.line) * slotSize
		)
		frame:SetPoint(anchor, offset.x, offset.y)
	end

	local x, y = unpack(self.settings.position)
	self.frame:ClearAllPoints()
	self.frame:SetPoint(anchor, UIParent, 'BOTTOMLEFT', x/scale - sign.x * (slotSize-spacing)/2, y/scale - sign.y * (slotSize-spacing)/2)
end

function method:Lock()
	self.frame:EnableMouse(false)
	for i = 1, self.settings.size do
		self.frame.cd_frames[i]:Hide()
	end
end

function method:Unlock()
	self.frame:EnableMouse(true)
	for i = 1, self.settings.size do
		self:SetDummyStyle(self.frame.cd_frames[i])
		self.frame.cd_frames[i]:Show()
	end
end

function method:Tooltip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:AddLine(self.title, unpack(self.color))
	GameTooltip:AddLine('<Left Drag> move', 1, 1, 1)
	GameTooltip:AddLine('<Left Click> turn', 1, 1, 1)
	GameTooltip:AddLine('<Right Click> lock', 1, 1, 1)
	GameTooltip:Show()
end

function method:CDTooltip()
	GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
	GameTooltip:AddLine(this.tooltip[1])
	GameTooltip:AddLine(this.tooltip[2], .8, .8, .8, 1)
	GameTooltip:Show()
end

function method:OnClick()
	if arg1 == 'LeftButton' then
		for i, orientation in ORIENTATIONS do
			if orientation == self.settings.orientation then
				for _ = 1, (self.settings.size <= self.settings.line and 2 or 1) do
					i = mod(i, getn(ORIENTATIONS)) + 1
					self.settings.orientation = ORIENTATIONS[i]
				end
				break
			end
		end
		self:PlaceFrames()
	elseif arg1 == 'RightButton' then
		self.settings.locked = true
		self:Configure()
	end
end

function method:Ignored(name)
	return In(strupper(self.settings.ignoreList), strupper(name))
end

function method:CDID(cooldown)
	return tostring(cooldown)
end

function method:Update()
	local tm = GetTime()

	local cooldownList = tt
	for _, cooldown in self.cooldowns do tinsert(cooldownList, cooldown) end
	sort(cooldownList, function(a, b) local ta, tb = a.started + a.duration - tm, b.started + b.duration - tm return ta < tb or tb == ta and a.name < b.name end)

	local i = 1
	for _, cooldown in cooldownList do
		local timeLeft = cooldown.started + cooldown.duration - tm

		if timeLeft > 0 then
			if i <= self.settings.size and not self:Ignored(cooldown.name) then
				local frame = self.frame.cd_frames[i]
				if timeLeft <= self.settings.blink then
					local a = blink_alpha1(tm)
					frame.icon:SetAlpha(a)
					frame.border:SetAlpha(a)
					frame.cooldown:SetAlpha(a)
				else
					frame.icon:SetAlpha(1)
					frame.border:SetAlpha(1)
					frame.cooldown:SetAlpha(1)
				end

				frame.cooldown.started = cooldown.started
				frame.cooldown.duration = cooldown.duration
				local text, color
				if self.settings.text == 1 then
					text, color = time_format1(timeLeft)
				elseif self.settings.text == 2 then
					text, color = time_format2(timeLeft)
				end
				if self.settings.text ~= 0 then
					frame.text:SetText(text)
					frame.text:SetTextColor(unpack(color))
				end
				frame.icon:SetTexture(cooldown.icon)
				recycle(frame.tooltip)
				frame.tooltip = A(cooldown.name, cooldown.info)
				frame:Show()

				i = i + 1
			end
		else
			self.cooldowns[self:CDID(cooldown)] = nil
		end
	end
	for j = i, self.settings.size do
		self.frame.cd_frames[j]:Hide()
	end	
end

function method:StartCD(name, info, icon, started, duration)
	local cooldown = T(
		'name', name,
		'info', info,
		'icon', icon,
		'started', started,
		'duration', duration
	)
	self.cooldowns[self:CDID(cooldown)] = cooldown
	return self:CDID(cooldown)
end

function method:CancelCD(CDID)
	local cooldowns = self.cooldowns
	cooldowns[CDID] = cooldowns[CDID] and recycle(cooldowns[CDID])
end

function private.blink_alpha1(t)
	local x = t * 4/3
	return (mod(floor(x), 2) == 0 and x - floor(x) or 1 - x + floor(x)) * .7 + .3
end

function private.blink_alpha2(t)
	return (math.sin(t * 4/3 * math.pi) + 1) / 2 * .7 + .3
end

function private.time_format1(t) -- TODO ¼ ½ ¾
	if t > 60 then
		return ceil((t / 60) * 10) / 10, {0, 1, 0}
	else
		return ceil(t), {1, 1, 0}
	end
end

function private.time_format2(t)
	if t > 86400 then
		return ceil(t / 86400) .. 'd', {.8, .8, .9}
	elseif t > 3600 then
		return ceil(t / 3600) .. 'h', {.8, .8, .9}
	elseif t > 60 then
		return ceil(t / 60) .. 'm', {.8, .8, .9}
	else
		return ceil(t), t > 5 and {1, 1, .4} or {1, 0, 0}
	end
end