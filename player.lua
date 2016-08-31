CDFrames 'player'

function private.BAG_UPDATE_COOLDOWN()
	M.DetectItemCooldowns()
end

function private.SPELL_UPDATE_COOLDOWN()
	M.DetectSpellCooldowns()
end

function public.Setup()
	CDFrames_Settings.PLAYER = CDFrames_Settings.PLAYER or {}
	public.frame = CDFrames.frame.New('Player Cooldowns', {.35, .85, .35}, CDFrames_Settings.PLAYER)

	private.events = CreateFrame('Frame')
	M.events:SetScript('OnEvent', function() M[event]() end)
	M.events:RegisterEvent('BAG_UPDATE_COOLDOWN')
	M.events:RegisterEvent('SPELL_UPDATE_COOLDOWN')

	M.DetectItemCooldowns()
	M.DetectSpellCooldowns()
end

do
	activeCooldowns = {}

	function private.StartCD(name, texture, started, duration)
		if activeCooldowns[name] then
			M.frame:CancelCD(activeCooldowns[name])
		end
		activeCooldowns[name] = M.frame:StartCD(name, '', texture, started, duration)
	end

	function private.StopCD(name)
		if activeCooldowns[name] then
			M.frame:CancelCD(activeCooldowns[name])
		end
	end
end

function private.LinkName(link)
	for name in string.gfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h') do
		return name
	end
end

function private.DetectItemCooldowns()	
    for bag=0,4 do
        if GetBagName(bag) then
            for slot = 1, GetContainerNumSlots(bag) do
				local started, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = M.LinkName(GetContainerItemLink(bag, slot))
					if duration > 3 and duration <= 1800 and GetItemInfo(6948) ~= name then
						M.StartCD(
							name,
							GetContainerItemInfo(bag, slot),
							started,
							duration
						)
					elseif duration == 0 then
						M.StopCD(started)
					end
				end
            end
        end
    end
	for slot=0,19 do
		local started, duration, enabled = GetInventoryItemCooldown('player', slot)
		if enabled == 1 then
			local name = M.LinkName(GetInventoryItemLink('player', slot))
			if duration > 3 and duration <= 1800 then
				M.StartCD(
					name,
					GetInventoryItemTexture('player', slot),
					started,
					duration
				)
			elseif duration == 0 then
				M.StopCD(started)
			end
		end
	end
end

function private.DetectSpellCooldowns()	
	local _, _, offset, spellCount = GetSpellTabInfo(GetNumSpellTabs())
	local totalSpells = offset + spellCount
	for id=1,totalSpells do
		local started, duration, enabled = GetSpellCooldown(id, BOOKTYPE_SPELL)
		local name = GetSpellName(id, BOOKTYPE_SPELL)
		if enabled == 1 and duration > 2.5 then
			M.StartCD(
				name,
				GetSpellTexture(id, BOOKTYPE_SPELL),
				started,
				duration
			)
		elseif duration == 0 then
			M.StopCD(name)
		end
	end
end