local m, public, private = CDFrames.module'frame'

CDFrames_Settings = {}

local BASE_SCALE = 0.85
local ORIENTATIONS = {'RU', 'RD', 'DR', 'DL', 'LD', 'LU', 'UL', 'UR'}

local DEFAULT_SETTINGS = {
	active = true,
	locked = false,
	position = {UIParent:GetWidth()/2/BASE_SCALE, UIParent:GetHeight()/2/BASE_SCALE},
	scale = 1,
	size = {8, 2},
	orientation = 'RU',
	ignoreList = '',
	blink = 10,
	clickThrough = false,
}

function public.New(key, title, color)
	local self = {}
	for k, v in m.method do
		self[k] = v
	end

	self.key = key
	self.title = title
	self.color = color
	self.cooldowns = {}
	self.iconFramePool = {}

	self:LoadSettings()
	self:Initialize()

	return self
end

do
	local x = 0

	function private.ID()
		x = x + 1
		return 'CDFrames_Frame'..x
	end
end

private.method = {}

function m.method:LoadSettings()
	if not CDFrames_Settings[self.key] then
		self:CreateSettings()
	end
	self.settings = CDFrames_Settings[self.key]
end

function m.method:CreateSettings()
	CDFrames_Settings[self.key] = {}
	for k, v in DEFAULT_SETTINGS do
		CDFrames_Settings[self.key][k] = v
	end
end

function m.method:CreateFrames()
	if not self.frame then
		local frame = CreateFrame('Button', tostring({}), UIParent)
		frame:SetMovable(true)
		frame:SetToplevel(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag('LeftButton')
		frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame:SetScript('OnDragStart', function()
			self:OnDragStart()
		end)
		frame:SetScript('OnDragStop', function()
			self:OnDragStop()
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
		self.frame = frame
	end

	local count = self.settings.size[1]*self.settings.size[2]

	while getn(self.frame.iconFrames) > count do
		local frame = tremove(self.frame.iconFrames)
		frame:Hide()
		tinsert(self.iconFramePool, frame)
	end
	for i=getn(self.frame.iconFrames)+1,count do
		tinsert(self.frame.iconFrames, self:IconFrame())
	end
end

function m.method:IconFrame()
	if getn(self.iconFramePool) > 0 then
		return tremove(self.iconFramePool)
	end

	local frame = CreateFrame('CheckButton', m.ID(), self.frame, 'ActionButtonTemplate')
	frame:SetHighlightTexture(nil)
	frame:RegisterForClicks()
	frame:SetScript('OnEnter', function()
		self:CDTooltip()
	end)
	frame:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	frame.texture = getglobal(frame:GetName()..'Icon')
	frame.texture:SetTexCoord(0.06,0.94,0.06,0.94)

	frame.border = frame:GetNormalTexture()

	frame.count = frame:CreateFontString()
	frame.count:SetJustifyH('CENTER')
	frame.count:SetWidth(38)
	frame.count:SetHeight(12)

	return frame
end

function m.method:Initialize()
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

function m.method:PlaceFrames()
	self.frame:SetScale(self.settings.scale * BASE_SCALE)

	local orientation = self.settings.orientation
	local primarySize, secondarySize = unpack(self.settings.size)

	if CDFrames.In('UL,UR,DL,DR', orientation) then
		self.frame:SetWidth(secondarySize*40)
		self.frame:SetHeight(primarySize*40)
	elseif CDFrames.In('LU,LD,RU,RD', orientation) then
		self.frame:SetWidth(primarySize*40)
		self.frame:SetHeight(secondarySize*40)
	end
	
	for i, frame in self.frame.iconFrames do
		frame:ClearAllPoints()
		local primaryOffset = 2+mod(i-1, primarySize)*40
		local secondaryOffset = 2+floor((i-1)/primarySize)*40

		if orientation == 'UL' then
			frame:SetPoint('BOTTOMRIGHT', -secondaryOffset, primaryOffset)
		elseif orientation == 'UR' then
			frame:SetPoint('BOTTOMLEFT', secondaryOffset, primaryOffset)
		elseif orientation == 'DL' then
			frame:SetPoint('TOPRIGHT', -secondaryOffset, -primaryOffset)
		elseif orientation == 'DR' then
			frame:SetPoint('TOPLEFT', secondaryOffset, -primaryOffset)
		elseif orientation == 'LU' then
			frame:SetPoint('BOTTOMRIGHT', -primaryOffset, secondaryOffset)
		elseif orientation == 'LD' then
			frame:SetPoint('TOPRIGHT', -primaryOffset, -secondaryOffset)
		elseif orientation == 'RU' then
			frame:SetPoint('BOTTOMLEFT', primaryOffset, secondaryOffset)
		elseif orientation == 'RD' then
			frame:SetPoint('TOPLEFT', primaryOffset, -secondaryOffset)
		end
	end

	local x, y = unpack(self.settings.position)
	self.frame:ClearAllPoints()
	if CDFrames.In('UR,RU', orientation) then
		self.frame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', x-20, y-20)
	elseif CDFrames.In('UL,LU', orientation) then
		self.frame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', x+20, y-20)
	elseif CDFrames.In('DR,RD', orientation) then
		self.frame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', x-20, y+20)
	elseif CDFrames.In('DL,LD', orientation) then
		self.frame:SetPoint('TOPRIGHT', UIParent, 'BOTTOMLEFT', x+20, y+20)
	end
end

function m.method:Lock()
	self.frame:EnableMouse(false)
	for _, frame in self.frame.iconFrames do
		frame:EnableMouse(not self.settings.clickThrough)
		frame.border:SetVertexColor(1, 1, 1)
		frame.texture:SetBlendMode('BLEND')
		frame.count:SetFont([[Fonts\ARIALN.ttf]], 16, 'THICKOUTLINE')
		frame.count:SetShadowOffset(0, 0)
		frame.count:SetPoint('CENTER', 0, 0)
		frame:Hide()
	end
end

function m.method:Unlock()
	self.frame:EnableMouse(true)
	for i, frame in self.frame.iconFrames do
		frame:EnableMouse(false)
		frame.texture:SetAlpha(1)
		frame.border:SetAlpha(1)
		frame.texture:SetTexture(unpack(self.color))
		frame.border:SetVertexColor(unpack(self.color))
		frame.texture:SetBlendMode('ADD')
		frame.count:SetFont([[Fonts\FRIZQT__.ttf]], 16)
		frame.count:SetShadowOffset(1, -1)
		frame.count:SetTextColor(1, 1, 1)
		frame.count:SetText(i)
		frame.count:SetPoint('CENTER', -1, 0)
		frame:Show()
	end
end

function m.method:Tooltip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:AddLine(self.title)
	GameTooltip:AddLine('<Left Drag> move', 1, 1, 1)
	GameTooltip:AddLine('<Left Click> change orientation', 1, 1, 1)
	GameTooltip:AddLine('<Right Click> lock', 1, 1, 1)
	GameTooltip:Show()
end

function m.method:CDTooltip()
	GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
	GameTooltip:AddLine(this.tooltip[1])
	GameTooltip:AddLine(this.tooltip[2], .8, .8, .8, 1)
	GameTooltip:Show()
end

function m.method:OnClick()
	if arg1 == 'LeftButton' then
		for i, orientation in ORIENTATIONS do
			if orientation == self.settings.orientation then
				self.settings.orientation = ORIENTATIONS[mod(i,getn(ORIENTATIONS))+1]
				break
			end
		end
		self:PlaceFrames()
	elseif arg1 == 'RightButton' then
		self.settings.locked = true
		self:Initialize()
	end
end

function m.method:OnDragStart()
	self.frame:StartMoving()
end

function m.method:OnDragStop()
	self.frame:StopMovingOrSizing()
	self.settings.position = {self.frame.iconFrames[1]:GetCenter()}
end

function m.method:Ignored(name)
	return CDFrames.In(strupper(self.settings.ignoreList), strupper(name))
end

function m.method:CDID(cooldown)
	return tostring(cooldown)
end

function m.method:Update()
	local t = GetTime()
	local i = 1

	local cooldownList = {}
	for _, cooldown in self.cooldowns do
		tinsert(cooldownList, cooldown)
	end
	sort(cooldownList, function(a, b) local ta, tb = a.expiration-t, b.expiration-t return ta < tb or tb == ta and a.name < b.name end)
	for _, cooldown in cooldownList do
		local timeleft = cooldown.expiration-t

		if timeleft > 0 then
			if i <= getn(self.frame.iconFrames) and not self:Ignored(cooldown.name) then
				local frame = self.frame.iconFrames[i]
				if timeleft <= self.settings.blink then
					local x = t*4/3
					local a = (mod(floor(x),2) == 0 and x-floor(x) or 1-x+floor(x))*0.7+0.3
					frame.texture:SetAlpha(a)
					frame.border:SetAlpha(a)
					-- frame:SetAlpha((math.sin(t*4/3*math.pi)+1)/2*0.7+0.3)
				else
					frame.texture:SetAlpha(1)
					frame.border:SetAlpha(1)
				end

				timeleft = ceil(timeleft)
				if timeleft >= 60 then
					timeleft = ceil((timeleft/60)*10)/10
					frame.count:SetTextColor(0, 1, 0)
				else
					frame.count:SetTextColor(1, 1, 0)
				end

				frame.texture:SetTexture([[Interface\Icons\]]..cooldown.texture)
				frame.count:SetText(timeleft)
				frame:Show()

				frame.tooltip = {cooldown.name, cooldown.info}

				i = i+1
			end
		else
			self.cooldowns[self:CDID(cooldown)] = nil
		end
	end

	while i <= getn(self.frame.iconFrames) do
		self.frame.iconFrames[i]:Hide()
		i = i+1
	end	
end

function m.method:StartCD(name, info, texture, expiration)
	local cooldown = {
		name = name,
		info = info,
		texture = texture,
		expiration = expiration,
	}
	self.cooldowns[self:CDID(cooldown)] = cooldown
	return self:CDID(cooldown)
end

function m.method:CancelCD(CDID)
	self.cooldowns[CDID] = nil
end