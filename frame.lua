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
	'text', true,
	'blink', 7,
	'animation', false,
	'clickThrough', false,
	'ignoreList', ''
)

function public.new(title, color, settings)
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
		local frame = CreateFrame('Button', nil, UIParent)
		self.frame = frame
		frame:SetMovable(true)
		frame:SetToplevel(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag('LeftButton')
		frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame:SetScript('OnDragStart', function() this:StartMoving() end)
		frame:SetScript('OnDragStop', function()
			this:StopMovingOrSizing()
			init[self.settings.position] = temp-A(this:GetCenter())
		end)
		frame:SetScript('OnClick', function() self:OnClick() end) -- TODO string lambdas?
		frame:SetScript('OnEnter', function() self:Tooltip() end)
		frame:SetScript('OnLeave', function() GameTooltip:Hide() end)
		frame:SetScript('OnUpdate', function() return self.settings.locked and self:Update() end)
		frame.cd_frames = t
	end

	for i = getn(self.frame.cd_frames) + 1, self.settings.size do
		tinsert(self.frame.cd_frames, self:CDFrame())
	end
	for i = self.settings.size + 1, getn(self.frame.cd_frames) do
		self.frame.cd_frames[i]:Hide()
	end
	for i = 1, self.settings.size do
		local cd_frame = self.frame.cd_frames[i]
		cd_frame:EnableMouse(not self.settings.clickThrough)
		cd_frame.cooldown:SetSequenceTime(0, 1000)
		if not self.settings.text then
			cd_frame.text:SetText('')
		end
	end
end

do
	local apply = {
		blizzard = function()
			icon:SetWidth(30)
			icon:SetHeight(30)
			icon:SetTexCoord(.07, .93, .07, .93)

			border:ClearAllPoints()
			border:SetPoint('CENTER', .5, -.5)
			border:SetWidth(56)
			border:SetHeight(56)
			border:SetTexture([[Interface\Buttons\UI-Quickslot2]])

			cooldown:SetScale(32.5/36)
		end,
		zoomed = function()
			icon:SetWidth(36)
			icon:SetHeight(36)
			icon:SetTexCoord(.08, .92, .08, .92)

			cooldown:SetScale(1)
		end,
		caith = function()
			icon:SetWidth(36)
			icon:SetHeight(36)
			icon:SetTexCoord(.02, .98, .02, .98)

			border:SetWidth(42)
			border:SetHeight(42)
			border:SetTexture([[Interface\Addons\CDFrames\Textures\caith\Normal]])
			border:SetVertexColor(.3, .3, .3)

			cooldown:SetScale(1)
		end,
		newsom = function()
			icon:SetWidth(30)
			icon:SetHeight(30)
			icon:SetTexCoord(.07,.93,.07,.93)

			border:SetWidth(36)
			border:SetHeight(36)
			border:SetTexture([[Interface\Addons\CDFrames\Textures\newsom\Normal]])
			border:SetTexCoord(.14, .86, .14, .86)

			gloss:SetWidth(36)
			gloss:SetHeight(36)
			gloss:SetTexture([[Interface\Addons\CDFrames\Textures\newsom\Gloss]])
			gloss:SetBlendMode('BLEND')
			gloss:SetTexCoord(.14, .86, .14, .86)

			cooldown:SetScale(30/36)
		end,
		darion = function()
			icon:SetWidth(34)
			icon:SetHeight(34)

			border:SetWidth(40)
			border:SetHeight(40)
			border:SetTexture([[Interface\Addons\CDFrames\Textures\darion\Normal]])
			border:SetVertexColor(.2, .2, .2)

			gloss:SetWidth(40)
			gloss:SetHeight(40)
			gloss:SetTexture([[Interface\Addons\CDFrames\Textures\darion\Gloss]])

			cooldown:SetScale(34/36)
		end,
	}
	function private.skin(frame, skin)
		local apply = apply[skin]
		setfenv(apply, frame); apply()
	end
end

function method:CDFrame()
	local frame = CreateFrame('Frame', nil, self.frame)
	frame:SetWidth(36)
	frame:SetHeight(36)

	frame.icon = frame:CreateTexture(nil, 'BORDER')
	frame.icon:SetPoint('CENTER', 0, 0)

	frame.background = frame:CreateTexture(nil, 'BACKGROUND')
	frame.background:SetAllPoints(frame.icon)
	frame.background:SetTexture(unpack(self.color))

	frame.border = frame:CreateTexture(nil, 'ARTWORK')
	frame.border:SetPoint('CENTER', 0, 0)

	frame.gloss = frame:CreateTexture(nil, 'OVERLAY')
	frame.gloss:SetPoint('CENTER', 0, 0)

	do
		local cooldown = CreateFrame('Model', nil, frame, 'CooldownFrameTemplate')
		cooldown:ClearAllPoints()
		cooldown:SetPoint('CENTER', frame.icon, 'CENTER', .5, -.5)
		cooldown:SetWidth(36)
		cooldown:SetHeight(36)
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
		text_frame:SetAllPoints()
		frame.text = text_frame:CreateFontString()
		frame.text:SetPoint('CENTER', .5, 0)
		frame.text:SetFont([[Fonts\ARIALN.ttf]], 14, 'THICKOUTLINE')
	end
	frame.tooltip = t
	skin(frame, 'blizzard') -- blizzard, zoomed, caith, newsom, darion
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
	local axis1, axis2 = ret(strfind(orientation, '^[LR]') and A('x', 'y') or A('y', 'x'))
	local sign = temp-T(
		'x', (strfind(orientation, 'R') and 1 or -1),
		'y', (strfind(orientation, 'U') and 1 or -1)
	)
	local anchor = (strfind(orientation, 'D') and 'TOP' or 'BOTTOM') .. (strfind(orientation, 'R') and 'LEFT' or 'RIGHT')

	local spacing = self.settings.spacing * 36
	local slotSize = 36 + spacing

	self.frame:SetWidth(36)
	self.frame:SetHeight(36)
	
	for i = 1, self.settings.size do
		local frame = self.frame.cd_frames[i]
		frame:ClearAllPoints()
		local offset = temp-T(
			axis1, sign[axis1] * mod(i - 1, self.settings.line) * slotSize,
			axis2, sign[axis2] * floor((i - 1) / self.settings.line) * slotSize
		)
		frame:SetPoint(anchor, offset.x, offset.y)
	end

	self.frame:ClearAllPoints()
	self.frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', unpack(self.settings.position))
end

function method:Lock()
	self.frame:EnableMouse(false)
	for i = 1, self.settings.size do
		self.frame.cd_frames[i].background:Hide()
		self.frame.cd_frames[i]:Hide()
	end
end

function method:Unlock()
	self.frame:EnableMouse(true)
	for i = 1, self.settings.size do
		local frame = self.frame.cd_frames[i]
		frame:EnableMouse(false)
		frame.background:Show()
		if i == 1 then
			frame.icon:SetAlpha(0)
		else
			frame.icon:SetTexture([[Interface\Icons\INV_Misc_QuestionMark]])
			frame.icon:SetAlpha(.8)
			frame:SetAlpha(.5)
		end
		frame:Show()
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
	return contains(strupper(self.settings.ignoreList), strupper(name))
end

function method:CDID(cooldown) return tostring(cooldown) end

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
				do
					local alpha = timeLeft <= self.settings.blink and blink_alpha1(tm) or 1
					frame.icon:SetAlpha(alpha); frame.border:SetAlpha(alpha); frame.gloss:SetAlpha(alpha); frame.cooldown:SetAlpha(alpha)
				end
				frame.cooldown.started, frame.cooldown.duration = cooldown.started, cooldown.duration
				if self.settings.text then
					frame.text:SetText(time_text(timeLeft))
					frame.text:SetFont([[Fonts\ARIALN.ttf]], 15, 'THICKOUTLINE')
				end
				frame.icon:SetTexture(cooldown.icon)
				init[frame.tooltip] = temp-A(cooldown.name, cooldown.info)
				frame:Show()

				i = i + 1
			end
		else
			self.cooldowns[self:CDID(cooldown)] = nil
		end
	end
	for j = i, self.settings.size do self.frame.cd_frames[j]:Hide() end
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

function method:CancelCD(CDID) local cooldowns = self.cooldowns
	cooldowns[CDID] = cooldowns[CDID] and release(cooldowns[CDID])
end

function private.blink_alpha1(t) local x = t * 4/3
	return (mod(floor(x), 2) == 0 and x - floor(x) or 1 - x + floor(x)) * .7 + .3
end

function private.blink_alpha2(t)
	return (sin(t * 240) + 1) / 2 * .7 + .3
end

do
	local DAY, HOUR, MINUTE = 86400, 3600, 60
	local color_code = function(r, g, b) return format('|cFF%02X%02X%02X', r*255, g*255, b*255) end

	function private.time_text(t) -- TODO ¼ ½ ¾
		if t > HOUR then
			return color_code(.7, .7, .7) .. ceil((t / HOUR) * 10) / 10
		elseif t > MINUTE then
			return color_code(0, 1, 0) .. ceil((t / MINUTE) * 10) / 10
		elseif t > 5 then
			return color_code(1, 1, 0) .. ceil(t)
		else
			return color_code(1, 0, 0) .. ceil(t)
		end
	end
end