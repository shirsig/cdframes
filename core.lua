do
	local modules = {}
	local mt = {__metatable=false, __index=function(_, key) return modules[key]._I end, __newindex=error}
	cooldowns = function(name)
		if not modules[name] then
			(function()
				modules[name] = module and _E
				import (green_t)
				private.cooldowns = setmetatable(t, mt)
			end)()
		end
		modules[name].import (modules.core._I)
		setfenv(2, modules[name])
	end
end

cooldowns 'core'

CreateFrame('GameTooltip', 'cooldowns_Tooltip', nil, 'GameTooltipTemplate')

do local frame = CreateFrame('Frame')
	frame:SetScript('OnEvent', function() _E[event]() end)
	frame:RegisterEvent('ADDON_LOADED')
end

cooldowns_settings = t

function public.print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(LIGHTYELLOW_FONT_COLOR_CODE .. '[cooldowns] ' .. msg)
end

function public.color_code(r, g, b)
	return format('|cFF%02X%02X%02X', r*255, g*255, b*255)
end

function public.list(first, ...)
	for i = 1, arg.n do first = first .. ',' .. arg[i] end
	return first or ''
end

function public.elems(list)
	local elems = t
	for elem in string.gfind(list, '[^,]+') do tinsert(elems, elem) end
	return elems
end

function public.contains(list, str)
	for element in string.gfind(list, '[^,]+') do
		if element == str then return true end
	end
end

function private.ADDON_LOADED()
	if arg1 ~= 'cooldowns' then return end

	SLASH_COOLDOWNS1 = '/cooldowns'
	SlashCmdList.COOLDOWNS = SLASH

	cooldowns.player.setup()
	cooldowns.enemy.setup()
	cooldowns.diminishing_returns.setup()
end

function private.parse_number(params)
	local number = tonumber(params.input) or params.default
	if params.min then number = max(params.min, number) end
	if params.max then number = min(params.max, number) end
	return params.integer and floor(number + .5) or number
end

function private.SLASH(str)
	str = strupper(str)
	local parameters, frames = tokenize(str), tt
	if parameters[1] == 'USED' then
		cooldowns_settings.used = not cooldowns_settings.used
		return
	end
	if contains(parameters[1] or '', 'PLAYER') then
		frames[cooldowns.player.frame] = true
	end
	if contains(parameters[1] or '', 'TARGET') then
		frames[cooldowns.enemy.targetFrame] = true
	end
	if contains(parameters[1] or '', 'TARGETTARGET') then
		frames[cooldowns.enemy.targetTargetFrame] = true
	end
	if contains(parameters[1] or '', 'DR') then
		frames[cooldowns.diminishing_returns.frame] = true
	end
	if not next(frames) then
		frames = temp-S(cooldowns.player.frame, cooldowns.enemy.targetFrame, cooldowns.enemy.targetTargetFrame, cooldowns.diminishing_returns.frame)
	else
		tremove(parameters, 1)
	end
	for frame in frames do
		if parameters[1] == 'ON' then
			frame.settings.active = true
		elseif parameters[1] == 'OFF' then
			frame.settings.active = false
		elseif parameters[1] == 'LOCK' then
			frame.settings.locked = true
		elseif parameters[1] == 'UNLOCK' then
			frame.settings.locked = false
		elseif parameters[1] == 'SIZE' then
			frame.settings.size = parse_number{ input=parameters[2], min=1, max=100, default=16, integer=true }
		elseif parameters[1] == 'LINE' then
			frame.settings.line = parse_number{ input=parameters[2], min=1, max=100, default=8, integer=true }
		elseif parameters[1] == 'SPACING' then
			frame.settings.spacing = parse_number{ input=parameters[2], min=0, max=1, default=0 }
		elseif parameters[1] == 'SCALE' then
			local scale = parse_number{ input=parameters[2], min=.5, max=2, default=1 }
			frame.settings.x = frame.settings.x * frame.settings.scale / scale
			frame.settings.y = frame.settings.y * frame.settings.scale / scale
			frame.settings.scale = scale
		elseif parameters[1] == 'SKIN' then
			frame.settings.skin = (temp-S('darion', 'blizzard', 'zoomed', 'elvui'))[strlower(parameters[2] or '')] and strlower(parameters[2]) or 'darion'
		elseif parameters[1] == 'COUNT' then
			frame.settings.count = not frame.settings.count
		elseif parameters[1] == 'BLINK' then
			frame.settings.blink = parse_number{ input=parameters[2], min=0, default=7 }
		elseif parameters[1] == 'ANIMATION' then
			frame.settings.animation = not frame.settings.animation
		elseif parameters[1] == 'CLICKTHROUGH' then
			frame.settings.clickthrough = not frame.settings.clickthrough
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
			local _, _, match = strfind(str, '[^,]*ADD%s+(.-)%s*$')
			local names = tt
			for _, name in temp-elems(match) do
				if not contains(frame.settings.ignoreList, name) then tinsert(names, name) end
			end
			frame.settings.ignoreList = frame.settings.ignoreList == '' and list(unpack(names)) or frame.settings.ignoreList .. ',' .. list(unpack(names))
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
			local _, _, match = strfind(str, '[^,]*REMOVE%s+(.-)%s*$')
			local names = tt
			for _, name in temp-elems(frame.settings.ignoreList) do
				if not contains(match, name) then tinsert(names, name) end
			end
			frame.settings.ignoreList = list(unpack(names))
		elseif parameters[1] == 'IGNORE' then
			print(frame.key .. ':')
			for _, name in temp-elems(frame.settings.ignoreList) do print(name) end
		elseif parameters[1] == 'RESET' then
			wipe(frame.settings)
		else
			return
		end
		frame:Loadsettings(frame.settings)
	end
end

function private.tokenize(str)
	local tokens = t
	for token in string.gfind(str, '%S+') do tinsert(tokens, token) end
	return tokens
end
