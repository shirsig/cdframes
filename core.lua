local interface, m, public, private = unpack(CDFrames_Module())
CDFrames = interface

function public.module(name)
	local module = CDFrames_Module()
	public[name] = tremove(module, 1)
	return unpack(module)
end

public.events = CreateFrame('Frame')
m.events:SetScript('OnEvent', function() this[event]() end)
m.events:RegisterEvent('ADDON_LOADED')

function public.In(list, str)
	for element in string.gfind(list, '[^,]+') do
		if element == str then
			return true
		end
	end
end

function m.events.ADDON_LOADED()
	if arg1 ~= 'CDFrames' then
		return
	end

	SLASH_CDFrames1 = '/cdframes'
	SlashCmdList.CDFrames = m.SlashHandler

	m.player.Setup()
	m.enemy.Setup()
end

function private.parseNumber(arg)
	local number = tonumber(arg.input) or arg.default
	if arg.min then
		number = max(arg.min, number)
	end
	if arg.max then
		number = min(arg.max, number)
	end
	return arg.integer and floor(number+0.5) or number
end

function private.SlashHandler(str)
	str = strupper(str)
	local parameters = m.Tokenize(str)

	local frames
	if parameters[1] == m.player.frame.key then
		frames = {m.player.frame}
		tremove(parameters, 1)
	elseif parameters[1] == m.enemy.frame.key then
		frames = {m.enemy.frame}
		tremove(parameters, 1)
	else
		frames = {m.player.frame, m.enemy.frame}
	end

	for _, frame in frames do
		if parameters[1] == 'ON' then
			frame.settings.active = true
		elseif parameters[1] == 'OFF' then
			frame.settings.active = false
		elseif parameters[1] == 'LOCK' then
			frame.settings.locked = true
		elseif parameters[1] == 'UNLOCK' then
			frame.settings.locked = false
		elseif parameters[1] == 'SIZE' then
			frame.settings.size = {m.parseNumber{input=parameters[2], min=1, max=20, default=10, integer=true}, m.parseNumber{input=parameters[3], min=1, max=20, default=1, integer=true}}
		elseif parameters[1] == 'SCALE' then
			frame.settings.scale = m.parseNumber{input=parameters[2], min=0.5, max=2, default=1}
		elseif parameters[1] == 'CLICK' then
			frame.settings.clickThrough = not frame.settings.clickThrough
		elseif parameters[1] == 'BLINK' then
			frame.settings.blink = m.parseNumber{input=parameters[2], min=0, default=10, integer=true}
		elseif parameters[1] == 'IGNORE' then
			local _, _, ignoreList = strfind(str, '^%s*'..frame.key..'%s+IGNORE%s+(.-)%s*$')
			frame.settings.ignoreList = ignoreList or ''
		elseif parameters[1] == 'RESET' then
			frame:Reset()
		else
			return
		end

		frame:Initialize()
	end
end

function private.Tokenize(str)
	local tokens = {}
	for token in string.gfind(str, '%S+') do
		tinsert(tokens, token)
	end
	return tokens
end
