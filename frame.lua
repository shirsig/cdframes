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
		frame:SetScript('OnDragStart', function() self.frame:StartMoving() end)
		frame:SetScript('OnDragStop', function()
			this:StopMovingOrSizing()
			local scale = self.settings.scale
			local x, y = self.frame.cd_frames[1]:GetCenter()
			init[self.settings.position] = temp-A(x * scale, y * scale)
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
		if self.settings.text == 1 then
			cd_frame.text:SetPoint('CENTER', 1, 0)
			cd_frame.text:SetFont([[Fonts\ARIALN.ttf]], 14, 'THICKOUTLINE')
		elseif self.settings.text == 2 then
			cd_frame.text:SetPoint('CENTER', 0, 1)
			cd_frame.text:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
		elseif cd_frame.text:GetText() then
			cd_frame.text:SetText('')
		end
	end
end

--local Justify = {
--	Count = "RIGHT",
--	Duration = "CENTER",
--}
---- Point
--local Point = {
--	Count = "BOTTOMRIGHT",
--	Duration = "TOP",
--}
--
---- Relative Point
--local RelPoint = {
--	Count = "BOTTOMRIGHT",
--	Duration = "BOTTOM",
--}

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

			status:SetWidth(60)
			status:SetHeight(60)
			status:SetPoint('CENTER', .5, .5)
			status:SetTexture([[Interface\Buttons\UI-ActionButton-Border]])
			status:SetBlendMode('ADD')

			cooldown:SetScale(32/36)

--			Count = {
--				Width = 32,
--				Height = 10,
--				OffsetX = -3,
--				OffsetY = 6,
--			},

--			Duration = {
--				Width = 36,
--				Height = 10,
--				OffsetY = -2,
--			},
		end,
		zoomed = function()
			icon:SetWidth(36)
			icon:SetHeight(36)
			icon:SetTexCoord(.07, .93, .07, .93)

			status:SetWidth(66)
			status:SetHeight(66)
			status:SetPoint('CENTER', .5, .5)
			status:SetTexture([[Interface\Buttons\UI-ActionButton-Border]])
			status:SetBlendMode('ADD')

			cooldown:SetScale(1)

			--			Count = {
			--				Width = 36,
			--				Height = 10,
			--				OffsetX = -2,
			--				OffsetY = 4,
			--			},

			--			Duration = {
			--				Width = 36,
			--				Height = 10,
			--				OffsetY = -3,
			--			},
		end,
		fade = function()
			icon:SetWidth(32)
			icon:SetHeight(32)
			icon:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture([[Interface\Addons\CDFrames\Textures\Fade\Normal]])
			border:SetVertexColor(0, 0, 0, 1)

			status:SetTexture([[Interface\Addons\CDFrames\Textures\Fade\Border]])

			gloss:SetTexture([[Interface\Addons\CDFrames\Textures\Fade\Gloss]])
			gloss:SetBlendMode('ADD')

			cooldown:SetScale(32/36)
		end,
		newsom = function()
			icon:SetWidth(30)
			icon:SetHeight(30)
			icon:SetTexCoord(.07,.93,.07,.93)

			border:ClearAllPoints()
			border:SetWidth(36)
			border:SetHeight(36)
			border:SetPoint('CENTER', 0, 0)
			border:SetTexture([[Interface\Addons\CDFrames\Textures\newsom\Normal]])
			border:SetTexCoord(.14, .86, .14, .86)

			status:SetWidth(35)
			status:SetHeight(35)
			status:SetPoint('CENTER', 0, 0)
			status:SetTexture([[Interface\Addons\CDFrames\Textures\newsom\Border]])
			status:SetTexCoord(.14, .86, .14, .86)
			status:SetBlendMode('ADD')

			gloss:ClearAllPoints()
			gloss:SetWidth(36)
			gloss:SetHeight(36)
			gloss:SetPoint('CENTER', 0, 0)
			gloss:SetTexture([[Interface\Addons\CDFrames\Textures\newsom\Gloss]])
			gloss:SetBlendMode('BLEND')
			gloss:SetTexCoord(.14, .86, .14, .86)

			cooldown:SetScale(30/36)

--			Count = {
--				Width = 32,
--				Height = 10,
--				OffsetX = -1,
--				OffsetY = 6,
--			},
		end,
		imoen = function()
			icon:SetWidth(32)
			icon:SetHeight(32)
			icon:SetTexCoord(.06, .94, .06, .94)

			border:ClearAllPoints()
			border:SetWidth(64)
			border:SetHeight(64)
			border:SetPoint('CENTER', 0, 0)
			border:SetTexture([[Interface\Addons\CDFrames\Textures\imoen\Normal]])

			status:ClearAllPoints()
			status:SetWidth(64)
			status:SetHeight(64)
			status:SetPoint('CENTER', 0, 0)
			status:SetTexture([[Interface\Addons\CDFrames\Textures\imoen\Highlight]])
			status:SetBlendMode('ADD')
			status:SetVertexColor(1, 1, 1, .5)

			gloss:ClearAllPoints()
			gloss:SetWidth(64)
			gloss:SetHeight(64)
			gloss:SetPoint('CENTER', 0, 0)
			gloss:SetTexture([[Interface\Addons\CDFrames\Textures\imoen\Gloss]])
			gloss:SetVertexColor(1, 1, 1, .3)

			cooldown:SetScale(32/36)

--			Count = {
--				Width = 32,
--				Height = 10,
--				OffsetX = -2,
--				OffsetY = 3,
--			},
		end,
		darion = function()
			icon:SetWidth(34)
			icon:SetHeight(34)

			border:ClearAllPoints()
			border:SetWidth(40)
			border:SetHeight(40)
			border:SetPoint('CENTER', 0, 0)
			border:SetTexture([[Interface\Addons\CDFrames\Textures\darion\Normal]])
			border:SetVertexColor(0, 0, 0)

			status:ClearAllPoints()
			status:SetWidth(40)
			status:SetHeight(40)
			status:SetPoint('CENTER', 0, 0)
			status:SetTexture([[Interface\Addons\CDFrames\Textures\darion\Border]])
			status:SetBlendMode('DISABLE')

			gloss:ClearAllPoints()
			gloss:SetWidth(40)
			gloss:SetHeight(40)
			gloss:SetPoint('CENTER', 0, 0)
			gloss:SetTexture([[Interface\Addons\CDFrames\Textures\darion\Gloss]])

			cooldown:SetScale(34/36)

--			Count = {
--				Width = 32,
--				Height = 10,
--				OffsetX = -4,
--				OffsetY = 5,
--			},
		end,
	}
	function private.skin(frame, skin)
		local apply = apply[skin]
		setfenv(apply, frame); apply()
	end
end

function method:CDFrame()
	local frame = CreateFrame('Frame', nil, self.frame)
	frame:SetWidth(42)
	frame:SetHeight(42)

	frame.icon = frame:CreateTexture(nil, 'BACKGROUND')
	frame.icon:SetPoint('CENTER', 0, 0)

	frame.border = frame:CreateTexture(nil, 'BORDER')
	frame.border:SetAllPoints()

	frame.status = frame:CreateTexture(nil, 'ARTWORK')
	frame.status:SetAllPoints()
	frame.status:Hide()

	frame.gloss = frame:CreateTexture(nil, 'OVERLAY')
--	frame.gloss:SetAlpha(1)
	frame.gloss:SetAllPoints()

	do local cooldown = CreateFrame('Model', nil, frame, 'CooldownFrameTemplate')
		cooldown:ClearAllPoints()
		cooldown:SetPoint('BOTTOMLEFT', frame.icon, 'BOTTOMLEFT', 0, -1)
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
	do local text_frame = CreateFrame('Frame', nil, frame)
		text_frame:SetFrameLevel(4)
		text_frame:SetAllPoints()
		frame.text = text_frame:CreateFontString()
	end
	frame.tooltip = t
	skin(frame, 'imoen')
	return frame
end

--M(public) -- TODO
--__(public)
--public()

--interface = false
--

function method:SetDummyStyle(frame, index)
	frame:EnableMouse(false)
	frame.icon:SetTexture([[Interface\Icons\INV_Misc_QuestionMark]])
--	frame.icon:SetTexture(unpack(self.color))
	frame.text:SetWidth(32)
	frame.text:SetHeight(10)
	frame.text:ClearAllPoints()
	frame.text:SetFont([[Fonts\ARIALN.ttf]], 10)
	frame.text:SetTextColor(1, 1, 1)
	frame.text:SetPoint('BOTTOMRIGHT', -3, 6)
	frame.text:SetJustifyV('MIDDLE')
	frame.text:SetJustifyH('RIGHT')
	frame.text:SetText('#'..index)
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
	local anchor = (strfind(orientation, 'D') and 'TOP' or 'BOTTOM') .. (strfind(orientation, 'R') and 'LEFT' or 'RIGHT')

	local spacing = self.settings.spacing * 36
	local slotSize = 36 + spacing

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
	for i = 1, self.settings.size do self.frame.cd_frames[i]:Hide() end
end

function method:Unlock()
	self.frame:EnableMouse(true)
	for i = 1, self.settings.size do
		self:SetDummyStyle(self.frame.cd_frames[i], i)
		self.frame.cd_frames[i]:Show()
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
				do local alpha = timeLeft <= self.settings.blink and blink_alpha1(tm) or 1
					frame.icon:SetAlpha(alpha); frame.border:SetAlpha(alpha); frame.gloss:SetAlpha(alpha); frame.cooldown:SetAlpha(alpha)
				end
				frame.cooldown.started, frame.cooldown.duration = cooldown.started, cooldown.duration
				local text, color
				if self.settings.text == 1 then
					text, color = time_format1(timeLeft)
				elseif self.settings.text == 2 then
					text, color = time_format2(timeLeft)
				end
				if self.settings.text ~= 0 then
					frame.text:SetText(text)
					frame.text:SetTextColor(ret(color))
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

--soon = {
--	r = 1, g = .1, b = .1, a = 1,
--	scale = 1.5
--},
--seconds = {
--	r = 1, g = 1, b = .1, a = 1,
--	scale = 1
--},
--minutes = {
--	r = 1, g = 1, b = 1, a = 1,
--	scale = 1
--},
--hours = {
--	r = .7, g = .7, b = .7, a = 1,
--	scale = .75
--},


--

--
--function Timer:GetTimeText(remain)
--	if remain < tenthsDuration then
--		return '%.1f', remain
--	elseif remain < MINUTEISH then
--		local seconds = round(remain)
--		return seconds ~= 0 and seconds or ''
--	elseif remain < mmSSDuration then
--		local seconds = round(remain)
--		return '%d:%02d', seconds/MINUTE, seconds%MINUTE
--	elseif remain < HOURISH then
--		return '%dm', round(remain/MINUTE)
--	elseif remain < DAYISH then
--		return '%dh', round(remain/HOUR)
--	else
--		return '%dd', round(remain/DAY)
--	end
--end

local tenthsDuration, mmSSDuration = 0, 0

local DAY, HOUR, MINUTE = 86400, 3600, 60
local DAYISH, HOURISH, MINUTEISH, SOONISH = HOUR * 23.5, MINUTE * 59.5, 59.5, 5.5
local HalfDayish, HalfHourish, HalfMinuteish = DAY/2 + .5, HOUR/2 + .5, MINUTE/2 + .5
local round = function(x) return floor(x + .5) end

local color_code = function(r, g, b) return format('|c%02X%02X%02X%02X', a, r*255, g*255, b*255) end

function private.time_format1(t) -- TODO ¼ ½ ¾
	if t > HOUR then
		return color_code(.7, .7, .7) .. ceil((t / HOUR) * 10) / 10
	elseif t > MINUTE then
		return color_code(0, 1, 0) .. ceil((t / MINUTE) * 10) / 10
	else
		return color_code(1, 1, 0) .. ceil(t)
	end
end

function private.time_format2(t)
	if t > 86400 then
		return color_code(.7, .7, .7) .. round(t / DAY)  ..  'd', .75
	elseif t < DAYISH then
		return color_code(.7, .7, .7) .. round(t / HOUR)  ..  'h', .75
	elseif t < HOURISH then
		return color_code(1, 1, 1) .. round(t / MINUTE)  ..  'm', 1
	elseif t < MINUTEISH then
		return color_code(1, 1, .1) .. round(t), 1
	elseif t < SOONISH then
		return color_code(1, .1, .1) .. round(t), 1.5
	end
end