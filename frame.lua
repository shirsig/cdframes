CDFrames_Settings = {}

local BORDERLESS_ICONS = 'INV_Misc_ArmorKit_04'

local ORIENTATIONS = {'R', 'D', 'L', 'U'}

local DEFAULT_SETTINGS = {
	active = true,
	locked = false,
	position = {UIParent:GetWidth()/2, UIParent:GetHeight()/2},
	orientation = 'R',
	ignoreList = '',
	clickThrough = false,
}

local method = {}

function method:LoadSettings()
	if not CDFrames_Settings[self.key] then
		self:CreateSettings()
	end
	self.settings = CDFrames_Settings[self.key]
	self:ApplySettings()
end

function method:CreateSettings()
	CDFrames_Settings[self.key] = {}
	for k, v in DEFAULT_SETTINGS do
		CDFrames_Settings[self.key][k] = v
	end
end

function method:CreateFrames()
	local frame = CreateFrame('Frame', nil, UIParent)
	self.frame = frame
	frame:SetWidth(32)
	frame:SetHeight(32)
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
		self:OnDragStart()
	end)
	frame.button:SetScript('OnDragStop', function()
		self:OnDragStop()
	end)
	frame.button:SetScript('OnClick', function()
		self:OnClick()
	end)
	frame.button:SetScript('OnEnter', function()
		self:ButtonTooltip()
	end)
	frame.button:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	frame.iconFrames = {}
	for i=1,10 do
		tinsert(frame.iconFrames, self:IconFrame(frame))
	end

	frame:SetScript('OnUpdate', function()
		if self.settings.locked then
			self:Update()
		end
	end)
end

function method:IconFrame(parent)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetWidth(32)
	frame:SetHeight(32)
	frame:SetScript('OnEnter', function()
		self:CDTooltip()
	end)
	frame:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	frame.texture = frame:CreateTexture()
	frame.texture:SetPoint('BOTTOM', 0, 1)
	frame.texture:SetPoint('LEFT', 1, 0)
	frame.texture:SetPoint('TOP', 0, -1)
	frame.texture:SetPoint('RIGHT', -1, 0)

	frame.border = frame:CreateTexture(nil, 'OVERLAY')
	frame.border:SetTexture([[Interface\Buttons\UI-Quickslot2]])
	frame.border:SetWidth(53)
	frame.border:SetHeight(53)
	frame.border:SetPoint('CENTER', 0, 0)

	frame.count = frame:CreateFontString()
	frame.count:SetFont([[Fonts\ARIALN.TTF]], 14, 'THICKOUTLINE')
	frame.count:SetWidth(32)
	frame.count:SetHeight(12)
	frame.count:SetPoint('BOTTOM', 0, 10)

	return frame
end

function method:ApplySettings()
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

	for _, frame in self.frame.iconFrames do
		frame:EnableMouse(not self.settings.clickThrough)
	end

	self:PlaceFrames()
end

function method:PlaceFrames()
	self.frame:SetPoint('BOTTOMLEFT', unpack(self.settings.position))
	for i, frame in self.frame.iconFrames do
		frame:ClearAllPoints()
		local orientation, offset = self.settings.orientation, (i-1)*32
		if orientation == 'U' then
			frame:SetPoint('BOTTOM', self.frame, 'TOP', 0, offset-3)
		elseif orientation == 'D' then
			frame:SetPoint('TOP', self.frame, 'BOTTOM', 0, 3-offset)
		elseif orientation == 'L' then
			frame:SetPoint('RIGHT', self.frame, 'LEFT', -offset, 0)
		elseif orientation == 'R' then
			frame:SetPoint('LEFT', self.frame, 'RIGHT', offset, 0)
		end
	end
end

function method:Lock()
	self.frame.button:Hide()
	for _, frame in self.frame.iconFrames do
		frame:Hide()
	end
end

function method:Unlock()
	self.frame.button:Show()
	for i, frame in self.frame.iconFrames do
		frame.tooltip = {'test'..i, 'test'..i}
		frame.texture:SetTexture([[Interface\Icons\temp]])
		frame.count:SetText()
		frame:Show()
	end
end

function method:ButtonTooltip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:AddLine(self.title)
	GameTooltip:AddLine('Left-click/drag to position', .8, .8, .8)
	GameTooltip:AddLine('Right-click to lock', .8, .8, .8)
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
				self.settings.orientation = ORIENTATIONS[mod(i,4)+1]
				break
			end
		end
		self:PlaceFrames()
	elseif arg1 == 'RightButton' then
		self.settings.locked = true
		self:ApplySettings()
	end
end

function method:OnDragStart()
	self.frame:StartMoving()
end

function method:OnDragStop()
	self.frame:StopMovingOrSizing()
	self.settings.position = {self.frame:GetLeft(), self.frame:GetBottom()}
end

function method:Ignored(name)
	for entry in string.gfind(self.settings.ignoreList, '[^,]+') do
		if strupper(entry) == strupper(name) then
			return true
		end
	end
end

function method:CDID(CD)
	return tostring(CD)
end

function method:Update()
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
			if i <= 10 and not self:Ignored(CD.name) then
				local frame = self.frame.iconFrames[i]
				if timeleft <= 10 then
					local x = t*4/3
					frame.texture:SetAlpha((mod(floor(x),2) == 0 and x-floor(x) or 1-x+floor(x))*0.7+0.3)
					-- frame.texture:SetAlpha((math.sin(t*4/3*math.pi)+1)/2*0.7+0.3)
				else
					frame.texture:SetAlpha(1)
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

	while i <= 10 do
		self.frame.iconFrames[i]:Hide()
		i = i + 1
	end	
end

function method:StartCD(name, info, texture, expiration)
	local CD = {
		name = name,
		info = info,
		texture = texture,
		expiration = expiration,
	}
	self.CDs[self:CDID(CD)] = CD
	return self:CDID(CD)
end

function method:CancelCD(CDID)
	self.CDs[CDID] = nil
end

function CDFrames:Frame(key, title)
	local frame = {}
	for k, v in method do
		frame[k] = v
	end

	frame.key = key
	frame.title = title
	frame.CDs = {}

	frame:CreateFrames()
	frame:LoadSettings()

	return frame
end