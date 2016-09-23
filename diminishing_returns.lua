cooldowns 'diminishing_returns'

local PATTERNS = {
	"You cast (.+) on (.+)%.",
	".+ casts (.+) on (.+)%.",
}

local DIMINISHING_RETURN = {
	["Bash"] = { class=1, duration=.999, icon='' },
	["Hammer of Justice"] = { class=1, duration=.999, icon='' },
	["Cheap Shot"] = { class=1, duration=.999, icon='' },
	["Charge Stun"] = { class=1, duration=4, icon='' },
	["Intercept Stun"] = { class=1, duration=3, icon='' },
	["Concussion Blow"] = { class=1, duration=5, icon='' },

	["Fear"] = { class=2, duration=10, icon=[[Interface\Icons\Spell_Shadow_Possession]] },
	["Howl of Terror"] = { class=2, duration=10, icon='' },
	["Seduction"] = { class=2, duration=15, icon='' },
	["Intimidating Shout"] = { class=2, duration=.999, icon='' },
	["Psychic Scream"] = { class=2, duration=8, icon=[[Interface\Icons\Spell_Shadow_PsychicScream]] },

	["Polymorph"] = { class=3, duration=15, icon=[[Interface\Icons\Spell_Nature_Polymorph]] },
	["Sap"] = { class=3, duration=15, icon='' },
	["Gouge"] = { class=3, duration=4, icon='' },

	["Entangling Roots"] = { class=4, duration=12, icon='' },
	["Frost Nova"] = { class=4, duration=8, icon='' },

	["Blind"] = { class=5, duration=10, icon='' },

	["Hibernate"] = { class=6, duration=20, icon='' },

	["Mind Control"] = { class=7, duration=.999, icon='' },

	["Kidney Shot"] = { class=8, duration=.999, icon='' },

	["Death Coil"] = { class=9, duration=3, icon='' },

	--frost shock? TODO
}

local LABEL = { color_code(1, 1, 0) .. '½', color_code(1, .5, 0) .. '¼', color_code(1, 0, 0) .. '0' }

function public.setup()
	cooldowns_settings.TARGET_DR = cooldowns_settings.TARGET_DR or T('animation', true)
	public.frame = cooldowns.frame.new('Target Diminishing Returns', A(.5, .5, .5), cooldowns_settings.TARGET_DR)
	do
		local frame = CreateFrame('Frame')
		frame:SetScript('OnEvent', function() _E[event]() end)
		frame:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
		frame:RegisterEvent('CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE')
		frame:RegisterEvent('CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE')
		frame:RegisterEvent('PLAYER_TARGET_CHANGED')
	end
end

do
	local diminishing_returns = t
	function private.diminishing_returns.get()
		local time = GetTime()
		for k, v in diminishing_returns do
			if time - v.started > 15 then
				diminishing_returns[k] = nil
			end
		end
		return diminishing_returns
	end
end

function private.show(frame, key)
	local dr = diminishing_returns[key]
	if not dr[frame] then
		dr[frame] = frame:StartCD('', '', dr.icon, dr.started, dr.duration, LABEL[min(3, dr.level)])
	end
end

function private.hide(frame, key)
	local dr = diminishing_returns[key]
	if dr[frame] then
		frame:CancelCD(dr[frame])
		dr[frame] = nil
	end
end

function private.start(player, spell)
	if not DIMINISHING_RETURN[spell] then return end
	local diminishing_returns = diminishing_returns
	local key = DIMINISHING_RETURN[spell].class .. player
	if diminishing_returns[key] then
		hide(frame, key)
	end
	diminishing_returns[key] = diminishing_returns[key] or T('player', player, 'level', 0)
	if diminishing_returns[key].level < 3 then
		diminishing_returns[key].duration = DIMINISHING_RETURN[spell].duration / 2 ^ diminishing_returns[key].level + 15
		diminishing_returns[key].started = GetTime()
		diminishing_returns[key].icon = DIMINISHING_RETURN[spell].icon
	end
	diminishing_returns[key].level = diminishing_returns[key].level + 1

	if player == UnitName('target') then
		show(frame, key)
	end
end

do
	local function combat_event_handler()
		for _, pattern in PATTERNS do
			for spell, player in string.gfind(arg1, pattern) do
				start(player == 'you' and UnitName('player') or player, spell)
			end
		end
	end
	private.CHAT_MSG_SPELL_SELF_DAMAGE = combat_event_handler
	private.CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = combat_event_handler
	private.CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = combat_event_handler
end

function private.update_frame(frame, player_name)
	for key, dr in diminishing_returns do
		(player_name == dr.player and show or hide)(frame, key)
	end
end

function private.PLAYER_TARGET_CHANGED()
	update_frame(frame, UnitName('target'))
end