CDFrames 'frame'

public.BASE_SCALE = .85
private.ORIENTATIONS = {'RU', 'RD', 'DR', 'DL', 'LD', 'LU', 'UL', 'UR'}

private.DEFAULT_SETTINGS = {
	active = true,
	locked = false,
	position = {0,0},
	scale = 1,
	size = 16,
	line = 8,
	spacing = 0,
	orientation = 'RU',
	text = 1,
	blink = 7,
	animation = false,
	clickThrough = false,
	ignoreList = '',
}

function public.New(title, color, settings)
	local self = {}
	for k, v in method do
		self[k] = v
	end
	self.title = title
	self.color = color
	self.cooldowns = {}
	self.iconFramePool = {}
	self:LoadSettings(settings)
	return self
end

do
	local id = 0
	function private.name.get()
		id = id + 1
		return 'CDFrames_Frame'..id
	end
end

private.method = {}

function method:LoadSettings(settings)
	for k, v in DEFAULT_SETTINGS do
		if settings[k] == nil then
			settings[k] = v
		end
	end
	self.settings = settings
	self:Configure()
end

function method:CreateFrames()
	if not self.frame then
		local frame = CreateFrame('Button', name, UIParent)
		self.frame = frame
		frame:SetMovable(true)
		frame:SetToplevel(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag('LeftButton')
		frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame:SetScript('OnDragStart', function()
			self.frame:StartMoving()
		end)
		frame:SetScript('OnDragStop', function()
			this:StopMovingOrSizing()
			local scale = self.settings.scale * BASE_SCALE
			local x, y = self.frame.iconFrames[1]:GetCenter()
			self.settings.position = {x*scale, y*scale}
		end)
		frame:SetScript('OnClick', function()
			self:OnClick()
		end)
		frame:SetScript('OnEnter', function()
			self:Tooltip()
		end)
		frame:SetScript('OnLeave', function()
			GameTooltip:Hide()
		end)
		frame:SetScript('OnUpdate', function()
			if self.settings.locked then
				self:Update()
			end
		end)
		frame.iconFrames = {}
		frame.dummyFrames = {}
	end

	for i = getn(self.frame.iconFrames) + 1, self.settings.size do
		tinsert(self.frame.iconFrames, self:IconFrame())
		tinsert(self.frame.dummyFrames, self:DummyFrame(i))
		self.frame.dummyFrames[i]:SetAllPoints(self.frame.iconFrames[i])
	end
	for i = self.settings.size + 1, getn(self.frame.iconFrames) do
		self.frame.iconFrames[i]:Hide()
		self.frame.dummyFrames[i]:Hide()
	end
	for i = 1, self.settings.size do
		local iconFrame = self.frame.iconFrames[i]
		iconFrame:EnableMouse(not self.settings.clickThrough)
		iconFrame.cooldown:SetSequenceTime(0, 1000)
		if self.settings.text == 1 then
			iconFrame.count:SetFont([[Fonts\ARIALN.ttf]], 16.5, 'THICKOUTLINE')
			iconFrame.count:SetPoint('CENTER', 0, 0)
		elseif self.settings.text == 2 then
			iconFrame.count:SetFont(STANDARD_TEXT_FONT, 16.5, 'OUTLINE')
			iconFrame.count:SetPoint('CENTER', 0, 1)
		elseif iconFrame.count:GetText() then
			iconFrame.count:SetText('')
		end
	end

end

function method:IconFrame()
	local frame = CreateFrame('CheckButton', name, self.frame, 'ActionButtonTemplate')
	frame:SetWidth(37)
	frame:SetHeight(37)
	frame:SetHighlightTexture(nil)
	frame:RegisterForClicks()
	frame:SetScript('OnEnter', function()
		self:CDTooltip()
	end)
	frame:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)
	local icon = getglobal(frame:GetName()..'Icon')
	icon:ClearAllPoints()
	icon:SetPoint('CENTER', 0, 0)
	icon:SetWidth(36)
	icon:SetHeight(36)
	icon:SetTexCoord(.06, .94, .06, .94)
	frame.icon = icon
	frame.border = frame:GetNormalTexture()
	local cooldown = getglobal(frame:GetName()..'Cooldown')
	cooldown:Show()
	cooldown:SetScript('OnAnimFinished', nil)
	cooldown:SetScript('OnUpdateModel', function()
		if self.settings.animation and this.started then
			local progress = (GetTime() - this.started) / this.duration
			this:SetSequenceTime(0, (1 - progress) * 1000)
		end
	end)
	frame.cooldown = cooldown
	frame.count = frame.cooldown:CreateFontString(nil, 'OVERLAY')
	return frame
end

function method:DummyFrame(i)
	local frame = CreateFrame('CheckButton', name, self.frame, 'ActionButtonTemplate')
	frame:SetWidth(37)
	frame:SetHeight(37)
	frame:EnableMouse(nil)
	frame:SetHighlightTexture(nil)
	frame:RegisterForClicks()
	local icon = getglobal(frame:GetName()..'Icon')
	icon:ClearAllPoints()
	icon:SetPoint('CENTER', 0, 0)
	icon:SetWidth(36)
	icon:SetHeight(36)
	icon:SetTexture(unpack(self.color))
	local border = frame:GetNormalTexture()
	local r, g, b = unpack(self.color)
	border:SetVertexColor(.5 + .5 * r, .5 + .5 * g, .5 + .5 * b)
--	frame.border:SetAlpha(.85)
	local index = frame:CreateFontString(nil, 'OVERLAY')
	index:SetPoint('CENTER', -.5, 0)
	index:SetFont([[Fonts\FRIZQT__.ttf]], 16)
	index:SetWidth(36)
	index:SetShadowOffset(1, -1)
	index:SetText(i)
	return frame
end

function method:Configure()
	self:CreateFrames()
	if self.settings.active then
		self.frame:Show()
	else
		self.frame:Hide()
	end
	if self.settings.locked then
		self:Lock()
	else
		self:Unlock()
	end
	self:PlaceFrames()
end

function method:PlaceFrames()
	local scale = self.settings.scale * BASE_SCALE
	self.frame:SetScale(scale)
	local orientation = self.settings.orientation
	local axis1, axis2 = unpack(strfind(orientation, '^[LR]') and {'x', 'y'} or {'y', 'x'})
	local sign = {
		x = (strfind(orientation, 'R') and 1 or -1),
		y = (strfind(orientation, 'U') and 1 or -1),
	}
	local anchor = (strfind(orientation, 'D') and 'TOP' or 'BOTTOM')..(strfind(orientation, 'R') and 'LEFT' or 'RIGHT')

	local spacing = self.settings.spacing * 40
	local slotSize = 40 + spacing

	local size = {
		[axis1] = min(self.settings.size, self.settings.line) * slotSize - spacing,
		[axis2] = ceil(self.settings.size/self.settings.line) * slotSize - spacing,
	}

	self.frame:SetWidth(size.x)
	self.frame:SetHeight(size.y)
	
	for i = 1, self.settings.size do
		local frame = self.frame.iconFrames[i]
		frame:ClearAllPoints()
		local offset = {
			[axis1] = sign[axis1] * mod(i - 1, self.settings.line) * slotSize,
			[axis2] = sign[axis2] * floor((i - 1)/self.settings.line) * slotSize,
		}
		frame:SetPoint(anchor, offset.x, offset.y)
	end

	local x, y = unpack(self.settings.position)
	self.frame:ClearAllPoints()
	self.frame:SetPoint(anchor, UIParent, 'BOTTOMLEFT', x/scale - sign.x * (slotSize-spacing)/2, y/scale - sign.y * (slotSize-spacing)/2)
end

function method:Lock()
	self.frame:EnableMouse(false)
	for i = 1, self.settings.size do
		self.frame.dummyFrames[i]:Hide()
	end
end

function method:Unlock()
	self.frame:EnableMouse(true)
	for i = 1, self.settings.size do
		self.frame.iconFrames[i]:Hide()
		self.frame.dummyFrames[i]:Show()
	end
end

function method:Tooltip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:AddLine(self.title)
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
	local t = GetTime()

	local cooldownList = {}
	for _, cooldown in self.cooldowns do
		tinsert(cooldownList, cooldown)
	end
	sort(cooldownList, function(a, b) local ta, tb = a.started + a.duration - t, b.started + b.duration - t return ta < tb or tb == ta and a.name < b.name end)

	local i = 1
	for _, cooldown in cooldownList do
		local timeLeft = cooldown.started + cooldown.duration - t

		if timeLeft > 0 then
			if i <= self.settings.size and not self:Ignored(cooldown.name) then
				local frame = self.frame.iconFrames[i]
				if timeLeft <= self.settings.blink then
					local a = blink_alpha1(t)
					frame.icon:SetAlpha(a)
					frame.border:SetAlpha(a)
				else
					frame.icon:SetAlpha(1)
					frame.border:SetAlpha(1)
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
					frame.count:SetText(text)
					frame.count:SetTextColor(unpack(color))
				end
				frame.icon:SetTexture(cooldown.icon)
				frame.tooltip = {cooldown.name, cooldown.info}
				frame:Show()

				i = i + 1
			end
		else
			self.cooldowns[self:CDID(cooldown)] = nil
		end
	end

	for j = i , self.settings.size do
		self.frame.iconFrames[j]:Hide()
	end	
end

function method:StartCD(name, info, icon, started, duration)
	local cooldown = {
		name = name,
		info = info,
		icon = icon,
		started = started,
		duration = duration,
	}
	self.cooldowns[self:CDID(cooldown)] = cooldown
	return self:CDID(cooldown)
end

function method:CancelCD(CDID)
	self.cooldowns[CDID] = nil
end

function private.blink_alpha1(t)
	local x = t * 4/3
	return (mod(floor(x), 2) == 0 and x - floor(x) or 1 - x + floor(x)) * .7 + .3
end

function private.blink_alpha2(t)
	return (math.sin(t * 4/3 * math.pi) + 1) / 2 * .7 + .3
end

function private.time_format1(t)
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