cooldowns 'diminishing_returns'

local PATTERNS = {
	"You cast (.+) on (.+)%.",
}

local CLASS = {
	["Bash"] = 1,
	["Hammer of Justice"] = 1,
	["Cheap Shot"] = 1,
	["Charge Stun"] = 1,
	["Intercept Stun"] = 1,
	["Concussion Blow"] = 1,

	["Fear"] = 2,
	["Howl of Terror"] = 2,
	["Seduction"] = 2,
	["Intimidating Shout"] = 2,
	["Psychic Scream"] = 2,

	["Polymorph"] = 3,
	["Sap"] = 3,
	["Gouge"] = 3,

	["Entangling Roots"] = 4,
	["Frost Nova"] = 4,

	["Blind"] = 5,

	["Hibernate"] = 6,

	["Mind Control"] = 7,

	["Kidney Shot"] = 8,

	["Death Coil"] = 9,
}

local LABEL = { color_code(1, 1, 0) .. '½', color_code(1, .5, 0) .. '¼', color_code(1, 0, 0) .. '0' }

function public.setup()
	cooldowns_settings.TARGET_DR = cooldowns_settings.TARGET_DR or T('animation', true)
	public.frame = cooldowns.frame.new('Target Diminishing Returns', A(.5, .5, .5), cooldowns_settings.TARGET_DR)
	do
		local frame = CreateFrame('Frame')
		frame:SetScript('OnEvent', event_handler)
		frame:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
	end
end

--frost shock? TODO

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
		dr[frame] = frame:StartCD('', '', [[Interface\Icons\INV_Misc_QuestionMark]], dr.started, 15, LABEL[dr.level])
	end
end

function private.hide(frame, key)
	local dr = diminishing_returns[key]
	if dr[frame] then
		frame:CancelCD(dr[frame])
		dr[frame] = nil
	end
end

function private.start(player, class)
	local diminishing_returns = diminishing_returns
	local key = class .. player
	p(key)
	if diminishing_returns[key] then
		hide(frame, key)
	end
	diminishing_returns[key] = diminishing_returns[key] or T('level', 0)
	diminishing_returns[key].level = min(3, diminishing_returns[key].level + 1)
	diminishing_returns[key].started = GetTime()
	if player == UnitName('target') then
		show(frame, key)
	end
end

function private.event_handler()
	p(event)
	for _, pattern in PATTERNS do
		for spell, player in string.gfind(arg1, pattern) do
			local class = CLASS[spell]
			if class then
				start(player, class)
			end
		end
	end
end