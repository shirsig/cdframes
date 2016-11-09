module 'cooldowns.frame'

include 'T'
include 'cooldowns'

ORIENTATIONS = A('RU', 'RD', 'DR', 'DL', 'LD', 'LU', 'UL', 'UR')

DEFAULT_SETTINGS = O(
	'active', true,
	'locked', false,
	'x', UIParent:GetCenter(),
	'y', (temp-A(UIParent:GetCenter()))[2],
	'scale', 1,
	'size', 15,
	'line', 8,
	'spacing', .1,
	'orientation', 'RU',
	'skin', 'darion',
	'count', true,
	'blink', 0,
	'animation', false,
	'clickthrough', false,
	'ignore_list', ''
)

function M.new(title, color, settings)
	local self = T
	for k, v in method do self[k] = v end
	self.title = title
	self.color = color
	self.cooldowns = T
	self.iconFramePool = T
	self:LoadSettings(settings)
	return self
end

method = T

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
			self.settings.x, self.settings.y = this:GetCenter()
		end)
		frame:SetScript('OnClick', function() self:OnClick() end) -- TODO string lambdas?
		frame:SetScript('OnEnter', function() self:Tooltip() end)
		frame:SetScript('OnLeave', function() GameTooltip:Hide() end)
		frame:SetScript('OnUpdate', function() return self.settings.locked and self:Update() end)
		frame.cd_frames = T
	end
	for i = getn(self.frame.cd_frames) + 1, self.settings.size do
		tinsert(self.frame.cd_frames, self:CDFrame())
	end
	for i = self.settings.size + 1, getn(self.frame.cd_frames) do
		self.frame.cd_frames[i]:Hide()
	end
	for i = 1, self.settings.size do
		local cd_frame = self.frame.cd_frames[i]
		skin(cd_frame, self.settings.skin)
		cd_frame:EnableMouse(not self.settings.clickthrough)
		cd_frame.cooldown:SetSequenceTime(0, 1000)
	end
	if not self.frame.arrow then
		local arrow = self.frame.cd_frames[1]:CreateTexture(nil, 'OVERLAY')
		arrow:SetTexture([[Interface\Buttons\UI-SortArrow]])
		arrow:SetPoint('CENTER', 0, 0)
		arrow:SetWidth(9)
		arrow:SetHeight(8)
		self.frame.arrow = arrow
	end
end

do
	local apply = {
		blizzard = function(frame)
			frame:SetWidth(33.5)
			frame:SetHeight(33.5)

			frame.icon:SetWidth(30)
			frame.icon:SetHeight(30)
			frame.icon:SetTexCoord(.07, .93, .07, .93)

			frame.border:Show()
			frame.border:SetPoint('CENTER', .5, -.5)
			frame.border:SetWidth(56)
			frame.border:SetHeight(56)
			frame.border:SetTexture([[Interface\Buttons\UI-Quickslot2]])
			frame.border:SetTexCoord(0, 1, 0, 1)
			frame.border:SetVertexColor(1, 1, 1)

			frame.gloss:Hide()

			frame.cooldown:SetScale(32.5/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 15, 'THICKOUTLINE')
		end,
		zoomed = function(frame)
			frame:SetWidth(36)
			frame:SetHeight(36)

			frame.icon:SetWidth(36)
			frame.icon:SetHeight(36)
			frame.icon:SetTexCoord(.08, .92, .08, .92)

			frame.border:Hide()

			frame.gloss:Hide()

			frame.cooldown:SetScale(1.01)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 17, 'THICKOUTLINE')
		end,
		elvui = function(frame)
			frame:SetWidth(36.5)
			frame:SetHeight(36.5)

			frame.icon:SetWidth(36)
			frame.icon:SetHeight(36)
			frame.icon:SetTexCoord(.07,.93,.07,.93)

			frame.border:Show()
			frame.border:SetPoint('CENTER', 0, 0)
			frame.border:SetWidth(38)
			frame.border:SetHeight(38)
			frame.border:SetTexture([[Interface\Addons\cooldowns\Textures\elvui\Border]])
			frame.border:SetTexCoord(0, 1, 0, 1)
			frame.border:SetVertexColor(0, 0, 0)

			frame.gloss:Hide()

			frame.cooldown:SetScale(38/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 17, 'THICKOUTLINE')
		end,
		darion = function(frame)
			frame:SetWidth(34.5)
			frame:SetHeight(34.5)

			frame.icon:SetWidth(33)
			frame.icon:SetHeight(33)
			frame.icon:SetTexCoord(0, 1, 0, 1)

			frame.border:Show()
			frame.border:SetPoint('CENTER', 0, 0)
			frame.border:SetWidth(40)
			frame.border:SetHeight(40)
			frame.border:SetTexture([[Interface\Addons\cooldowns\Textures\darion\Border]])
			frame.border:SetTexCoord(0, 1, 0, 1)
			frame.border:SetVertexColor(.2, .2, .2)

			frame.gloss:Show()
			frame.gloss:SetWidth(40)
			frame.gloss:SetHeight(40)
			frame.gloss:SetTexture([[Interface\Addons\cooldowns\Textures\darion\Gloss]])
			frame.gloss:SetTexCoord(0, 1, 0, 1)

			frame.cooldown:SetScale(34/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 15, 'THICKOUTLINE')
		end,
	}
	function skin(frame, skin)
		apply[skin](frame)
	end
end

function method:CDFrame()
	local frame = CreateFrame('Frame', nil, self.frame)
	frame:SetScript('OnEnter', function()
		self:CDTooltip()
	end)
	frame:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	frame.icon = frame:CreateTexture(nil, 'BORDER')
	frame.icon:SetPoint('CENTER', 0, 0)

	frame.background = frame:CreateTexture(nil, 'BACKGROUND')
	frame.background:SetAllPoints(frame.icon)
	frame.background:SetTexture(unpack(self.color))
	frame.background:SetAlpha(.6)

	frame.border = frame:CreateTexture(nil, 'ARTWORK')
	frame.border:SetPoint('CENTER', 0, 0)

	frame.gloss = frame:CreateTexture(nil, 'OVERLAY')
	frame.gloss:SetPoint('CENTER', 0, 0)

	do
		local count_frame = CreateFrame('Frame', nil, frame)
		count_frame:SetFrameLevel(4)
		count_frame:SetAllPoints()
		frame.count = count_frame:CreateFontString()
		frame.count:SetPoint('CENTER', .7, 0)
	end

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
	frame.tooltip = T
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
	local sign = temp-O(
		'x', (strfind(orientation, 'R') and 1 or -1),
		'y', (strfind(orientation, 'U') and 1 or -1)
	)
	local anchor = (strfind(orientation, 'D') and 'TOP' or 'BOTTOM') .. (strfind(orientation, 'R') and 'LEFT' or 'RIGHT')

	local size = self.frame.cd_frames[1]:GetWidth()

	local spacing = self.settings.spacing * size
	local slotSize = size + spacing

	self.frame:SetWidth(size)
	self.frame:SetHeight(size)
	
	for i = 1, self.settings.size do
		local frame = self.frame.cd_frames[i]
		frame:ClearAllPoints()
		local offset = temp-O(
			axis1, sign[axis1] * mod(i - 1, self.settings.line) * slotSize,
			axis2, sign[axis2] * floor((i - 1) / self.settings.line) * slotSize
		)
		frame:SetPoint(anchor, offset.x, offset.y)
	end

	self.frame:ClearAllPoints()
	self.frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', self.settings.x, self.settings.y)
end

function method:Lock()
	self.frame:EnableMouse(false)
	self.frame.arrow:Hide()
	for i = 1, self.settings.size do
		local frame = self.frame.cd_frames[i]
		frame.background:Hide()
		frame:Hide()
	end
end

do
	ROTATIONS = {
		D = 0,
		R = 1,
		U = 2,
		L = 3,
	}
	function method:Unlock()
		self.frame:EnableMouse(true)
		self.frame.arrow:Show()
		self.frame.arrow:SetTexCoord(0, .5625, 0, 1)
		rotate(self.frame.arrow, ROTATIONS[strsub(self.settings.orientation, 1, 1)])
		for i = 1, self.settings.size do
			local frame = self.frame.cd_frames[i]
			frame:EnableMouse(false)
			frame.background:Show()
			frame.count:SetText('')
			frame.cooldown:SetAlpha(0)
			if i == 1 then
				frame.icon:SetTexture('')
			else
				frame.icon:SetTexture([[Interface\Icons\INV_Misc_QuestionMark]])
				frame.icon:SetAlpha(.6)
			end
			frame:Show()
		end
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
		for i, orientation in ipairs(ORIENTATIONS) do
			if orientation == self.settings.orientation then
				for _ = 1, (self.settings.size <= self.settings.line and 2 or 1) do
					i = mod(i, getn(ORIENTATIONS)) + 1
					self.settings.orientation = ORIENTATIONS[i]
				end
				break
			end
		end
	elseif arg1 == 'RightButton' then
		self.settings.locked = true
	end
	self:Configure()
end

function method:Ignored(name)
	return contains(strupper(self.settings.ignore_list), strupper(name))
end

function method:CDID(cooldown) return tostring(cooldown) end

function method:Update()
	local tm = GetTime()

	local cooldown_list = temp-T
	for _, cooldown in self.cooldowns do tinsert(cooldown_list, cooldown) end
	sort(cooldown_list, function(a, b) local ta, tb = a.started + a.duration - tm, b.started + b.duration - tm return ta < tb or tb == ta and a.name < b.name end)

	local i = 1
	for _, cooldown in ipairs(cooldown_list) do
		local timeLeft = cooldown.started + cooldown.duration - tm

		if timeLeft > 0 then
			if i <= self.settings.size and not self:Ignored(cooldown.name) then
				local frame = self.frame.cd_frames[i]
				do
					local alpha = timeLeft <= self.settings.blink and blink_alpha1(tm) or 1
					frame.icon:SetAlpha(alpha); frame.border:SetAlpha(alpha); frame.gloss:SetAlpha(alpha); frame.cooldown:SetAlpha(alpha)
				end
				frame.icon:SetTexture(cooldown.icon)
				frame.count:SetText(self.settings.count and time_text(timeLeft) or '')
				frame.cooldown.started, frame.cooldown.duration = cooldown.started, cooldown.duration
				release(frame.tooltip)
				frame.tooltip = A(cooldown.name, cooldown.info)
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
	local cooldown = O(
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
	cooldowns[CDID] = cooldowns[CDID] and release(cooldowns[CDID])
end

function rotate(tex, n)
	for i = 1, n do
	    local x1, y1, x2, y2, x3, y3, x4, y4 = tex:GetTexCoord()
	    tex:SetTexCoord(x3, y3, x1, y1, x4, y4, x2, y2)
    end
end

function blink_alpha1(t)
	local x = t * 4/3
	return (mod(floor(x), 2) == 0 and x - floor(x) or 1 - x + floor(x)) * .7 + .3
end

function blink_alpha2(t)
	return (sin(t * 240) + 1) / 2 * .7 + .3
end

do
	local DAY, HOUR, MINUTE = 86400, 3600, 60

	function time_text(t)
		if t > HOUR then
			return color_code(.7, .7, .7) .. ceil(t / HOUR * 10) / 10
		elseif t > MINUTE then
			return color_code(0, 1, 0) .. ceil(t / MINUTE * 10) / 10
		elseif t > 5 then
			return color_code(1, 1, 0) .. ceil(t)
		else
			return color_code(1, 0, 0) .. ceil(t)
		end
	end
end