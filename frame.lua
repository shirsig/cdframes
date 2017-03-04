module 'cdframes.frame'

include 'T'
include 'cdframes'

local cdframes_player = require 'cdframes.player'
local cdframes_other = require 'cdframes.other'

local ORIENTATIONS = {'RU', 'RD', 'DR', 'DL', 'LD', 'LU', 'UL', 'UR'}

local DEFAULT_SETTINGS = {
	locked = false,
	x = UIParent:GetCenter(),
	y = (temp-A(UIParent:GetCenter()))[2],
	scale = 1,
	size = 15,
	line = 8,
	spacing = .1,
	orientation = 'RU',
	skin = 'darion',
	count = true,
	blink = 0,
	shadow = false,
	ignore_list = '',
}

local frames = {}

do
	local t = {
		blizzard = function(frame)
			frame:SetWidth(33.5)
			frame:SetHeight(33.5)

			frame.icon:SetWidth(30)
			frame.icon:SetHeight(30)
			frame.icon:SetTexCoord(.07, .93, .07, .93)

			frame.border:SetPoint('CENTER', .5, -.5)
			frame.border:SetWidth(56)
			frame.border:SetHeight(56)
			frame.border:SetTexture([[Interface\Buttons\UI-Quickslot2]])
			frame.border:SetVertexColor(1, 1, 1)

			frame.gloss:SetTexture()

			frame.cooldown:SetScale(32.5/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 15, 'THICKOUTLINE')
		end,
		zoomed = function(frame)
			frame:SetWidth(36)
			frame:SetHeight(36)

			frame.icon:SetWidth(36)
			frame.icon:SetHeight(36)
			frame.icon:SetTexCoord(.08, .92, .08, .92)

			frame.border:SetTexture()

			frame.gloss:SetTexture()

			frame.cooldown:SetScale(1.01)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 17, 'THICKOUTLINE')
		end,
		elvui = function(frame)
			frame:SetWidth(36.5)
			frame:SetHeight(36.5)

			frame.icon:SetWidth(36)
			frame.icon:SetHeight(36)
			frame.icon:SetTexCoord(.07, .93, .07, .93)

			frame.border:SetPoint('CENTER', 0, 0)
			frame.border:SetWidth(38)
			frame.border:SetHeight(38)
			frame.border:SetTexture([[Interface\Addons\cdframes\Textures\elvui\Border]])
			frame.border:SetVertexColor(0, 0, 0)

			frame.gloss:SetTexture()

			frame.cooldown:SetScale(38/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 17, 'THICKOUTLINE')
		end,
		darion = function(frame)
			frame:SetWidth(34.5)
			frame:SetHeight(34.5)

			frame.icon:SetWidth(33)
			frame.icon:SetHeight(33)
			frame.icon:SetTexCoord(0, 1, 0, 1)

			frame.border:SetPoint('CENTER', 0, 0)
			frame.border:SetWidth(40)
			frame.border:SetHeight(40)
			frame.border:SetTexture([[Interface\Addons\cdframes\Textures\darion\Border]])
			frame.border:SetVertexColor(.2, .2, .2)

			frame.gloss:SetWidth(40)
			frame.gloss:SetHeight(40)
			frame.gloss:SetTexture([[Interface\Addons\cdframes\Textures\darion\Gloss]])

			frame.cooldown:SetScale(34/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 15, 'THICKOUTLINE')
		end,
		modui = function(frame)
			frame:SetWidth(33)
			frame:SetHeight(33)

			frame.icon:SetWidth(30)
			frame.icon:SetHeight(30)
			frame.icon:SetTexCoord(0, 1, 0, 1)

			frame.border:SetPoint('CENTER', 0, 0)
			frame.border:SetWidth(38.5)
			frame.border:SetHeight(38.5)
			frame.border:SetTexture([[Interface\Addons\cdframes\Textures\modui\Border]])
			frame.border:SetVertexColor(.22, .22, .22)

			frame.gloss:SetTexture()

			frame.cooldown:SetScale(32.5/36)

			frame.count:SetFont([[Fonts\ARIALN.ttf]], 15, 'THICKOUTLINE')
		end,
	}
	function apply_skin(frame, skin)
		t[skin](frame)
	end
end

function M.load(key, settings)
	frames[key] = frames[key] or O('title', key)
	local self = frames[key]
	self.unit = loadstring('return ' .. settings.code)
	for k, v in DEFAULT_SETTINGS do
		if settings[k] == nil then settings[k] = v end
	end
	self.settings = settings
	configure(self)
end

function create_frames(self)
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
		frame:SetScript('OnClick', function() click(self) end)
		frame:SetScript('OnEnter', function() tooltip(self) end)
		frame:SetScript('OnLeave', function() GameTooltip:Hide() end)
		frame:SetScript('OnUpdate', function() update(self) end)
		frame.cd_frames = T
	end
	for i = getn(self.frame.cd_frames) + 1, self.settings.size do
		tinsert(self.frame.cd_frames, cdframe(self))
	end
	for i = self.settings.size + 1, getn(self.frame.cd_frames) do
		self.frame.cd_frames[i]:Hide()
	end
	for i = 1, self.settings.size do
		local cd_frame = self.frame.cd_frames[i]
		apply_skin(cd_frame, self.settings.skin)
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

function cdframe(self)
	local frame = CreateFrame('Frame', nil, self.frame)

	frame.icon = frame:CreateTexture(nil, 'BORDER')
	frame.icon:SetPoint('CENTER', 0, 0)

	frame.background = frame:CreateTexture(nil, 'BACKGROUND')
	frame.background:SetAllPoints(frame.icon)
	frame.background:SetTexture(0, 0, 0)
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
			if self.settings.shadow and this.started then
				local progress = (GetTime() - this.started) / this.duration
				this:SetSequenceTime(0, (1 - progress) * 1000)
			end
		end)
		cooldown:Show()
		frame.cooldown = cooldown
	end

	return frame
end

function configure(self)
	create_frames(self)
	self.frame:Show()
	if self.settings.locked then lock(self) else unlock(self) end
	place_frames(self)
end

function place_frames(self)
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

function lock(self)
	self.frame:EnableMouse(false)
	self.frame.arrow:Hide()
	for i = 1, self.settings.size do
		local frame = self.frame.cd_frames[i]
		frame.background:Hide()
		frame:Hide()
	end
end

do
	local ROTATIONS = {
		D = 0,
		R = 1,
		U = 2,
		L = 3,
	}
	local function rotate_texture(tex, n)
		for i = 1, n do
			local x1, y1, x2, y2, x3, y3, x4, y4 = tex:GetTexCoord()
			tex:SetTexCoord(x3, y3, x1, y1, x4, y4, x2, y2)
		end
	end
	function unlock(self)
		self.frame:EnableMouse(true)
		self.frame.arrow:Show()
		self.frame.arrow:SetTexCoord(0, .5625, 0, 1)
		rotate_texture(self.frame.arrow, ROTATIONS[strsub(self.settings.orientation, 1, 1)])
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

function tooltip(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:AddLine(self.title)
	GameTooltip:AddLine('<Left Drag> move', 1, 1, 1)
	GameTooltip:AddLine('<Left Click> turn', 1, 1, 1)
	GameTooltip:AddLine('<Right Click> lock', 1, 1, 1)
	GameTooltip:Show()
end

function click(self)
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
	configure(self)
end

function update(self)
	if not self.settings.locked then
		return
	end

	local cooldowns
	if self.unit() == UnitName'player' then
		cooldowns = cdframes_player.cooldowns
	else
		cooldowns = cdframes_other.cooldowns(self.unit())
	end

	local tm = GetTime()

	local cooldown_list = temp-T
	for _, cooldown in cooldowns do
		if not contains(self.settings.ignore_list, strupper(cooldown.name)) then
			tinsert(cooldown_list, cooldown)
		end
	end
	sort(cooldown_list, function(a, b)
		local ta, tb = a.started + a.duration - tm, b.started + b.duration - tm
		return tb < ta or tb == ta and a.name < b.name
	end)

	for i = 1, min(getn(cooldown_list), self.settings.size) do
		local frame, cooldown = self.frame.cd_frames[i], cooldown_list[i]
		local time_left = cooldown.started + cooldown.duration - tm
		do
			local alpha = time_left <= self.settings.blink and blink_alpha(tm) or 1
			frame.icon:SetAlpha(alpha); frame.border:SetAlpha(alpha); frame.gloss:SetAlpha(alpha); frame.cooldown:SetAlpha(alpha)
		end
		frame.icon:SetTexture(cooldown.icon)
		frame.count:SetText(self.settings.count and time_text(time_left) or '')
		frame.cooldown.started, frame.cooldown.duration = cooldown.started, cooldown.duration
		frame:Show()
	end
	for i = getn(cooldown_list) + 1, self.settings.size do
		self.frame.cd_frames[i]:Hide()
	end
end

function blink_alpha(t)
	local x = t * 4/3
	return (mod(floor(x), 2) == 0 and x - floor(x) or 1 - x + floor(x)) * .7 + .3
end

--function blink_alpha(t)
--	return (sin(t * 240) + 1) / 2 * .7 + .3
--end

do
	local DAY, HOUR, MINUTE = 86400, 3600, 60
	local function color_code(r, g, b)
		return format('|cFF%02X%02X%02X', r*255, g*255, b*255)
	end
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
