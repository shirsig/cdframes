local m, public, private = CDFrames.module'frame'

CDFrames_Settings = {}

local ORIENTATIONS = {'R', 'D', 'L', 'U'}

local DEFAULT_SETTINGS = {
	active = true,
	locked = false,
	position = {UIParent:GetWidth()/2, UIParent:GetHeight()/2},
	orientation = 'R',
	size = 10,
	scale = 1,
	ignoreList = '',
	clickThrough = false,
}

function public.Frame(key, title, color)
	local self = {}
	for k, v in m.method do
		self[k] = v
	end

	self.key = key
	self.title = title
	self.color = color
	self.CDs = {}

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
			self:ButtonTooltip()
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

	for i=getn(self.frame.iconFrames)+1,self.settings.size do
		tinsert(self.frame.iconFrames, self:IconFrame(self.frame))
	end
end

function m.method:IconFrame(parent)
	local frame = CreateFrame('CheckButton', m.ID(), parent, 'ActionButtonTemplate')
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
	self.frame:SetScale(self.settings.scale * 0.85)

	local orientation = self.settings.orientation

	if CDFrames.In('U,D', orientation) then
		self.frame:SetWidth(40)
		self.frame:SetHeight(self.settings.size*40)
	elseif CDFrames.In('L,R', orientation) then
		self.frame:SetWidth(self.settings.size*40)
		self.frame:SetHeight(40)
	end
	
	for i, frame in self.frame.iconFrames do
		frame:ClearAllPoints()
		local offset = 2+(i-1)*(40)
		if orientation == 'U' then
			frame:SetPoint('BOTTOM', self.frame, 'BOTTOM', 0, offset)
		elseif orientation == 'D' then
			frame:SetPoint('TOP', self.frame, 'TOP', 0, -offset)
		elseif orientation == 'L' then
			frame:SetPoint('RIGHT', self.frame, 'RIGHT', -offset, 0)
		elseif orientation == 'R' then
			frame:SetPoint('LEFT', self.frame, 'LEFT', offset, 0)
		end
	end

	local x, y = unpack(self.settings.position)
	self.frame:ClearAllPoints()
	if CDFrames.In('U,R', orientation) then
		self.frame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', x - 20, y - 20)
	elseif CDFrames.In('D,L', orientation) then
		self.frame:SetPoint('TOPRIGHT', UIParent, 'BOTTOMLEFT', x + 20, y + 20)
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
		if i > self.settings.size then
			frame:Hide()
		else
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
end

function m.method:ButtonTooltip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:AddLine(self.title)
	GameTooltip:AddLine('Left-click/drag to position', .8, .8, .8)
	GameTooltip:AddLine('Right-click to lock', .8, .8, .8)
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
				self.settings.orientation = ORIENTATIONS[mod(i,4)+1]
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
	if CDFrames.In('U,R', self.settings.orientation) then
		self.settings.position = { self.frame:GetLeft() + 20, self.frame:GetBottom() + 20 }
	elseif CDFrames.In('D,L', self.settings.orientation) then
		self.settings.position = { self.frame:GetRight() - 20, self.frame:GetTop() - 20 }
	end
end

function m.method:Ignored(name)
	return CDFrames.In(strupper(self.settings.ignoreList), strupper(name))
end

function m.method:CDID(CD)
	return tostring(CD)
end

function m.method:Update()
	local t = GetTime()
	local i = 1

	local CDList = {}
	for _, CD in self.CDs do
		tinsert(CDList, CD)
	end
	sort(CDList, function(a, b) local ta, tb = a.expiration - t, b.expiration - t return ta < tb or tb == ta and a.name < b.name end)
	for _, CD in CDList do
		local timeleft = CD.expiration - t

		if timeleft > 0 then
			if i <= self.settings.size and not self:Ignored(CD.name) then
				local frame = self.frame.iconFrames[i]
				if timeleft <= 10 then
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

				frame.texture:SetTexture([[Interface\Icons\]]..CD.texture)
				frame.count:SetText(timeleft)
				frame:Show()

				frame.tooltip = {CD.name, CD.info}

				i = i + 1
			end
		else
			self.CDs[self:CDID(CD)] = nil
		end
	end

	while i <= getn(self.frame.iconFrames) do
		self.frame.iconFrames[i]:Hide()
		i = i + 1
	end	
end

function m.method:StartCD(name, info, texture, expiration)
	local CD = {
		name = name,
		info = info,
		texture = texture,
		expiration = expiration,
	}
	self.CDs[self:CDID(CD)] = CD
	return self:CDID(CD)
end

function m.method:CancelCD(CDID)
	self.CDs[CDID] = nil
end