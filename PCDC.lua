local PCDC = CreateFrame('Frame')
PCDC:SetScript('OnUpdate', function()
	this:UPDATE(arg1)
end)
PCDC:SetScript('OnEvent', function()
	this[event](this)
end)
PCDC:RegisterEvent('ADDON_LOADED')

function PCDC_ToggleStack(setPos)
	if (setPos == "Verti") then
		PCDC_Pos = "Verti";
		PCDC_Tex1:ClearAllPoints(); PCDC_Tex1:SetPoint("TOP", "PCDC_Frame", "BOTTOM", 0, 3);
		PCDC_Tex2:ClearAllPoints(); PCDC_Tex2:SetPoint("TOP", "PCDC_Tex1", "BOTTOM", 0, 0);
		PCDC_Tex3:ClearAllPoints(); PCDC_Tex3:SetPoint("TOP", "PCDC_Tex2", "BOTTOM", 0, 0);
		PCDC_Tex4:ClearAllPoints(); PCDC_Tex4:SetPoint("TOP", "PCDC_Tex3", "BOTTOM", 0, 0);
		PCDC_Tex5:ClearAllPoints(); PCDC_Tex5:SetPoint("TOP", "PCDC_Tex4", "BOTTOM", 0, 0);
		PCDC_Tex6:ClearAllPoints(); PCDC_Tex6:SetPoint("TOP", "PCDC_Tex5", "BOTTOM", 0, 0);
		PCDC_Tex7:ClearAllPoints(); PCDC_Tex7:SetPoint("TOP", "PCDC_Tex6", "BOTTOM", 0, 0);
		PCDC_Tex8:ClearAllPoints(); PCDC_Tex8:SetPoint("TOP", "PCDC_Tex7", "BOTTOM", 0, 0);
		PCDC_Tex9:ClearAllPoints(); PCDC_Tex9:SetPoint("TOP", "PCDC_Tex8", "BOTTOM", 0, 0);
		PCDC_Tex10:ClearAllPoints(); PCDC_Tex10:SetPoint("TOP", "PCDC_Tex9", "BOTTOM", 0, 0);
	elseif (setPos == "Hori") then
		PCDC_Pos = "Hori";
		PCDC_Tex1:ClearAllPoints(); PCDC_Tex1:SetPoint("LEFT", "PCDC_Frame", "RIGHT", 0, 0);
		PCDC_Tex2:ClearAllPoints(); PCDC_Tex2:SetPoint("LEFT", "PCDC_Tex1", "RIGHT", 0, 0);
		PCDC_Tex3:ClearAllPoints(); PCDC_Tex3:SetPoint("LEFT", "PCDC_Tex2", "RIGHT", 0, 0);
		PCDC_Tex4:ClearAllPoints(); PCDC_Tex4:SetPoint("LEFT", "PCDC_Tex3", "RIGHT", 0, 0);
		PCDC_Tex5:ClearAllPoints(); PCDC_Tex5:SetPoint("LEFT", "PCDC_Tex4", "RIGHT", 0, 0);
		PCDC_Tex6:ClearAllPoints(); PCDC_Tex6:SetPoint("LEFT", "PCDC_Tex5", "RIGHT", 0, 0);
		PCDC_Tex7:ClearAllPoints(); PCDC_Tex7:SetPoint("LEFT", "PCDC_Tex6", "RIGHT", 0, 0);
		PCDC_Tex8:ClearAllPoints(); PCDC_Tex8:SetPoint("LEFT", "PCDC_Tex7", "RIGHT", 0, 0);
		PCDC_Tex9:ClearAllPoints(); PCDC_Tex9:SetPoint("LEFT", "PCDC_Tex8", "RIGHT", 0, 0);
		PCDC_Tex10:ClearAllPoints(); PCDC_Tex10:SetPoint("LEFT", "PCDC_Tex9", "RIGHT", 0, 0);
	end
end

function PCDC_Click()
	if arg1 ~= 'LeftButton' then
		return
	end

	if (PCDC_Pos == "Hori") then
		PCDC_ToggleStack("Verti");
	elseif (PCDC_Pos == "Verti") then
		PCDC_ToggleStack("Hori");
	else
		PCDC_ToggleStack("Verti");
	end
end

function PCDC_Test()
	if arg1 ~= 'LeftButton' then
		return
	end

	PCDC:StartCooldown('temp', [[Interface\Icons\temp]], GetTime(), 7)
end

function PCDC_ToolTip(tooltipnum)
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:AddLine(PCDC_ToolTips[tooltipnum]);
	GameTooltip:AddLine(PCDC_ToolTipDetails[tooltipnum], .8, .8, .8, 1);
	GameTooltip:Show();
end

function PCDC_OnDragStart()
	PCDC_Frame:StartMoving()
end

function PCDC_OnDragStop()
	PCDC_Frame:StopMovingOrSizing()
end

SLASH_PCDC1 = '/pcdc'
function SlashCmdList.PCDC()
	PCDC_Locked = not PCDC_Locked
	if PCDC_Locked then
		PCDC_Button:Hide()
	else
		PCDC_Button:Show()
	end
end

function PCDC:ADDON_LOADED()
	if arg1 ~= 'PCDC' then
		return
	end

	PCDC_ToolTips = {}
	PCDC_ToolTipDetails = {}
	PCDC_UsedSkills = {}
	PCDC_UpdateInterval = 0.1
	PCDC_TimeSinceLastUpdate = 0

	PCDC_Button:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Abilities-Up.blp")

	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('SPELL_UPDATE_COOLDOWN')

	PCDC_ToggleStack(PCDC_Pos)
	if PCDC_Locked then
		PCDC_Button:Hide()
	end

	self:DetectCooldowns()
end

function PCDC:StartCooldown(name, texture, started, duration)
	-- for _, ignored_name in ignored do
	-- 	if strupper(name) == strupper(ignored_name) then
	-- 		return
	-- 	end
	-- end

	for i, skill in PCDC_UsedSkills do
		if skill.skill == name then
			tremove(PCDC_UsedSkills, i)
			break
		end
	end
	table.insert(PCDC_UsedSkills, {skill = name, info = '', texture = strsub(texture, 17), countdown = duration, started = started})
end

function PCDC:DetectCooldowns()	
    for bag=0,4 do
        if GetBagName(bag) then
            for slot = 1, GetContainerNumSlots(bag) do
				local started, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = self:LinkName(GetContainerItemLink(bag, slot))
					if duration == 0 or duration > 3 and duration <= 3600 then
						self:StartCooldown(
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
			if duration == 0 or duration > 3 and duration <= 3600 then
				self:StartCooldown(
					name,
					GetInventoryItemTexture('player', slot),
					started,
					duration
				)
			end
		end
	end
	
	local _, _, offset, spellCount = GetSpellTabInfo(GetNumSpellTabs())
	local totalSpells = offset + spellCount
	for id=1,totalSpells do
		local started, duration, enabled = GetSpellCooldown(id, BOOKTYPE_SPELL)
		local name = GetSpellName(id, BOOKTYPE_SPELL)
		if duration == 0 or enabled == 1 and duration > 2.5 then
			self:StartCooldown(
				name,
				GetSpellTexture(id, BOOKTYPE_SPELL),
				started,
				duration
			)
		end
	end
end

function PCDC:BAG_UPDATE_COOLDOWN()
	self:DetectCooldowns()
end

function PCDC:SPELL_UPDATE_COOLDOWN()
	self:DetectCooldowns()
end

function PCDC:UPDATE(elapsed)
	PCDC_TimeSinceLastUpdate = PCDC_TimeSinceLastUpdate + elapsed;
	if (PCDC_TimeSinceLastUpdate > PCDC_UpdateInterval) then
		PCDC_TimeSinceLastUpdate = 0;
		-- Spit out the infoz
		local i = 1;

		local temp = {}
		sort(PCDC_UsedSkills, function(a, b) local ta, tb = a.countdown - (GetTime() - a.started), b.countdown - (GetTime() - b.started) return tb < ta or tb == ta and a.skill < b.skill end)
		for k, v in PCDC_UsedSkills do
			local timeleft = ceil(v.countdown - (GetTime() - v.started))
			--	  Only show CD for our target if there is time left on the CD      Loop through Stuff           Warrior enrage isnt a CD, Druid Enrage is!
			if timeleft > 0 and timeleft <= 600 then
				tinsert(temp, v)

				if i <= 10 then
					PCDC_ToolTips[i] = v.skill;
					PCDC_ToolTipDetails[i] = v.info;
					if timeleft > 60 then
						timeleft = floor((timeleft/60)*10)/10;
						getglobal("PCDC_CD"..i):SetTextColor(0, 1, 0);
					else
						getglobal("PCDC_CD"..i):SetTextColor(1, 1, 0);
					end
					getglobal("PCDC_CD"..i):SetText(timeleft);
					getglobal("PCDC_Tex"..i):SetTexture([[Interface\Icons\]]..v.texture);
					getglobal("PCDC_Frame"..i):Show();
					getglobal("PCDC_CD"..i):Show();
					getglobal("PCDC_Tex"..i):Show();
					i = i + 1;
				end
			end
		end
		PCDC_UsedSkills = temp

		while i <= 10 do
			getglobal("PCDC_Frame"..i):Hide();
			getglobal("PCDC_CD"..i):Hide();
			getglobal("PCDC_Tex"..i):Hide();
			i = i + 1;
		end
	end
end

function PCDC:LinkName(link)
    local _, _, name = strfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h')
    return name
end